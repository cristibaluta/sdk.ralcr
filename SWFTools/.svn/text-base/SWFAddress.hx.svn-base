/**
 * SWFAddress 2.2: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2008 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 * Ported to haXe by Baluta Cristian ( http://ralcr.com/ports/swfaddress/ )
 */
import flash.external.ExternalInterface;
import flash.system.Capabilities;

#if flash9
import flash.net.URLRequest;
import flash.events.EventDispatcher;
#elseif flash8
import EventDispatcher;
#end

class SWFAddress {

	static var _init = false;
	static var _initChange = false;
	static var _strict = true;
	static var _value = '';
	static var _interval :haxe.Timer;
	static var _availability = ExternalInterface.available;
	static var _dispatcher = new EventDispatcher();
	static var _initializer = _initialize();
	
	dynamic public static var onInit :Dynamic;
	dynamic public static var onChange :Dynamic;
	
	
	
	static function _initialize () :Bool {
		if (_availability) {
#if flash8
			ExternalInterface.addCallback ('getSWFAddressValue', SWFAddress, function():String { return _value; });
			ExternalInterface.addCallback ('setSWFAddressValue', SWFAddress, _setValue);
#elseif flash9
			ExternalInterface.addCallback ('getSWFAddressValue', function():String { return _value; });
			ExternalInterface.addCallback ('setSWFAddressValue', _setValue);
#end
		}
#if flash8
		if (flash.Lib._root.swfaddress != 'undefined')
			_value = flash.Lib._root.swfaddress;
#elseif flash9
		var swfaddress_str = flash.Lib.current.loaderInfo.parameters.swfaddress;
		if (swfaddress_str != 'undefined' && swfaddress_str != null)
			_value = swfaddress_str;
#end
		_interval = new haxe.Timer (10);
		_interval.run = _check;
		return true;
	}
	
	static function _check () :Void {
		if ((Reflect.isFunction (onInit) || _dispatcher.hasEventListener ('init')) && !_init) {
			_setValueInit (_getValue());	
			_init = true;		
		}
		if (Reflect.isFunction (onChange) || _dispatcher.hasEventListener ('change')) {
			_interval.stop();
			_init = true;
			_setValueInit (_getValue());
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
			value = Std.string (ExternalInterface.call ('SWFAddress.getValue'));
			ids = Std.string (ExternalInterface.call ('SWFAddress.getIds'));
		}
		if (isNull (ids) || !_availability) {
			value = _value;
		}
		else {
			if (isNull (value)) value = '';
		}
		return _strictCheck (value, false);
	}
	
	static function _setValueInit (value:String) :Void {
		_value = value;
		
		if (!_init) {
			_dispatchEvent (SWFAddressEvent.INIT);
		}
		else {
			_dispatchEvent (SWFAddressEvent.CHANGE);
		}
		_initChange = true;
	}
	
	static function _setValue (value:String) :Void {
		if (isNull (value)) value = '';
		if (_value == value && _init) return;
		if (!_initChange) return;
		_value = value;
		
		if (!_init) {
			_init = true;		
			if (Reflect.isFunction (onInit) || _dispatcher.hasEventListener ('init'))
				_dispatchEvent (SWFAddressEvent.INIT);
		}
		_dispatchEvent ( SWFAddressEvent.CHANGE );
	}
	
	static function _dispatchEvent (type:String) :Void {
		
		// Dispatch the event
		if (_dispatcher.hasEventListener (type))
			_dispatcher.dispatchEvent ( new SWFAddressEvent(type) );
		
		// Call the static methods onInit and onChange
		var func = Reflect.field (SWFAddress, 'on' + type.substr(0,1).toUpperCase() + type.substr(1));
		if (Reflect.isFunction (func))
			Reflect.callMethod (SWFAddress, func, null);
	}
	
	
	/**
     * Loads the previous URL in the history list.
     */
	public static function back () :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.back');
	}
	
	/**
     * Loads the next URL in the history list.
     */
	public static function forward () :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.forward');
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
		if (_availability)
			ExternalInterface.call ('SWFAddress.go', delta);
	}
	
	/**
     * Opens a new URL in the browser. 
     * @param url The resource to be opened.
     * @param target Target window.
     */
	public static function href (url:String, ?target:String) :Void {
		target = (target != 'undefined' && target != null) ? target : '_self';
		
		if (_availability && Capabilities.playerType == 'ActiveX') {
			ExternalInterface.call ('SWFAddress.href', url, target);
			return;
		}
#if flash8
		flash.Lib.getURL (url, target);
#elseif flash9
		flash.Lib.getURL (new URLRequest(url), target);
#end
	}
	
	/**
     * Opens a browser popup window. 
     * @param url Resource location.
     * @param name Name of the popup window.
     * @param options Options which get evaluted and passed to the window.open() method.
     * @param handler Optional JavsScript handler code for popup handling.    
     */
	public static function popup (url:String, ?name:String, ?options:String, ?handler:String) :Void {
		name = isNull (name) ? 'popup' : name;
		options = isNull (options) ? '""' : options;
		handler = isNull (handler) ? '' : handler;
		
		if (_availability &&
			Capabilities.playerType == 'ActiveX' ||
			ExternalInterface.call ('asual.util.Browser.isSafari')) {
			ExternalInterface.call ('SWFAddress.popup', url, name, options, handler);
			return;
		}
		var URL = 'javascript:popup=window.open("'+url+'","'+name+'",'+options+');' + handler + ';void(0);';
#if flash8
		flash.Lib.getURL (URL);
#elseif flash9
		flash.Lib.getURL (new URLRequest (URL), '_self');
#end
	}
	
	
	/**
     * Registers an event listener.
     * @param type Event type.
     * @param listener Event listener.
     * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
     * @param priority The priority level of the event listener.
     * @param useWeakReference Determines whether the reference to the listener is strong or weak.
     */
#if flash8
	public static function addEventListener (type:String, listener:Dynamic) :Void {
        _dispatcher.addEventListener (type, listener);
    }
#elseif flash9
	public static function addEventListener (type:String, listener:Dynamic,
							?useCapture:Bool=false, ?priority:Int=0, ?useWeakReference:Bool=false) :Void {
		
		_dispatcher.addEventListener (type, listener, useCapture, priority, useWeakReference);
	}
#end
	
	/**
     * Removes an event listener.
     * @param type Event type.
     * @param listener Event listener.
     */
#if flash8
	public static function removeEventListener (type:String, listener:Dynamic) :Void {
		_dispatcher.removeEventListener (type, listener);
	}
#elseif flash9
	public static function removeEventListener (type:String, listener:Dynamic) :Void {
        _dispatcher.removeEventListener (type, listener, false);
    }
#end
	
	/**
     * Dispatches an event to all the registered listeners. 
     * @param event Event object.
     */
	public static function dispatchEvent (event:SWFAddressEvent) :Void {
		_dispatcher.dispatchEvent (event);
	}
	
	/**
     * Checks the existance of any listeners registered for a specific type of event. 
     * @param event Event type.
     */
	public static function hasEventListener (type:String) :Bool {
		return _dispatcher.hasEventListener (type);
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
		if (_availability)
			ExternalInterface.call ('SWFAddress.setStrict', strict);
		_strict = strict;
	}
	
	/**
     * Provides the state of the history setting. 
     */
	public static function getHistory () :Bool {
		var hasHistory :Dynamic = ExternalInterface.call ('SWFAddress.getHistory');
		
		return (_availability) ? (hasHistory == 'true' || hasHistory == true) : false;
	}
	
	/**
     * Enables or disables the creation of history entries.
     * @param {Boolean} history History state.
     */
	public static function setHistory (history:Bool) :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.setHistory', history);
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
		if (_availability)
			ExternalInterface.call ('SWFAddress.setTracker', tracker);
	}
	
	/**
     * Provides the title of the HTML document.
     */
	public static function getTitle () :String {
		var title:String = (_availability) ? Std.string (ExternalInterface.call ('SWFAddress.getTitle')) : '';
		if (isNull (title)) title = '';
		return title;
	}
	
	/**
     * Sets the title of the HTML document.
     * @param title Title value.
     */
	public static function setTitle (title:String) :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.setTitle', title);
	}
	
	/**
     * Provides the status of the browser window.
     */
	public static function getStatus () :String {
		var status:String = (_availability) ? Std.string (ExternalInterface.call ('SWFAddress.getStatus')) : '';
		if (isNull (status)) status = '';
		return status;
	}
	
	/**
     * Sets the status of the browser window.
     * @param status Status value.
     */
	public static function setStatus (status:String) :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.setStatus', status);
	}
	
	/**
     * Resets the status of the browser window.
     */
	public static function resetStatus () :Void {
		if (_availability)
			ExternalInterface.call ('SWFAddress.resetStatus');
	}
	
	/**
     * Provides the current deep linking value.
     */
	public static function getValue () :String {
		return _strictCheck (_value, false);
	}
	
	/**
     * Sets the current deep linking value.
     * @param value A value which will be appended to the base link of the HTML document.
     */
	public static function setValue (value:String) :Void {
		if (isNull (value)) value = '';
		value = _strictCheck (value, true);
		if (_value == value) return;
		_value = value;
		
		if (_availability)
			ExternalInterface.call ('SWFAddress.setValue', value);
			
		_dispatchEvent (SWFAddressEvent.CHANGE);
	}
	
	/**
     * Provides the deep linking value without the query string.
     */
	public static function getPath () :String {
		var value:String = getValue();
		if (value.indexOf('?') != -1) {
			return StringTools.urlDecode (value.split('?')[0]);
		}
		else {
			return StringTools.urlDecode (value);
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
		return '';
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
		return '';
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
	
	static function isNull (value:String) :Bool {
		return (value == 'undefined' || value == 'null' || value == null);
	}
}
