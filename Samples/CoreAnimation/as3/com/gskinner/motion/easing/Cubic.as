package com.gskinner.motion.easing {
	public class Cubic {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ratio * ratio * ratio;
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return (ratio -= 1) * ratio * ratio + 1;
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ((ratio < 0.5)?4 * ratio * ratio * ratio:4 * (ratio -= 1) * ratio * ratio + 1);
		}
		
	}
}
