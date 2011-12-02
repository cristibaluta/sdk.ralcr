package com.gskinner.motion.easing {
	public class Quintic {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ratio * ratio * ratio * ratio * ratio;
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return 1 + (ratio -= 1) * ratio * ratio * ratio * ratio;
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ((ratio < 0.5)?16 * ratio * ratio * ratio * ratio * ratio:16 * (ratio -= 1) * ratio * ratio * ratio * ratio + 1);
		}
		
	}
}
