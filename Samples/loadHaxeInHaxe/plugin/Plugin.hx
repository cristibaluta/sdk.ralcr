import Rect;

class Plugin extends flash.display.Sprite {
	
	public static var plugin :Plugin;
	
	
	public function new(){
		trace("new Plugin()");
		super();
		this.graphics.lineStyle(10, 0x000000);
		this.graphics.lineTo(300, 300);
		testFunction();
	}
	public function diff (a:Float, b:Float):Float{
		trace("diff "+a+"-"+b);
		return a-b;
	}
	public function add (a:Float, b:Float):Float{
		trace("add "+a+"+"+b);
		return a+b;
	}
	public static function main(){
		//haxe.Firebug.redirectTraces();
		//plugin = new Plugin();
		//flash.Lib.current.addChild ( plugin );
	}
	
	
	
	static function testFunction () :Void {
		trace("TEST FUNCTION PLUGIN");
	}
	
}