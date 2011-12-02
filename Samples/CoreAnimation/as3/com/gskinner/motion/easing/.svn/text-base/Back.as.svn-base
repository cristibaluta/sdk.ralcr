package com.gskinner.motion.easing {
	public class Back {
		static protected var s : Number = 1.70158;
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return ratio * ratio * ((1.70158 + 1) * ratio - 1.70158);
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return (ratio -= 1) * ratio * ((1.70158 + 1) * ratio + 1.70158) + 1;
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return (((ratio *= 2) < 1)?0.5 * (ratio * ratio * ((2.5949095 + 1) * ratio - 2.5949095)):0.5 * ((ratio -= 2) * ratio * ((2.5949095 + 1) * ratio + 2.5949095) + 2));
		}
		
	}
}
