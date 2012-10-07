//
//  RCCircularProgressIndicator.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-05-09.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import flash.display.GradientType;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.events.Event;


class RCCircularProgressIndicator extends RCView {
	
	inline static var RAZA : Int = 10;
	inline static var SPEED : Int = 20;
	
	public function new (x, y) {
		super (x, y);
		
		var colors = [0x000000, 0xFF0066];
		var alphas = [0, 1];
		var ratios = [0, 255];
		var matrix : Matrix = new Matrix();
			matrix.createGradientBox (RAZA, RAZA, 0, 0, 0);
		layer.graphics.beginGradientFill (GradientType.LINEAR, colors, alphas, ratios, matrix);
		
		// deseneaza gradient
		layer.graphics.drawCircle (0, 0, RAZA);
		layer.graphics.endFill();
	}
	
	public function loop () : Void {
		//this.rotation += SPEED;
	}
	
	
	override public function destroy () : Void {
		super.destroy();
	}
}
