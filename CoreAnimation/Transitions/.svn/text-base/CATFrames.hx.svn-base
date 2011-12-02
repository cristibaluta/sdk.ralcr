//
//  Frames
//
//  Created by Cristi Baluta on 2010-09-30.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.MovieClip;


class CATFrames extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		var fromFrame :Int = target.currentFrame;
		var toFrame :Int = target.currentFrame;
		
		var frame :Dynamic = Reflect.field (properties, "frame");
		
		
		if (frame != null) {
			if (Std.is (frame, Int) || Std.is (frame, Float)) {
				toFrame = Math.round ( frame );
			}
			else {
				var _fromFrame	:Null<Int> = Reflect.field (frame, "fromValue");
				var _toFrame	:Null<Int> = Reflect.field (frame, "toValue");
				
				if (_fromFrame != null)	fromFrame = _fromFrame;
				if (_toFrame != null)	toFrame = _toFrame;
			}
		}
		
		fromValues = { frame : fromFrame };
		toValues = { frame : toFrame };
	}
	
	override public function animate (time_diff:Float) :Void {
		target.gotoAndStop ( Math.round (calculate (time_diff, "frame")) );
	}
}
