import flash.errors.Error;
import flash.events.MouseEvent;

class Main {
	
	static function main () {
		haxe.Firebug.redirectTraces();
		
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		
		RCNotificationCenter.addObserver ("resize", resize2);
		RCNotificationCenter.addObserver ("resize", resize);
		RCNotificationCenter.postNotification ("resize", [1,2]);
		
		//haxe.Timer.delay (autoResize, 3000);
		
		// String with format test
		//trace(RCStringTools.stringWithFormat("stringWithFormat %@ %@, %@->>>%@", [1, 23, "hahaha", "yo"]));
		
		
		testTea();
		flash.Lib.current.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
		
		
		var o = new Obj();
		o.x = 4;
		trace(o.x);
	}
	static function resize(w, h):Void {
		//trace("resize to "+w+"x"+h);
	}
	static function resize2():Void {
		//trace("resize");
	}
	static function autoResize () {
		RCNotificationCenter.postNotification ("resize", [2,3]);
	}
	static function mouseDown (e:MouseEvent) {}
	
	
	static function testTea(){
		var str = "blah blah blah";
		var pass = "123dsf";
		trace(str);
		var str1 = TEA.encrypt(str, pass);
		trace(str1);
		var str2 = TEA.decrypt(str1, pass);
		trace(str2);
		
		var str1 = XXTea.encrypt(str, pass);
		trace(str1);
		var str2 = XXTea.decrypt(str1, pass);
		trace(str2);
	}
	
	
/*	static var req :RCHttp;
	static function testTheDeals () {
		req = new RCHttp("http://thedeals.ro/api/categories");
		req.onComplete = onC;
		req.call ("", {api_key:"0e54c11ddbf9f29570a9cbf3c6709059", api_sig:"zguxoqlek6l1vuzo"});
	}
	static function onC () {
		trace(req.result);
	}*/
}

class Obj {
	public var x (default, set_x) :Int;
	function set_x(x:Int):Int{
		this.x = x;trace(x);
		return x;
	}
	public function new(){}
		
}
