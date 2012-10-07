//a port of Processing's PVector class

class RCVector {
	
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	public function new (x:Float=0, y:Float=0, z:Float=0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	public function copyXYZ (x:Float, y:Float, z:Float = 0) :Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	//equivalent of set(PVector v)
	public function copyVector (v:RCVector) :Void {
		x = v.x;
		y = v.y;
		z = v.z;
	}
	//equivalnet of set(float[] source)
	public function copyArray (source:Array<Float>) :Void {
		
		if (source.length >= 2) {
			x = source[0];
			y = source[1];
		}
		if (source.length >= 3) {
			z = source[2];
		}
	}
	
	public static function lerp (from:RCVector, to:RCVector, amount:Float) :RCVector {
		return new RCVector();//RCVector.add (from, RCVector.mult (RCVector.sub (to, from), amount));
	}
	
	inline public function mag () :Float {
		return Math.sqrt (x*x + y*y + z*z);
	}
	public function addVector (v:RCVector) :Void {
		x += v.x;
		y += v.y;
		z += v.z;
	}
	public function addXYZ (x:Float, y:Float, z:Float) :Void {
		this.x += x;
		this.y += y;
		this.z += z;
	}
	static public function addVectors (v1:RCVector, v2:RCVector, ?target:RCVector) :RCVector {
		if (target == null)
			return new RCVector (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
			target.copyXYZ (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
			return target;
	}
	public function subVec (v:RCVector) :Void {
		x -= v.x;
		y -= v.y;
		z -= v.z;
	}
	public function subXYZ (x:Float, y:Float, z:Float) :Void {
		this.x -= x;
		this.y -= y;
		this.z -= z;
	}
	static public function subTo (v1:RCVector, v2:RCVector, ?target:RCVector) :RCVector {
		if (target == null)
			return new RCVector (v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
			target.copyXYZ (v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
			return target;
	}
	public function mult (n:Float) :Void {
		x *= n;
		y *= n;
		z *= n;
	}
	static public function multTo (v:RCVector, n:Float, ?target:RCVector) :RCVector {
		if (target == null)
			return new RCVector (v.x * n,v.y * n,v.z * n);
			target.copyXYZ (v.x*n, v.y*n, v.z*n);
			return target;
	}
	public function multVec (v:RCVector) :Void {
		x *= v.x;
		y *= v.y;
		z *= v.z;
	}
	static public function multVecTo (v1:RCVector, v2:RCVector, ?target:RCVector) :RCVector {
		if (target == null)
			return target = new RCVector(v1.x * v2.x,v1.y * v2.y,v1.z * v2.z);
			target.copyXYZ (v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);
			return target;
	}
	public function div (n:Float) :Void {
		x /= n;
		y /= n;
		z /= n;
	}
	static public function div_ (v:RCVector, n:Float) :RCVector {
		return divTo (v, n, null);
	}
	static public function divTo (v:RCVector, n:Float, ?target:RCVector) :RCVector {
		if (target == null)
			return new RCVector (v.x / n, v.y / n, v.z / n);
			target.copyXYZ (v.x / n, v.y / n, v.z / n);
			return target;
	}
	public function divVec (v:RCVector) :Void {
		x /= v.x;
		y /= v.y;
		z /= v.z;
	}
	//divide RCVectortor
	//divide vector to target(3rd) vector
	static public function divVecTo (v1:RCVector, v2:RCVector, ?target:RCVector) :RCVector {
		if (target == null)
			return new RCVector (v1.x / v2.x,v1.y / v2.y,v1.z / v2.z);
			target.copyXYZ (v1.x/v2.x, v1.y/v2.y, v1.z/v2.z);
			return target;
	}
	public function distanceTo (v:RCVector) :Float {
		var dx = x - v.x;
		var dy = y - v.y;
		var dz = z - v.z;
		return Math.sqrt (dx*dx + dy*dy + dz*dz);
	}
	
	static public function distanceBetween (v1:RCVector, v2:RCVector) :Float {
		var dx = v1.x - v2.x;
		var dy = v1.y - v2.y;
		var dz = v1.z - v2.z;
		return Math.sqrt (dx*dx + dy*dy + dz*dz);
	}
	public function dotVec (v:RCVector) :Float {
		return x*v.x + y*v.y + z*v.z;
	}
	public function dot (x:Float, y:Float, z:Float) :Float {
		return this.x*x + this.y*y + this.z*z;
	}
	static public function dotVec_ (v1:RCVector, v2:RCVector) :Float {
		return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
	}
	public function cross (v:RCVector) :RCVector {
		return crossTo (v, null);
	}
	
	public function crossTo (v:RCVector, ?target:RCVector) :RCVector {
		
		var crossX = y * v.z - v.y * z;
		var crossY = z * v.x - v.z * x;
		var crossZ = x * v.y - v.x * y;
		
		if (target == null)
			return new RCVector (crossX, crossY, crossZ);
			target.copyXYZ (crossX, crossY, crossZ);
			return target;
	}


	static public function cross_ (v1:RCVector, v2:RCVector, ?target:RCVector) :RCVector {
		
		var crossX = v1.y * v2.z - v2.y * v1.z;
		var crossY = v1.z * v2.x - v2.z * v1.x;
		var crossZ = v1.x * v2.y - v2.x * v1.y;
		
		if (target == null)
			return new RCVector (crossX, crossY, crossZ);
			target.copyXYZ (crossX, crossY, crossZ);
			return target;
	}
	public function normalize() :Void {
		
		var m = mag();
		if (m != 0 && m != 1) div ( m );
	}
	public function normalizeTo (?target:RCVector) :RCVector {
		
		if (target == null)
			target = new RCVector (0, 0);
		
		var m = mag();
		if (m > 0)
			target.copyXYZ (x/m, y/m, z/m);
		else
			target.copyXYZ (x, y, z);
		
		return target;
	}
	public function limit (max:Float) :Void {
		
		if (mag() > max) {
			normalize();
			mult ( max );
		}
	}
	inline public function heading2D() :Float {
		return Math.atan2 (-y, x) * -1;
	}
	static public function angleBetween (v1:RCVector, v2:RCVector) :Float {
		
		var dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
		var v1mag = Math.sqrt (v1.x * v1.x + v1.y * v1.y + v1.z * v1.z);
		var v2mag = Math.sqrt (v2.x * v2.x + v2.y * v2.y + v2.z * v2.z);
		
		// This should be a number between -1 and 1, since it's "normalized"
		var amt = dot / (v1mag * v2mag);
		// But if it's not due to rounding error, then we need to fix it
		// http://code.google.com/p/processing/issues/detail?id=340
		// Otherwise if outside the range, acos() will return NaN
		// http://www.cppreference.com/wiki/c/math/acos
		if (amt <= -1) {
			return Math.PI;
		}
		else if (amt >= 1) {
			// http://code.google.com/p/processing/issues/detail?id=435
			return 0;
		}
		return Math.acos ( amt );
	}

	
	
	public function equals (obj:RCVector) :Bool {
		return x == obj.x && y == obj.y && z == obj.z;
	}
	public static function random (from:Float, to:Float) :Float {
		if (from >= to) return from;
		var diff = to - from;
		return (Math.random()*diff) + from;
	}
	
	/*
	 * From Quasimondo Libs: http://code.google.com/p/quasimondolibs/
	 */
	public function squaredDistanceToVector (v:RCVector) : Float {
		var dx = x - v.x;
		var dy = y - v.y;
		return dx * dx + dy * dy;
	}
	public function distanceToVector (v:RCVector) : Float {
		return Math.sqrt ( squaredDistanceToVector ( v));
	}
	public function distanceToLine (v1:RCVector, v2:RCVector) :Float {
		if (v1.equals(v2))
			return distanceToVector( v1 );
			return getArea( v1,v2 ) / v1.distanceToVector( v2 ) * 2;
	}
    public function getArea (v1:RCVector, v2:RCVector) :Float {
    	return Math.abs ( 0.5 * ( v1.x * v2.y + v2.x * y + x * v1.y - v2.x * v1.y - x * v2.y - v1.x * y ));
    }
	
	
	
	public function clone () :RCVector {
		return new RCVector (x, y, z);
	}
	public function cloneToArray (?target:Array<Float>) :Array<Float> {
		
		if (target == null)
			return [ x, y, z ];
		
		if (target.length >= 2) {
			target[0] = x;
			target[1] = y;
		}
		if (target.length >= 3) {
			target[2] = z;
		}
		return target;
	}
	
	
	
	public function toString () :String {
		return "[RCVector x:" + x + ", y:" + y + ", z:" + z + "]";
	}
	public function toArray (?array:Array<Float>) :Array<Float> {
		if (array == null)
			array = [];
			array[0] = x;
			array[1] = y;
			array[2] = z;
		return array;
	}
	
}
