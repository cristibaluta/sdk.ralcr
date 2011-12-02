package  {
	import haxe.Stack;
	import haxe.Log;
	import flash.Boot;
	public class CADelegate {
		public function CADelegate() : void { if( !flash.Boot.skip_constructor ) {
			this.startPointPassed = false;
			this.kenBurnsPointInPassed = false;
			this.kenBurnsPointOutPassed = false;
		}}
		
		public var animationDidStart : *;
		public var animationDidStop : *;
		public var animationDidReversed : *;
		public var arguments : Array;
		public var kenBurnsDidFadedIn : *;
		public var kenBurnsBeginsFadingOut : *;
		public var kenBurnsArgs : Array;
		public var startPointPassed : Boolean;
		public var kenBurnsPointInPassed : Boolean;
		public var kenBurnsPointOutPassed : Boolean;
		public var kenBurnsPointIn : *;
		public var kenBurnsPointOut : *;
		public var pos : *;
		public function start() : void {
			this.startPointPassed = true;
			if(Reflect.isFunction(this.animationDidStart)) try {
				this.animationDidStart.apply(null,this.arguments);
			}
			catch( e : * ){
				haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 36, className : "CADelegate", methodName : "start"});
			}
		}
		
		public function stop() : void {
			if(Reflect.isFunction(this.animationDidStop)) {
				try {
					this.animationDidStop.apply(null,this.arguments);
				}
				catch( e : * ){
					haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 42, className : "CADelegate", methodName : "stop"});
					haxe.Log.trace(this.pos.className + " -> " + this.pos.methodName + " -> " + this.pos.lineNumber,{ fileName : "CADelegate.hx", lineNumber : 43, className : "CADelegate", methodName : "stop"});
					var stack : Array = haxe.Stack.exceptionStack();
					haxe.Log.trace(haxe.Stack.toString(stack),{ fileName : "CADelegate.hx", lineNumber : 45, className : "CADelegate", methodName : "stop"});
				}
			}
		}
		
		public function repeat() : void {
			if(Reflect.isFunction(this.animationDidReversed)) try {
				this.animationDidReversed.apply(null,this.arguments);
			}
			catch( e : * ){
				haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 52, className : "CADelegate", methodName : "repeat"});
			}
		}
		
		public function kbIn() : void {
			this.kenBurnsPointInPassed = true;
			if(Reflect.isFunction(this.kenBurnsDidFadedIn)) try {
				this.kenBurnsDidFadedIn.apply(null,this.kenBurnsArgs);
			}
			catch( e : * ){
				haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 58, className : "CADelegate", methodName : "kbIn"});
			}
		}
		
		public function kbOut() : void {
			this.kenBurnsPointOutPassed = true;
			if(Reflect.isFunction(this.kenBurnsBeginsFadingOut)) try {
				this.kenBurnsBeginsFadingOut.apply(null,this.kenBurnsArgs);
			}
			catch( e : * ){
				haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 64, className : "CADelegate", methodName : "kbOut"});
			}
		}
		
	}
}
