/**
 * properties.CurveModifiers
 * List of default special properties modifiers for the Tweener class
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.0
 */
package caurina.transitions.properties;

import caurina.transitions.Tweener;

class CurveModifiers {

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

		// Bezier modifiers
		Tweener.registerSpecialPropertyModifier ("_bezier", _bezier_modifier, _bezier_get);
	}


	// ==================================================================================================================================
	// SPECIAL PROPERTY MODIFIER functions ----------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// _bezier

	/**
	 * Given the parameter object passed to this special property, return an array listing the properties that should be modified, and their parameters
	 *
	 * @param		p_obj				Object		Parameter passed to this property
	 * @return							Array		Array listing name and parameter of each property
	 */
	public static function _bezier_modifier (p_obj:Dynamic) : Array<Dynamic> {
		var mList:Array<Dynamic> = []; // List of properties to be modified
		var pList:Array<Dynamic>; // List of parameters passed, normalized as an array
		if (Std.is (p_obj, Array)) {
			// Complex
			pList = p_obj;
		} else {
			pList = [p_obj];
		}
		
		var mListObj:Dynamic = {}; // Object describing each property name and parameter

		for (i in 0...pList.length) {
			for (istr in Reflect.fields (pList[i])) {
				if (Reflect.field (mListObj, istr) == null) Reflect.setField (mListObj, istr, []);
				Reflect.field (mListObj, istr).push (Reflect.field (pList[i], istr));
			}
		}
		for (istr in Reflect.fields (mListObj)) {
			mList.push ({name:istr, parameters:Reflect.field (mListObj, istr)});
		}
		return mList;
	}

	/**
	 * Given tweening specifications (beging, end, t), applies the property parameter to it, returning new t
	 *
	 * @param		b					Number		Beginning value of the property
	 * @param		e					Number		Ending (desired) value of the property
	 * @param		t					Number		Current t of this tweening (0-1), after applying the easing equation
	 * @param		p					Array		Array of parameters passed to this specific property
	 * @return							Number		New t, with the p parameters applied to it
	 */
	public static function _bezier_get (b:Float, e:Float, t:Float, p:Array<Float>) : Float {
		// This is based on Robert Penner's code
		if (p.length == 1) {
			// Simple curve with just one bezier control point
			return b + t*(2*(1-t)*(p[0]-b) + t*(e - b));
		} else {
			// Array of bezier control points, must find the point between each pair of bezier points
			var ip = Math.floor (t * p.length); // Position on the bezier list
			var it = (t - (ip * (1 / p.length))) * p.length; // t inside this ip
			var p1:Float, p2:Float;
			
			if (ip == 0) {
				// First part: belongs to the first control point, find second midpoint
				p1 = b;
				p2 = (p[0] + p[1]) / 2;
			} else if (ip == p.length - 1) {
				// Last part: belongs to the last control point, find first midpoint
				p1 = (p[ip-1] + p[ip]) / 2;
				p2 = e;
			} else {
				// Any middle part: find both midpoints
				p1 = (p[ip-1] + p[ip]) / 2;
				p2 = (p[ip] + p[ip+1]) / 2;
			}
			return p1 + it*(2*(1 - it)*(p[ip] - p1) + it*(p2 - p1));
		}
	}
}
