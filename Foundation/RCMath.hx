
class RCMath {
	
	
	/**
	 *	Return the angle for the item number i if it were on a circle with nrOfItems
	 */
	public static function angleOnCircle (i:Int, nrOfItems:Int) :Float {
		return i * ((Math.PI * 2) / nrOfItems);
	}
	
	/**
	 *  The point on an ellipse of a given angle
	 */
	public static function positionOnEllipse (angle:Float, radiusX:Float, radiusY:Float) :RCPoint {
		return new RCPoint (	Math.cos (angle) * radiusX,
								Math.sin (angle) * radiusY
								);
	}
	
	public static function radians (deg:Float) :Float {
		return deg * Math.PI / 180;
	}
	public static function degrees (rad:Float) :Float {
		return rad * 180 / Math.PI;
	}
	
	
	public static function distanceBetween2Points (p1:RCPoint, p2:RCPoint) :Float {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		return Math.sqrt (dx*dx + dy*dy);
	}
	
	
	
	public static function ponderatedSum (a:Array<Float>, p:Array<Float>) :Float {
		var f1 :Float = 0, f2 :Float = 0;
		for (i in 0...a.length) {
			f1 += a[i] * p[i];
			f2 += p[i];
		}
		return f1/f2;
	}
	
	public static function sum (a:Array<Float>) :Float {
		var f1 :Float = 0;
		for (i in a) {
			f1 += i;
		}
		return f1;
	}
	
	
}
