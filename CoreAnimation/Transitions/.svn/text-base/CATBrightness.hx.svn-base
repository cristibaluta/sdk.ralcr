//
//  Brightness
//
//  Created by Cristi Baluta on 2010-05-20.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.filters.ColorMatrixFilter;
import flash.display.DisplayObjectContainer;


class CATBrightness extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		var fromBrightness :Int = 0;
		var toBrightness :Int = 0;
		
		var brightness :Dynamic = Reflect.field (properties, "brightness");
		if (brightness != null)
		if (Std.is (brightness, Int) || Std.is (brightness, UInt) || Std.is (brightness, Float)) {
			toBrightness = brightness;
		}
		else {
			// Custom brightnesses
			fromBrightness = Reflect.field (brightness, "fromValue");
			toBrightness = Reflect.field (brightness, "toValue");
		}
		
		// Set the starting and ending properties to the CAObject
		fromValues = {brightness	: fromBrightness};
		toValues = {brightness	: toBrightness};
		
		// Apply the starting brightness and alpha
		setBrightness (target, fromBrightness);
	}
	
	override public function animate (time_diff:Float) :Void {
		var toBrightness = Math.round ( calculate (time_diff, "brightness") );
		setBrightness (target, toBrightness);
	}
	
	
	public function setBrightness (obj:DisplayObjectContainer, brightness:Int) :Void {
		
		var m =  [	1,0,0,0,brightness,
					0,1,0,0,brightness,
					0,0,1,0,brightness,
					0,0,0,1,0,
					0,0,0,0,1];
		
		var matrix :Array<Dynamic> = [];
		var col :Array<Dynamic> = [];
		
		for (i in 0...5) {
			for (j in 0...5) {
				col[j] = m[j + i * 5];
			}
			for (j in 0...5) {
				var val = 0.0;
				for (k in 0...5) {
					val += m[j + k * 5] * col[k];
				}
				matrix[j + i * 5] = val;
			}
		}
		
		obj.filters = [new ColorMatrixFilter ( matrix )];
	}
	
	/**
	 *	Reset the brightness of an object
	 */
	public function resetBrightness (obj:Dynamic) :Void {
		setBrightness (obj, 0);
	}
}
