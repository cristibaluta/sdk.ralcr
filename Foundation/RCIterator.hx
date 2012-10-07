import haxe.Timer;


class RCIterator {
	
	public var min :Float;
	public var max :Float;
	public var step :Float;
	public var percentCompleted :Int;
	//public var operations :Array<Dynamic>;
	var timer :Timer;
	var interval :Int;
	
	dynamic public function run (i:Float) :Void {}
	dynamic public function onComplete():Void {}
	
	
	/**
	*  @param interval - 
	*  @param min - 
	*  @param max - 
	*  @param step - 
	*/
	public function new (interval:Int, min:Float, max:Float, step:Float) {
		
		this.interval = interval;
		this.min = min;
		this.max = max;
		this.step = step;
		
		timer = new Timer ( interval );
	}
	
	public function start() {
		run ( min );
		timer.run = loop;
	}
	
	function loop () {
		min += step;
		run ( min );
		if (min >= max) {
			destroy();
			onComplete();
		}
	}
	
	
	public function destroy () {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}
}
