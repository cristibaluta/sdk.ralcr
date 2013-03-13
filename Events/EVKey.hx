
#if (flash || (nme && (cpp || neko)))
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
#elseif js
	import js.html.KeyboardEvent;
#end


class EVKey extends RCSignal<EVKey->Void> {
	
	public var char :String;
	public var keyCode :Int;
	
	public var down :RCSignal<String->Void>;
	public var up :RCSignal<String->Void>;
	
	
	public function new () {
		#if (flash || (nme && (cpp || neko)))
			flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDownHandler);
			flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUpHandler);
		#elseif js
			js.Browser.document.onkeydown = keyDownHandler;
			js.Browser.document.onkeyup = keyUpHandler;
		#end
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		keyCode = e.keyCode;
		char = "";
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		//charCode = e.charCode;
		char = "";
		dispatch();
	}
	
	override public function destroy () :Void {
		#if (flash || (nme && (cpp || neko)))
			flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_DOWN, keyDownHandler);
			flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_UP, keyUpHandler);
		#elseif js
			js.Browser.document.onkeydown = null;
			js.Browser.document.onkeyup = null;
		#end
	}
}
