//
//  RCPolygon
//
//  Created by Baluta Cristian on 2008-10-12.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
import flash.geom.Point;

class RCPolygon extends RCDraw, implements RCDrawInterface {
	
	public var points :Array<Point>;
	
	
	public function new (x, y, points:Array<Point>, color:Dynamic, ?alpha:Float=1.0) {
		super (x, y, 0, 0, color, alpha);
		
		this.points = points;
		this.redraw();
	}
	
	public function redraw () {
		
		this.graphics.clear();
		this.configure();
		
		// Draw a polygon		
			this.graphics.moveTo ( points[0].x, points[0].y );
		for (i in 1...points.length)
			this.graphics.lineTo ( points[i].x, points[i].y );
			this.graphics.endFill();
	}
}
