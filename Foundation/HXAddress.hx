/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Mark Ross <http://www.therossman.org>
 * @author Piotr Zema <http://felixz.mark-naegeli.com>
 * Ported to Haxe by Baluta Cristian ( http://ralcr.com/projects/classes/address/ )
 */

#if flash
	import flash.external.ExternalInterface;
#elseif js
	private typedef ExternalInterface = JSExternalInterface;
#end

typedef HXAddressQueue = {fn:String, param:Dynamic};
typedef HXAddressSignalListener = Array<String>->Void;

class HXAddress {

	static var _init = false;
	static var _initChange = false;
	static var _initChanged = false;
	static var _strict = true;
	static var _value = '';
	static var _queue = new Array<HXAddressQueue>();
	static var _queueTimer :haxe.Timer;
	static var _initTimer :haxe.Timer;
	static var _availability = ExternalInterface.available;
	@:keep static var _initializer = _initialize();
	
	// Dispatch events
	public static var init :HXAddressSignal;
	public static var change :HXAddressSignal;
	public static var externalChange :HXAddressSignal;
	public static var internalChange :HXAddressSignal;
	
	public function new () {
		throw "HXAddress should not be instantiated.";
	}
	
	static function _initialize () :Bool {
		if (_availability) { try {
			_availability = ExternalInterface.call ('function() { return (typeof SWFAddress != "undefined"); }');
			ExternalInterface.addCallback ('getSWFAddressValue', function():String { return _value; });
			ExternalInterface.addCallback ('setSWFAddressValue', _setValue);
		}
		catch (e:Dynamic) {
			_availability = false;
		}
		}

		init = new HXAddressSignal();
		change = new HXAddressSignal();
		externalChange = new HXAddressSignal();
		internalChange = new HXAddressSignal();
		
		_initTimer = new haxe.Timer ( 10 );
		_initTimer.run = _check;
		return true;
	}
	
	static function _check () :Void {
		if (init.listeners.length > 0 && !_init)
		{
			_setValueInit ( _getValue() );
			_init = true;
		}
		if (change.listeners.length > 0) {
			if (_initTimer != null)
				_initTimer.stop();
			_initTimer = null;
			_init = true;
			_setValueInit ( _getValue() );
		}
	}

	static function _strictCheck (value:String, force:Bool) :String {
		if (getStrict()) {
			if (force) {
				if (value.substr(0, 1) != '/') value = '/' + value;
			}
			else {
				if (value == '') value = '/';
			}
		}
		return value;
	}

	static function _getValue () :String {
		var value:String = null, ids:String = null;
		
		if (_availability) {
			value = Std.string ( ExternalInterface.call ('SWFAddress.getValue'));
			var arr :Array<String> = ExternalInterface.call ('SWFAddress.getIds');
			if (arr != null)
				ids = arr.toString();
		}
		if (isNull (ids) || !_availability || _initChanged) {
			value = _value;
		}
		else if (isNull (value))
			value = '';
		
		return _strictCheck (value, false);
	}
	
	static function _setValueInit (value:String) :Void {
		_value = value;
		var pathNames = getPathNames();
		if (!_init)
			init.dispatch(pathNames);
		else {
			change.dispatch(pathNames);
			externalChange.dispatch(pathNames);
		}
		_initChange = true;
	}
	
	static function _setValue (value:String) :Void {
		if (isNull (value)) value = '';
		if (_value == value && _init) return;
		if (!_initChange) return;
		_value = value;
		var pathNames = getPathNames();
		if (!_init) {
			_init = true;
			init.dispatch(pathNames);
		}
		change.dispatch(pathNames);
		externalChange.dispatch(pathNames);
	}
	
	static function _callQueue () :Void {
		#if js
			trace("If you see this trace means something went wrong, _callQueue is used in flash on Mac only");
		#end
		if (_queue.length != 0) {
			var script:String = '';
			for (q in _queue) {
				if (Std.is (q.param, String))
					q.param = '"' + q.param + '"';
				script += q.fn + '(' + q.param + ');';
			}
			_queue = [];
			#if flash
				var URL = 'javascript:' + script + 'void(0);';
				flash.Lib.getURL ( new flash.net.URLRequest ( URL ), '_self' );
			#end
		}
		else if (_queueTimer != null) {
			_queueTimer.stop();
			_queueTimer = null;
		}
	}
	
	static function _call (fn:String, param:Dynamic='') :Void {
		if (_availability) {
			#if js
				ExternalInterface.call (fn, param);
				return;
			#end
			if (isMac()) {
				if (_queue.length == 0) {
					if (_queueTimer != null)
						_queueTimer.stop();
						_queueTimer = new haxe.Timer ( 10 );
						_queueTimer.run = _callQueue;
				}
				var q :HXAddressQueue = {fn:fn, param:param};
				_queue.push ( q );
			}
			else {
				ExternalInterface.call (fn, param);
			}
		}
	}
	
	
	/**
     * Loads the previous URL in the history list.
     */
	public static function back () :Void {
		_call ('SWFAddress.back');
	}
	
	/**
     * Loads the next URL in the history list.
     */
	public static function forward () :Void {
		_call ('SWFAddress.forward');
	}
	
	/**
     * Navigates one level up in the deep linking path.
     */
    public static function up () :Void {
        var path:String = getPath();
        setValue	(path.substr(0, path.lastIndexOf('/', path.length - 2) +
					(path.substr(path.length - 1) == '/' ? 1 : 0)));
    }
	
	/**
     * Loads a URL from the history list.
     * @param delta An integer representing a relative position in the history list.
     */
	public static function go (delta:Int) :Void {
		_call ('SWFAddress.go', delta);
	}
	
	/**
     * Opens a new URL in the browser.
     * @param url The resource to be opened.
     * @param target Target window.
     */
	@:keep public static function href (url:String, ?target:String="_self") :Void {
		if (_availability && (isActiveX() || isJS())) {
			ExternalInterface.call ('SWFAddress.href', url, target);
			return;
		}
		#if flash
			flash.Lib.getURL (new flash.net.URLRequest(url), target);
		#end
	}
	
	/**
     * Opens a browser popup window.
     * @param url Resource location.
     * @param name Name of the popup window.
     * @param options Options which get evaluted and passed to the window.open() method.
     * @param handler Optional JavsScript handler code for popup handling.
     */
	@:keep public static function popup (url:String, ?name:String="popup", ?options:String='""', ?handler:String="") :Void {
		
		if (_availability && (isActiveX() || isJS() || ExternalInterface.call ('asual.util.Browser.isSafari')))
		{
			trace("good to go");
			ExternalInterface.call ('SWFAddress.popup', url, name, options, handler);
			return;
		}
		#if flash
			var URL = 'javascript:popup=window.open("' + url + '","' + name + '",' + options + ');' + handler + ';void(0);';
			flash.Lib.getURL ( new flash.net.URLRequest ( URL ), '_self' );
		#end
	}
	
	/**
     * Provides the base address of the document.
     */
	public static function getBaseURL () :String {
		var url:String = null;
		if (_availability)
			url = Std.string (ExternalInterface.call ('SWFAddress.getBaseURL'));
		return (isNull (url) || !_availability) ? '' : url;
	}
	
	 /**
      * Provides the state of the strict mode setting.
      */
	public static function getStrict () :Bool {
		var strict:String = null;
		if (_availability)
			strict = Std.string (ExternalInterface.call ('SWFAddress.getStrict'));
			
		return isNull (strict) ? _strict : (strict == 'true');
	}
	
	/**
     * Enables or disables the strict mode.
     * @param {Boolean} strict Strict mode state.
     */
	public static function setStrict (strict:Bool) :Void {
		_call ('SWFAddress.setStrict', strict);
		_strict = strict;
	}
	
	/**
     * Provides the state of the history setting.
     */
	public static function getHistory () :Bool {
		if (_availability) {
			var hasHistory :Dynamic = ExternalInterface.call ('SWFAddress.getHistory');
			return (hasHistory == 'true' || hasHistory == true);
		}
		return false;
	}
	
	/**
     * Enables or disables the creation of history entries.
     * @param {Boolean} history History state.
     */
	public static function setHistory (history:Bool) :Void {
		_call ('SWFAddress.setHistory', history);
	}
	
	/**
     * Provides the tracker function.
     */
	public static function getTracker () :String {
		return (_availability) ? Std.string (ExternalInterface.call ('SWFAddress.getTracker')) : '';
	}
	
	/**
     * Sets a function for page view tracking. The default value is 'urchinTracker'.
     * @param tracker Tracker function.
     */
	public static function setTracker (tracker:String) :Void {
		_call ('SWFAddress.setTracker', tracker);
	}
	
	/**
     * Provides the title of the HTML document.
     */
	public static function getTitle () :String {
		var title:String = _availability ? Std.string (ExternalInterface.call ('SWFAddress.getTitle')) : '';
		if (isNull (title)) title = '';
		return StringTools.htmlUnescape ( title );
	}
	
	/**
     * Sets the title of the HTML document.
     * @param title Title value.
     */
	public static function setTitle (title:String) :Void {
		_call ('SWFAddress.setTitle', StringTools.htmlEscape ( StringTools.htmlUnescape ( title )));
	}
	
	/**
     * Provides the status of the browser window.
     */
	public static function getStatus () :String {
		var status:String = _availability ? Std.string (ExternalInterface.call ('SWFAddress.getStatus')) : '';
		if (isNull (status)) status = '';
		return StringTools.htmlUnescape ( status );
	}
	
	/**
     * Sets the status of the browser window.
     * @param status Status value.
     */
	public static function setStatus (status:String) :Void {
		_call ('SWFAddress.setStatus', StringTools.htmlEscape ( StringTools.htmlUnescape ( status )));
	}
	
	/**
     * Resets the status of the browser window.
     */
	public static function resetStatus () :Void {
		_call ('SWFAddress.resetStatus');
	}
	
	/**
     * Provides the current deep linking value.
     */
	public static function getValue () :String {
		return StringTools.htmlUnescape ( _strictCheck (_value, false) );
	}
	
	/**
     * Sets the current deep linking value.
     * @param value A value which will be appended to the base link of the HTML document.
     */
	public static function setValue (value:String) :Void {
		if (isNull (value)) value = '';
		value = StringTools.htmlEscape ( StringTools.htmlUnescape ( _strictCheck (value, true) ) );
		if (_value == value) return;
		_value = value;
		
		_call ('SWFAddress.setValue', value);
		
		if (_init) {
			var pathNames = getPathNames();
			change.dispatch(pathNames);
			internalChange.dispatch(pathNames);
		} else
			_initChanged = true;
	}
	
	/**
     * Provides the deep linking value without the query string.
     */
	public static function getPath () :String {
		var value:String = getValue();
		if (value.indexOf('?') != -1) {
			return value.split('?')[0];
		}
		else if (value.indexOf('#') != -1) {
			return value.split('#')[0];
		}
		else {
			return value;
		}
	}
	
	/**
     * Provides a list of all the folders in the deep linking path.
     */
	public static function getPathNames () :Array<String> {
		var path:String = getPath();
		var names:Array<String> = path.split('/');
		if (path.substr(0, 1) == '/' || path.length == 0)
			names.splice(0, 1);
		if (path.substr(path.length - 1, 1) == '/')
			names.splice(names.length - 1, 1);
		return names;
	}
	
	/**
     * Provides the query string part of the deep linking value.
     */
	public static function getQueryString () :String {
		var value:String = getValue();
		var index:Int = value.indexOf('?');
		if (index != -1 && index < value.length) {
			return value.substr(index + 1);
		}
		return null;
	}
	
	/**
     * Provides the value of a specific query parameter.
     * @param param Parameter name.
     */
	public static function getParameter (param:String) :String {
		var value:String = getValue();
		var index:Int = value.indexOf('?');
		
		if (index != -1) {
			value = value.substr(index + 1);
			var params:Array<String> = value.split('&');
			var i = params.length;
			
			while (i-- >= 0) {
				var p:Array<String> = params[i].split('=');
				if (p[0] == param) {
					return p[1];
				}
			}
		}
		return null;
	}
	
	/**
     * Provides a list of all the query parameter names.
     */
	public static function getParameterNames () :Array<String> {
		var value:String = getValue();
		var index:Int = value.indexOf('?');
		var names = new Array<String>();
		
		if (index != -1) {
			value = value.substr(index + 1);
			if (value != '' && value.indexOf('=') != -1) {
				var params:Array<String> = value.split('&');
				var i = 0;
				while (i < params.length) {
					names.push (params[i].split('=')[0]);
					i++;
				}
			}
		}
		return names;
	}
	
	
	// Utils
	static function isNull (value:String) :Bool {
		return (value == 'undefined' || value == 'null' || value == null);
	}
	static function isMac () :Bool {
		#if flash
			return (flash.system.Capabilities.os.indexOf('Mac') != -1);
		#elseif js
			return true;
		#end
	}
	static function isActiveX () :Bool {
		#if flash
			return (flash.system.Capabilities.playerType == 'ActiveX');
		#elseif js
			return true;
		#end
	}
	static function isJS () :Bool {
		return #if js true #else false #end;
	}
}



class HXAddressSignal {
	
	public var listeners :List<HXAddressSignalListener>;
	
	public function new () {
		removeAll();
	}
	public function add (listener:HXAddressSignalListener) {
		listeners.add ( listener );
	}
	public function remove (listener:HXAddressSignalListener) :Void {
		for (l in listeners) {
			if (Reflect.compareMethods(l, listener)) {
				listeners.remove ( listener );
				return;
			}
		}
	}
	public function removeAll():Void {
		listeners = new List<HXAddressSignalListener>();
	}
	public function dispatch (args:Array<String>) :Void {
		for (listener in listeners)
		try {
			Reflect.callMethod (null, listener, [args.copy()]);
		}
		catch (e:Dynamic) {
			trace ("[HXAddressEvent error calling: "+listener+"]");
		}
	}
}

#if js
class JSExternalInterface {
	public static var available : Bool = true;
	public static function addCallback(functionName:String, closure:Dynamic) :Void {
		switch (functionName) {
			//case "getSWFAddressValue" : null;// this one seems is not used in the .js file
			case "setSWFAddressValue" : SWFAddress.addEventListener ('change', function(e:Dynamic){closure(e.value);});
		}
	}
	public static function call(functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic) :Dynamic {
		
		switch (functionName) {
			case "SWFAddress.back" : SWFAddress.back();
			case "SWFAddress.forward" : SWFAddress.forward();
			case "SWFAddress.go" : SWFAddress.go(p1);
			case "SWFAddress.href" : SWFAddress.href(p1,p2);
			case "SWFAddress.popup" : SWFAddress.popup(p1,p2,p3,p4);
			case "SWFAddress.getBaseURL" : return SWFAddress.getBaseURL();
			case "SWFAddress.getStrict" : return SWFAddress.getStrict();
			case "SWFAddress.setStrict" : SWFAddress.setStrict(p1);
			case "SWFAddress.getHistory" : return SWFAddress.getHistory();
			case "SWFAddress.setHistory" : SWFAddress.setHistory(p1);
			case "SWFAddress.getTracker" : return SWFAddress.getTracker();
			case "SWFAddress.setTracker" : SWFAddress.setTracker(p1);
			case "SWFAddress.getTitle" : return SWFAddress.getTitle();
			case "SWFAddress.setTitle" : SWFAddress.setTitle(p1);
			case "SWFAddress.getStatus" : return SWFAddress.getStatus();
			case "SWFAddress.setStatus" : SWFAddress.setStatus(p1);
			case "SWFAddress.resetStatus" : SWFAddress.resetStatus();
			case "SWFAddress.getValue" : return SWFAddress.getValue();
			case "SWFAddress.setValue" : SWFAddress.setValue(p1);
			case "SWFAddress.getIds" : return SWFAddress.getIds();
			case 'function() { return (typeof SWFAddress != "undefined"); }' :
			return untyped __js__('function() { return (typeof SWFAddress != "undefined"); }()');
			default : throw "You are trying to call an inexisting extern method";
		}
		return null;
	}
}

extern class SWFAddress {
	public static function back () :Void;
	public static function forward () :Void;
	public static function go (p1:Int) :Void;
	public static function href (p1:String,p2:String) :Void;
	public static function popup (p1:String,p2:String,p3:String,p4:String) :Void;
	public static function getBaseURL () :String;
	public static function getIds () :Array<String>;
	public static function getStrict () :Bool;
	public static function setStrict (p1:Bool) :Bool;
	public static function getHistory () :Bool;
	public static function setHistory (p1:Bool) :Void;
	public static function getTracker () :String;
	public static function setTracker (p1:String) :Void;
	public static function getTitle () :String;
	public static function setTitle (p1:String) :Void;
	public static function getStatus () :String;
	public static function setStatus (p1:String) :Void;
	public static function getValue () :String;
	public static function setValue (str:String) :String;
	public static function resetStatus () :Void;
	public static function addEventListener (type:String, listener:Dynamic) :Void;
}
#end
