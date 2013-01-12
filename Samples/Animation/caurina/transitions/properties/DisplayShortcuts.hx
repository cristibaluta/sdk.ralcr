/**
 * properties.DisplayShortcuts.as
 * List of default special MovieClip properties (normal and splitter properties) for the Tweener class
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.0
 */
package caurina.transitions.properties;

import flash.geom.Point;
import flash.geom.Rectangle;

import caurina.transitions.Tweener;

class DisplayShortcuts {

	/**
	 * There's no constructor.
	 */
	public function new () {
		trace ("This is a static class and should not be instantiated.");
	}

	/**
	 * Registers all the special properties to the Tweener class, so the Tweener knows what to do with them.
	 */
	public static function init () : Void {

		// Normal properties
		Tweener.registerSpecialProperty ("_frame", _frame_get, _frame_set, null);
		Tweener.registerSpecialProperty ("_autoAlpha", _autoAlpha_get, _autoAlpha_set, null);

		// Scale splitter properties
		Tweener.registerSpecialPropertySplitter ("_scale", _scale_splitter);
		
#if !tweener_lite
		// scrollRect splitter properties
		Tweener.registerSpecialPropertySplitter ("_scrollRect", _scrollRect_splitter);
		
		// scrollrect normal properties
		Tweener.registerSpecialProperty ("_scrollRect_x",		_scrollRect_property_get, _scrollRect_property_set, ["x"]);
		Tweener.registerSpecialProperty ("_scrollRect_y",		_scrollRect_property_get, _scrollRect_property_set, ["y"]);
		Tweener.registerSpecialProperty ("_scrollRect_left",	_scrollRect_property_get, _scrollRect_property_set, ["left"]);
		Tweener.registerSpecialProperty ("_scrollRect_right",	_scrollRect_property_get, _scrollRect_property_set, ["right"]);
		Tweener.registerSpecialProperty ("_scrollRect_top",		_scrollRect_property_get, _scrollRect_property_set, ["top"]);
		Tweener.registerSpecialProperty ("_scrollRect_bottom",	_scrollRect_property_get, _scrollRect_property_set, ["bottom"]);
		Tweener.registerSpecialProperty ("_scrollRect_width",	_scrollRect_property_get, _scrollRect_property_set, ["width"]);
		Tweener.registerSpecialProperty ("_scrollRect_height",	_scrollRect_property_get, _scrollRect_property_set, ["height"]);
#end
	}


	// ==================================================================================================================================
	// PROPERTY GROUPING/SPLITTING functions --------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// scale
	public static function _scale_splitter (p_value:Float, ?p_parameters:Array<Dynamic>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
#if (flash || nme)8
		nArray.push ({name:"_xscale", value: p_value});
		nArray.push ({name:"_yscale", value: p_value});
#elseif flash9
		nArray.push ({name:"scaleX", value: p_value});
		nArray.push ({name:"scaleY", value: p_value});
#end
		return nArray;
	}
#if !tweener_lite
	// ----------------------------------------------------------------------------------------------------------------------------------
	// _scrollRect

	/**
	 * Splits the _scrollRect parameter into specific scrollRect variables
	 *
	 * @param		p_value				Rectangle	The original _scrollRect rectangle
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	public static function _scrollRect_splitter (p_value:Dynamic/*Rectangle*/, ?p_parameters:Array<Dynamic>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		if (p_value == null) {
			// No parameter passed, so try any rectangle :/
			nArray.push ({name:"_scrollRect_x", value:0});
			nArray.push ({name:"_scrollRect_y", value:0});
			nArray.push ({name:"_scrollRect_width", value:100});
			nArray.push ({name:"_scrollRect_height", value:100});
		} else {
			// A rectangle is passed, so just return the properties
			nArray.push ({name:"_scrollRect_x", value:p_value.x});
			nArray.push ({name:"_scrollRect_y", value:p_value.y});
			nArray.push ({name:"_scrollRect_width", value:p_value.width});
			nArray.push ({name:"_scrollRect_height", value:p_value.height});
		}
		return nArray;
	}
#end

	// ==================================================================================================================================
	// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// _frame

	/**
	 * Returns the current frame number from the movieclip timeline
	 *
	 * @param		p_obj				Object		MovieClip object
	 * @return							Number		The current frame
	 */
	public static function _frame_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Int {
#if (flash || nme)8
		return p_obj._currentframe;
#elseif flash9
		return p_obj.currentFrame;
#end
	}

	/**
	 * Sets the timeline frame
	 *
	 * @param		p_obj				Object		MovieClip object
	 * @param		p_value				Number		New frame number
	 */
	public static function _frame_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Void {
		p_obj.gotoAndStop (Math.round (p_value));
	}

	
	// ----------------------------------------------------------------------------------------------------------------------------------
	// _autoAlpha

	/**
	 * Returns the current alpha
	 *
	 * @param		p_obj				Object		MovieClip or Textfield object
	 * @return							Number		The current alpha
	 */
	public static function _autoAlpha_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Float {
#if (flash || nme)8
		return p_obj._alpha;
#elseif flash9
		return p_obj.alpha;
#end
	}

	/**
	 * Sets the current autoAlpha
	 *
	 * @param		p_obj				Object		MovieClip or Textfield object
	 * @param		p_value				Number		New alpha
	 */
	public static function _autoAlpha_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Void {
#if (flash || nme)8
		p_obj._alpha = p_value;
		p_obj._visible = p_value > 0;
#elseif flash9
		p_obj.alpha = p_value;
		p_obj.visible = p_value > 0;
#end
		
	}
#if !tweener_lite
	// ----------------------------------------------------------------------------------------------------------------------------------
	// _scrollRect_*

	/**
	 * _scrollRect_*
	 * Generic function for the properties of the scrollRect object
	 */
	public static function _scrollRect_property_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Float {
		return Reflect.field (p_obj.scrollRect, p_parameters[0]);
	}
	public static function _scrollRect_property_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic) : Void {
		var rect = p_obj.scrollRect;
		Reflect.setField (rect, p_parameters[0], Math.round(p_value));
		p_obj.scrollRect = rect;
	}
#end
}
