package  {
	import flash.Lib;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.system.System;
	import flash.Boot;
	public class RCStats extends flash.display.Sprite {
		public function RCStats(x : int = 0,y : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			super();
			this.x = x;
			this.y = y;
			this.addChild(this.background = new RCRectangle(-1,-1,152,18,16777215,0.9,16));
			this.addChild(this.background = new RCRectangle(0,0,150,16,3355443,0.3,16));
			this.txt = new flash.text.TextField();
			this.txt.x = 6;
			this.txt.y = 1;
			this.txt.width = 100;
			this.txt.height = 20;
			this.txt.text = "Calculating...";
			this.addChild(this.txt);
			this.last = flash.Lib._getTimer();
			this.addEventListener(flash.events.Event.ENTER_FRAME,this.loop);
		}}
		
		protected var last : uint;
		protected var ticks : uint;
		protected var background : RCRectangle;
		protected var txt : flash.text.TextField;
		protected var fps : int;
		protected var currMemory : int;
		protected function loop(evt : flash.events.Event) : void {
			this.ticks++;
			var now : int = flash.Lib._getTimer();
			var delta : int = now - this.last;
			if(delta >= 1000) {
				this.fps = Math.round(this.ticks / delta * 1000);
				this.ticks = 0;
				this.last = now;
				this.currMemory = Math.round(flash.system.System.totalMemory / 1048576);
				this.txt.text = this.fps + " FPS,  " + this.currMemory + " Mbytes";
			}
		}
		
		public function destroy() : void {
			this.removeEventListener(flash.events.Event.ENTER_FRAME,this.loop);
		}
		
	}
}
