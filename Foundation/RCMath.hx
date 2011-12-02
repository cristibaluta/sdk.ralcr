
class RCMath {
	
	
	/**
	 *	
	 */
	inline public static function angleOnCircle (i:Int, nrOfItems:Int) :Float {
		return i * ((Math.PI * 2) / nrOfItems);
	}
	
	/**
	 *  Arrange the object on the ellipse depending by the angle
	 */
	inline public static function positionOnEllipse (angle:Float, radiusX:Float, radiusY:Float) :RCPosition {
		return new RCPosition (	Math.cos (angle) * radiusX,
								Math.sin (angle) * radiusY
								);
	}
	
	inline public static function radians (deg:Float) :Float {
		return deg * Math.PI / 180;
	}
	inline public static function degrees (rad:Float) :Float {
		return rad * 180 / Math.PI;
	}
	
	
	inline public static function distanceBetween2Points (p1:RCPosition, p2:RCPosition) :Float {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		return Math.sqrt (dx*dx + dy*dy);
	}
	
	
	
	inline public function ponderatedSum (a:Array<Float>, p:Array<Float>) :Float {
		var f1 :Float = 0, f2 :Float = 0;
		for (i in 0...a.length) {
			f1 += a[i] * p[i];
			f2 += p[i];
		}
		return f1/f2;
	}
	
	inline public function sum (a:Array<Float>) :Float {
		var f1 :Float = 0;
		for (i in a) {
			f1 += i;
		}
		return f1;
	}
}
