package com.gskinner.motion.easing {
	public class Bounce {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return 1 - easeOut(1 - ratio,0,0,0);
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			if(ratio < 1 / 2.75) {
				return 7.5625 * ratio * ratio;
			}
			else if(ratio < 2 / 2.75) {
				return 7.5625 * (ratio -= 1.5 / 2.75) * ratio + 0.75;
			}
			else if(ratio < 2.5 / 2.75) {
				return 7.5625 * (ratio -= 2.25 / 2.75) * ratio + 0.9375;
			}
			else {
				return 7.5625 * (ratio -= 2.625 / 2.75) * ratio + 0.984375;
			}
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return (((ratio *= 2) < 1)?0.5 * easeIn(ratio,0,0,0):0.5 * easeOut(ratio - 1,0,0,0) + 0.5);
		}
		
	}
}
