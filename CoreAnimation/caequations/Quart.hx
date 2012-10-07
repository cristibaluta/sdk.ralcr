package caequations;

class Quart {
	/**
	 * Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	inline public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*(t/=d)*t*t*t + b;
	}

	inline public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	}

	inline public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	}

	inline public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, null);
		return IN ((t*2)-d, b+c/2, c/2, d, null);
	}
}
