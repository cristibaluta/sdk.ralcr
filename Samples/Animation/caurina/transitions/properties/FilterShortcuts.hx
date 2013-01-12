/**
 * properties.FilterShortcuts
 * Special properties for the Tweener class to handle MovieClip filters
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.0
 */
package caurina.transitions.properties;

import flash.display.BitmapData;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;
//import flash.geom.Point;

import caurina.transitions.Tweener;
import caurina.transitions.AuxFunctions;

class FilterShortcuts {

	/**
	 * There's no constructor.
	 */
	public function FilterShortcuts () {
		trace ("This is an static class and should not be instantiated.");
	}

	/**
	 * Registers all the special properties to the Tweener class, so the Tweener knows what to do with them.
	 */
	public static function init () : Void {

		// Filter tweening splitter properties
		Tweener.registerSpecialPropertySplitter ("_filter", _filter_splitter);
#if !tweener_lite
		// Shortcuts - BevelFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/BevelFilter.html
		Tweener.registerSpecialProperty ("_Bevel_angle",			_filter_property_get,	_filter_property_set,	[BevelFilter, "angle"]);
		Tweener.registerSpecialProperty ("_Bevel_blurX",			_filter_property_get,	_filter_property_set,	[BevelFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_Bevel_blurY",			_filter_property_get,	_filter_property_set,	[BevelFilter, "blurY"]);
		Tweener.registerSpecialProperty ("_Bevel_distance",			_filter_property_get,	_filter_property_set,	[BevelFilter, "distance"]);
		Tweener.registerSpecialProperty ("_Bevel_highlightAlpha",	_filter_property_get,	_filter_property_set,	[BevelFilter, "highlightAlpha"]);
		Tweener.registerSpecialPropertySplitter ("_Bevel_highlightColor",	_generic_color_splitter, ["_Bevel_highlightColor_r", "_Bevel_highlightColor_g", "_Bevel_highlightColor_b"]);
		Tweener.registerSpecialProperty ("_Bevel_highlightColor_r",	_filter_property_get,	_filter_property_set,	[BevelFilter, "highlightColor", "color", "r"]);
		Tweener.registerSpecialProperty ("_Bevel_highlightColor_g",	_filter_property_get,	_filter_property_set,	[BevelFilter, "highlightColor", "color", "g"]);
		Tweener.registerSpecialProperty ("_Bevel_highlightColor_b",	_filter_property_get,	_filter_property_set,	[BevelFilter, "highlightColor", "color", "b"]);
		Tweener.registerSpecialProperty ("_Bevel_knockout",			_filter_property_get,	_filter_property_set,	[BevelFilter, "knockout"]);
		Tweener.registerSpecialProperty ("_Bevel_quality",			_filter_property_get,	_filter_property_set,	[BevelFilter, "quality"]);
		Tweener.registerSpecialProperty ("_Bevel_shadowAlpha",		_filter_property_get,	_filter_property_set,	[BevelFilter, "shadowAlpha"]);
		Tweener.registerSpecialPropertySplitter ("_Bevel_shadowColor",		_generic_color_splitter, ["_Bevel_shadowColor_r", "_Bevel_shadowColor_g", "_Bevel_shadowColor_b"]);
		Tweener.registerSpecialProperty ("_Bevel_shadowColor_r",	_filter_property_get,	_filter_property_set,	[BevelFilter, "shadowColor", "color", "r"]);
		Tweener.registerSpecialProperty ("_Bevel_shadowColor_g",	_filter_property_get,	_filter_property_set,	[BevelFilter, "shadowColor", "color", "g"]);
		Tweener.registerSpecialProperty ("_Bevel_shadowColor_b",	_filter_property_get,	_filter_property_set,	[BevelFilter, "shadowColor", "color", "b"]);
		Tweener.registerSpecialProperty ("_Bevel_strength",			_filter_property_get,	_filter_property_set,	[BevelFilter, "strength"]);
		Tweener.registerSpecialProperty ("_Bevel_type",				_filter_property_get,	_filter_property_set,	[BevelFilter, "type"]);
#end
		// Shortcuts - BlurFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/BlurFilter.html
		Tweener.registerSpecialProperty ("_Blur_blurX",				_filter_property_get,	_filter_property_set, [BlurFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_Blur_blurY",				_filter_property_get,	_filter_property_set, [BlurFilter, "blurY"]);
		Tweener.registerSpecialProperty ("_Blur_quality",			_filter_property_get,	_filter_property_set, [BlurFilter, "quality"]);
#if !tweener_lite
		// Shortcuts - ColorMatrixFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/ColorMatrixFilter.html
		Tweener.registerSpecialPropertySplitter ("_ColorMatrix_matrix",	_generic_matrix_splitter, [[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
																									["_ColorMatrix_matrix_rr", "_ColorMatrix_matrix_rg", "_ColorMatrix_matrix_rb", "_ColorMatrix_matrix_ra", "_ColorMatrix_matrix_ro",
																									"_ColorMatrix_matrix_gr", "_ColorMatrix_matrix_gg", "_ColorMatrix_matrix_gb", "_ColorMatrix_matrix_ga", "_ColorMatrix_matrix_go",
																									"_ColorMatrix_matrix_br", "_ColorMatrix_matrix_bg", "_ColorMatrix_matrix_bb", "_ColorMatrix_matrix_ba", "_ColorMatrix_matrix_bo",
																									"_ColorMatrix_matrix_ar", "_ColorMatrix_matrix_ag", "_ColorMatrix_matrix_ab", "_ColorMatrix_matrix_aa", "_ColorMatrix_matrix_ao"]]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_rr",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 0]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_rg",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 1]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_rb",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 2]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ra",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 3]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ro",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 4]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_gr",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 5]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_gg",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 6]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_gb",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 7]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ga",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 8]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_go",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 9]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_br",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 10]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_bg",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 11]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_bb",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 12]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ba",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 13]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_bo",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 14]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ar",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 15]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ag",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 16]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ab",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 17]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_aa",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 18]);
		Tweener.registerSpecialProperty ("_ColorMatrix_matrix_ao",	_filter_property_get,	_filter_property_set, [ColorMatrixFilter, "matrix", "matrix", 19]);

		// Shortcuts - ConvolutionFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/ConvolutionFilter.html
		Tweener.registerSpecialProperty ("_Convolution_alpha",			_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "alpha"]);
		Tweener.registerSpecialProperty ("_Convolution_bias",			_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "bias"]);
		Tweener.registerSpecialProperty ("_Convolution_clamp",			_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "clamp"]);
		Tweener.registerSpecialPropertySplitter ("_Convolution_color",	_generic_color_splitter, ["_Convolution_color_r", "_Convolution_color_g", "_Convolution_color_b"]);
		Tweener.registerSpecialProperty ("_Convolution_color_r",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "color", "color", "r"]);
		Tweener.registerSpecialProperty ("_Convolution_color_g",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "color", "color", "g"]);
		Tweener.registerSpecialProperty ("_Convolution_color_b",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "color", "color", "b"]);
		Tweener.registerSpecialProperty ("_Convolution_divisor",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "divisor"]);
		//Tweener.registerSpecialPropertySplitter("_Convolution_matrix",	_generic_array_splitter, ["_Convolution_matrix_array"]);
		//Tweener.registerSpecialProperty("_Convolution_matrix_array",	_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "matrix", "array"]);
		Tweener.registerSpecialProperty ("_Convolution_matrixX",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "matrixX"]);
		Tweener.registerSpecialProperty ("_Convolution_matrixY",		_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "matrixY"]);
		Tweener.registerSpecialProperty ("_Convolution_preserveAlpha",	_filter_property_get,	_filter_property_set,	[ConvolutionFilter, "preserveAlpha"]);

		// Shortcuts - DisplacementMapFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/DisplacementMapFilter.html
		Tweener.registerSpecialProperty ("_DisplacementMap_alpha",			_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "alpha"]);
		Tweener.registerSpecialPropertySplitter ("_DisplacementMap_color",	_generic_color_splitter, ["_DisplacementMap_color_r", "_DisplacementMap_color_r", "_DisplacementMap_color_r"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_color_r",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "color", "color", "r"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_color_g",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "color", "color", "g"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_color_b",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "color", "color", "b"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_componentX",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "componentX"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_componentY",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "componentY"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_mapBitmap",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "mapBitmap"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_mapPoint",		_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "mapPoint"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_mode",			_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "mode"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_scaleX",			_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "scaleX"]);
		Tweener.registerSpecialProperty ("_DisplacementMap_scaleY",			_filter_property_get,	_filter_property_set, [DisplacementMapFilter, "scaleY"]);

		// Shortcuts - DropShadowFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/DropShadowFilter.html
		Tweener.registerSpecialProperty ("_DropShadow_alpha",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "alpha"]);
		Tweener.registerSpecialProperty ("_DropShadow_angle",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "angle"]);
		Tweener.registerSpecialProperty ("_DropShadow_blurX",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_DropShadow_blurY",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "blurY"]);
		Tweener.registerSpecialPropertySplitter ("_DropShadow_color",	_generic_color_splitter, ["_DropShadow_color_r", "_DropShadow_color_g", "_DropShadow_color_b"]);
		Tweener.registerSpecialProperty ("_DropShadow_color_r",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "color", "color", "r"]);
		Tweener.registerSpecialProperty ("_DropShadow_color_g",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "color", "color", "g"]);
		Tweener.registerSpecialProperty ("_DropShadow_color_b",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "color", "color", "b"]);
		Tweener.registerSpecialProperty ("_DropShadow_distance",		_filter_property_get,	_filter_property_set, [DropShadowFilter, "distance"]);
		Tweener.registerSpecialProperty ("_DropShadow_hideObject",		_filter_property_get,	_filter_property_set, [DropShadowFilter, "hideObject"]);
		Tweener.registerSpecialProperty ("_DropShadow_inner",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "inner"]);
		Tweener.registerSpecialProperty ("_DropShadow_knockout",		_filter_property_get,	_filter_property_set, [DropShadowFilter, "knockout"]);
		Tweener.registerSpecialProperty ("_DropShadow_quality",			_filter_property_get,	_filter_property_set, [DropShadowFilter, "quality"]);
		Tweener.registerSpecialProperty ("_DropShadow_strength",		_filter_property_get,	_filter_property_set, [DropShadowFilter, "strength"]);
#end
		// Shortcuts - GlowFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/GlowFilter.html
		Tweener.registerSpecialProperty ("_Glow_alpha",				_filter_property_get,	_filter_property_set, [GlowFilter, "alpha"]);
		Tweener.registerSpecialProperty ("_Glow_blurX",				_filter_property_get,	_filter_property_set, [GlowFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_Glow_blurY",				_filter_property_get,	_filter_property_set, [GlowFilter, "blurY"]);
		Tweener.registerSpecialPropertySplitter ("_Glow_color",		_generic_color_splitter, ["_Glow_color_r", "_Glow_color_g", "_Glow_color_b"]);
		Tweener.registerSpecialProperty ("_Glow_color_r",			_filter_property_get,	_filter_property_set, [GlowFilter, "color", "color", "r"]);
		Tweener.registerSpecialProperty ("_Glow_color_g",			_filter_property_get,	_filter_property_set, [GlowFilter, "color", "color", "g"]);
		Tweener.registerSpecialProperty ("_Glow_color_b",			_filter_property_get,	_filter_property_set, [GlowFilter, "color", "color", "b"]);
		Tweener.registerSpecialProperty ("_Glow_inner",				_filter_property_get,	_filter_property_set, [GlowFilter, "inner"]);
		Tweener.registerSpecialProperty ("_Glow_knockout",			_filter_property_get,	_filter_property_set, [GlowFilter, "knockout"]);
		Tweener.registerSpecialProperty ("_Glow_quality",			_filter_property_get,	_filter_property_set, [GlowFilter, "quality"]);
		Tweener.registerSpecialProperty ("_Glow_strength",			_filter_property_get,	_filter_property_set, [GlowFilter, "strength"]);
#if !tweener_lite
		// Shortcuts - GradientBevelFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/GradientBevelFilter.html
		// .alphas (array)
		Tweener.registerSpecialProperty ("_GradientBevel_angle",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "angle"]);
		Tweener.registerSpecialProperty ("_GradientBevel_blurX",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_GradientBevel_blurY",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "blurY"]);
		// .colors (array)
		Tweener.registerSpecialProperty ("_GradientBevel_distance",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "distance"]);
		Tweener.registerSpecialProperty ("_GradientBevel_quality",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "quality"]);
		// .ratios(array)
		Tweener.registerSpecialProperty ("_GradientBevel_strength",	_filter_property_get,	_filter_property_set, [GradientBevelFilter, "strength"]);
		Tweener.registerSpecialProperty ("_GradientBevel_type",		_filter_property_get,	_filter_property_set, [GradientBevelFilter, "type"]);

		// Shortcuts - GradientGlowFilter
		// http://livedocs.adobe.com/flex/2/langref/flash/filters/GradientGlowFilter.html
		// .alphas (array)
		Tweener.registerSpecialProperty ("_GradientGlow_angle",		_filter_property_get,	_filter_property_set, [GradientGlowFilter, "angle"]);
		Tweener.registerSpecialProperty ("_GradientGlow_blurX",		_filter_property_get,	_filter_property_set, [GradientGlowFilter, "blurX"]);
		Tweener.registerSpecialProperty ("_GradientGlow_blurY",		_filter_property_get,	_filter_property_set, [GradientGlowFilter, "blurY"]);
		// .colors (array)
		Tweener.registerSpecialProperty ("_GradientGlow_distance",	_filter_property_get,	_filter_property_set, [GradientGlowFilter, "distance"]);
		Tweener.registerSpecialProperty ("_GradientGlow_knockout",	_filter_property_get,	_filter_property_set, [GradientGlowFilter, "knockout"]);
		Tweener.registerSpecialProperty ("_GradientGlow_quality",	_filter_property_get,	_filter_property_set, [GradientGlowFilter, "quality"]);
		// .ratios (array)
		Tweener.registerSpecialProperty ("_GradientGlow_strength",	_filter_property_get,	_filter_property_set, [GradientGlowFilter, "strength"]);
		Tweener.registerSpecialProperty ("_GradientGlow_type",		_filter_property_get,	_filter_property_set, [GradientGlowFilter, "type"]);
#end
	}


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
	public static function _generic_color_splitter (p_value:Int, p_parameters:Array<Dynamic>) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		nArray.push ({name:p_parameters[0], value:AuxFunctions.numberToR (p_value)});
		nArray.push ({name:p_parameters[1], value:AuxFunctions.numberToG (p_value)});
		nArray.push ({name:p_parameters[2], value:AuxFunctions.numberToB (p_value)});
		return nArray;
	}

	/**
	 * A generic matrix splitter - from [] to items with the name of the parameters passed
	 *
	 * @param		p_value				Array		The original matrix
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	public static function _generic_matrix_splitter (p_value:Array<Dynamic>, p_parameters:Array<Dynamic>) : Array<Dynamic> {
		if (p_value == null) p_value = p_parameters[0].concat();
		var nArray = new Array<Dynamic>();
		
		for (i in 0...p_value.length) {
			nArray.push ({name:p_parameters[1][i], value:p_value[i]});
		}
		return nArray;
	}

	/**
	 * A generic array splitter - from [] to items with the index passed back
	 *
	 * @param		p_value				Array		The original array value
	 * @return							Array		An array containing the .name and .value of all new properties
	 */
	/*
	public static function _generic_array_splitter (p_value:Array, p_parameters:Array):Array {
		if (p_value == null) p_value = p_parameters[0].concat();
		var nArray:Array = new Array();
		for (var i:Float = 0; i < p_value.length; i++) {
			nArray.push({name:p_parameters[1][i], value:p_value[i], arrayIndex:i});
		}
		return nArray;
	}
	*/

	// ----------------------------------------------------------------------------------------------------------------------------------
	// filters

	/**
	 * Splits the _filter, _blur, etc parameter into specific filter variables
	 *
	 * @param		p_value				BitmapFilter	A BitmapFilter instance
	 * @return							Array			An array containing the .name and .value of all new properties
	 */
	public static function _filter_splitter (p_value:BitmapFilter, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Array<Dynamic> {
		var nArray = new Array<Dynamic>();
		if (Std.is (p_value, BevelFilter)) {
#if !tweener_lite
			nArray.push ({name:"_Bevel_angle",					value:Reflect.field (p_value, "angle")});
			nArray.push ({name:"_Bevel_blurX",					value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_Bevel_blurY",					value:Reflect.field (p_value, "blurY")});
			nArray.push ({name:"_Bevel_distance",				value:Reflect.field (p_value, "distance")});
			nArray.push ({name:"_Bevel_highlightAlpha",			value:Reflect.field (p_value, "highlightAlpha")});
			nArray.push ({name:"_Bevel_highlightColor",			value:Reflect.field (p_value, "highlightColor")});
			nArray.push ({name:"_Bevel_knockout",				value:Reflect.field (p_value, "knockout")});
			nArray.push ({name:"_Bevel_quality",				value:Reflect.field (p_value, "quality")});
			nArray.push ({name:"_Bevel_shadowAlpha",			value:Reflect.field (p_value, "shadowAlpha")});
			nArray.push ({name:"_Bevel_shadowColor",			value:Reflect.field (p_value, "shadowColor")});
			nArray.push ({name:"_Bevel_strength",				value:Reflect.field (p_value, "strength")});
			nArray.push ({name:"_Bevel_type",					value:Reflect.field (p_value, "type")});
#end
		} else if (Std.is (p_value, BlurFilter)) {
			nArray.push ({name:"_Blur_blurX",					value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_Blur_blurY",					value:Reflect.field (p_value, "blurY")});
			nArray.push ({name:"_Blur_quality",					value:Reflect.field (p_value, "quality")});
		} else if (Std.is (p_value, ColorMatrixFilter)) {
#if !tweener_lite
			nArray.push ({name:"_ColorMatrix_matrix",			value:Reflect.field (p_value, "matrix")});
		} else if (Std.is (p_value, ConvolutionFilter)) {
			nArray.push ({name:"_Convolution_alpha",			value:Reflect.field (p_value, "alpha")});
			nArray.push ({name:"_Convolution_bias",				value:Reflect.field (p_value, "bias")});
			nArray.push ({name:"_Convolution_clamp",			value:Reflect.field (p_value, "clamp")});
			nArray.push ({name:"_Convolution_color",			value:Reflect.field (p_value, "color")});
			// .matrix
			nArray.push ({name:"_Convolution_divisor",			value:Reflect.field (p_value, "divisor")});
			nArray.push ({name:"_Convolution_matrixX",			value:Reflect.field (p_value, "matrixX")});
			nArray.push ({name:"_Convolution_matrixY",			value:Reflect.field (p_value, "matrixY")});
			nArray.push ({name:"_Convolution_preserveAlpha",	value:Reflect.field (p_value, "preserveAlpha")});
		} else if (Std.is (p_value, DisplacementMapFilter)) {
			nArray.push ({name:"_DisplacementMap_alpha",		value:Reflect.field (p_value, "alpha")});
			nArray.push ({name:"_DisplacementMap_color",		value:Reflect.field (p_value, "color")});
			nArray.push ({name:"_DisplacementMap_componentX",	value:Reflect.field (p_value, "componentX")});
			nArray.push ({name:"_DisplacementMap_componentY",	value:Reflect.field (p_value, "componentY")});
			nArray.push ({name:"_DisplacementMap_mapBitmap",	value:Reflect.field (p_value, "mapBitmap")});
			nArray.push ({name:"_DisplacementMap_mapPoint",		value:Reflect.field (p_value, "mapPoint")});
			nArray.push ({name:"_DisplacementMap_mode",			value:Reflect.field (p_value, "mode")});
			nArray.push ({name:"_DisplacementMap_scaleX",		value:Reflect.field (p_value, "scaleX")});
			nArray.push ({name:"_DisplacementMap_scaleY",		value:Reflect.field (p_value, "scaleY")});
		} else if (Std.is (p_value, DropShadowFilter)) {
			nArray.push ({name:"_DropShadow_alpha",				value:Reflect.field (p_value, "alpha")});
			nArray.push ({name:"_DropShadow_angle",				value:Reflect.field (p_value, "angle")});
			nArray.push ({name:"_DropShadow_blurX",				value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_DropShadow_blurY",				value:Reflect.field (p_value, "blurY")});
			nArray.push ({name:"_DropShadow_color",				value:Reflect.field (p_value, "color")});
			nArray.push ({name:"_DropShadow_distance",			value:Reflect.field (p_value, "distance")});
			nArray.push ({name:"_DropShadow_hideObject",		value:Reflect.field (p_value, "hideObject")});
			nArray.push ({name:"_DropShadow_inner",				value:Reflect.field (p_value, "inner")});
			nArray.push ({name:"_DropShadow_knockout",			value:Reflect.field (p_value, "knockout")});
			nArray.push ({name:"_DropShadow_quality",			value:Reflect.field (p_value, "quality")});
			nArray.push ({name:"_DropShadow_strength",			value:Reflect.field (p_value, "strength")});
#end
		} else if (Std.is (p_value, GlowFilter)) {
			nArray.push ({name:"_Glow_alpha",					value:Reflect.field (p_value, "alpha")});
			nArray.push ({name:"_Glow_blurX",					value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_Glow_blurY",					value:Reflect.field (p_value, "blurY")});
			nArray.push ({name:"_Glow_color",					value:Reflect.field (p_value, "color")});
			nArray.push ({name:"_Glow_inner",					value:Reflect.field (p_value, "inner")});
			nArray.push ({name:"_Glow_knockout",				value:Reflect.field (p_value, "knockout")});
			nArray.push ({name:"_Glow_quality",					value:Reflect.field (p_value, "quality")});
			nArray.push ({name:"_Glow_strength",				value:Reflect.field (p_value, "strength")});
		} else if (Std.is (p_value, GradientBevelFilter)) {
#if !tweener_lite
			// .alphas (array)
			nArray.push ({name:"_GradientBevel_angle",			value:Reflect.field (p_value, "strength")});
			nArray.push ({name:"_GradientBevel_blurX",			value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_GradientBevel_blurY",			value:Reflect.field (p_value, "blurY")});
			// .colors (array)
			nArray.push ({name:"_GradientBevel_distance",		value:Reflect.field (p_value, "distance")});
			nArray.push ({name:"_GradientBevel_quality",		value:Reflect.field (p_value, "quality")});
			// .ratios(array)
			nArray.push ({name:"_GradientBevel_strength",		value:Reflect.field (p_value, "strength")});
			nArray.push ({name:"_GradientBevel_type",			value:Reflect.field (p_value, "type")});
		} else if (Std.is (p_value, GradientGlowFilter)) {
			// .alphas (array)
			nArray.push ({name:"_GradientGlow_angle",			value:Reflect.field (p_value, "strength")});
			nArray.push ({name:"_GradientGlow_blurX",			value:Reflect.field (p_value, "blurX")});
			nArray.push ({name:"_GradientGlow_blurY",			value:Reflect.field (p_value, "blurY")});
			// .colors (array)
			nArray.push ({name:"_GradientGlow_distance",		value:Reflect.field (p_value, "distance")});
			nArray.push ({name:"_GradientGlow_knockout",		value:Reflect.field (p_value, "knockout")});
			nArray.push ({name:"_GradientGlow_quality",			value:Reflect.field (p_value, "quality")});
			// .ratios(array)
			nArray.push ({name:"_GradientGlow_strength",		value:Reflect.field (p_value, "strength")});
			nArray.push ({name:"_GradientGlow_type",			value:Reflect.field (p_value, "type")});
#end
		} else {
			// ?
			trace ("Tweener FilterShortcuts Error :: Unknown filter class used");
		}
		return nArray;
	}


	// ==================================================================================================================================
	// NORMAL SPECIAL PROPERTY functions ------------------------------------------------------------------------------------------------

	// ----------------------------------------------------------------------------------------------------------------------------------
	// filters

	/**
	 * (filters)
	 * Generic function for the properties of filter objects
	 */
	public static function _filter_property_get (p_obj:Dynamic, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Float {
		var f:Array<Dynamic> = p_obj.filters;
		var filterClass:Dynamic = p_parameters[0];
		var propertyName:String = p_parameters[1];
		var splitType:String = p_parameters[2];
		
		for (i in 0...f.length) {
			if (Std.is (f[i], filterClass)) {
				if (splitType == "color") {
					// Composite, color channel
					var colorComponent:String = p_parameters[3];
					if (colorComponent == "r") return AuxFunctions.numberToR (Reflect.field (f[i], propertyName));
					if (colorComponent == "g") return AuxFunctions.numberToG (Reflect.field (f[i], propertyName));
					if (colorComponent == "b") return AuxFunctions.numberToB (Reflect.field (f[i], propertyName));
				} else if (splitType == "matrix") {
					// Composite, some kind of matrix
					return Reflect.field (Reflect.field (f[i], propertyName), p_parameters[3]);
				} else {
					// Standard property
					return Reflect.field (f[i], propertyName);
				}
			}
		}

		// No value found for this property - no filter instance found using this class!
		// Must return default desired values
		var defaultValues : Dynamic;
		switch (filterClass) {
			case BevelFilter: defaultValues = {angle:Math.NaN, blurX:0, blurY:0, distance:0, highlightAlpha:1, highlightColor:Math.NaN, knockout:null, quality:Math.NaN, shadowAlpha:1, shadowColor:Math.NaN, strength:2, type:null};
			case BlurFilter: defaultValues = {blurX:0, blurY:0, quality:Math.NaN};
			case ColorMatrixFilter: defaultValues = {matrix:[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]};
			case ConvolutionFilter: defaultValues = {alpha:0, bias:0, clamp:null, color:Math.NaN, divisor:1, matrix:[1], matrixX:1, matrixY:1, preserveAlpha:null};
			//case DisplacementMapFilter: defaultValues = {alpha:0, color:Math.NaN, componentX:null, componentY:null, mapBitmap:null, mapPoint:null, mode:null, scaleX:0, scaleY:0};
			case DropShadowFilter: defaultValues = {distance:0, angle:Math.NaN, color:Math.NaN, alpha:1, blurX:0, blurY:0, strength:1, quality:Math.NaN, inner:null, knockout:null, hideObject:null};
			case GlowFilter: defaultValues = {alpha:1, blurX:0, blurY:0, color:Math.NaN, inner:null, knockout:null, quality:Math.NaN, strength:2};
			case GradientBevelFilter: defaultValues = {alphas:null, angle:Math.NaN, blurX:0, blurY:0, colors:null, distance:0, knockout:null, quality:Math.NaN, ratios:Math.NaN, strength:1, type:null};
			case GradientGlowFilter: defaultValues = {alphas:null, angle:Math.NaN, blurX:0, blurY:0, colors:null, distance:0, knockout:null, quality:Math.NaN, ratios:Math.NaN, strength:1, type:null};
			default : defaultValues = {};
		}
		// When returning NaN, the Tweener engine sets the starting value as being the same as the final value (if not found)
		// When returning null, the Tweener engine doesn't tween it at all, just setting it to the final value
		// This is DIFFERENT from the default filter applied as default on _filter_property_set because some values shouldn't be tweened
		if (splitType == "color") {
			// Composite, color channel; always defaults to target value
			return Math.NaN;
		} else if (splitType == "matrix") {
			// Composite, matrix; always defaults to target value
			return Reflect.field (Reflect.field (defaultValues, propertyName), p_parameters[3]);
		} else {
			// Standard property
			return Reflect.field (defaultValues, propertyName);
		}
	}

	public static function _filter_property_set (p_obj:Dynamic, p_value:Float, p_parameters:Array<Dynamic>, ?p_extra:Dynamic = null) : Void {
		var f:Array<Dynamic> = p_obj.filters;
		var filterClass:Dynamic = p_parameters[0];
		var propertyName:String = p_parameters[1];
		var splitType:String = p_parameters[2];
		
		for (i in 0...f.length) {
			if (Std.is (f[i], filterClass)) {
				if (splitType == "color") {
					// Composite, color channel
					var colorComponent:String = p_parameters[3];
					untyped {
						if (colorComponent == "r") Reflect.setField (f[i], propertyName, (Std.parseInt (Reflect.field (f[i], propertyName)) & 0xffff)   | (p_value << 16));
						if (colorComponent == "g") Reflect.setField (f[i], propertyName, (Std.parseInt (Reflect.field (f[i], propertyName)) & 0xff00ff) | (p_value << 8));
						if (colorComponent == "b") Reflect.setField (f[i], propertyName, (Std.parseInt (Reflect.field (f[i], propertyName)) & 0xffff00) | p_value);
					}
				} else if (splitType == "matrix") {
					var mtx:Array<Dynamic> = Reflect.field (f[i], propertyName);
					mtx[p_parameters[3]] = p_value;
					Reflect.setField (f[i], propertyName, mtx);
				} else {
					// Standard property
					Reflect.setField (f[i], propertyName, p_value);
				}
				p_obj.filters = f;
				return;
			}
		}

		// The correct filter class wasn't found, so create a new one that is the equivalent of the object without the filter
		if (f == null) f = new Array<Dynamic>();
		var fi : BitmapFilter = null;
		switch (filterClass) {
			case BevelFilter: fi = new BevelFilter (0, 45, 0xffffff, 1, 0x000000, 1, 0, 0);
			case BlurFilter: fi = new BlurFilter (0, 0);
			case ColorMatrixFilter: fi = new ColorMatrixFilter ([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
			case ConvolutionFilter: fi = new ConvolutionFilter (1, 1, [1], 1, 0, true, true, 0x000000, 0);
			//case DisplacementMapFilter: fi = new DisplacementMapFilter (new BitmapData(10, 10), new Point(0, 0), 0, 1, 0, 0);
			case DropShadowFilter: fi = new DropShadowFilter (0, 45, 0x000000, 1, 0, 0);
			case GlowFilter: fi = new GlowFilter (0xff0000, 1, 0, 0);
			case GradientBevelFilter: fi = new GradientBevelFilter (0, 45, [0xffffff, 0x000000], [1, 1], [32, 223], 0, 0);
			case GradientGlowFilter: fi = new GradientGlowFilter (0, 45, [0xffffff, 0x000000], [1, 1], [32, 223], 0, 0);
		}
		//fi[propertyName] = p_value;
		f.push (fi);
		p_obj.filters = f;
		_filter_property_set (p_obj, p_value, p_parameters);
	}
}
