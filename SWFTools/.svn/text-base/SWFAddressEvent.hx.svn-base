/**
 * SWFAddress 2.2: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2008 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */
#if flash8
class SWFAddressEvent {
#elseif flash9
class SWFAddressEvent extends flash.events.Event {
#end
	inline public static var INIT : String = 'init';
	inline public static var CHANGE : String = 'change';
	
	public var _type (getType, null) :String;
	public var _value (getValue, null) :String;
	public var _path (getPath, null) :String;
	public var _pathNames (getPathNames, null) :Array<String>;
	public var _parameters (getParameters, null) :Array<String>;
	public var _parametersNames (getParametersNames, null) :Array<String>;
	
	public function new (type:String) {
		#if flash9 super(type);#end
		_type = type;
	}
	
	#if flash9 override#end public function toString():String {
        return '[class SWFAddressEvent]';
    }
	
	function getType () :String {
		return _type;
	}
	
	public function getTarget () :Dynamic {
		return SWFAddress;
	}
	
	function getValue () :String {
		if (_value == 'undefined' || _value == null)
            _value = SWFAddress.getValue();
		return _value;
	}
	
	function getPath () :String {
		if (_path == 'undefined' || _path == null)
            _path = SWFAddress.getPath();
		return _path;
	}
	
	function getPathNames () :Array<String> {
		if (/*_pathNames == 'undefined' || */_pathNames == null)
            _pathNames = SWFAddress.getPathNames();
		return _pathNames;
	}
	
	function getParameters () :Array<String> {
		if (/*_parameters == 'undefined' || */_parameters == null) {
			_parameters = new Array<String>();
			var params:Array<String> = getParametersNames();
			
			for (i in 0...params.length)
				Reflect.setField (_parameters, params[i], SWFAddress.getParameter (params[i]));
		}
		return _parameters;
	}
	
	function getParametersNames () :Array<String> {
		if (/*_parametersNames == 'undefined' || */_parametersNames == null)
			_parametersNames = SWFAddress.getParameterNames();
		return _parametersNames;
	}
}
