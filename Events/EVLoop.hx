#if flash
	typedef Ticker = flash.display.Sprite;
#else
	typedef Ticker = haxe.Timer;
#end


class EVLoop {
	
	var ticker :Ticker;
	var _run :Void->Void;
	public var run (null, set_run) :Void->Void;
	public static var FPS :Int = 60;
	
	public function new (?pos:haxe.PosInfos) { }
	
	public function set_run (func:Void->Void) :Void->Void {
		//trace("setFunction");
		stop();
		_run = func;
		#if flash
			ticker = new Ticker();
			ticker.addEventListener (flash.events.Event.ENTER_FRAME, loop);
		#else
			ticker = new Ticker ( Math.round (1/FPS*1000) );
			ticker.run = loop;
		#end
		return func;
	}
	
	function loop (#if flash _ #end) {
		//trace(_run);
		if (_run != null) _run();
	}
	
	public function stop () {
		if (ticker == null) return;
		#if flash
			ticker.removeEventListener (flash.events.Event.ENTER_FRAME, loop);
			//if (!ticker.hasEventListener (flash.events.Event.ENTER_FRAME))
			ticker = null;
		#else
			ticker.stop();
			ticker = null;
		#end
	}
	
	public function destroy () {
		stop();
	}
}
