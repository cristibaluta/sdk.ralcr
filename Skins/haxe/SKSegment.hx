//
//  SKSegment
//
//  Created by Cristi Baluta on 2010-09-07.
//  Copyright (c) 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

package haxe;

class SKSegment extends RCSkin {
	
	public function new (label:String, w:Int, h:Float, pos:String, colors:Array<Null<Int>>) {
		super ( colors );
		
		var segmentLeft :String;
		var segmentMiddle :String;
		var segmentRight :String;
		
		switch (pos) {
			case "left":	segmentLeft = "LL";  segmentMiddle = "M"; segmentRight = "M"; // First
			case "right":	segmentLeft = "M"; segmentMiddle = "M"; segmentRight = "RR"; // Last
			default:		segmentLeft = "M"; segmentMiddle = "M"; segmentRight = "M"; // Middle
		}
		
		var segLeft = new RCAttach (0, 0, "Segment"+segmentLeft);
		var segMiddle = new RCAttach (0, 0, "Segment"+segmentMiddle);
		var segRight = new RCAttach (0, 0, "Segment"+segmentRight);
		var segLeftSelected = new RCAttach (0, 0, "Segment"+segmentLeft+"Selected");
		var segMiddleSelected = new RCAttach (0, 0, "Segment"+segmentMiddle+"Selected");
		var segRightSelected = new RCAttach (0, 0, "Segment"+segmentRight+"Selected");
		
		segLeft.x = 0;
		segMiddle.x = segLeft.width;
		segMiddle.width = w - segLeft.width - segRight.width;
		segRight.x = w - segRight.width;
		
		segLeftSelected.x = 0;
		segMiddleSelected.x = segLeftSelected.width;
		segMiddleSelected.width = w - segLeftSelected.width - segRightSelected.width;
		segRightSelected.x = w - segRightSelected.width;
		
		
		//RCFontManager.getFont ("bold", {size:25, color:0x777777, align:"center"}))
		var font = RCFont.boldSystemFontOfSize(13);
			font.align = "center";
		
		normal.background = new RCView (0, 0, w, h);
		//normal.background = new RCRectangle (0, 0, w, h, 0x000000);
		normal.background.addChild ( segLeft );
		normal.background.addChild ( segMiddle );
		normal.background.addChild ( segRight );
		normal.label = new RCTextView (0, 0, w, null, label, font);
		normal.label.y = Math.round ((h - 25)/2);
		
		highlighted.background = new RCView (0, 0, w, h);
		highlighted.background = new RCRectangle (0, 0, w, h, RCColor.orangeColor());
		highlighted.background.addChild ( segLeftSelected );
		highlighted.background.addChild ( segMiddleSelected );
		highlighted.background.addChild ( segRightSelected );
		highlighted.label = new RCTextView (0, 0, w, null, label, font);
		highlighted.label.y = Math.round ((h - 25)/2);
		
		hit = new RCRectangle (0, 0, w, h, 0x000000, 0);
	}
}
