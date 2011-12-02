//
//  RCRandomCurve
//
//  Created by Cristi Baluta on 2010-05-11.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.Shape;


class RCRandomCurve extends RCDraw, implements RCDrawInterface {
	
	public var points :Int;// Rounded corners radius
	
	
	public function new (x, y, w, h, ?color:Int, ?alpha:Float=1.0, ?points:Int=2) {
		super (x, y, w, h, color, alpha);
		
		this.points = points;
		this.redraw();
	}
	
	public function redraw () :Void {
		
		points = (points < 2) ? 2 : points;
		
		var curve = new Shape();
			curve.graphics.lineStyle (1, color, 0.9);
		
		for (i in 0...points) {
			curve.graphics.curveTo (size.width/2-Math.random()*size.width, 30-Math.random()*60,
									Math.random()*50, 30+Math.random()*20);
		}
		
		this.addChild ( curve );
	}
}
