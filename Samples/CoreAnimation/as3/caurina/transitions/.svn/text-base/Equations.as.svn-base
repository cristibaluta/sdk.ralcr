package caurina.transitions {
	import caurina.transitions.Tweener;
	import haxe.Log;
	import flash.Boot;
	public class Equations {
		public function Equations() : void { if( !flash.Boot.skip_constructor ) {
			haxe.Log.trace("Equations is a static class and should not be instantiated.",{ fileName : "Equations.hx", lineNumber : 41, className : "caurina.transitions.Equations", methodName : "new"});
		}}
		
		static public function init() : void {
			caurina.transitions.Tweener.registerTransition("easenone",caurina.transitions.Equations.easeNone);
			caurina.transitions.Tweener.registerTransition("linear",caurina.transitions.Equations.easeNone);
			caurina.transitions.Tweener.registerTransition("easeincubic",caurina.transitions.Equations.easeInCubic);
			caurina.transitions.Tweener.registerTransition("easeoutcubic",caurina.transitions.Equations.easeOutCubic);
			caurina.transitions.Tweener.registerTransition("easeinoutcubic",caurina.transitions.Equations.easeInOutCubic);
			caurina.transitions.Tweener.registerTransition("easeoutincubic",caurina.transitions.Equations.easeOutInCubic);
			caurina.transitions.Tweener.registerTransition("easeinquad",caurina.transitions.Equations.easeInQuad);
			caurina.transitions.Tweener.registerTransition("easeoutquad",caurina.transitions.Equations.easeOutQuad);
			caurina.transitions.Tweener.registerTransition("easeinoutquad",caurina.transitions.Equations.easeInOutQuad);
			caurina.transitions.Tweener.registerTransition("easeoutinquad",caurina.transitions.Equations.easeOutInQuad);
			caurina.transitions.Tweener.registerTransition("easeinquart",caurina.transitions.Equations.easeInQuart);
			caurina.transitions.Tweener.registerTransition("easeoutquart",caurina.transitions.Equations.easeOutQuart);
			caurina.transitions.Tweener.registerTransition("easeinoutquart",caurina.transitions.Equations.easeInOutQuart);
			caurina.transitions.Tweener.registerTransition("easeoutinquart",caurina.transitions.Equations.easeOutInQuart);
			caurina.transitions.Tweener.registerTransition("easeinquint",caurina.transitions.Equations.easeInQuint);
			caurina.transitions.Tweener.registerTransition("easeoutquint",caurina.transitions.Equations.easeOutQuint);
			caurina.transitions.Tweener.registerTransition("easeinoutquint",caurina.transitions.Equations.easeInOutQuint);
			caurina.transitions.Tweener.registerTransition("easeoutinquint",caurina.transitions.Equations.easeOutInQuint);
			caurina.transitions.Tweener.registerTransition("easeinsine",caurina.transitions.Equations.easeInSine);
			caurina.transitions.Tweener.registerTransition("easeoutsine",caurina.transitions.Equations.easeOutSine);
			caurina.transitions.Tweener.registerTransition("easeinoutsine",caurina.transitions.Equations.easeInOutSine);
			caurina.transitions.Tweener.registerTransition("easeoutinsine",caurina.transitions.Equations.easeOutInSine);
			caurina.transitions.Tweener.registerTransition("easeincirc",caurina.transitions.Equations.easeInCirc);
			caurina.transitions.Tweener.registerTransition("easeoutcirc",caurina.transitions.Equations.easeOutCirc);
			caurina.transitions.Tweener.registerTransition("easeinoutcirc",caurina.transitions.Equations.easeInOutCirc);
			caurina.transitions.Tweener.registerTransition("easeoutincirc",caurina.transitions.Equations.easeOutInCirc);
			caurina.transitions.Tweener.registerTransition("easeinexpo",caurina.transitions.Equations.easeInExpo);
			caurina.transitions.Tweener.registerTransition("easeoutexpo",caurina.transitions.Equations.easeOutExpo);
			caurina.transitions.Tweener.registerTransition("easeinoutexpo",caurina.transitions.Equations.easeInOutExpo);
			caurina.transitions.Tweener.registerTransition("easeoutinexpo",caurina.transitions.Equations.easeOutInExpo);
			caurina.transitions.Tweener.registerTransition("easeinelastic",caurina.transitions.Equations.easeInElastic);
			caurina.transitions.Tweener.registerTransition("easeoutelastic",caurina.transitions.Equations.easeOutElastic);
			caurina.transitions.Tweener.registerTransition("easeinoutelastic",caurina.transitions.Equations.easeInOutElastic);
			caurina.transitions.Tweener.registerTransition("easeoutinelastic",caurina.transitions.Equations.easeOutInElastic);
			caurina.transitions.Tweener.registerTransition("easeinback",caurina.transitions.Equations.easeInBack);
			caurina.transitions.Tweener.registerTransition("easeoutback",caurina.transitions.Equations.easeOutBack);
			caurina.transitions.Tweener.registerTransition("easeinoutback",caurina.transitions.Equations.easeInOutBack);
			caurina.transitions.Tweener.registerTransition("easeoutinback",caurina.transitions.Equations.easeOutInBack);
			caurina.transitions.Tweener.registerTransition("easeinbounce",caurina.transitions.Equations.easeInBounce);
			caurina.transitions.Tweener.registerTransition("easeoutbounce",caurina.transitions.Equations.easeOutBounce);
			caurina.transitions.Tweener.registerTransition("easeinoutbounce",caurina.transitions.Equations.easeInOutBounce);
			caurina.transitions.Tweener.registerTransition("easeoutinbounce",caurina.transitions.Equations.easeOutInBounce);
		}
		
		static public function easeNone(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * t / d + b;
		}
		
		static public function easeInCubic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * (t /= d) * t * t + b;
		}
		
		static public function easeOutCubic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		static public function easeInOutCubic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return c / 2 * t * t * t + b;
			return c / 2 * ((t -= 2) * t * t + 2) + b;
		}
		
		static public function easeOutInCubic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutCubic(t * 2,b,c / 2,d,p_params);
			return easeInCubic(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInQuad(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * (t /= d) * t + b;
		}
		
		static public function easeOutQuad(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return -c * (t /= d) * (t - 2) + b;
		}
		
		static public function easeInOutQuad(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return c / 2 * t * t + b;
			return -c / 2 * (--t * (t - 2) - 1) + b;
		}
		
		static public function easeOutInQuad(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutQuad(t * 2,b,c / 2,d,p_params);
			return easeInQuad(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInQuart(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * (t /= d) * t * t * t + b;
		}
		
		static public function easeOutQuart(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		
		static public function easeInOutQuart(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
		
		static public function easeOutInQuart(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutQuart(t * 2,b,c / 2,d,p_params);
			return easeInQuart(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInQuint(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * (t /= d) * t * t * t * t + b;
		}
		
		static public function easeOutQuint(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		static public function easeInOutQuint(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
			return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		static public function easeOutInQuint(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutQuint(t * 2,b,c / 2,d,p_params);
			return easeInQuint(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInSine(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
		}
		
		static public function easeOutSine(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * Math.sin(t / d * (Math.PI / 2)) + b;
		}
		
		static public function easeInOutSine(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
		
		static public function easeOutInSine(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutSine(t * 2,b,c / 2,d,p_params);
			return easeInSine(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInExpo(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return ((t == 0)?b:c * Math.pow(2,10 * (t / d - 1)) + b - c * 0.001);
		}
		
		static public function easeOutExpo(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return ((t == d)?b + c:c * 1.001 * (-Math.pow(2,-10 * t / d) + 1) + b);
		}
		
		static public function easeInOutExpo(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t == 0) return b;
			if(t == d) return b + c;
			if((t /= d / 2) < 1) return c / 2 * Math.pow(2,10 * (t - 1)) + b - c * 0.0005;
			return c / 2 * 1.0005 * (-Math.pow(2,-10 * --t) + 2) + b;
		}
		
		static public function easeOutInExpo(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutExpo(t * 2,b,c / 2,d,p_params);
			return easeInExpo(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInCirc(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		static public function easeOutCirc(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}
		
		static public function easeInOutCirc(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
			return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
		
		static public function easeOutInCirc(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutCirc(t * 2,b,c / 2,d,p_params);
			return easeInCirc(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInElastic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t == 0) return b;
			if((t /= d) == 1) return b + c;
			var p : Number = ((Reflect.field(p_params,"period") == null)?d * .3:Reflect.field(p_params,"period"));
			var s : Number;
			var a : * = Std._parseFloat(Reflect.field(p_params,"amplitude"));
			if(a == null || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			}
			else {
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			return -(a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		}
		
		static public function easeOutElastic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t == 0) return b;
			if((t /= d) == 1) return b + c;
			var p : Number = ((Reflect.field(p_params,"period") == null)?d * .3:Reflect.field(p_params,"period"));
			var s : Number;
			var a : * = Reflect.field(p_params,"amplitude");
			if(a == null || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			}
			else {
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			return a * Math.pow(2,-10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
		}
		
		static public function easeInOutElastic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t == 0) return b;
			if((t /= d / 2) == 2) return b + c;
			var p : Number = ((Reflect.field(p_params,"period") == null)?d * (.3 * 1.5):Reflect.field(p_params,"period"));
			var s : Number;
			var a : * = Reflect.field(p_params,"amplitude");
			if(a == null || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			}
			else {
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			if(t < 1) return -0.5 * (a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
			return a * Math.pow(2,-10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
		}
		
		static public function easeOutInElastic(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutElastic(t * 2,b,c / 2,d,p_params);
			return easeInElastic(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInBack(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			var s : Number = ((Reflect.field(p_params,"overshoot") == null)?1.70158:Reflect.field(p_params,"overshoot"));
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		static public function easeOutBack(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			var s : Number = ((Reflect.field(p_params,"overshoot") == null)?1.70158:Reflect.field(p_params,"overshoot"));
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		static public function easeInOutBack(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			var s : Number = ((Reflect.field(p_params,"overshoot") == null)?1.70158:Reflect.field(p_params,"overshoot"));
			if((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
			return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
		}
		
		static public function easeOutInBack(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutBack(t * 2,b,c / 2,d,p_params);
			return easeInBack(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
		static public function easeInBounce(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c - easeOutBounce(d - t,0,c,d,null) + b;
		}
		
		static public function easeOutBounce(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d) < 1 / 2.75) {
				return c * (7.5625 * t * t) + b;
			}
			else if(t < 2 / 2.75) {
				return c * (7.5625 * (t -= 1.5 / 2.75) * t + .75) + b;
			}
			else if(t < 2.5 / 2.75) {
				return c * (7.5625 * (t -= 2.25 / 2.75) * t + .9375) + b;
			}
			else {
				return c * (7.5625 * (t -= 2.625 / 2.75) * t + .984375) + b;
			}
		}
		
		static public function easeInOutBounce(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeInBounce(t * 2,0,c,d,null) * .5 + b;
			else return easeOutBounce(t * 2 - d,0,c,d,null) * .5 + c * .5 + b;
		}
		
		static public function easeOutInBounce(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return easeOutBounce(t * 2,b,c / 2,d,p_params);
			return easeInBounce(t * 2 - d,b + c / 2,c / 2,d,p_params);
		}
		
	}
}
