package caequations;

class Elastic {
	/**
	 * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		a					Float		Amplitude
	 * @param		p					Float		Period
	 * @return							Float		The correct value
	 */
	public static function IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d)==1) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*.3 : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Std.parseFloat (Reflect.field (p_params, "amplitude"));
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		}
		else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	}

	public static function OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d)==1) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*.3 : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Reflect.field (p_params, "amplitude");
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		}
		else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
	}

	public static function IN_OUT (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d/2)==2) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*(.3*1.5) : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Reflect.field (p_params, "amplitude");
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		}
		else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	}

	public static function OUT_IN (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return OUT (t*2, b, c/2, d, p_params);
		return IN ((t*2)-d, b+c/2, c/2, d, p_params);
	}
}
