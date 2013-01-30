//
//  Display stats about FPS and memory ocupied by all flash applications
//
//  Created by Baluta Cristian on 2010-04-18.
//  Copyright (c) 2010-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCDebugger extends RCView {
	
	var txt :RCTextView;
	
	
	/**
	 *  In flash the memory reported is from all flash player instances running.
	 *  In cpp the memory reportd is from the Haxe objects managed by the garbage collector.
	 *  NME bitmaps are not included
	 **/
	public function new (x, y, w, h) {
		
		super (x, y, w, h);
		
		var f = RCFont.systemFontOfSize(12);
			f.color = 0x000000;
		txt = new RCTextView (0, 0, w, h, "Debugger...\n", f);
		addChild ( txt );
	}
	
	public function log (str:String) {
		txt.text = txt.text + str + "\n";
	}
	
	override public function destroy () {
		txt.removeFromSuperview();
		txt.destroy();
		txt = null;
		super.destroy();
	}
}
