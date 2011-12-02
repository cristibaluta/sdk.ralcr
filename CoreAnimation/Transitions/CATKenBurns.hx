//
//  KenBurns
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class CATKenBurns extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		// Use a number from 0 to 10 to decide the direction of movement
		var random_direction_x = Std.random ( 10 );
		var random_direction_y = Std.random ( 10 );
		
		// Scale the photo to it's original size
		target.scaleX = 1;
		target.scaleY = 1;
		// Store it's original size as the final width and height of the animation
		var f_w = target.width;
		var f_h = target.height;
		
		// Scale the photo to fill the constraintBounds
		var x = constraintBounds.origin.x;
		var y = constraintBounds.origin.y;
		var w = constraintBounds.size.width;
		var h = constraintBounds.size.height;
		
		// Begin the scale
		if (w / target.width > h / target.height) {
			target.width = w;
			target.height = w * f_h / f_w;
		}
		else {
			target.height = h;
			target.width = h * f_w / f_h;
		}
		
		
		//	If the photo in its 100% size is smaller than the constraintBounds,
		//	set the final width and height to the ones that fits the constraintBounds
		if (f_w < w || f_h < h) {
			f_w = target.width;
			f_h = target.height;
		}
		
		
		// Find the x, y coordinates where the photo should animate to: left or right
		var f_x = random_direction_x > 5
		? (x - f_w + w)// left
		:  x;// right
		
		var f_y = random_direction_y > 5
		? (y - f_h + h)// top
		:  y;// bottom
		
		
		// Position the photo from where the animation should start
		target.x = random_direction_x > 5
		? x// right
		: (x - target.width + w);// left
		
		target.y = random_direction_y > 5
		? y// bottom
		: (y - target.height + h);// top
		
		target.alpha = 0;
		
		
		// Set the properties that are used to zoom the object: x, y, width, height, alpha
		// >>
		// Get the original properties of the object
		var i_w = target.width;
		var i_h = target.height;
		var i_x = target.x;
		var i_y = target.y;
		
		// Final values we should zoom to
		// already inited: f_w, f_h, f_x, f_y
		
		// Set the fading in and fading out points
		var p1 = delegate.kenBurnsPointIn;
		var p2 = delegate.kenBurnsPointOut;
		if (p1 == null) delegate.kenBurnsPointIn = duration*1000 / 5;
		if (p2 == null) delegate.kenBurnsPointOut = duration*1000 * 4 / 5;
		
		// Set the starting and ending properties to the CAObject also
		fromValues = {	x		: target.x,
						y		: target.y,
						width	: target.width,
						height	: target.height,
						alpha	: null
					};
		
		toValues = {	x		: f_x,
						y		: f_y,
						width	: f_w,
						height	: f_h,
						alpha	: null
					};
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues)) {
			if (prop != "alpha") {
				Reflect.setField (target, prop, calculate (time_diff, prop));
			
			} else if (time_diff < delegate.kenBurnsPointIn) {
				// Calculate the alpha separately, depending on the kenBurnsPoints
				Reflect.setField (target, prop, calculateAlpha (time_diff, 0, 1));
			}
			else if (time_diff > delegate.kenBurnsPointOut) {
				Reflect.setField (target, prop, calculateAlpha (time_diff - delegate.kenBurnsPointOut, 1, 0));
			}
		}
	}
	
	public function calculateAlpha (time_diff:Float, fromAlpha:Float, toAlpha:Float) :Float {
		
		var duration = fromAlpha == 0
		? delegate.kenBurnsPointIn
		: (duration - delegate.kenBurnsPointOut);
		
		return  timingFunction (	time_diff,
									fromAlpha,
									toAlpha - fromAlpha,
									duration, null
								);
	}
}
