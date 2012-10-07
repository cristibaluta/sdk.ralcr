//
//  Display stats bout frames per second and memory ocupied by all flash applications in that time
//
//  Created by Baluta Cristian on 2010-04-18.
//  Copyright (c) 2010-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCStats extends RCRectangle {
	
	var last :Float;
	var ticks :Int;
	var fps :Int;
	var currMemory :Int;
	var txt :RCTextView;
	var e :EVLoop;
	
	
	public function new (?x=0, ?y=0) {
		super (x, y, 152, 18, 0xffffff, 0.9, 16);
		addChild ( new RCRectangle (1, 1, 150, 16, 0x333333, 0.3, 16) );
		
		var f = RCFont.systemFontOfSize(12);
			f.color = 0xffffff;
		txt = new RCTextView (6, #if flash 1 #else 3 #end, null, 20, "Calculating...", f);
		addChild ( txt );
		
		last = CoreAnimation.timestamp();
		e = new EVLoop();
		e.run = loop;
	}
	
	function loop () {
		ticks++;
		var now = CoreAnimation.timestamp();
		var delta = now - last;
		
		if (delta >= 1000) {
			fps = Math.round (ticks / delta * 1000);
			ticks = 0;
			last = now;
			#if flash
				currMemory = Math.round ( flash.system.System.totalMemory / (1024*1024) );
			#end
			txt.text = fps + " FPS,  " + currMemory + " Mbytes";
		}
	}
	
	override public function destroy () {
		e.destroy();
		txt.destroy();
		super.destroy();
	}
}
