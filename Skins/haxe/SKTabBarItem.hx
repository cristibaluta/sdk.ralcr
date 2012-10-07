//
//  SkinButtonControls
//
//  Created by Cristi Baluta on 2009-10-07.
//  Copyright (c) 2009 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
package haxe;

import flash.display.Sprite;

class SKTabBarItem extends RCSkin {
	
	public function new (label:String, linkage:String, colors:Array<Null<Int>>) {
		super (colors);
		
		// Attach an object from library
		normal.background = new Sprite();
		//normal.background.addChild ( new RCAttach (50, 4, linkage) );
		normal.background.addChild ( new RCTextView (0, 72, 155, null, label, RCFontManager.getFont("regular", {color:0xCCCCCC, align:"center"})) );

		normal.label = new Sprite();
		
		highlighted.background = new Sprite();
		highlighted.background.addChild ( new RCRectangle (0, 0, 155, 90, 0xFFFFFF, 0.2, 6) );
		//highlighted.background.addChild ( new RCAttach (50, 4, linkage+"Selected") );
		highlighted.background.addChild ( new RCTextView (0, 72, 155, null, label, RCFontManager.getFont("regular", {color:0xFFFFFF, align:"center"})) );
		
		
		// Draws a background as a hit area
		//background = new RCRectangle (0, 0, 155, 90, 0x333333, 0);
		hit = new RCRectangle (0, 0, 155, 90, 0x333333, 0);
	}
}
