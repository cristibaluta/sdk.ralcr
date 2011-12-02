package caequations;

class Back {
	/**
	 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		s					Float		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent)
	 * @return							Float		The correct value
	 */
	inline public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		return c*(t/=d)*t*((s+1)*t - s) + b;
	}
	
	inline public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}
	
	inline public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	}
	
	inline public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, p_params);
		return IN ((t*2)-d, b+c/2, c/2, d, p_params);
	}
}
