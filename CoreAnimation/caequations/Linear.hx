package caequations;

class Linear {
	/**
	 * Easing equation function for a simple linear tweening, with no easing
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	inline public static function NONE (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*t/d + b;
	}
}
