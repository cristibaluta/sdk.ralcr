//
//  RCPattern
//
//  Created by Cristi Baluta on 2011-03-15.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.display.DisplayObjectContainer;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;


class RCPatternFill extends RCDraw, implements RCDrawInterface {
	
	public var pattern :DisplayObjectContainer;// Rounded corners radius
	
	
	public function new (x, y, w, h, alpha, pattern:DisplayObjectContainer) {
		super (x, y, w, h, 0x000000, alpha);
		
		this.pattern = pattern;
		this.redraw();
	}
	
	public function redraw() :Void {
		
		var bitmapData = new BitmapData (Math.round (pattern.width), Math.round (pattern.height));
			bitmapData.draw ( pattern );
			
		this.graphics.clear();
		this.graphics.beginBitmapFill (bitmapData, new Matrix(), true, true);
		this.graphics.drawRect (0, 0, size.width, size.height);
		this.graphics.endFill();
	}
}
