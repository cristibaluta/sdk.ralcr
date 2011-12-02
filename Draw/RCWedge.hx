//
//  Wedge
//
//  Created by Cristi Baluta on 2010-02-09.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
// // x, y = center point of the wedge.
// startAngle = starting angle in degrees.
// arc = sweep of the wedge. Negative values draw clockwise.
// radius = radius of wedge. If [optional] yRadius is defined, then radius is the x radius.
// yRadius = [optional] y radius for wedge.
// 
class RCWedge extends RCDraw, implements RCDrawInterface {
	
	public var arc :Int;
	
	
	public function new (x, y, w, h, color:Dynamic, alpha:Float=1.0, arc:Int) {
		super (x, y, w, h, color, alpha);
		
		this.arc = arc;
		this.redraw();
	}
	
	public function redraw() :Void {
		
		this.graphics.clear();
		this.configure();
		this.graphics.moveTo (size.width/2, size.height/2);
		
		var segAngle:Float, theta:Float, angle:Float, angleMid:Float, segs:Int;
		var ax:Int, ay:Int, bx:Int, by:Int, cx:Int, cy:Int;
		var radiusX = Math.round (size.width / 2);
		var radiusY = Math.round (size.height / 2);
		var startAngle :Int = 0;
		
		// limit sweep to reasonable numbers
		if (Math.abs(arc) > 360)
			arc = 360;
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil ( Math.abs(arc) / 45 );
		// Now calculate the sweep of each segment.
		segAngle = arc / segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
		theta = - ( segAngle / 180 ) * Math.PI;
		// convert angle startAngle to radians
		angle = - ( startAngle / 180 ) * Math.PI;
		
		// Draw the curve in segments no larger than 45 degrees.
		if (segs > 0) {
			// Draw a line from the center to the start of the curve
			ax = Math.round ( size.width/2 + Math.cos ( startAngle / 180 * Math.PI) * radiusX );
			ay = Math.round ( size.height/2 + Math.sin (-startAngle / 180 * Math.PI) * radiusY );
			this.graphics.lineTo (ax, ay);
			
			// Loop for drawing curve segments
			for (i in 0...segs) {
				angle += theta;
				angleMid = angle - ( theta / 2 );
				bx = Math.round ( size.width/2 + Math.cos ( angle ) * radiusX );
				by = Math.round ( size.height/2 + Math.sin ( angle ) * radiusY );
				cx = Math.round ( size.width/2 + Math.cos ( angleMid ) * (radiusX / Math.cos ( theta / 2 ) ) );
				cy = Math.round ( size.height/2 + Math.sin ( angleMid ) * (radiusY / Math.cos ( theta / 2 ) ) );
				this.graphics.curveTo (cx, cy, bx, by);
			}
			
			// Close the wedge by drawing a line to the center
			this.graphics.lineTo (size.width/2, size.height/2);
		}
	}
}
