//
//  SKSimpleButtonWithObject
//
//  Created by Cristi Baluta on 2010-05-14.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//

class SKSimpleButtonWithLinkage extends RCSkin {
	
	public function new (linkage:String, ?colors:Array<Null<Int>>) {
		super ( colors );
		
		// Attach from library the object with linkage "linkage"
		up = new RCAttach (0, 0, linkage);
		
		// Creates a transparent background for mouse hit area
		background = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
	}
}
