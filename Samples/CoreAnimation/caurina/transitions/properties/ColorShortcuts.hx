/**
 * properties.ColorShortcuts
 * List of default special color properties (normal and splitter properties) for the Tweener class
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.0
 */
package caurina.transitions.properties;

import flash.geom.ColorTransform;
import flash.filters.ColorMatrixFilter;
#if flash8
import flash.Color;
#end

import caurina.transitions.Tweener;
import caurina.transitions.AuxFunctions;

class ColorShortcuts {

	// Sources:
	// http://www.graficaobscura.com/matrix/index.html
	// And mario Klingemann's ColorMatrix class as mentioned on the credits:
	// http://www.quasimondo.com/archives/000565.php
	
	// Defines luminance using sRGB luminance
	inline static var LUMINANCE_R:Float = 0.212671;
	inline static var LUMINANCE_G:Float = 0.715160;
	inline static var LUMINANCE_B:Float = 0.072169;
	
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
#if flash8
		Tweener.registerSpecialProperty ("_color_ra", _oldColor_property_get, _oldColor_property_set, ["ra"]);
		Tweener.registerSpecialProperty ("_color_rb", _oldColor_property_get, _oldColor_property_set, ["rb"]);
		Tweener.registerSpecialProperty ("_color_ga", _oldColor_property_get, _oldColor_property_set, ["ga"]);
		Tweener.registerSpecialProperty ("_color_gb", _oldColor_property_get, _oldColor_property_set, ["gb"]);
		Tweener.registerSpecialProperty ("_color_ba", _oldColor_property_get, _oldColor_property_set, ["ba"]);
		Tweener.registerSpecialProperty ("_color_bb", _oldColor_property_get, _oldColor_property_set, ["bb"]);
		Tweener.registerSpecialProperty ("_color_aa", _oldColor_property_get, _oldColor_property_set, ["aa"]);
		Tweener.registerSpecialProperty ("_color_ab", _oldColor_property_get, _oldColor_property_set, ["ab"]);
#elseif flash9
		Tweener.registerSpecialProperty ("_color_ra", _oldColor_property_get,	_oldColor_property_set,	["redMultiplier"]);
		Tweener.registerSpecialProperty ("_color_rb", _color_property_get,		_color_property_set,	["redOffset"]);
		Tweener.registerSpecialProperty ("_color_ga", _oldColor_property_get,	_oldColor_property_set,	["greenMultiplier"]);
		Tweener.registerSpecialProperty ("_color_gb", _color_property_get,		_color_property_set,	["greenOffset"]);
		Tweener.registerSpecialProperty ("_color_ba", _oldColor_property_get,	_oldColor_property_set,	["blueMultiplier"]);
		Tweener.registerSpecialProperty ("_color_bb", _color_property_get,		_color_property_set,	["blueOffset"]);
		Tweener.registerSpecialProperty ("_color_aa", _oldColor_property_get,	_oldColor_property_set,	["alphaMultiplier"]);
		Tweener.registerSpecialProperty ("_color_ab", _color_property_get,		_color_property_set,	["alphaOffset"]);
#end
		Tweener.registerSpecialProperty ("_color_redMultiplier", 	_color_property_get, _color_property_set, ["redMultiplier"]);
		Tweener.registerSpecialProperty ("_color_redOffset",		_color_property_get, _color_property_set, ["redOffset"]);
		Tweener.registerSpecialProperty ("_color_greenMultiplier",	_color_property_get, _color_property_set, ["greenMultiplier"]);
		Tweener.registerSpecialProperty ("_color_greenOffset",		_color_property_get, _color_property_set, ["greenOffset"]);
		Tweener.registerSpecialProperty ("_color_blueMultiplier",	_color_property_get, _color_property_set, ["blueMultiplier"]);
		Tweener.registerSpecialProperty ("_color_blueOffset",		_color_property_get, _color_property_set, ["blueOffset"]);
		Tweener.registerSpecialProperty ("_color_alphaMultiplier",	_color_property_get, _color_property_set, ["alphaMultiplier"]);
		Tweener.registerSpecialProperty ("_color_alphaOffset",		_color_property_get, _color_property_set, ["alphaOffset"]);
		
		// Normal splitter properties
		Tweener.registerSpecialPropertySplitter ("_color", _color_splitter);
		Tweener.registerSpecialPropertySplitter ("_colorTransform", _colorTransform_splitter);
#if !tweener_lite
		// Color changes that depend on the ColorMatrixFilter
		Tweener.registerSpecialProperty ("_brightness",		_brightness_get,	_brightness_set, [false]);
		Tweener.registerSpecialProperty ("_tintBrightness",	_brightness_get,	_brightness_set, [true]);
		Tweener.registerSpecialProperty ("_contrast",		_contrast_get,		_contrast_set);
		Tweener.registerSpecialProperty ("_hue",			_hue_get,			_hue_set);
		Tweener.registerSpecialProperty ("_saturation",		_saturation_get,	_saturation_set, [false]);
		Tweener.registerSpecialProperty ("_dumbSaturation",	_saturation_get,	_saturation_set, [true]);
#end
	}


	// ==================================================================================================================================
	// PROPERTY GROUPING/SPLITTING functions --------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// _color

	/**
	 * Splits the _color parameter into specific color variables
	 *
	 * @param		p_value				Number		The original _color value
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	public static function _color_splitter (p_value:Dynamic, p_parameters:Array<Dynamic>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		if (p_value == null) {
			// No parameter passed, so just resets the color
			nArray.push ({name:"_color_redMultiplier",	value:1});
			nArray.push ({name:"_color_redOffset",		value:0});
			nArray.push ({name:"_color_greenMultiplier",value:1});
			nArray.push ({name:"_color_greenOffset",	value:0});
			nArray.push ({name:"_color_blueMultiplier",	value:1});
			nArray.push ({name:"_color_blueOffset",		value:0});
		} else {
			// A color tinting is passed, so converts it to the object values
			nArray.push ({name:"_color_redMultiplier",	value:0});
			nArray.push ({name:"_color_redOffset",		value:AuxFunctions.numberToR (p_value)});
			nArray.push ({name:"_color_greenMultiplier",value:0});
			nArray.push ({name:"_color_greenOffset",	value:AuxFunctions.numberToG (p_value)});
			nArray.push ({name:"_color_blueMultiplier",	value:0});
			nArray.push ({name:"_color_blueOffset",		value:AuxFunctions.numberToB (p_value)});
		}
		return nArray;
	}


	// ----------------------------------------------------------------------------------------------------------------------------------
	// _colorTransform

	/**
	 * Splits the _colorTransform parameter into specific color variables
	 *
	 * @param		p_value				Number		The original _colorTransform value
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	public static function _colorTransform_splitter (p_value:Dynamic, p_parameters:Array<Dynamic>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		if (p_value == null) {
			// No parameter passed, so just resets the color
			nArray.push ({name:"_color_redMultiplier",	value:1});
			nArray.push ({name:"_color_redOffset",		value:0});
			nArray.push ({name:"_color_greenMultiplier",value:1});
			nArray.push ({name:"_color_greenOffset",	value:0});
			nArray.push ({name:"_color_blueMultiplier",	value:1});
			nArray.push ({name:"_color_blueOffset",		value:0});
		} else {
			// A color tinting is passed, so converts it to the object values
			if (Reflect.field (p_value, "ra") != null) nArray.push ({name:"_color_ra", value:Reflect.field (p_value, "ra")});
			if (Reflect.field (p_value, "rb") != null) nArray.push ({name:"_color_rb", value:Reflect.field (p_value, "rb")});
			if (Reflect.field (p_value, "ga") != null) nArray.push ({name:"_color_ba", value:Reflect.field (p_value, "ba")});
			if (Reflect.field (p_value, "gb") != null) nArray.push ({name:"_color_bb", value:Reflect.field (p_value, "bb")});
			if (Reflect.field (p_value, "ba") != null) nArray.push ({name:"_color_ga", value:Reflect.field (p_value, "ga")});
			if (Reflect.field (p_value, "bb") != null) nArray.push ({name:"_color_gb", value:Reflect.field (p_value, "gb")});
			if (Reflect.field (p_value, "aa") != null) nArray.push ({name:"_color_aa", value:Reflect.field (p_value, "aa")});
			if (Reflect.field (p_value, "ab") != null) nArray.push ({name:"_color_ab", value:Reflect.field (p_value, "ab")});
			
			if (Reflect.field (p_value, "redMultiplier") != null)	nArray.push ({name:"_color_redMultiplier",	value:Reflect.field (p_value, "redMultiplier")});
			if (Reflect.field (p_value, "redOffset") != null)		nArray.push ({name:"_color_redOffset", 		value:Reflect.field (p_value, "redOffset")});
			if (Reflect.field (p_value, "blueMultiplier") != null)	nArray.push ({name:"_color_blueMultiplier", value:Reflect.field (p_value, "blueMultiplier")});
			if (Reflect.field (p_value, "blueOffset") != null)		nArray.push ({name:"_color_blueOffset", 	value:Reflect.field (p_value, "blueOffset")});
			if (Reflect.field (p_value, "greenMultiplier") != null)	nArray.push ({name:"_color_greenMultiplier",value:Reflect.field (p_value, "greenMultiplier")});
			if (Reflect.field (p_value, "greenOffset") != null)		nArray.push ({name:"_color_greenOffset", 	value:Reflect.field (p_value, "greenOffset")});
			if (Reflect.field (p_value, "alphaMultiplier") != null)	nArray.push ({name:"_color_alphaMultiplier",value:Reflect.field (p_value, "alphaMultiplier")});
			if (Reflect.field (p_value, "alphaOffset") != null)		nArray.push ({name:"_color_alphaOffset", 	value:Reflect.field (p_value, "alphaOffset")});
		}
		return nArray;
	}


	// ==================================================================================================================================
	// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// _color_*

	/**
	 * _color_*
	 * Generic function for the ra/rb/etc components of the deprecated colorTransform object
	 */
	public static function _oldColor_property_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic=null) : Int {
#if flash8
		return Reflect.field ((new Color(p_obj)).getTransform(), p_parameters[0]);
#elseif flash9
		return Math.round (Reflect.field (p_obj.transform.colorTransform, p_parameters[0]) * 100);
#end
	}
	public static function _oldColor_property_set (p_obj:Dynamic, p_value:Int, p_parameters:Array<Dynamic>, ?p_extra:Dynamic=null) : Void {
#if flash8
		var cfObj:Dynamic = {};
		Reflect.setField (cfObj, p_parameters[0], p_value); // Math.round(p_value);
		(new Color(p_obj)).setTransform(cfObj);
#elseif flash9
		var tf:ColorTransform = p_obj.transform.colorTransform;
		Reflect.setField (tf, p_parameters[0], p_value / 100);
		p_obj.transform.colorTransform = tf;
#end
	}

	/**
	 * _color_*
	 * Generic function for the redMultiplier/redOffset/etc components of the new colorTransform
	 */
	public static function _color_property_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Int {
		return Reflect.field (p_obj.transform.colorTransform, p_parameters[0]);
	}
	public static function _color_property_set (p_obj:Dynamic, p_value:Int, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		var cfm:ColorTransform = p_obj.transform.colorTransform;
		Reflect.setField (cfm, p_parameters[0], p_value);
		p_obj.transform.colorTransform = cfm;
	}



#if !tweener_lite



	// ----------------------------------------------------------------------------------------------------------------------------------
	// Special coloring

	/**
	 * _brightness
	 * Brightness of an object: -1 -> [0] -> +1
	 */
	public static function _brightness_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Float {

		var isTint:Bool = p_parameters[0];

		/*
		// Using ColorMatrix:
		
		var mtx:Array = getObjectMatrix(p_obj);
		
		var mc:Float = 1 - ((mtx[0] + mtx[6] + mtx[12]) / 3); // Brightness as determined by the main channels
		var co:Float = (mtx[4] + mtx[9] + mtx[14]) / 3; // Brightness as determined by the offset channels
		*/
#if flash8
		var cfm:Dynamic = (new Color(p_obj)).getTransform();
		var mc:Float = 1 - ((cfm.ra + cfm.ga + cfm.ba) / 300); // Brightness as determined by the main channels
		var co:Float = (cfm.rb + cfm.gb + cfm.bb) / 3;
#elseif flash9
		var cfm:ColorTransform = p_obj.transform.colorTransform;
		var mc:Float = 1 - ((cfm.redMultiplier + cfm.greenMultiplier + cfm.blueMultiplier) / 3); // Brightness as determined by the main channels
		var co:Float = (cfm.redOffset + cfm.greenOffset + cfm.blueOffset) / 3;
#end
		if (isTint) {
			// Tint style
			return co > 0 ? co / 255 : -mc;
		}
		// Native, Flash "Adjust Color" and Photoshop style
		return co / 100;
	}
	public static function _brightness_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		//var mtx:Array = getObjectMatrix(p_obj);

		var isTint:Bool = (p_parameters[0] != null);

		var mc:Float; // Main channel
		var co:Float; // Channel offset

		if (isTint) {
			// Tint style
			mc = 1 - Math.abs (p_value);
			co = p_value > 0 ? Math.round (p_value*255) : 0;
		} else {
			// Native, Flash "Adjust Color" and Photoshop style
			mc = 1;
			co = Math.round (p_value*100);
		}

		/*
		// Using ColorMatrix:
		var mtx:Array = [
			mc, cc, cc, cc, co,
			cc, mc, cc, cc, co,
			cc, cc, mc, cc, co,
			0,  0,  0,  1,  0
		];
		setObjectMatrix(p_obj, mtx);
		*/
#if flash8
		var cfm:Dynamic = {ra:mc * 100, rb:co, ga:mc * 100, gb:co, ba:mc * 100, bb:co};
		(new Color(p_obj)).setTransform (cfm);
#elseif flash9
		var cfm:ColorTransform = new ColorTransform (mc, mc, mc, 1, co, co, co, 0);
		p_obj.transform.colorTransform = cfm;
#end
	}

	/**
	 * _saturation
	 * Saturation of an object: 0 -> [1] -> 2
	 */
	public static function _saturation_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Float {

		var mtx = getObjectMatrix (p_obj);

		var isDumb = (p_parameters[0] != null);
		var rl = isDumb ? 1/3 : LUMINANCE_R;
		var gl = isDumb ? 1/3 : LUMINANCE_G;
		var bl = isDumb ? 1/3 : LUMINANCE_B;

		var mc = ((mtx[0]-rl)/(1-rl) + (mtx[6]-gl)/(1-gl) + (mtx[12]-bl)/(1-bl)) / 3;					// Color saturation as determined by the main channels
		var cc = 1 - ((mtx[1]/gl + mtx[2]/bl + mtx[5]/rl + mtx[7]/bl + mtx[10]/rl + mtx[11]/gl) / 6);	// Color saturation as determined by the other channels
		return (mc + cc) / 2;
	}
	public static function _saturation_set (p_obj:Dynamic, p_value:Float, ?p_parameters:Array<Null<Float>>, ?p_extra:Dynamic = null) : Void {
		
		var isDumb = (p_parameters[0] != null);
		var rl = isDumb ? 1/3 : LUMINANCE_R;
		var gl = isDumb ? 1/3 : LUMINANCE_G;
		var bl = isDumb ? 1/3 : LUMINANCE_B;

		var sf = p_value;
		var nf = 1-sf;
		var nr = rl * nf;
		var ng = gl * nf;
		var nb = bl * nf;

		var mtx : Array<Float> = [
			nr+sf,	ng,		nb,		0,	0,
			nr,		ng+sf,	nb,		0,	0,
			nr,		ng,		nb+sf,	0,	0,
			0,  	0, 		0,  	1,  0
		];
		setObjectMatrix (p_obj, mtx);
	}

	/**
	 * _contrast
	 * Contrast of an object: -1 -> [0] -> +1
	 */
	public static function _contrast_get (p_obj:Dynamic, ?p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Float {

		/*
		// Using ColorMatrix:
		var mtx:Array = getObjectMatrix(p_obj);

		var mc:Float = ((mtx[0] + mtx[6] + mtx[12]) / 3) - 1;		// Contrast as determined by the main channels
		var co:Float = (mtx[4] + mtx[9] + mtx[14]) / 3 / -128;		// Contrast as determined by the offset channel
		*/
#if flash8
		var cfm:Dynamic = (new Color(p_obj)).getTransform();
#elseif flash9		
		var cfm:ColorTransform = p_obj.transform.colorTransform;
#end
		var mc:Float;	// Contrast as determined by the main channels
		var co:Float;	// Contrast as determined by the offset channel
#if flash8
		mc = ((cfm.ra + cfm.ga + cfm.ba) / 300) - 1;
		co = (cfm.rb + cfm.gb + cfm.bb) / 3 / -128;
#elseif flash9
		mc = ((cfm.redMultiplier + cfm.greenMultiplier + cfm.blueMultiplier) / 3) - 1;
		co = (cfm.redOffset + cfm.greenOffset + cfm.blueOffset) / 3 / -128;
#end
		/*
		if (cfm.ra < 100) {
			// Low contrast
			mc = ((cfm.ra + cfm.ga + cfm.ba) / 300) - 1;
			co = (cfm.rb + cfm.gb + cfm.bb) / 3 / -128;
		} else {
			// High contrast
			mc = (((cfm.ra + cfm.ga + cfm.ba) / 300) - 1) / 37;
			co = (cfm.rb + cfm.gb + cfm.bb) / 3 / -3840;
		}
		*/

		return (mc+co)/2;
	}
	public static function _contrast_set (p_obj:Dynamic, p_value:Float, ?p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		
		var mc:Float;	// Main channel
		var co:Float;	// Channel offset
		mc = p_value + 1;
		co = Math.round (p_value*-128);

		/*
		if (p_value < 0) {
			// Low contrast
			mc = p_value + 1;
			co = Math.round(p_value*-128);
		} else {
			// High contrast
			mc = (p_value * 37) + 1;
			co = Math.round(p_value*-3840);
		}
		*/
		
		// Flash: * 8, * -512

		/*
		// Using ColorMatrix:
		var mtx:Array = [
			mc,	0,	0, 	0, co,
			0,	mc,	0, 	0, co,
			0,	0,	mc,	0, co,
			0,  0, 	0, 	1,  0
		];
		setObjectMatrix(p_obj, mtx);
		*/
#if flash8
		var cfm:Dynamic = {ra:mc * 100, rb:co, ga:mc * 100, gb:co, ba:mc * 100, bb:co};
		(new Color(p_obj)).setTransform (cfm);
#elseif flash9
		var cfm:ColorTransform = new ColorTransform (mc, mc, mc, 1, co, co, co, 0);
		p_obj.transform.colorTransform = cfm;
#end
	}

	/**
	 * _hue
	 * Hue of an object: -180 -> [0] -> 180
	 */
	public static function _hue_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Float {

		var mtx = getObjectMatrix (p_obj);

		// Find the current Hue based on a given matrix.
		// This is a kind of a brute force method by sucessive division until a close enough angle is found.
		// Reverse-engineering the hue equation would be is a better choice, but it's hard to find material
		// on the correct calculation employed by Flash.
		// This code has to run only once (before the tween starts), so it's good enough.

		var hues:Array<Dynamic> = [];
		hues[0] = {angle:-179.9, matrix:getHueMatrix (-179.9)};
		hues[1] = {angle:180, matrix:getHueMatrix (180)};
	
		for (i in 0...hues.length) {
			hues[i].distance = getHueDistance(mtx, hues[i].matrix);
		}

		var maxTries:Int = 15;	// Number o maximum divisions until the hue is found
		var angleToSplit:Int = 0;

		for (i in 0...maxTries) {
			// Find the nearest angle
			if (hues[0].distance < hues[1].distance) {
				// First is closer
				angleToSplit = 1;
			} else {
				// Second is closer
				angleToSplit = 0;
			}
			hues[angleToSplit].angle = (hues[0].angle + hues[1].angle)/2;
			hues[angleToSplit].matrix = getHueMatrix (hues[angleToSplit].angle);
			hues[angleToSplit].distance = getHueDistance (mtx, hues[angleToSplit].matrix);
		}

		return hues[angleToSplit].angle;
	}

	public static function _hue_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		setObjectMatrix (p_obj, getHueMatrix (p_value));
	}

	public static function getHueDistance (mtx1:Array<Float>, mtx2:Array<Float>) : Float {
		return (Math.abs (mtx1[0] - mtx2[0]) + Math.abs (mtx1[1] - mtx2[1]) + Math.abs (mtx1[2] - mtx2[2]));
	}

	public static function getHueMatrix (hue:Float) : Array<Float> {
		var ha = hue * Math.PI/180;		// Hue angle, to radians

 		var rl = LUMINANCE_R;
		var gl = LUMINANCE_G;
		var bl = LUMINANCE_B;

		var c = Math.cos(ha);
		var s = Math.sin(ha);

		var mtx:Array<Float> = [
			(rl + (c * (1 - rl))) + (s * (-rl)),
			(gl + (c * (-gl))) + (s * (-gl)),
			(bl + (c * (-bl))) + (s * (1 - bl)),
			0, 0,

			(rl + (c * (-rl))) + (s * 0.143),
			(gl + (c * (1 - gl))) + (s * 0.14),
			(bl + (c * (-bl))) + (s * -0.283),
			0, 0,

			(rl + (c * (-rl))) + (s * (-(1 - rl))),
			(gl + (c * (-gl))) + (s * gl),
			(bl + (c * (1 - bl))) + (s * bl),
			0, 0,

			0, 0, 0, 1, 0
		];
		
		return mtx;
	}


	// ==================================================================================================================================
	// AUXILIARY functions --------------------------------------------------------------------------------------------------------------

	private static function getObjectMatrix (p_obj:Dynamic) : Array<Float> {
		// Get the current color matrix of an object
		var objFilters:Array<Dynamic> = p_obj.filters; //array
		for (filter in objFilters) {
			if (Std.is (filter, ColorMatrixFilter)) {
				return filter.matrix.concat();
			}
		}
		return [
			1.0, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0
		];
	}

	private static function setObjectMatrix (p_obj:Dynamic, p_matrix:Array<Float>) : Void {
		// Set the current color matrix of an object
		var objFilters:Array<Dynamic> = p_obj.filters.concat(); //array
		var found = false;
		for (filter in objFilters) {
			if (Std.is (filter, ColorMatrixFilter)) {
				filter.matrix = p_matrix/*.concat()*/;
				found = true;
			}
		}
		if (!found) {
			// Has to create a new color matrix filter
			var cmtx = new ColorMatrixFilter (p_matrix);
			objFilters.push (cmtx);
		}
		p_obj.filters = objFilters;
	}
#end
}
