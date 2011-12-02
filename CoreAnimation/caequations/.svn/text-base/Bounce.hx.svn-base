package caequations;

class Bounce {
	/**
	 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	inline public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c - OUT (d-t, 0, c, d, null) + b;
	}

	inline public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}

	inline public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return IN (t*2, 0, c, d, null) * .5 + b;
		else return OUT (t*2-d, 0, c, d, null) * .5 + c*.5 + b;
	}

	inline public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, null);
		return IN ((t*2)-d, b+c/2, c/2, d, null);
	}
}
