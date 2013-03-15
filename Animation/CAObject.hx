//
//  CAObject.hx
//	RCAnimation
//
//  Created by Baluta Cristian on 2009-03-22.
//  Copyright (c) 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

/**
 *  The base object that holds the properties which will be animated.
 *  However, this class should not be instantiated directly.
 *  Instantiate one transition from Transitions folder.
 **/

class CAObject {
	
	public var target :Dynamic;// The object that is being animated (DisplayObjectContainer, TextField, Sound, or Function)
	public var prev :CAObject;// Previous caobject in the list
	public var next :CAObject;// Next caobject in the list
	
	// Properties to be animated:
	public var properties :Dynamic;
	public var fromValues :Dynamic;// initial values of the properties that are animated
	public var toValues :Dynamic;// final values of the properties that are animated
	
	// Parameters of the animation:
	public var fromTime :Float;// the starting time (ms)
	public var delay :Float;// s
	public var duration :Float;// s
	public var repeatCount :Int;
	public var startPointPassed :Bool;
	public var autoreverses :Bool;
	public var timingFunction :Dynamic;//Float -> Float -> Float -> Float -> Dynamic -> Float;
	public var constraintBounds :RCRect;// Used by kenburns and slide
	
	public var animationDidStart :Dynamic;
	public var animationDidStop :Dynamic;
	public var animationDidReversed :Dynamic;
	public var arguments :Array<Dynamic>;// A list of objects to be passed when the animation state changes
	public var pos :haxe.PosInfos;
	
	/**
	 *	object = DisplayObject
	 *	properties: x, y, width, height, scaleX, scaleY, ....
	 *	parameters: duration, transition, equation, onComplete, onCompleteParams
	 */
	public function new (	target :Dynamic,
							properties :Dynamic,
							?duration :Null<Float>,
							?delay :Null<Float>,
							?Eq :Dynamic,/*Float -> Float -> Float -> Float -> Dynamic -> Float,*/
							?pos :haxe.PosInfos)
	{
		
		this.target = target;
		this.properties = properties;
		this.repeatCount = 0;
		this.autoreverses = false;
		this.startPointPassed = false;
		this.fromTime = RCAnimation.timestamp();
		this.duration = (duration == null) ? RCAnimation.defaultDuration : ((duration <= 0) ? 0.001 : duration);
		this.delay = (delay == null || delay < 0) ? 0 : delay;
		// cpp does not work if you don't use "if else"
		if (Eq == null)
			this.timingFunction = RCAnimation.defaultTimingFunction;
		else
			this.timingFunction = Eq;
		this.pos = pos;
		
		// initial state of the object, and the state that should be animated to
		this.fromValues = {};
		this.toValues = {};
	}
	
	
	public function init () :Void { throw "CAObject should be extended, use a CATransition ("+pos+")"; }
	public function animate (time_diff:Float) :Void { throw "CAObject should be extended, use a CATransition ("+pos+")"; }
	
	
	/**
	 *	Creates starting and ending points for each parameter of the object to animate.
	 *  This is not called till is not added to RCAnimation
	 */
	public function initTime () :Void {
		this.fromTime = RCAnimation.timestamp();
		this.duration = this.duration*1000;// Convert duration from seconds to milliseconds
		this.delay = this.delay*1000;// Convert delay from seconds to milliseconds
	}
	
	
	public function start () :Void {
		startPointPassed = true;
		if (Reflect.isFunction( animationDidStart ))
		try{ Reflect.callMethod (null, animationDidStart, arguments); }catch(e:Dynamic){trace(e);}
			//try{ animationDidStart/*.apply (null,*/ (arguments); }catch(e:Dynamic){trace(e);}
	}
	
	public function stop () :Void {
		// TODO: .apply is not working on Mac and ios with NME
		if (Reflect.isFunction( animationDidStop )) {
			try {
				//animationDidStop/*.apply (null,*/ (arguments);
				Reflect.callMethod (null, animationDidStop, arguments);
			}
			catch(e:Dynamic){
				trace(e);
				trace(pos.className + " -> " + pos.methodName + " -> " + pos.lineNumber);
				var stack = haxe.CallStack.exceptionStack();
				trace(haxe.CallStack.toString ( stack ));
			}
		}
	}
	
	
	/**
	 *	Restarts the animation. Values are reversed if autoreverses is set to true
	 */
	public function repeat () :Void {
		
		fromTime = RCAnimation.timestamp();
		delay = 0;
		
		if (autoreverses) {
			var v = fromValues;
			fromValues = toValues;
			toValues = v;
		}
		
		repeatCount --;
		
		// Dispatch repeat event
		if (Reflect.isFunction( animationDidReversed ))
			Reflect.callMethod (null, animationDidReversed, arguments);
	}
	
	
	
	
	/**
	 *  @param time_diff - the remaining time
	 *  @param prop - the property that will be animated ( CAObject.fromValues )
	 */
	inline public function calculate (time_diff:Float, prop:String) :Float {
		/*
		* @param		t					Float		Current time (in frames or seconds)
	 	* @param		b					Float		Starting value
	 	* @param		c					Float		Change needed in value
	 	* @param		d					Float		Expected easing duration (in frames or seconds)
	 	* @return							Float		The correct value
		*/
		return  timingFunction (time_diff,
								Reflect.field (fromValues, prop),
								Reflect.field (toValues, prop) -
								Reflect.field (fromValues, prop),
								duration, null);
	}
	
	
	
	public function toString () :String {
		return "[CAObject: target="+target+
						", duration="+duration+
						", delay="+delay+
						", fromTime="+fromTime+
						", properties="+properties+
						", repeatCount="+repeatCount+"]";
	}
}
