package caequations;

class Sine {
	/**
	 * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	inline public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	}

	inline public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	}
	
	inline public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	}

	inline public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, null);
		return IN ((t*2)-d, b+c/2, c/2, d, null);
	}
}
