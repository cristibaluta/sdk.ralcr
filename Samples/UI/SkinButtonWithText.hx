//
//  SkinButtonWithText.hx
//
//  Created by Baluta Cristian on 2009-09-19.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//

class SkinButtonWithText extends RCSkin {
	
	
	public function new (label_str:String, colors:Array<Null<Int>>) {
		
		super (colors);
		
		// Creates a TextField
		var format = RCFont.systemFontOfSize(12);
		var formatHighlighted = format.copy();
			formatHighlighted.color = 0x333333;
		
		normal.label = new RCTextView (0, 0, null, null, label_str, format);
		normal.label.viewDidAppear.add ( viewDidAppear_ );
		highlighted.label = new RCTextView (0, 0, null, null, label_str, formatHighlighted);
		
		// Creates a transparent background for mouse hit area
		normal.background = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
		//normal.background.viewDidAppear.add ( viewDidAppear_ );
		//normal.background = new RCRectangle (0, 0, 50, 20, 0xFFFFFF, 0.2);
		hit = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
		//hit = new RCRectangle (0, 0, 100, 20, 0xFFFFFF, 0.2);
	}
	
	function viewDidAppear_ () {
		trace("bg appear " + normal.label.width);
		normal.background.size = normal.label.contentSize;
		hit.size = normal.label.contentSize;
		cast (normal.background, RCRectangle).redraw();
		cast (hit, RCRectangle).redraw();
		
		normal.label.viewDidAppear.removeAll();
	}
}
