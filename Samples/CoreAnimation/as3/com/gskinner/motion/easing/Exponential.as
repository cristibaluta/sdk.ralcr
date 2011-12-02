package com.gskinner.motion.easing {
	public class Exponential {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ((ratio == 0)?0:Math.pow(2,10 * (ratio - 1)));
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ((ratio == 1)?1:1 - Math.pow(2,-10 * ratio));
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			if(ratio == 0 || ratio == 1) {
				return ratio;
			}
			if(0 > (ratio = ratio * 2 - 1)) {
				return 0.5 * Math.pow(2,10 * ratio);
			}
			return 1 - 0.5 * Math.pow(2,-10 * ratio);
		}
		
	}
}
