//
//  Color
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.geom.ColorTransform;


class CATColors extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		var toMultiplier :Float = 1;
		var fromOffset :Null<Int> = null;
		var toOffset :Null<Int> = null;
		var fromAlpha :Null<Int> = 0;
		var toAlpha :Null<Int> = null;
		var toColor :Null<Int> = null;
		
		var color :Dynamic = Reflect.field (properties, "color");
		if ( color != null )
		if (Std.is (color, Int) || Std.is (color, UInt)) {
			
			// Fade to a RGB color, flat color
			toColor = color;
			toMultiplier = 0;
		}
		else if (Std.is (color, String)) {
			// Predefined ColorTransforms
			// 255 = white; -255 = black; 0 = no transformation
			fromAlpha = 0;
			toAlpha = 0;
			
			switch ( color.toLowerCase() ) {
				case "colorburnout":	fromOffset = 255;	toOffset = 0;
				case "colorburnin":		fromOffset = 0;		toOffset = 255;
				case "colordodgeout":	fromOffset = -255;	toOffset = 0;
				case "colordodgein":	fromOffset = 0;		toOffset = -255;
			}
		}
		else {
			// Custom ColorTransforms
			fromOffset = Reflect.field (color, "fromOffset");
			toOffset = Reflect.field (color, "toOffset");
			var _fromAlpha :Null<Int> = Reflect.field (color, "fromAlpha");
			toAlpha = Reflect.field (color, "toAlpha");
			if (_fromAlpha != null) fromAlpha = _fromAlpha;
		}
		
		
		// Get the starting colorTransform of the object
		//
		// multiplier = 1 if we want to use color burn and dodge
		//				0 if we want to manipulate the overall color
		var redMultiplier	= getColorTransform (target, "redMultiplier");
		var redOffset 		= getColorTransform (target, "redOffset");
		var greenMultiplier = getColorTransform (target, "greenMultiplier");
		var greenOffset 	= getColorTransform (target, "greenOffset");
		var blueMultiplier 	= getColorTransform (target, "blueMultiplier");
		var blueOffset 		= getColorTransform (target, "blueOffset");
		var alphaMultiplier = getColorTransform (target, "alphaMultiplier");
		var alphaOffset 	= getColorTransform (target, "alphaOffset");
		
		// Set the starting and ending properties to the CAObject
		fromValues = {redMultiplier	: redMultiplier,
							redOffset		: fromOffset != null ? fromOffset : redOffset,
							greenMultiplier	: greenMultiplier,
							greenOffset		: fromOffset != null ? fromOffset : greenOffset,
							blueMultiplier	: blueMultiplier,
							blueOffset		: fromOffset != null ? fromOffset : blueOffset,
							alphaMultiplier	: alphaMultiplier,
							alphaOffset		: fromAlpha
						};
		//
		toValues = {	redMultiplier	: toMultiplier,//redMultiplier,
							redOffset		: toOffset == null ? numberToR (toColor) : toOffset,
							greenMultiplier	: toMultiplier,//greenMultiplier,
							greenOffset		: toOffset == null ? numberToG (toColor) : toOffset,
							blueMultiplier	: toMultiplier,//blueMultiplier,
							blueOffset		: toOffset == null ? numberToB (toColor) : toOffset,
							alphaMultiplier	: 1,//alphaMultiplier,
							alphaOffset		: toColor != null ? 0 : toAlpha
						};
						//trace(Std.string(fromValues));
						//trace(Std.string(toValues));
		
		// Reset all the previous color transformations of the object
		//resetColors ( target );
		// Apply the starting colortransform to the object
		for (prop in Reflect.fields (fromValues))
			setColorTransform (target, prop, Reflect.field (fromValues, prop));
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues))
			setColorTransform (target, prop, Math.round (calculate (time_diff, prop)));
	}
	
	
	/**
	 * Generic function for the redMultiplier/redOffset/etc components of the new colorTransform
	 */
	inline function getColorTransform (obj:Dynamic, param:String) :Int {
		return Reflect.field (obj.transform.colorTransform, param);
	}
	
	function setColorTransform (obj:Dynamic, prop:String, value:Int) :Void {
		
		var ct:ColorTransform = obj.transform.colorTransform;
		Reflect.setField (ct, prop, value);
		obj.transform.colorTransform = ct;
	}
	
	
	/**
	 *	Set the color of an object
	 *	Multiplier can be 0(flat color) or 1(color transformations)
	 */
/*	public static function setColor (obj:Dynamic, color:Int, ?multiplier:Float=0) :Void {
		
		var red   = numberToR (color);//color >> 16;
		var green = numberToG (color);//color >> 8 & 0xFF;
		var blue  = numberToB (color);//color &  0xFF;
		var alpha = 0;
		
		obj.transform.colorTransform = new ColorTransform (	multiplier,	multiplier,	multiplier, 1,
															red,		green,		blue,		alpha	);
															trace(Std.string(obj.transform.colorTransform));
	}*/
	inline public function numberToR (p_num:Int) :Int {
		// The initial & is meant to crop numbers bigger than 0xffffff
		return (p_num & 0xff0000) >> 16;
	}
	inline public function numberToG (p_num:Int) :Int {
		return (p_num & 0xff00) >> 8;
	}
	inline public function numberToB (p_num:Int) :Int {
		return (p_num & 0xff);
	}
	
	
	/**
	 *	Reset the colorTransform of an object
	 */
	public function resetColors (obj:Dynamic) :Void {
		obj.transform.colorTransform = new ColorTransform (	1,	1,	1,	1,
															0,	0,	0,	0	);
	}
}
