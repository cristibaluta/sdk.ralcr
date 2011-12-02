package caequations {
	public class Cubic {
		static public function IN(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * (t /= d) * t * t + b;
		}
		
		static public function OUT(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		static public function IN_OUT(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if((t /= d / 2) < 1) return c / 2 * t * t * t + b;
			return c / 2 * ((t -= 2) * t * t + 2) + b;
		}
		
		static public function OUT_IN(t : Number,b : Number,c : Number,d : Number,p_params : *) : Number {
			if(t < d / 2) return OUT(t * 2,b,c / 2,d,null);
			return IN(t * 2 - d,b + c / 2,c / 2,d,null);
		}
		
	}
}
