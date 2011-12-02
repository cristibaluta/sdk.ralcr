//
//  DashedLine
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//

class RCRectangle extends RCDraw, implements RCDrawInterface {
	
	public var roundness :Null<Int>;// Rounded corners radius
	
	
	public function new (x, y, w, h, ?color:Dynamic, ?alpha:Float=1.0, ?r:Null<Int>) {
		super (x, y, w, h, color, alpha);
		
		this.roundness = r;
		this.redraw();
	}
	
	public function redraw() :Void {
		
#if flash
		this.graphics.clear();
		this.configure();
		
		(roundness != null)
		? this.graphics.drawRoundRect (0, 0, size.width, size.height, roundness)
		: this.graphics.drawRect (0, 0, size.width, size.height);
		
		this.graphics.endFill();
#elseif js
		view.innerHTML = "";
	    view.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:0px;top:0px;width:" + size.width +  "px;height:" + size.height + "px;background-color:" + color.hexFillColor() + "\"></DIV>";
#end
	}
}
