package com.gskinner.motion.easing {
	public class Sine {
		static public function easeIn(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return 1 - Math.cos(ratio * (Math.PI / 2));
		}
		
		static public function easeOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return Math.sin(ratio * (Math.PI / 2));
		}
		
		static public function easeInOut(ratio : Number,unused1 : Number,unused2 : Number,unused3 : Number) : Number {
			return -0.5 * (Math.cos(ratio * Math.PI) - 1);
		}
		
	}
}
