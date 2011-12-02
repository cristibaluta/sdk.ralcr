//
//  Display stats bout frames per second and memory ocupied by all flash applications in that time
//
//  Created by Baluta Cristian on 2010-04-18.
//  Copyright (c) 2010 http://ralcr.com. All rights reserved.
//
import flash.Lib;
import flash.events.Event;
import flash.display.Sprite;
import flash.text.TextField;
import flash.system.System;


class RCStats extends Sprite {
	
	var last :UInt;
	var ticks :UInt;
	var background :RCRectangle;
	var txt :TextField;
	var fps :Int;
	var currMemory :Int;
	
	
	public function new (?x=0, ?y=0) {
		super();
		this.x = x;
		this.y = y;
		this.addChild ( background = new RCRectangle (-1, -1, 152, 18, 0xffffff, 0.9, 16) );
		this.addChild ( background = new RCRectangle (0, 0, 150, 16, 0x333333, 0.3, 16) );
		
		txt = new TextField();
		txt.x = 6;
		txt.y = 1;
		txt.width = 100;
		txt.height = 20;
		txt.text = "Calculating...";
		this.addChild ( txt );
		
		this.last = Lib.getTimer();
		this.addEventListener (Event.ENTER_FRAME, loop);
	}
	
	function loop (evt:Event) {
		ticks++;
		var now = Lib.getTimer();
		var delta = now - last;
		
		if (delta >= 1000) {
			fps = Math.round (ticks / delta * 1000);
			ticks = 0;
			last = now;
			currMemory = Math.round ( System.totalMemory / (1024*1024) );
			
			txt.text = fps + " FPS,  " + currMemory + " Mbytes";
		}
	}
	
	public function destroy () {
		this.removeEventListener (Event.ENTER_FRAME, loop);
	}
}
