//
//  HXScroll
//
//  Created by Baluta Cristian on 2011-03-07.
//  Copyright (c) 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

package haxe;
import RCView;


class SKSlider extends RCSkin {
	
	public function new (?colors:Array<Null<Int>>) {
		super ( colors );
		
		var w = 160;
		var h = 8;
		
		normal.background = new RCRectangle (0, 0, w, h, 0x777777, 1, 8);
		normal.otherView = new RCEllipse(0, 0, h*2, h*2, 0x333333);
		normal.otherView.addChild ( new RCEllipse(1,1, h*2-2, h*2-2, 0xFFCC00) );
		
		highlighted.background = new RCRectangle (0, 0, w, h, 0x000000, 1, 8);
		
		// Creates a transparent background for mouse hit area
		hit = new RCView(0,0);
	}
}
