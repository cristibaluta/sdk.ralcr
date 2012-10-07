import flash.events.Event;


class Main extends flash.display.Sprite {
	
	var plugin :RCPluginLoader;
	
	
	public function new(){
		super();trace("new Main()");
		
		graphics.lineStyle (5, 0xff3300);
		graphics.lineTo (400, 0);
		
		plugin = new RCPluginLoader ("plugin.swf?"+Math.random());
		//plugin.onComplete = completeHandler;
		plugin.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
	}
	
	
	function completeHandler(e:Event){
		trace("completeHandler");
		try{
			//this.addChild ( e.target.content );
			trace(plugin);
			trace(e.target.contentType);
			trace(e.target.applicationDomain);
			trace(e.target.sameDomain);
			trace(e.target.swfVersion);
			trace(e.target.url);
			
/*			trace(Type.getInstanceFields(RCPluginLoader));
			trace(Type.getInstanceFields(Plugin));*/
			
			var p = new Plugin();
				p.y = 100;
			this.addChild ( p );
			trace ( p.add(50, 10) );
			trace ( p.diff(50, 10) );
			
			var p = new Plugin();
				p.y = 200;
			this.addChild ( p );
			
			var r = new Rect();
			trace(r);
			trace ( r.diff(10, 5) );
		
		}
		catch(e:Dynamic){trace(e);}
		
		testFunction();
	}
	
	
	static function testFunction () :Void {
		trace("TEST FUNCTION MAIN");
	}
	public static function main(){trace("main");
		haxe.Firebug.redirectTraces();
		flash.Lib.current.addChild( new Main() );
	}
}