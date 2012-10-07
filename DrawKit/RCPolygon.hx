//
//  RCPolygon.hx
//
//  Created by Baluta Cristian on 2008-10-12.
//  Copyright (c) 2008 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCPolygon extends RCDraw, implements RCDrawInterface {
	
	public var points :Array<RCPoint>;
	
	
	public function new (x, y, points:Array<RCPoint>, color:Dynamic, ?alpha:Float=1.0) {
		super (x, y, 0, 0, color, alpha);
		
		this.points = points;
		this.redraw();
	}
	
	public function redraw () {
#if (flash || nme)
		layer.graphics.clear();
		this.configure();
		
		// Draw a polygon		
		layer.graphics.moveTo ( points[0].x, points[0].y );
		for (i in 1...points.length)
			layer.graphics.lineTo ( points[i].x, points[i].y );
			layer.graphics.endFill();
#end
	}
}
