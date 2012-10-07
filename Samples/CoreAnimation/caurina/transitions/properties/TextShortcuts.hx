/**
 * properties.TextShortcuts
 * Special properties for the Tweener class to handle MovieClip filters
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.0
 */
package caurina.transitions.properties;

import caurina.transitions.Tweener;
import caurina.transitions.AuxFunctions;

#if (flash || nme)8
import flash.TextFormat;
#elseif flash9
import flash.text.TextFormat;
#end

class TextShortcuts {

	/**
	 * There's no constructor.
	 */
	public function new () {
		trace ("This is an static class and should not be instantiated.");
	}

	/**
	 * Registers all the special properties to the Tweener class, so the Tweener knows what to do with them.
	 */
	public static function init () : Void {
		// Normal properties
		Tweener.registerSpecialProperty ("_text", _text_get, _text_set, null, _text_preProcess);

#if !tweener_lite
		// TextFormat-based properties
		Tweener.registerSpecialPropertySplitter ("_text_color",		_generic_color_splitter, ["_text_color_r", "_text_color_g", "_text_color_b"]);
		Tweener.registerSpecialProperty ("_text_color_r",			_textFormat_property_get,	_textFormat_property_set,	["color", true, "r"]);
		Tweener.registerSpecialProperty ("_text_color_g",			_textFormat_property_get,	_textFormat_property_set,	["color", true, "g"]);
		Tweener.registerSpecialProperty ("_text_color_b",			_textFormat_property_get,	_textFormat_property_set,	["color", true, "b"]);
		Tweener.registerSpecialProperty ("_text_indent",			_textFormat_property_get,	_textFormat_property_set,	["indent"]);
		Tweener.registerSpecialProperty ("_text_leading",			_textFormat_property_get,	_textFormat_property_set,	["leading"]);
		Tweener.registerSpecialProperty ("_text_leftMargin",		_textFormat_property_get,	_textFormat_property_set,	["leftMargin"]);
		Tweener.registerSpecialProperty ("_text_letterSpacing",		_textFormat_property_get,	_textFormat_property_set,	["letterSpacing"]);
		Tweener.registerSpecialProperty ("_text_rightMargin",		_textFormat_property_get,	_textFormat_property_set,	["rightMargin"]);
		Tweener.registerSpecialProperty ("_text_size",				_textFormat_property_get,	_textFormat_property_set,	["size"]);
#end
	}


	// ==================================================================================================================================
	// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// _text

	/**
	 * Returns the current frame number from the movieclip timeline
	 *
	 * @param		p_obj				Object		MovieClip object
	 * @return							Number		The current frame
	 */
	public static function _text_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Int {
		return -p_obj.text.length;
	}

	/**
	 * Sets the timeline frame
	 *
	 * @param		p_obj				Object		MovieClip object
	 * @param		p_value				Number		New frame number
	 */
	public static function _text_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		if (p_value < 0) {
			// Old text
			p_obj.text = Reflect.field (p_extra, "oldText").substr (0, -Math.round (p_value));
		} else {
			// New text
			p_obj.text = Reflect.field (p_extra, "newText").substr (0, Math.round (p_value));
		}
	}

	public static function _text_preProcess (p_obj:Dynamic, p_parameters:Array<Dynamic>, p_originalValueComplete:Dynamic, ?p_extra:Dynamic = null) : Int {
		Reflect.setField (p_extra, "oldText", p_obj.text);
		Reflect.setField (p_extra, "newText", p_originalValueComplete);
		return Reflect.field (p_extra, "newText").length;
	}
	
#if !tweener_lite	
	// ==================================================================================================================================
	// PROPERTY GROUPING/SPLITTING functions --------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// generic splitters

	/**
	 * A generic color splitter - from 0xrrggbb to r, g, b with the name of the parameters passed
	 *
	 * @param		p_value				Number		The original _color value
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	public static function _generic_color_splitter (p_value:Int, p_parameters:Array<String>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		nArray.push ({name:p_parameters[0], value:AuxFunctions.numberToR (p_value)});
		nArray.push ({name:p_parameters[1], value:AuxFunctions.numberToG (p_value)});
		nArray.push ({name:p_parameters[2], value:AuxFunctions.numberToB (p_value)});
		return nArray;
	}


	// ==================================================================================================================================
	// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------

	/**
	 * Generic function for the textformat properties
	 */
	public static function _textFormat_property_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Null<Int> {
		var fmt:TextFormat = p_obj.getTextFormat();
		var propertyName:String = Std.string (p_parameters[0]);
		var isColor:Bool = (p_parameters[1] != null);
		
		if (!isColor) {
			// Standard property
			return (Reflect.field (fmt, propertyName));
		} else {
			// Composite, color channel
			var colorComponent:String = Std.string (p_parameters[2]);
			if (colorComponent == "r") return AuxFunctions.numberToR (Reflect.field (fmt, propertyName));
			if (colorComponent == "g") return AuxFunctions.numberToG (Reflect.field (fmt, propertyName));
			if (colorComponent == "b") return AuxFunctions.numberToB (Reflect.field (fmt, propertyName));
		}
		
		return null;
	}

	public static function _textFormat_property_set (p_obj:Dynamic, p_value:Int, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		var fmt:TextFormat = p_obj.getTextFormat();
		var propertyName:String = Std.string (p_parameters[0]);
		var isColor:Bool = (p_parameters[1] != null);

		if (!isColor) {
			// Standard property
			Reflect.setField (fmt, propertyName, p_value);
		} else {
			// Composite, color channel
			var colorComponent:String = Std.string (p_parameters[2]);
			if (colorComponent == "r") Reflect.setField (fmt, propertyName, (Reflect.field (fmt, propertyName) & 0xffff)   | (p_value << 16));
			if (colorComponent == "g") Reflect.setField (fmt, propertyName, (Reflect.field (fmt, propertyName) & 0xff00ff) | (p_value << 8));
			if (colorComponent == "b") Reflect.setField (fmt, propertyName, (Reflect.field (fmt, propertyName) & 0xffff00) |  p_value);
		}

		p_obj.defaultTextFormat = fmt;
		p_obj.setTextFormat (fmt);
	}
#end
}
