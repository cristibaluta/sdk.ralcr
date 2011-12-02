//
//  DashedLine
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//
class RCDashedLine extends RCDraw, implements RCDrawInterface {
	
	public var dashWidth :Int;
	public var dashGap :Null<Int>;// If the dashGap is null, use the dashWidth
	
	var dashes :Array<RCRectangle>;
	
	
	public function new (x, y, w, h, color:Int, alpha:Float, dashWidth:Int, ?dashGap:Null<Int>=null) {
		
		super (x, y, w, h, color, alpha);
		
		this.dashWidth = dashWidth;
		this.dashGap = dashGap;
		
		this.redraw();
	}
	
	public function redraw () :Void {
		
		this.graphics.clear();
		this.configure();
		
		// decide direction of drawing
		// w>h use x axis
		// w<h use y axis
		if (dashGap == null)
			dashGap = dashWidth;
			
		var nr_of_dashes = Math.round ((size.width > size.height ? size.width : size.height) / (dashWidth + dashGap));
		
		for (i in 0...nr_of_dashes) {
			var X = size.width > size.height ? i * (dashWidth + dashGap) : 0;
			var Y = size.width < size.height ? i * (dashWidth + dashGap) : 0;
			var W = size.width > size.height ? dashWidth : size.width;
			var H = size.width < size.height ? dashWidth : size.height;
			
			this.graphics.drawRect (X, Y, W, H);
		}
	}
}
