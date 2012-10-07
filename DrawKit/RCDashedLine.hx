//
//  RCDashedLine.hx
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCDashedLine extends RCDraw, implements RCDrawInterface {
	
	public var dashWidth :Int;
	public var dashGap :Null<Int>;// If the dashGap is null, use the dashWidth
	
	//var dashes :Array<RCRectangle>;
	
	
	public function new (x, y, w, h, color:Int, alpha:Float, dashWidth:Int, ?dashGap:Null<Int>) {
		
		super (x, y, w, h, color, alpha);
		
		this.dashWidth = dashWidth;
		this.dashGap = dashGap;
		
		this.redraw();
	}
	
	public function redraw () :Void {
		
#if (flash || nme)
		
		layer.graphics.clear();
		this.configure();
		
#end
		
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
			
			#if (flash || nme)
				
				layer.graphics.drawRect (X, Y, W, H);
				
			#elseif js
				
				var dash = js.Lib.document.createElement("div");
					dash.style.position = "absolute";
					dash.style.margin = "0px 0px 0px 0px";
					dash.style.left = X + "px";
					dash.style.top = Y + "px";
					dash.style.width = W + "px";
					dash.style.height = H + "px";
					dash.style.backgroundColor = color.fillColorStyle;
					
				layer.appendChild ( dash );
				
			#end
		}
	}
}
