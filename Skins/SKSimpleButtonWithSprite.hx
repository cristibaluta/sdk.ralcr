//
//  SKSimpleButtonWithSprite
//
//  Created by Baluta Cristian on 2011-03-07.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.display.Sprite;


class SKSimpleButtonWithSprite extends RCSkin {
	
	public function new (sprite:Sprite, ?colors:Array<Null<Int>>) {
		super ( colors );
		
		// Attach from library the object with linkage "linkage"
		up = sprite;
		
		// Creates a transparent background for mouse hit area
		background = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, up.width, up.height, 0xFFFFFF, 0);
	}
}
