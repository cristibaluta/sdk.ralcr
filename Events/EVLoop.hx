#if (flash || nme7)
	typedef Ticker = flash.display.Sprite;
#else
	typedef Ticker = haxe.Timer;
#end


class EVLoop {
	
	var ticker :Ticker;
	public var run (default, setFuncToCall) :Void->Void;
	public static var FPS :Int = 60;
	
	public function new (?pos:haxe.PosInfos) { /*trace("new "+pos);*/ }
	
	public function setFuncToCall (func:Void->Void) :Void->Void {
		//trace("setFunction");
		stop();
		run = func;
		#if (flash || nme7)
			ticker = new Ticker();
			ticker.addEventListener (flash.events.Event.ENTER_FRAME, loop);
		#else
			ticker = new Ticker ( Math.round (1/FPS*1000) );
			ticker.run = loop;
		#end
		return func;
	}
	
	function loop (#if (flash || nme7) _ #end) {
		if (run != null) run();
	}
	
	public function stop (?pos:haxe.PosInfos) {
		//trace("stop "+pos);
		if (ticker == null) return;
		#if (flash || nme7)
			ticker.removeEventListener (flash.events.Event.ENTER_FRAME, loop);
		#else
			ticker.stop();
		#end
		ticker = null;
	}
	
	public function destroy () {
		//trace("destroy");
		stop();
	}
}
