//
//  Skins
//
//  Created by Baluta Cristian on 2009-01-28.
//  Copyright (c) 2009 milc.ro. All rights reserved.
//
class SKSimpleButtonWithText extends RCSkin {
	
	public function new (label_str:String, colors:Array<Null<Int>>) {
		super ( colors );
		
		// Creates a TextField
		up = new RCTextView (0, 0, null, null, label_str, FontManager.getRCFont("system",{embedFonts:false}));
		
		// Creates a transparent background for mouse hit area
		background = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
	}
}

