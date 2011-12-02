//
//  RCRandomShape
//
//  Created by Cristi Baluta on 2010-05-11.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.Shape;


class RCRandomShape extends RCDraw, implements RCDrawInterface {
	
	public var points :Int;// Rounded corners radius
	
	
	public function new (x, y, w, h, ?color:Dynamic, ?alpha:Float=1.0, ?points:Int) {
		super (x, y, w, h, color, alpha);
		
		this.points = points;
		this.redraw();
	}
	
	public function redraw () :Void {
		
		var shape = new Shape();
			shape.graphics.beginFill (color, 1);
			
		for (i in 0...points) {
			
			shape.graphics.curveTo (Math.random()*50, -Math.random()*30, 50, 30);
			shape.graphics.curveTo (30+30-Math.random()*60, 30+Math.random()*30, 30, 60);
			shape.graphics.curveTo (30-Math.random()*60, Math.random()*60, 0, 0);
		}
	}
}
