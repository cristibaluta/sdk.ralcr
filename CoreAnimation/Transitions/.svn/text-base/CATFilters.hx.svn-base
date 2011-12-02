//
//  Filters
//
//  Created by Cristi Baluta on 2010-05-27.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.DisplayObjectContainer;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;


class CATFilters extends CAObject, implements CATransitionInterface {
	
	// Only Float properties are animatable
	inline static var FILTERS = ["glow", "blur", "shadow"];
	inline static var BLUR_PROPERTIES = ["blurX", "blurY", "quality"];
	inline static var GLOW_PROPERTIES = ["alpha", "blurX", "blurY", "strength"];
	inline static var GLOW_FIXED_PROPERTIES = ["color", "quality", "inner"/*Bool*/, "knockout"/*Bool*/];
	inline static var SHADOW_PROPERTIES = ["distance", "angle", "alpha", "blurX", "blurY", "strength"];
	inline static var SHADOW_FIXED_PROPERTIES = ["color", "quality", "inner"/*Bool*/, "knockout"/*Bool*/, "hideObject"/*Bool*/];
	
	
	override public function init () :Void {
		
		var fromBlur :BlurFilter = null;
		var toBlur :BlurFilter = null;
		var fromGlow :GlowFilter = null;
		var toGlow :GlowFilter = null;
		var fromShadow :DropShadowFilter = null;
		var toShadow :DropShadowFilter = null;
		
		for (filterName in FILTERS) {
			var filterValue :Dynamic = Reflect.field (properties, filterName);
			
			if (filterValue != null)
			switch (filterName) {
			case "blur":
				if (Std.is (filterValue, Int) || Std.is (filterValue, Float)) {
					// We have directly a value
					fromBlur = getCurrentBlurFilter ( target );
					toBlur = new BlurFilter (filterValue, filterValue, 3);
				}
				// Set the values to be animatable
				for (prop in BLUR_PROPERTIES) {
					Reflect.setField (fromValues, "blur_" + prop, Reflect.field (fromBlur, prop));
					Reflect.setField (toValues, "blur_" + prop, Reflect.field (toBlur, prop));
				}
				
			case "glow":
				if (Std.is (filterValue, Int) || Std.is (filterValue, Float)) {
					// We have directly a value
					fromGlow = getCurrentGlowFilter ( target );
					fromGlow.knockout = false;
					fromGlow.inner = false;
					fromGlow.quality = 3;
					
					toGlow = new GlowFilter();
					toGlow.alpha = 1;
					toGlow.blurX = filterValue;
					toGlow.blurY = filterValue;
					toGlow.strength = 3;
					// Set non-animatable properties
					//fromGlow.color = toGlow.color = 0x000000;
					toGlow.quality = 3;
					toGlow.inner = false;
					toGlow.knockout = false;
				}
				// Set the values to be animatable
				for (prop in GLOW_PROPERTIES.concat( GLOW_FIXED_PROPERTIES )) {
					Reflect.setField (fromValues, "glow_" + prop, Reflect.field (fromGlow, prop));
					Reflect.setField (toValues, "glow_" + prop, Reflect.field (toGlow, prop));
				}
						
						
			case "shadow":
				if (Std.is (filterValue, Int) || Std.is (filterValue, Float)) {
					// We have directly a value
					fromShadow = getCurrentShadowFilter ( target );
					fromShadow.quality = 3;
					fromShadow.inner = false;
					fromShadow.knockout = false;
					fromShadow.hideObject = false;
					
					toShadow = new DropShadowFilter (10, 45, 0x000000, 1);
					toShadow.distance = 10;
					toShadow.angle = 45;
					toShadow.alpha = 1;
					toShadow.blurX = filterValue;
					toShadow.blurY = filterValue;
					toShadow.strength = 3;
					// Set non-animatable properties
					//fromGlow.color = toGlow.color = 0x000000;
					toShadow.quality = 3;
					toShadow.inner = false;
					toShadow.knockout = false;
					toShadow.hideObject = false;
				}
				// Set the values to be animatable
				for (prop in SHADOW_PROPERTIES.concat( SHADOW_FIXED_PROPERTIES )) {
					Reflect.setField (fromValues, "shadow_" + prop, Reflect.field (fromShadow, prop));
					Reflect.setField (toValues, "shadow_" + prop, Reflect.field (toShadow, prop));
				}


			default:
				null;
			}
		}
		trace(fromValues);
		trace(toValues);
	}
	
	override public function animate (time_diff:Float) :Void {
		
		var currentBlur :BlurFilter = null;
		var currentGlow :GlowFilter = null;
		var currentShadow :DropShadowFilter = null;
		
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues)) {
			var value = calculate (time_diff, prop);
			
			if (prop.indexOf("blur_") != -1) {
				if (currentBlur == null)
					currentBlur = new BlurFilter();
				Reflect.setField (currentBlur, prop.split("blur_").pop(), value);
			}
			else if (prop.indexOf("glow_") != -1) {
				if (currentGlow == null)
					currentGlow = new GlowFilter();
				var p = prop.split("glow_").pop();
				var v = (GLOW_FIXED_PROPERTIES.join("-").split( p ).length > 1)
				? Reflect.field (toValues, prop)
				: value;
				Reflect.setField (currentGlow, p, v);
			}
			else if (prop.indexOf("shadow_") != -1) {
				if (currentShadow == null)
					currentShadow = new DropShadowFilter();
				var p = prop.split("shadow_").pop();
				var v = (SHADOW_FIXED_PROPERTIES.join("-").split( p ).length > 1)
				? Reflect.field (toValues, prop)
				: value;
				Reflect.setField (currentShadow, p, v);
			}
		}
		
		if (currentBlur != null)
			target.filters = [currentBlur];
		else if (currentGlow != null)
			target.filters = [currentGlow];
		else if (currentShadow != null)
			target.filters = [currentShadow];
			
/*		return;
		for (f in target.filters) {
			if (Std.is (f, BlurFilter) && currentBlur != null)
				target.filters = [currentBlur];
			else if (Std.is (f, GlowFilter) && currentGlow != null)
				target.filters = [currentGlow];
			else if (Std.is (f, DropShadowFilter) && currentShadow != null)
				target.filters = [currentShadow];
		}*/
	}
	
	
	function getCurrentGlowFilter (obj:DisplayObjectContainer) :GlowFilter {
		for (f in obj.filters)
			if (Std.is (f, GlowFilter))
				return f;
		var glow = new GlowFilter();
			glow.alpha = 1;
			glow.blurX = 0;
			glow.blurY = 0;
			glow.strength = 3;
		return glow;
	}
	
	function getCurrentBlurFilter (obj:DisplayObjectContainer) :BlurFilter {
		for (f in obj.filters)
			if (Std.is (f, BlurFilter))
				return f;
				return new BlurFilter (0, 0, 3);
	}
	
	function getCurrentShadowFilter (obj:DisplayObjectContainer) :DropShadowFilter {
		for (f in obj.filters)
			if (Std.is (f, DropShadowFilter))
				return f;
		var shadow = new DropShadowFilter();
			shadow.distance = 0;
			shadow.angle = 0;
			shadow.alpha = 1;
			shadow.blurX = 0;
			shadow.blurY = 0;
			shadow.strength = 3;
		return shadow;
	}
}
