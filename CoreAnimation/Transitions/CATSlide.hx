//
//  Slide
//
//  Created by Baluta Cristian on 2009-03-26.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class CATSlide extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		constraintBounds = Reflect.field (properties, "constraintBounds");
		var fromScale = 1.;
		var toScale = 1.;
		var fromAlpha = .0;
		var toAlpha = 1.;
		var fromRotation = .0;
		var toRotation = .0;
		
		var zoom :Dynamic = Reflect.field (properties, "slide");
		
		if ( zoom != null ) {
			if (Std.is (zoom, Int) || Std.is (zoom, Float)) {
				
				fromScale = target.scaleX;
				toScale = fromScale * zoom;
			}
			else if (Std.is (zoom, String)) {
				switch ( zoom.toLowerCase() ) {
					case "tumbleweed":null;// rotation+alpha
					case "push":null;
					case "slide":null;
					case "reveal":null;
				}
			}
			else {
				var _fromScale	:Null<Float> = Reflect.field (zoom, "fromScale");
				var _toScale	:Null<Float> = Reflect.field (zoom, "toScale");
				var _fromAlpha	:Null<Float> = Reflect.field (zoom, "fromAlpha");
				var _toAlpha	:Null<Float> = Reflect.field (zoom, "toAlpha");
				var _fromRot	:Null<Float> = Reflect.field (zoom, "fromRotation");
				var _toRot		:Null<Float> = Reflect.field (zoom, "toRotation");
				
				if (_fromScale != null) fromScale = _fromScale;
				if (_toScale != null)	toScale = _toScale;
				if (_fromAlpha != null) fromAlpha = _fromAlpha;
				if (_toAlpha != null)	toAlpha = _toAlpha;
				if (_fromRot != null)	fromRotation = _fromRot;
				if (_toRot != null)		toRotation = _toRot;
			}
		}
		
		// Set the properties that are used to zoom the object: x, y, width, height, alpha
		// >>
		// Get the original properties of the object
		var i_w = target.width;
		var i_h = target.height;
		var i_x = target.x;
		var i_y = target.y;
		
		// Final values we should zoom to
		var f_w = i_w * toScale;
		var f_h = i_h * toScale;
		var f_x = Math.round (i_x + (i_w - f_w) / 2);// center the object relative to his original position and size
		var f_y = Math.round (i_y + (i_h - f_h) / 2);
		
		// Set the object properties to their starting position
		target.width *= fromScale;
		target.height *= fromScale;
		target.x = Math.round (i_x + (i_w - target.width) / 2);
		target.y = Math.round (i_y + (i_h - target.height)/ 2);
		target.alpha = fromAlpha;
		
		// Set the starting and ending properties to the CAObject also
		fromValues = {	x		: target.x,
						y		: target.y,
						width	: target.width,
						height	: target.height,
						alpha	: fromAlpha
					};
		
		toValues = {	x		: f_x,
						y		: f_y,
						width	: f_w,
						height	: f_h,
						alpha	: toAlpha
					};
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues))
			Reflect.setField (target, prop, calculate (time_diff, prop));
	}
}
