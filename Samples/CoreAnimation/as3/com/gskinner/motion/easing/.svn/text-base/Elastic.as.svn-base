package com.gskinner.motion.easing {
	public class Elastic {
		static protected var a : Number = 1;
		static protected var p : Number = 0.3;
		static protected var s : Number = 0.075;
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			if(ratio == 0 || ratio == 1) {
				return ratio;
			}
			return -(Math.pow(2,10 * (ratio -= 1)) * Math.sin((ratio - 0.075) * (2 * Math.PI) / 0.3));
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			if(ratio == 0 || ratio == 1) {
				return ratio;
			}
			return Math.pow(2,-10 * ratio) * Math.sin((ratio - 0.075) * (2 * Math.PI) / 0.3) + 1;
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			if(ratio == 0 || ratio == 1) {
				return ratio;
			}
			ratio = ratio * 2 - 1;
			if(ratio < 0) {
				return -0.5 * (Math.pow(2,10 * ratio) * Math.sin((ratio - 0.075 * 1.5) * (2 * Math.PI) / (0.3 * 1.5)));
			}
			return 0.5 * Math.pow(2,-10 * ratio) * Math.sin((ratio - 0.075 * 1.5) * (2 * Math.PI) / (0.3 * 1.5)) + 1;
		}
		
	}
}
