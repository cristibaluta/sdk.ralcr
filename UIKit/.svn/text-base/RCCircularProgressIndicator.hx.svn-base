//
//  Preloader
//
//  Created by Baluta Cristian on 2008-05-09.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//
import flash.display.Sprite;
import flash.display.GradientType;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.events.Event;

class RCCircularProgressIndicator extends Sprite {
	
	inline static var RAZA : Int = 10;
	inline static var SPEED : Int = 20;
	
	public function new (x, y) {
		super();
		this.x = x;
		this.y = y;
		
		var colors = [0x000000, 0xFF0066];
		var alphas = [0, 1];
		var ratios = [0, 255];
		var matrix : Matrix = new Matrix();
			matrix.createGradientBox (RAZA, RAZA, 0, 0, 0);
		this.graphics.beginGradientFill (GradientType.LINEAR, colors, alphas, ratios, matrix);
		
		// deseneaza gradient
		this.graphics.drawCircle (0, 0, RAZA);
		this.graphics.endFill();
		
		
		this.addEventListener (Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function onEnterFrame (event:Event) : Void {
		this.rotation += SPEED;
	}
	
	
	public function destroy () : Void {
		this.removeEventListener (Event.ENTER_FRAME, onEnterFrame);
	}
}
