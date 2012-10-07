//
//  SkinButtonControls
//
//  Created by Cristi Baluta on 2009-10-07.
//  Updated 2009 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
package ios;


class SKTabBarItem extends RCSkin {
	
	public function new (label:String, linkage:String, ?colors:Array<Null<Int>>) {
		
		super (colors);
		
		// Attach an object from library
		normal.background = new RCView(0, 0, 80, 50);
		var sn :RCImage = RCAssets.getFileWithKey( linkage );
		sn.x = 25;
		sn.y = 3;
		normal.background.addChild ( sn );
		normal.label = new RCTextView (0, 30, 78, null, label, RCFontManager.getFont("regular", {color:0xCCCCCC, align:"center"}));
		
		
		highlighted.background = new RCView(0,0);
		highlighted.background.addChild ( new RCRectangle (0, 0, 78, 45, 0xFFFFFF, 0.2, 6) );
		var sh :RCImage = RCAssets.getFileWithKey( linkage+"Selected" );
		sh.x = 25;
		sh.y = 3;
		highlighted.background.addChild ( sh );
		highlighted.label = new RCTextView (0, 30, 78, null, label, RCFontManager.getFont("regular", {color:0xFFFFFF, align:"center"}));
		
		
		// Hit area
		hit = new RCRectangle (0, 0, 78, 45, 0x333333, 0);
	}
}
