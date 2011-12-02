package  {
	import flash.Boot;
	public class CATKenBurns extends CAObject implements CATransitionInterface{
		public function CATKenBurns(obj : * = null,properties : * = null,duration : * = null,delay : * = null,Eq : Function = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(obj,properties,duration,delay,Eq,pos);
		}}
		
		public override function init() : void {
			var random_direction_x : int = Std.random(10);
			var random_direction_y : int = Std.random(10);
			this.target.scaleX = 1;
			this.target.scaleY = 1;
			var f_w : int = this.target.width;
			var f_h : int = this.target.height;
			var x : Number = this.constraintBounds.x;
			var y : Number = this.constraintBounds.y;
			var w : Number = this.constraintBounds.width;
			var h : Number = this.constraintBounds.height;
			if(w / this.target.width > h / this.target.height) {
				this.target.width = w;
				this.target.height = w * f_h / f_w;
			}
			else {
				this.target.height = h;
				this.target.width = h * f_w / f_h;
			}
			if(f_w < w || f_h < h) {
				f_w = this.target.width;
				f_h = this.target.height;
			}
			var f_x : Number = ((random_direction_x > 5)?x - f_w + w:x);
			var f_y : Number = ((random_direction_y > 5)?y - f_h + h:y);
			this.target.x = ((random_direction_x > 5)?x:x - this.target.width + w);
			this.target.y = ((random_direction_y > 5)?y:y - this.target.height + h);
			this.target.alpha = 0;
			var i_w : * = this.target.width;
			var i_h : * = this.target.height;
			var i_x : * = this.target.x;
			var i_y : * = this.target.y;
			var p1 : * = this.delegate.kenBurnsPointIn;
			var p2 : * = this.delegate.kenBurnsPointOut;
			if(p1 == null) this.delegate.kenBurnsPointIn = this.duration * 1000 / 5;
			if(p2 == null) this.delegate.kenBurnsPointOut = this.duration * 1000 * 4 / 5;
			this.fromValues = { x : this.target.x, y : this.target.y, width : this.target.width, height : this.target.height, alpha : null}
			this.toValues = { x : f_x, y : f_y, width : f_w, height : f_h, alpha : null}
		}
		
		public override function animate(time_diff : Number) : void {
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this.toValues);
				while(_g < _g1.length) {
					var prop : String = _g1[_g];
					++_g;
					if(prop != "alpha") {
						Reflect.setField(this.target,prop,this.calculate(time_diff,prop));
					}
					else if(time_diff < this.delegate.kenBurnsPointIn) {
						Reflect.setField(this.target,prop,this.calculateAlpha(time_diff,0,1));
					}
					else if(time_diff > this.delegate.kenBurnsPointOut) {
						Reflect.setField(this.target,prop,this.calculateAlpha(time_diff - this.delegate.kenBurnsPointOut,1,0));
					}
				}
			}
		}
		
		public function calculateAlpha(time_diff : Number,fromAlpha : Number,toAlpha : Number) : Number {
			var duration : * = ((fromAlpha == 0)?this.delegate.kenBurnsPointIn:this.duration - this.delegate.kenBurnsPointOut);
			return this.timingFunction(time_diff,fromAlpha,toAlpha - fromAlpha,duration,null);
		}
		
	}
}
