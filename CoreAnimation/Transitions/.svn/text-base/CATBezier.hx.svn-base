//
//  KenBurns
//
//  Created by Baluta Cristian on 2009-05-15.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.geom.Point;


class CATBezier extends CAObject, implements CATransitionInterface {
	
	
	inline static var _RAD2DEG = 180 / Math.PI; //precalculate for speed
	
	var _orientData :Array<Dynamic>;
	var _orient :Bool;
	/** @private used for orientToBezier projections **/
	var _future :Dynamic;
	var _beziers :Dynamic;
	public var orientToBezier :Bool;
	
	
	override public function init () :Void {
		
		var points :Array<Dynamic> = Reflect.field (properties, "points");
		var _orientToBezier :Bool = Reflect.field (properties, "orientToBezier");
		if (orientToBezier == null)
			orientToBezier = _orientToBezier;
			
		if (orientToBezier) {
			_orientData = [["x", "y", "rotation", 0, 0.01]];
			_orient = true;
		}
		
		var props = {};
		
		// Iterate over bezier points
		for (point in points) {
			
			// Iterate over point properties: x, y, rotation
			for (p in Reflect.fields(point)) {
				if (Reflect.field (props, p) == null) {
					var data = new Array<Dynamic>();
						data.push ( Reflect.field (target, p) );
					Reflect.setField (props, p, data);
				}
				if (typeof(point[p]) == "number") {
					props[p].push(beziers[i][p]);
				} else {
					props[p].push(tween.target[p] + Number(beziers[i][p])); //relative value
				}
			}
		}
		
		_beziers = parseBeziers (props, through);
	}
	
	/**
	 * Helper method for translating control points into bezier information.
	 * 
	 * @param props Object containing a property corresponding to each one you'd like bezier paths for. Each property's value should be a single Array with the numeric point values (i.e. <code>props.x = [12,50,80]</code> and <code>props.y = [50,97,158]</code>). 
	 * @param through If you want the paths drawn THROUGH the supplied control points, set this to true.
	 * @return A new object with an Array of values for each property. The first element in the Array is the start value, the second is the control point, and the 3rd is the end value. (i.e. <code>returnObject.x = [[12, 32, 50}, [50, 65, 80]]</code>)
	 */
	public function parseBeziers (props:Dynamic, through:Bool=false) :Dynamic {
		
		var i:Int, a:Array, b:Dynamic, p:String;
		var all = {};
		
		if (through) {
			for (p in props) {
				a = props[p];
				all[p] = b = [];
				if (a.length > 2) {
					b[b.length] = [a[0], a[1] - ((a[2] - a[0]) / 4), a[1]];
					for (i = 1; i < a.length - 1; i += 1) {
						b[b.length] = [a[i], a[i] + (a[i] - b[i - 1][1]), a[i + 1]];
					}
				} else {
					b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
				}
			}
		}
		else {
			for (p in props) {
				a = props[p];
				all[p] = b = [];
				if (a.length > 3) {
					b[b.length] = [a[0], a[1], (a[1] + a[2]) / 2];
					for (i = 2; i < a.length - 2; i += 1) {
						b[b.length] = [b[i - 2][2], a[i], (a[i] + a[i + 1]) / 2];
					}
					b[b.length] = [b[b.length - 1][2], a[a.length - 2], a[a.length - 1]];
				} else if (a.length == 3) {
					b[b.length] = [a[0], a[1], a[2]];
				} else if (a.length == 2) {
					b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
				}
			}
		}
		return all;
	}
	
	
	public function killProps (lookup:Dynamic) :Void {
		for (var p:String in _beziers) {
			if (p in lookup) {
				delete _beziers[p];
			}
		}
		//super.killProps(lookup);
	}	
	
	
	
	
	
	override public function animate (time_diff:Float) :Void {
		for (prop in Reflect.fields (toValues)) {
			
			var value = calculate (time_diff, prop);
			setChangeFactor ( value );
		}
	}
	
	function setChangeFactor (n:Float) :Void {
		var i:int, p:String, b:Object, t:Number, segments:int, val:Number;
		_changeFactor = n;
		if (n == 1) { //to make sure the end values are EXACTLY what they need to be.
			for (p in _beziers) {
				i = _beziers[p].length - 1;
				_target[p] = _beziers[p][i][2];
			}
		} else {
			for (p in _beziers) {
				segments = _beziers[p].length;
				if (n < 0) {
					i = 0;
				} else if (n >= 1) {
					i = segments - 1;
				} else {
					i = (segments * n) >> 0;
				}
				t = (n - (i * (1 / segments))) * segments;
				b = _beziers[p][i];
				if (this.round) {
					val = b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0]));
					if (val > 0) {
						_target[p] = (val + 0.5) >> 0; //4 times as fast as Math.round()
					} else {
						_target[p] = (val - 0.5) >> 0;
					}
				} else {
					_target[p] = b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0]));
				}
			}
		}
		
		if (_orient) {
			i = _orientData.length;
			var curVals:Object = {}, dx:Float, dy:Float, cotb:Array, toAdd:Float;
			while (i--) {
				cotb = _orientData[i]; //current orientToBezier Array
				curVals[cotb[0]] = _target[cotb[0]];
				curVals[cotb[1]] = _target[cotb[1]];
			}
			
			var oldTarget = target, oldRound:Bool = this.round;
			_target = _future;
			this.round = false;
			_orient = false;
			i = _orientData.length;
			
			while (i--) {
				cotb = _orientData[i]; //current orientToBezier Array
				this.changeFactor = n + (cotb[4] || 0.01);
				toAdd = cotb[3] || 0;
				dx = _future[cotb[0]] - curVals[cotb[0]];
				dy = _future[cotb[1]] - curVals[cotb[1]];
				oldTarget[cotb[2]] = Math.atan2(dy, dx) * _RAD2DEG + toAdd;
			}
			
			_target = oldTarget;
			this.round = oldRound;
			_orient = true;
		}
	}
}
