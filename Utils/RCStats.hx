//
//  Display stats about FPS and memory ocupied by all flash applications
//
//  Created by Baluta Cristian on 2010-04-18.
//  Copyright (c) 2010-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCStats extends RCRectangle {
	
	var last :Float;
	var now :Float;
	var delta :Float;
	var ticks :Int;
	var fps :Int;
	var currMemory :Float;
	var txt :RCTextView;
	var e :EVLoop;
	
	
	/**
	 *  In flash the memory reported is from all flash player instances running.
	 *  In cpp the memory reportd is from the Haxe objects managed by the garbage collector.
	 *  NME bitmaps are not included
	 **/
	public function new (?x=0, ?y=0) {
		
		super (x, y, 152, 18, 0xffffff, 0.9, 16);
		
		addChild ( new RCRectangle (1, 1, 150, 16, 0xFFFFFF, 0.8, 16) );
		
		var f = RCFont.systemFontOfSize(12);
			f.color = 0x000000;
		txt = new RCTextView (6, #if (flash || (nme && (cpp || neko))) 1 #else 3 #end, null, 20, "Calculating...", f);
		addChild ( txt );
		
		last = RCAnimation.timestamp();
		e = new EVLoop();
		e.run = loop;
		
		#if nme
			addChild ( new RCRectangle (155, 1, 60, 16, 0xFFFFFF, 0.8, 16) );
			var fps = new nme.display.FPS();
				fps.x = 162;
				fps.y = 0;
			layer.addChild ( fps );
		#end
	}
	
	function loop () {
		ticks++;
		now = RCAnimation.timestamp();
		delta = now - last;
		
		if (delta >= 1000) {
			//trace("loop "+delta);
			fps = Math.round (ticks / delta * 1000);
			ticks = 0;
			last = now;
			#if flash
				currMemory = Math.round ( flash.system.System.totalMemory / (1024*1024) );
			#elseif cpp
				currMemory = Math.round ( cpp.vm.Gc.memUsage() / (1024*1024) * 100 ) / 100;
			#end
			txt.text = fps + " FPS,  " + currMemory + " Mbytes";
		}
	}
	
	override public function destroy () {
		e.destroy();
		txt.removeFromSuperview();
		txt.destroy();
		e = null;
		txt = null;
		super.destroy();
	}
}
