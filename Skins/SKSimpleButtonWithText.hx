//
//  Skins
//
//  Created by Baluta Cristian on 2009-01-28.
//  Copyright (c) 2009 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class SKSimpleButtonWithText extends RCSkin {
	
	public function new (label_str:String, colors:Array<Null<Int>>) {
		
		super ( colors );
		
		// Creates a TextField
		normal.label = new RCTextView (0, 0, null, null, label_str, RCFont.systemFontOfSize(12));
		
		// Creates a transparent background for mouse hit area
		normal.background = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
	}
}

