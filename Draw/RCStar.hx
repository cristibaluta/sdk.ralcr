//
//  RCStar
//
//  Created by Cristi Baluta on 2010-02-19.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//

class RCStar extends RCDraw, implements RCDrawInterface {
	
	public var points :UInt;
	public var innerRadius :Int;
	public var outerRadius :Int;
	public var angle :Int;
	
	// ==============
	// mc.drawStar() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
	// 
	// x, y = center of star
	// points = number of points (Math.abs(points) must be > 2)
	// innerRadius = radius of the indent of the points
	// outerRadius = radius of the tips of the points
	// angle = [optional] starting angle in degrees. (defaults to 0)
	// ==============
	public function new (x, y, w, h, color:Dynamic, alpha:Float=1.0, points:UInt, innerRadius, outerRadius, angle:Int=0) {
		super (x, y, w, h, color, alpha);
		
		this.points = points;
		this.innerRadius = innerRadius;
		this.outerRadius = outerRadius;
		this.angle = angle;
		
		this.redraw();
	}
	
	
	public function redraw() :Void {
		
		this.graphics.clear();
		this.configure();
		
		if (points <= 2)
			points = 3;
		
		// init vars
		var step, halfStep, start, dx, dy;
		
		// calculate distance between points
		step = Math.PI * 2 / points;
		halfStep = step / 2;
		
		// calculate starting angle in radians
		start = (angle / 180) * Math.PI;
		this.graphics.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
		
		// draw lines
		for (i in 0...points) {
			dx = x + Math.cos (start + (step*(i+1)) - halfStep) * innerRadius;
			dy = y - Math.sin (start + (step*(i+1)) - halfStep) * innerRadius;
			
			this.graphics.lineTo (dx, dy);
			
			dx = x + Math.cos (start+(step*(i+1))) * outerRadius;
			dy = y - Math.sin (start+(step*(i+1))) * outerRadius;
			
			this.graphics.lineTo (dx, dy);
		}
	}
}
