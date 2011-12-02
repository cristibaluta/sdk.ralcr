package caequations;

class Circ {
	/**
	 * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	inline public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}

	inline public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}

	inline public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}

	inline public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, null);
		return IN ((t*2)-d, b+c/2, c/2, d, null);
	}
}
