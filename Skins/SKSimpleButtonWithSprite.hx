//
//  SKSimpleButtonWithSprite
//
//  Created by Baluta Cristian on 2011-03-07.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class SKSimpleButtonWithSprite extends RCSkin {
	
	public function new (view:RCView, ?colors:Array<Null<Int>>) {
		
		super ( colors );
		
		// Attach from library the object with linkage "linkage"
		normal.label = view;
		
		// Creates a transparent background for mouse hit area
		normal.background = new RCRectangle (0, 0, view.width, view.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, view.width, view.height, 0xFFFFFF, 0);
	}
}
