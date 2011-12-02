package com.gskinner.motion.easing {
	public class Quadratic {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ratio * ratio;
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return -ratio * (ratio - 2);
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ((ratio < 0.5)?2 * ratio * ratio:-2 * ratio * (ratio - 2) - 1);
		}
		
	}
}
