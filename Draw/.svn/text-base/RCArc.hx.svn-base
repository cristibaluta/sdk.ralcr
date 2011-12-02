//
//  RCArc
//
//  Created by Cristi Baluta on 2010-02-19.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//

class RCArc extends RCDraw, implements RCDrawInterface {
	
	public var arc :Int;
	public var startAngle :Int;
	
	// ==============
	// mc.drawArc() - by Ric Ewing (ric@formequalsfunction.com) - version 1.5 - 4.7.2002
	// 
	// x, y = This must be the current pen position... other values will look bad
	// radius = radius of Arc. If [optional] yRadius is defined, then r is the x radius
	// arc = sweep of the arc. Negative values draw clockwise.
	// startAngle = starting angle in degrees.
	// yRadius = [optional] y radius of arc. Thanks to Robert Penner for the idea.
	// ==============
	// Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
	// ==============
	public function new (x, y, w, h, color:Dynamic, alpha:Float=1.0, arc:Int, startAngle:Int=0) {
		super (x, y, w, h, color, alpha);
		
		this.arc = arc;
		this.startAngle = startAngle;
		
		this.redraw();
	}
	
	public function redraw() :Void {
		
		this.graphics.clear();
		this.configure();
		
		// Init vars
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		// no sense in drawing more than is needed :)
		if (Math.abs(arc) > 360)
			arc = 360;
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil ( Math.abs (arc) / 45 );
		// Now calculate the sweep of each segment
		segAngle = arc / segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians. 
		theta = - segAngle / 180 * Math.PI;
		// convert angle startAngle to radians
		angle = - startAngle / 180 * Math.PI;
		// find our starting points (ax,ay) relative to the secified x,y
		ax = x - Math.cos (angle) * (size.width / 2);
		ay = y - Math.sin (angle) * (size.height / 2);
		// if our arc is larger than 45 degrees, draw as 45 degree segments
		// so that we match Flash's native circle routines.
		if (segs>0) {
			// Loop for drawing arc segments
			for (i in 0...segs) {
				// increment our angle
				angle += theta;
				// find the angle halfway between the last angle and the new
				angleMid = angle - theta / 2;
				// calculate our end point
				bx = ax + Math.cos (angle) * (size.width / 2);
				by = ay + Math.sin (angle) * (size.height / 2);
				// calculate our control point
				cx = ax + Math.cos (angleMid) * ((size.width / 2) / Math.cos (theta / 2));
				cy = ay + Math.sin (angleMid) * ((size.height / 2) / Math.cos (theta / 2));
				// draw the arc segment
				this.graphics.curveTo (cx, cy, bx, by);
			}
		}
	}
}
