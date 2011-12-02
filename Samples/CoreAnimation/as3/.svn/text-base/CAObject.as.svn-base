package  {
	import flash.geom.Rectangle;
	import flash.Lib;
	import haxe.Log;
	import flash.Boot;
	public class CAObject {
		public function CAObject(obj : * = null,properties : * = null,duration : * = null,delay : * = null,Eq : Function = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.target = obj;
			this.properties = properties;
			this.repeatCount = 0;
			this.autoreverses = false;
			this.fromTime = flash.Lib._getTimer();
			this.duration = ((duration == null || duration < 0)?CoreAnimation.defaultDuration:duration);
			this.delay = ((delay == null || delay < 0)?0:delay);
			this.timingFunction = ((Eq == null)?CoreAnimation.defaultTimingFunction:Eq);
			this.delegate = new CADelegate();
			this.delegate.pos = pos;
			this.fromValues = { }
			this.toValues = { }
		}}
		
		public var target : *;
		public var prev : CAObject;
		public var next : CAObject;
		public var properties : *;
		public var fromValues : *;
		public var toValues : *;
		public var fromTime : Number;
		public var delay : Number;
		public var duration : Number;
		public var repeatCount : int;
		public var autoreverses : Boolean;
		public var timingFunction : Function;
		public var modifierFunction : Function;
		public var constraintBounds : flash.geom.Rectangle;
		public var delegate : CADelegate;
		public function init() : void {
			haxe.Log.trace("CAObject should be extended (" + this.delegate.pos + ")",{ fileName : "CAObject.hx", lineNumber : 64, className : "CAObject", methodName : "init"});
		}
		
		public function animate(time_diff : Number) : void {
			haxe.Log.trace("CAObject should be extended (" + this.delegate.pos + ")",{ fileName : "CAObject.hx", lineNumber : 65, className : "CAObject", methodName : "animate"});
		}
		
		public function initTime() : void {
			this.fromTime = flash.Lib._getTimer();
			this.duration = this.duration * 1000;
			this.delay = this.delay * 1000;
		}
		
		public function repeat() : void {
			this.fromTime = flash.Lib._getTimer();
			this.delay = 0;
			if(this.autoreverses) {
				var v : * = this.fromValues;
				this.fromValues = this.toValues;
				this.toValues = v;
			}
			this.repeatCount--;
		}
		
		public function calculate(time_diff : Number,prop : String) : Number {
			return this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null);
		}
		
		public function toString() : String {
			return "[CAObject: target=" + this.target + ", duration=" + this.duration + ", delay=" + this.delay + ", fromTime=" + this.fromTime + ", properties=" + this.properties + ", repeatCount=" + this.repeatCount + "]";
		}
		
	}
}
