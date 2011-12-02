class Main {
	
	static function main () {
		haxe.Firebug.redirectTraces();
		
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		
		//
		RCNotificationCenter.addObserver ("resize", resizeWithArgs);
		RCNotificationCenter.addObserver ("resize2", resize2);
		
		RCNotificationCenter.postNotification ("resize", [1,1]);
		
		haxe.Timer.delay (autoResize, 3000);
	}
	static function resizeWithArgs(w:Int, h:Int):Void {
		trace("resize with args: "+w+", "+h);
		trace(w*h);
	}
	static function resize2():Void {
		trace("resize without args");
	}
	
	
	static function autoResize () {
		RCNotificationCenter.postNotification ("resize", ["2",2]);
		RCNotificationCenter.postNotification ("resize");// This will output an error
		RCNotificationCenter.postNotification ("resize2");
	}
}
