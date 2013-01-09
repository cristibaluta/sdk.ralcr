//
//  RCBurst
//
//  Created by Cristi Baluta on 2010-02-19.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCBurst extends RCDraw, implements RCDrawInterface {
	
	public var sides :Int;
	public var innerRadius :Int;
	public var outerRadius :Int;
	public var angle :Int;
	
	// ==============
	// mc.drawBurst() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
	// 
	// x, y = center of burst
	// sides = number of sides or points
	// innerRadius = radius of the indent of the curves
	// outerRadius = radius of the outermost points
	// angle = [optional] starting angle in degrees. (defaults to 0)
	// ==============
	public function new (x, y, w, h, color:Dynamic, alpha:Float, sides:Int, innerRadius:Int, outerRadius:Int, angle:Int) {
		
		super (x, y, w, h, color, alpha);
		
		this.sides = sides;
		this.innerRadius = innerRadius;
		this.outerRadius = outerRadius;
		this.angle = angle;
		
		this.redraw();
	}
	
	public function redraw() :Void {
		
		layer.graphics.clear();
		this.configure();
		
		if (sides <= 2)
			sides = 3;
		
		// init vars
		var step, halfStep, qtrStep, start, n, dx, dy, cx, cy;
		
		// calculate length of sides
		step = (Math.PI * 2) / sides;
		halfStep = step / 2;
		qtrStep = step / 4;
		
		// calculate starting angle in radians
		start = (angle / 180) * Math.PI;
		layer.graphics.moveTo (x + (Math.cos(start)*outerRadius), y - (Math.sin(start)*outerRadius));
		
		// draw curves
		for (i in 0...sides) {
			cx = x+Math.cos(start+(step*(i+1))-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
			cy = y-Math.sin(start+(step*(i+1))-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
			dx = x+Math.cos(start+(step*(i+1))-halfStep)*innerRadius;
			dy = y-Math.sin(start+(step*(i+1))-halfStep)*innerRadius;
			
			layer.graphics.curveTo (cx, cy, dx, dy);
			
			cx = x+Math.cos(start+(step*(i+1))-qtrStep)*(innerRadius/Math.cos(qtrStep));
			cy = y-Math.sin(start+(step*(i+1))-qtrStep)*(innerRadius/Math.cos(qtrStep));
			dx = x+Math.cos(start+(step*(i+1)))*outerRadius;
			dy = y-Math.sin(start+(step*(i+1)))*outerRadius;
			
			layer.graphics.curveTo (cx, cy, dx, dy);
		}
			layer.graphics.endFill();
	}
}
