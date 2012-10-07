// This is part of the skin collection for Haxe components

/**
*  The real size of the background (which is the scrollbar supraface),
*  the otherView (which is the scrollbar position indicator),
*  and the mouse hit area are set from the RCScrollBar
*  through the setWidth and setHeight methods
*/

package haxe;
import RCView;

class SKScrollBar extends RCSkin {
	
	public function new (?colors:Array<Null<Int>>) {
		super ( colors );
		var w = 8, h = 8;
		
		normal.background = new RCRectangle (0, 0, w, h, 0x999999, 0.6, 8);
		normal.otherView = new RCRectangle (0, 0, w, h, 0x333333, 1, 8);
		
		// Creates a transparent background for mouse hit area
		hit = new RCRectangle (0, 0, w, h, 0x666666, 0);
	}
}
