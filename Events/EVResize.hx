#if (flash || (openfl && (cpp || neko)))
	import flash.events.Event;
#elseif js
	import js.html.Event;
#end

class EVResize extends RCSignal<Int->Int->Void> {
	
	public function new () {
		
		super();
		
		#if (flash || (openfl && (cpp || neko)))
			flash.Lib.current.stage.addEventListener (Event.RESIZE, resizeHandler);
		#elseif js
			js.Browser.window.onresize = resizeHandler;
		#end
	}
	
	function resizeHandler (e:Event) {
		
		#if (flash || (openfl && (cpp || neko)))
			var w = flash.Lib.current.stage.stageWidth;
			var h = flash.Lib.current.stage.stageHeight;
		#elseif js
			// The size of the app
			//var w = js.Browser.document.body.scrollWidth;
			//var h = js.Browser.document.body.scrollHeight;
			// The size of the window
			var w = js.Browser.window.innerWidth;
			var h = js.Browser.window.innerHeight;
		#end
		
		dispatch ( w, h );
	}
	
	override public function destroy (?pos:haxe.PosInfos) :Void {
		#if (flash || (openfl && (cpp || neko)))
			flash.Lib.current.stage.removeEventListener (Event.RESIZE, resizeHandler);
		#elseif js
			js.Browser.window.onresize = null;
		#end
		super.destroy();
	}
	
}
