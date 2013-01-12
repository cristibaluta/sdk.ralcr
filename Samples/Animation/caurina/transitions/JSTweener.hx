/*
 * Yuichi Tateno. <hotchpotch@N0!spam@gmail.com>
 * http://rails2u.com/
 *
 * Ported to haxe by Baluta Cristian
 * http://ralcr.com/caurina/
 * 
 * The MIT License
 * --------
 * Copyright (c) 2007 Yuichi Tateno.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
package caurina.transitions;

class JSTweener {
	
	static var looping = false;
	static var frameRate = 60;
	static var objects :Array<JSObject> = [];
	static var defaultOptions :Dynamic = {
		time: 1,
		transition: 'easeoutexpo',
		delay: 0,
		prefix: {},
		suffix: {},
		onStart: null,
		onStartParams: null,
		onUpdate: null,
		onUpdateParams: null,
		onComplete: null,
		onCompleteParams: null
	}
	static var inited = false;
	static var easingFunctionsLowerCase :Dynamic = {};
	
	static function init () {
		inited = true;
		Equations.init();
	}
	public static function registerTransition (key:String, func:Dynamic) :Void {
		Reflect.setField (easingFunctionsLowerCase, key, func);
	}
	
	static function toNumber (value/*, prefix, suffix*/) :Float {
		// for style
		//if (suffix == null) suffix = 'px';
		return Std.parseFloat (Std.string(value));
		/*return Std.string(value).match(/[0-9]/) ? Std.parseFloat (Std.string(value).replace(
														new RegExp(suffix + '$'), '').replace(
														new RegExp('^' + (prefix ? prefix : '')), '')) : 0;*/
	}
	
	
	
	public static function addTween (obj:Dynamic, options:Dynamic) {
		
		if (!inited) init();
		
		var o = new JSObject();
		o.target = obj;
		o.targetProperties = {};
		
		for (key in Reflect.fields (defaultOptions)) {
			Reflect.setField (o, key,
				Reflect.field (Reflect.hasField (options, key) ? options : defaultOptions, key));
			Reflect.deleteField (options, key);
		}

		if (Reflect.isFunction (o.transition)) {
			o.easing = o.transition;
		}
		else {
			o.easing = Reflect.field (easingFunctionsLowerCase, o.transition.toLowerCase());
		}
		
		for (key in Reflect.fields (options)) {
			
			if (Reflect.field (o.prefix, key) == null) Reflect.setField (o.prefix, key, '');
			if (Reflect.field (o.suffix, key) == null) Reflect.setField (o.suffix, key, '');
			
			var sB = toNumber (	Reflect.field (obj, key)/*,
											Reflect.field (o.prefix, key),
											Reflect.field (o.suffix, key)*/);
			Reflect.setField (o.targetProperties, key, {b: sB,
														c: Reflect.field (options, key) - sB}
							);
		}
		
		haxe.Timer.delay (function() { startAnimation (o); }, Math.round (o.delay * 1000));
	}
	static function startAnimation (o:JSObject) {
		
		o.startTime = Date.now().getTime();
		o.endTime = o.time * 1000 + o.startTime;
		
		if (Reflect.isFunction (o.onStart)) {
			if (o.onStartParams != null) {
				Reflect.callMethod (o, o.onStart, o.onStartParams);
			}
			else {
				o.onStart();
			}
		}

		objects.push (o);
		
		if (!o.looping) { 
			o.looping = true;
			eventLoop();
		}
	}
	
	
	
	static function eventLoop () {
		var now = Date.now().getTime();
		
		for (o in objects) {
			var t = now - o.startTime;
			var d = o.endTime - o.startTime;
			
			if (t >= d) {
				for (property in Reflect.fields (o.targetProperties)) {
					var tP = Reflect.field (o.targetProperties, property);
					try {
						var final_value = toNumber (Reflect.field (tP, "b")) + toNumber (Reflect.field (tP, "c"));
						Reflect.setField (o.target, property,
							Reflect.field (o.prefix, property) + final_value + Reflect.field (o.suffix, property));
					}
					catch (e:Dynamic) {}
				}
				objects.remove ( o );

				if (Reflect.isFunction (o.onUpdate)) {
					if (o.onUpdateParams != null) {
						Reflect.callMethod (o, o.onUpdate, o.onUpdateParams);
					}
					else {
						o.onUpdate();
					}
				}

				if (Reflect.isFunction (o.onComplete)) {
					if (o.onCompleteParams != null) {
						Reflect.callMethod (o, o.onComplete, o.onCompleteParams);
					}
					else {
						o.onComplete();
					}
				}
			}
			else {
				for (property in Reflect.fields (o.targetProperties)) {
					var tP = Reflect.field (o.targetProperties, property);
					var val = o.easing (t, tP.b, tP.c, d, null/*p_params is used only in flash, in some cases*/);
					try {
						// FIXME:For IE. A Few times IE (style.width||style.height) = value is throw error...
						Reflect.setField (o.target, property,
							Reflect.field (o.prefix, property) + val + Reflect.field (o.suffix, property));
					}
					catch (e:Dynamic) {}
				}

				if (Reflect.isFunction (o.onUpdate)) {
					if (o.onUpdateParams != null) {
						Reflect.callMethod (o, o.onUpdate, o.onUpdateParams);
						//o.onUpdate.apply(o, o.onUpdateParams);
					}
					else {
						o.onUpdate();
					}
				}
			}
		}

		if (objects.length > 0) {
			haxe.Timer.delay (eventLoop, Math.round (1000/frameRate));
			//setTimeout(function(){ eventLoop(); }, 1000/frameRate);
		}
		else {
			looping = false;
		}
	}
}


class JSObject {
	
	public var target :Dynamic;
	public var targetProperties :Dynamic;
	
	public var time :Float;
	public var startTime :Float;
	public var endTime :Float;
	public var delay :Float;
	
	public var transition :Dynamic;// can be string or function
	public var easing :Dynamic;// transition function
	public var prefix :String;
	public var suffix :String;
	public var looping :Bool;
	
	public var onStart :Dynamic;
	public var onStartParams :Dynamic;
	public var onUpdate :Dynamic;
	public var onUpdateParams :Dynamic;
	public var onComplete :Dynamic;
	public var onCompleteParams :Dynamic;
	
	public function new(){}
}


class Utils {
	static function bezier2 (t, p0, p1, p2) {
		 return (1-t) * (1-t) * p0 + 2 * t * (1-t) * p1 + t * t * p2;
	}
	static function bezier3 (t, p0, p1, p2, p3) {
		 return Math.pow(1-t, 3) * p0 + 3 * t * Math.pow(1-t, 2) * p1 + 3 * t * t * (1-t) * p2 + t * t * t * p3;
	}
/*	static function allSetStyleProperties (element) {
		var css;
		// document.defaultView == Window.self ?
		if (Window.self && Window.self.getComputedStyle) {
			css = Window.self.getComputedStyle (element, null);
		}
		else {
			css = element.currentStyle;
		}
		for (key in Reflect.fields (css)) {
			//if (!key.match(/^\d+$/)) {
			// 	/^\d+$/  = All-digit
			
			// ^ = Get a match at the beginning of a string
			// \d = Find any single digit
			// + = Finds one or more occurrences of the regular expression
			// $ = Get a match at the end of a string
			if (Std.parseFloat (Reflect.field (css, key)) == null) {
				try {
					Reflect.setField (element.style, key, Reflect.field (css, key));
				}
				catch (e:Dynamic) {};
			}
		}
	}*/
}
