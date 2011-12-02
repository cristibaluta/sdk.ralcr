package  {
	import haxe.Log;
	import flash.Boot;
	public class CATween extends CAObject implements CATransitionInterface{
		public function CATween(obj : * = null,properties : * = null,duration : * = null,delay : * = null,Eq : Function = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(obj,properties,duration,delay,Eq,pos);
		}}
		
		public override function init() : void {
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this.properties);
				while(_g < _g1.length) {
					var p : String = _g1[_g];
					++_g;
					if(Std._is(Reflect.field(this.properties,p),int) || Std._is(Reflect.field(this.properties,p),Number)) {
						Reflect.setField(this.fromValues,p,Reflect.field(this.target,p));
						Reflect.setField(this.toValues,p,Reflect.field(this.properties,p));
					}
					else try {
						Reflect.setField(this.fromValues,p,Reflect.field(Reflect.field(this.properties,p),"fromValue"));
						Reflect.setField(this.target,p,Reflect.field(this.fromValues,p));
						Reflect.setField(this.toValues,p,Reflect.field(Reflect.field(this.properties,p),"toValue"));
					}
					catch( e : * ){
						haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 25, className : "CATween", methodName : "init"});
					}
				}
			}
		}
		
		public override function animate(time_diff : Number) : void {
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this.toValues);
				while(_g < _g1.length) {
					var prop : String = _g1[_g];
					++_g;
					try {
						Reflect.setField(this.target,prop,this.calculate(time_diff,prop));
					}
					catch( e : * ){
						haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 35, className : "CATween", methodName : "animate"});
					}
				}
			}
		}
		
	}
}
