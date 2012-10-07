//
//  SKSimpleButtonWithObject
//
//  Created by Cristi Baluta on 2010-05-14.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class SKSimpleButtonWithLinkage extends RCSkin {
	
	public function new (linkage:String, ?colors:Array<Null<Int>>) {
		super ( colors );
		
		// Attach from library the object with linkage "linkage"
		normal.otherView = new RCAttach (0, 0, linkage);
		
		// Creates a transparent background for mouse hit area
		normal.background = new RCRectangle (0, 0, normal.otherView.width, normal.otherView.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, normal.otherView.width, normal.otherView.height, 0xFFFFFF, 0);
	}
}
