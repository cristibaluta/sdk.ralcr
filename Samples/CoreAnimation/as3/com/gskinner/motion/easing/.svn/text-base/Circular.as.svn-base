package com.gskinner.motion.easing {
	public class Circular {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return -(Math.sqrt(1 - ratio * ratio) - 1);
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return Math.sqrt(1 - (ratio - 1) * (ratio - 1));
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return (((ratio *= 2) < 1)?-0.5 * (Math.sqrt(1 - ratio * ratio) - 1):0.5 * (Math.sqrt(1 - (ratio -= 2) * ratio) + 1));
		}
		
	}
}
