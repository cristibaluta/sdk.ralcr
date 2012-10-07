//
//  SKSegment.hx
//	SkinsKit
//
//  Created by Cristi Baluta on 2010-09-07.
//  Updated 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

package ios;

class SKSegment extends RCSkin {
	
	/**
	 *  Creates a new SegmentedControl button skin
	 *  @param label = 
	 *  @param w = 
	 *  @param h = 
	 *  @param buttonPosition = 
	 *  @param colors = 
	 **/
	public function new (label:String, w:Int, h:Float, buttonPosition:String, colors:Array<Null<Int>>) {
		
		super ( colors );
		
		var segmentLeft :String;
		var segmentMiddle :String;
		var segmentRight :String;
		var segmentLeftSelected :String;
		var segmentMiddleSelected :String;
		var segmentRightSelected :String;
		
		
		// Choose the resources to use for the button depending on it's position in the segmented control
		// It may not make any sense the following code, but it works
		// The idea is to have as few resources as possible
		switch (buttonPosition) {
			case "left": // First
				segmentLeft = "LL";  segmentMiddle = "M"; segmentRight = "M";
				segmentLeftSelected = "LL"; segmentMiddleSelected = "M"; segmentRightSelected = "LR";
				
			case "right": // Last
				segmentLeft = "M"; segmentMiddle = "M"; segmentRight = "RR";
				segmentLeftSelected = "RL"; segmentMiddleSelected = "M"; segmentRightSelected = "RR";
							
			default: // Middle
				segmentLeft = "M"; segmentMiddle = "M"; segmentRight = "M";
				segmentLeftSelected = "RL"; segmentMiddleSelected = "M"; segmentRightSelected = "LR";
		}
		
		// Add background image
		var hd = RCDevice.currentDevice().dpiScale == 2 ? "@2x" : "";
		var sl = "Resources/ios/RCSegmentedControl/"+segmentLeft+hd+".png";
		var sm = "Resources/ios/RCSegmentedControl/"+segmentMiddle+hd+".png";
		var sr = "Resources/ios/RCSegmentedControl/"+segmentRight+hd+".png";
		normal.background = new RCImageStretchable (0, 0, sl, sm, sr);
		normal.background.setWidth ( w );
		
		var slh = "Resources/ios/RCSegmentedControl/"+segmentLeftSelected+"Selected"+hd+".png";
		var smh = "Resources/ios/RCSegmentedControl/"+segmentMiddleSelected+"Selected"+hd+".png";
		var srh = "Resources/ios/RCSegmentedControl/"+segmentRightSelected+"Selected"+hd+".png";
		highlighted.background = new RCImageStretchable (0, 0, slh, smh, srh);
		highlighted.background.setWidth ( w );
		
		
		//RCFontManager.getFont ("bold", {size:25, color:0x777777, align:"center"}))
		var font = RCFont.boldSystemFontOfSize(13);
			font.align = "center";
			font.color = 0x333333;
		
		normal.label = new RCTextView (0, 0, w, null, label, font);
		normal.label.y = Math.round ((h - 20)/2);
		
			font.color = 0xFFFFFF;
			
		highlighted.label = new RCTextView (0, 0, w, null, label, font);
		highlighted.label.y = Math.round ((h - 20)/2);
		
		hit = new RCRectangle (0, 0, w, h, 0x000000);
	}
}
