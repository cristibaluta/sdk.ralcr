// This is part of the skin collection for Haxe components
// The checkbox skin should be added to a RCButtonRadio

package haxe;

class SKButtonRadio extends RCSkin {
	
	public function new (?colors:Array<Null<Int>>) {
		super ( colors );
		
		var r = 14;
		
		normal.background = new RCEllipse(0,0, r,r, 0x999999);
		normal.background.addChild ( new RCEllipse(1,1, r-2,r-2, 0xfdfdfd) );
		normal.label = new RCView(0,0);
		
		highlighted.background = new RCEllipse(0,0, r,r, 0x333333);
		highlighted.background.addChild ( new RCEllipse (1, 1, r-2,r-2, 0x999999) );
		highlighted.label = new RCEllipse(r/2-4/2,r/2-4/2, 4,4, 0xffffff);
		
		selected.background = new RCEllipse(0,0, r,r, 0x333333);
		selected.background.addChild ( new RCEllipse (1, 1, r-2,r-2, 0xFFE700) );
		selected.label = new RCEllipse(r/2-4/2,r/2-4/2, 4,4, 0x333333);
		
		// Creates a transparent background for mouse hit area
		hit = new RCRectangle (0, 0, r, r, 0xFFFFFF);
	}
}
