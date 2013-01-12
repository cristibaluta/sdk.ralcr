/**
 * Equations
 * Main equations for the T class
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.0.2
 */

/*
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIORC

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CORCEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package caurina.transitions;

#if js
typedef T = JSTweener;
#elseif flash
typedef T = Tweener;
#end

class Equations {

	/**
	 * There's no constructor.
	 */
	public function new () {
		trace ("Equations is a static class and should not be instantiated.");
	}

	/**
	 * Registers all the equations to the T class, so they can be found by the direct string parameters.
	 * This method doesn't actually have to be used - equations can always be referenced by their full function
	 * names. But "registering" them make them available as their shorthand string names.
	 */
	public static function init () : Void {
		T.registerTransition ("easenone",			easeNone);
		T.registerTransition ("linear",			easeNone);			// mx.transitions.easing.None.easeNone
		
		T.registerTransition ("easeincubic",		easeInCubic);
		T.registerTransition ("easeoutcubic",		easeOutCubic);
		T.registerTransition ("easeinoutcubic",	easeInOutCubic);
		T.registerTransition ("easeoutincubic",	easeOutInCubic);
		
#if !tweener_lite
		T.registerTransition ("easeinquad",		easeInQuad);		// mx.transitions.easing.Regular.easeIn
		T.registerTransition ("easeoutquad",		easeOutQuad);		// mx.transitions.easing.Regular.easeOut
		T.registerTransition ("easeinoutquad",	easeInOutQuad);		// mx.transitions.easing.Regular.easeInOut
		T.registerTransition ("easeoutinquad",	easeOutInQuad);
		
		T.registerTransition ("easeinquart",		easeInQuart);
		T.registerTransition ("easeoutquart",		easeOutQuart);
		T.registerTransition ("easeinoutquart",	easeInOutQuart);
		T.registerTransition ("easeoutinquart",	easeOutInQuart);
		
		T.registerTransition ("easeinquint",		easeInQuint);
		T.registerTransition ("easeoutquint",		easeOutQuint);
		T.registerTransition ("easeinoutquint",	easeInOutQuint);
		T.registerTransition ("easeoutinquint",	easeOutInQuint);
		
		T.registerTransition ("easeinsine",		easeInSine);
		T.registerTransition ("easeoutsine",		easeOutSine);
		T.registerTransition ("easeinoutsine",	easeInOutSine);
		T.registerTransition ("easeoutinsine",	easeOutInSine);
		
		T.registerTransition ("easeincirc",		easeInCirc);
		T.registerTransition ("easeoutcirc",		easeOutCirc);
		T.registerTransition ("easeinoutcirc",	easeInOutCirc);
		T.registerTransition ("easeoutincirc",	easeOutInCirc);
		
		T.registerTransition ("easeinexpo",		easeInExpo);		// mx.transitions.easing.Strong.easeIn
		T.registerTransition ("easeoutexpo", 		easeOutExpo);		// mx.transitions.easing.Strong.easeOut
		T.registerTransition ("easeinoutexpo", 	easeInOutExpo);		// mx.transitions.easing.Strong.easeInOut
		T.registerTransition ("easeoutinexpo", 	easeOutInExpo);
		
		T.registerTransition ("easeinelastic", 	easeInElastic);		// mx.transitions.easing.Elastic.easeIn
		T.registerTransition ("easeoutelastic", 	easeOutElastic);	// mx.transitions.easing.Elastic.easeOut
		T.registerTransition ("easeinoutelastic", easeInOutElastic);	// mx.transitions.easing.Elastic.easeInOut
		T.registerTransition ("easeoutinelastic", easeOutInElastic);
		
		T.registerTransition ("easeinback", 		easeInBack);		// mx.transitions.easing.Back.easeIn
		T.registerTransition ("easeoutback", 		easeOutBack);		// mx.transitions.easing.Back.easeOut
		T.registerTransition ("easeinoutback", 	easeInOutBack);		// mx.transitions.easing.Back.easeInOut
		T.registerTransition ("easeoutinback", 	easeOutInBack);
		
		T.registerTransition ("easeinbounce", 	easeInBounce);		// mx.transitions.easing.Bounce.easeIn
		T.registerTransition ("easeoutbounce", 	easeOutBounce);		// mx.transitions.easing.Bounce.easeOut
		T.registerTransition ("easeinoutbounce", 	easeInOutBounce);	// mx.transitions.easing.Bounce.easeInOut
		T.registerTransition ("easeoutinbounce", 	easeOutInBounce);
#end
	}

	// ==================================================================================================================================
	// TWEENING EQUATIORC functions -----------------------------------------------------------------------------------------------------
	// (the original equations are Robert Penner's work as mentioned on the disclaimer)

	/**
	 * Easing equation function for a simple linear tweening, with no easing
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeNone (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*t/d + b;
	}

	
	/**
	 * Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInCubic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*(t/=d)*t*t + b;
	}

	/**
	 * Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutCubic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*((t=t/d-1)*t*t + 1) + b;
	}

	/**
	 * Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutCubic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	}

	/**
	 * Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInCubic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutCubic (t*2, b, c/2, d, p_params);
		return easeInCubic ((t*2)-d, b+c/2, c/2, d, p_params);
	}
	
	
	
	
#if !tweener_lite




	// compile this equations only if it's LIGHT version

	/**
	 * Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInQuad (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*(t/=d)*t + b;
	}

	/**
	 * Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutQuad (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c *(t/=d)*(t-2) + b;
	}

	/**
	 * Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutQuad (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	}

	/**
	 * Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInQuad (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutQuad (t*2, b, c/2, d, p_params);
		return easeInQuad ((t*2)-d, b+c/2, c/2, d, p_params);
	}
	
	/**
	 * Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInQuart (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*(t/=d)*t*t*t + b;
	}

	/**
	 * Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutQuart (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	}

	/**
	 * Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutQuart (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	}

	/**
	 * Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInQuart (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutQuart (t*2, b, c/2, d, p_params);
		return easeInQuart ((t*2)-d, b+c/2, c/2, d, p_params);
	}

	/**
	 * Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInQuint (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*(t/=d)*t*t*t*t + b;
	}

	/**
	 * Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutQuint (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	}

	/**
	 * Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutQuint (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	}

	/**
	 * Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInQuint (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutQuint (t*2, b, c/2, d, p_params);
		return easeInQuint ((t*2)-d, b+c/2, c/2, d, p_params);
	}

	/**
	 * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInSine (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	}

	/**
	 * Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutSine (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	}

	/**
	 * Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutSine (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	}

	/**
	 * Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInSine (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutSine (t*2, b, c/2, d, p_params);
		return easeInSine ((t*2)-d, b+c/2, c/2, d, p_params);
	}

	/**
	 * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInExpo (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
	}

	/**
	 * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutExpo (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
	}

	/**
	 * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutExpo (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
		return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
	}

	/**
	 * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInExpo (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutExpo (t*2, b, c/2, d, p_params);
		return easeInExpo ((t*2)-d, b+c/2, c/2, d, p_params);
	}

	/**
	 * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInCirc (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}

	/**
	 * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutCirc (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}

	/**
	 * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutCirc (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}

	/**
	 * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInCirc (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutCirc (t*2, b, c/2, d, p_params);
		return easeInCirc ((t*2)-d, b+c/2, c/2, d, p_params);
	}

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
	public static function easeInElastic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d)==1) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*.3 : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Std.parseFloat (Reflect.field (p_params, "amplitude"));
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		} else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	}

	/**
	 * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		a					Float		Amplitude
	 * @param		p					Float		Period
	 * @return							Float		The correct value
	 */
	public static function easeOutElastic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d)==1) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*.3 : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Reflect.field (p_params, "amplitude");
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		} else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
	}

	/**
	 * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		a					Float		Amplitude
	 * @param		p					Float		Period
	 * @return							Float		The correct value
	 */
	public static function easeInOutElastic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t==0) return b;
		if ((t/=d/2)==2) return b+c;
		var p:Float = Reflect.field (p_params, "period") == null ? d*(.3*1.5) : Reflect.field (p_params, "period");
		var s:Float;
		var a:Null<Float> = Reflect.field (p_params, "amplitude");
		if (a == null || a < Math.abs(c)) {
			a = c;
			s = p/4;
		} else {
			s = p/(2*Math.PI) * Math.asin (c/a);
		}
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	}

	/**
	 * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		a					Float		Amplitude
	 * @param		p					Float		Period
	 * @return							Float		The correct value
	 */
	public static function easeOutInElastic (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutElastic (t*2, b, c/2, d, p_params);
		return easeInElastic ((t*2)-d, b+c/2, c/2, d, p_params);
	}

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
	public static function easeInBack (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		return c*(t/=d)*t*((s+1)*t - s) + b;
	}

	/**
	 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		s					Float		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent)
	 * @return							Float		The correct value
	 */
	public static function easeOutBack (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}

	/**
	 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		s					Float		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent)
	 * @return							Float		The correct value
	 */
	public static function easeInOutBack (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		var s:Float = Reflect.field (p_params, "overshoot") == null ? 1.70158 : Reflect.field (p_params, "overshoot");
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	}

	/**
	 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @param		s					Float		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent)
	 * @return							Float		The correct value
	 */
	public static function easeOutInBack (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutBack (t*2, b, c/2, d, p_params);
		return easeInBack ((t*2)-d, b+c/2, c/2, d, p_params);
	}

	/**
	 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInBounce (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		return c - easeOutBounce (d-t, 0, c, d, null) + b;
	}

	/**
	 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutBounce (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
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

	/**
	 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeInOutBounce (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeInBounce (t*2, 0, c, d, null) * .5 + b;
		else return easeOutBounce (t*2-d, 0, c, d, null) * .5 + c*.5 + b;
	}

	/**
	 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration
	 *
	 * @param		t					Float		Current time (in frames or seconds)
	 * @param		b					Float		Starting value
	 * @param		c					Float		Change needed in value
	 * @param		d					Float		Expected easing duration (in frames or seconds)
	 * @return							Float		The correct value
	 */
	public static function easeOutInBounce (t:Float, b:Float, c:Float, d:Float, p_params:Dynamic) : Float {
		if (t < d/2) return easeOutBounce (t*2, b, c/2, d, p_params);
		return easeInBounce ((t*2)-d, b+c/2, c/2, d, p_params);
	}
#end
}
