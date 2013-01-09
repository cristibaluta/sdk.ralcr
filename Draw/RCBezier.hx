//
//  RCBezier
//
//  Created by Cristi Baluta on 2011-02-22.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class RCBezier extends RCDraw, implements RCDrawInterface {
	
	public var lineWeight :Int;
	
	/**
	 *	Draws a line of lineWeight px from x1, y1 to x2, y2
	 */
	public function new (x1, y1, x2, y2, color:Int, ?alpha:Float=1.0, ?lineWeight:Int=1) {
		super (x1, y1, x2-x1, y2-y1, color, alpha);
		
		this.lineWeight = lineWeight;
		this.redraw();
	}
	
	public function redraw () :Void {
		
		layer.graphics.clear();
		layer.graphics.lineStyle (lineWeight, color);
		
		var line = new Shape();
			line.graphics.lineStyle (2, 0x000000);
			line.graphics.moveTo (anchor1.x, anchor1.y);

		// store values where to lineTo
		var posx :Float, posy :Float, u :Float;
		
		//loop through 100 steps of the curve
		for (i in 0...100) {
			u = i/100;
			posx = Math.pow(u,3)*(anchor2.x+3*(control1.x-control2.x)-anchor1.x)
					+3*Math.pow(u,2)*(anchor1.x-2*control1.x+control2.x)
					+3*u*(control1.x-anchor1.x)+anchor1.x;
			
			posy = Math.pow(u,3)*(anchor2.y+3*(control1.y-control2.y)-anchor1.y)
					+3*Math.pow(u,2)*(anchor1.y-2*control1.y+control2.y)
					+3*u*(control1.y-anchor1.y)+anchor1.y;
			
			line.graphics.lineTo (posx, posy);
		}
		
		//Let the curve end on the second anchorPoint
		line.graphics.lineTo (anchor2.x, anchor2.y);

		addChild ( line );
	}
}
