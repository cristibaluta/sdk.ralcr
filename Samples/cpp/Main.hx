//
//  Main
//
//  Created by Cristi Baluta on 2010-11-04.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import nme.Lib;
import flash.display.Sprite;
import flash.display.Shape;
import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Linear;	
import com.gskinner.motion.easing.Quadratic;
import com.gskinner.motion.easing.Cubic;
import com.gskinner.motion.easing.Quartic;
import com.gskinner.motion.easing.Quintic;
import com.gskinner.motion.easing.Exponential;
import com.gskinner.motion.easing.Sine;
import com.gskinner.motion.easing.Circular;
import com.gskinner.motion.easing.Back;
import com.gskinner.motion.easing.Bounce;
import com.gskinner.motion.easing.Elastic;


class Main extends Sprite {
	
	
    static function main() {
        trace("Hello World !");
		
		Lib.create (
				function(){
					new Main();
				},
				640, 480, 60, 0xccccff, (1*Lib.HARDWARE) | Lib.RESIZABLE
		);
    }



	public function new() {
		super();
		flash.Lib.current.addChild(this);
		
		var circle:Shape = new Shape( );
		circle.graphics.beginFill ( 0xff9933 , 1 );
		circle.graphics.drawCircle ( 0 , 0 , 40 );
		circle.x = 80;
		circle.y = 80;
		
		addChild ( circle );
		
/*		var obj = new CAObject(circle, {x:500, y:200}, 1, caequations.Cubic.IN_OUT);
			obj.delegate.animationDidStop = animationDidStop;
		CoreAnimation.add ( obj );*/
		new GTween (circle, 1, {x:500, scaleX:1.2, scaleY:1.8}, {ease:Cubic.easeInOut, onComplete:animationDidStop});
		
		circle.addEventListener (flash.events.MouseEvent.MOUSE_DOWN, md);
		haxe.Timer.delay (animationDidStop, 1500);
	}
	function animationDidStop () {
		trace("animation did stop");
	}
		function md (_) {
			trace("mouse down");
		}
	
}