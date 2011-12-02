/*
# ***** BEGIN LICENSE BLOCK *****
Copyright the original author or authors.
Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.mozilla.org/MPL/MPL-1.1.html
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# ***** END LICENSE BLOCK *****
*/


/*
****************************
* http://www.rubenswieringa.com/blog/distortimage
* Ported to haxe by Băluță Cristian ( http://ralcr.com/ports/distortimage )
*/
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.geom.Point;


class DistortImage {
	
	inline static var SMOOTH :Bool = true;
	
	// -- texture to distort
	var texture :BitmapData;
	
	// -- container Sprite or Shape : the display object containing the distorted picture drawn via graphics.
	var _container :Dynamic;
	
	var _w :Float;
	var _h :Float;
	var _xMin :Float;
	var _xMax :Float; 
	var _yMin :Float;
	var _yMax :Float;
	// -- picture segmentation properties
	var _hseg :Int;
	var _vseg :Int;
	var _hsLen :Float;
	var _vsLen :Float;
	var offsetRect :Rectangle;
	var points :Array<SandyPoint>;
	var _tri :Array<Triangle>;
	
	/*
	* 
	* @param vseg Number : the vertical precision
	* @param hseg Number : the horizontal precision
	* @param offsetRect Rectangle : optional, the real bounds to use.
	* @throws: An error if target property isn't a BitmapData or a DisplayObject
	*/
	public function new (	target_container:DisplayObject, source:DisplayObject,
							?vseg:Int=3, ?hseg:Int=3, ?offsetRect:Rectangle) {
		
		if (Std.is (target_container, Shape) || Std.is (target_container, Sprite)) {
			_container = target_container;
		}
		else {
			throw ('container must be flash.display.Shape or flash.display.Sprite');
		}
		
		if (Std.is (source, BitmapData)) {
			texture = cast (source, BitmapData);
			_w = texture.width;
			_h = texture.height;				
		}
		else if (Std.is (source, DisplayObject)) {
			renderVector (source, offsetRect);
		}
		else {
			throw ('target must be flash.display.BitmapData or flash.display.DisplayObject');
		}
		_vseg = vseg;
		_hseg = hseg;
		
		// --
		__init();
	}
	
	
	public function render() :Void {
		__render();
	}	
	
	
	/**
	 * Distorts the provided BitmapData according to the provided Point instances
	 * 
	 * @param	tl			Point specifying the coordinates of the top-left corner of the distortion
	 * @param	tr			Point specifying the coordinates of the top-right corner of the distortion
	 * @param	br			Point specifying the coordinates of the bottom-right corner of the distortion
	 * @param	bl			Point specifying the coordinates of the bottom-left corner of the distortion
	 * 
	 */
	public function setTransform (tl:Point, tr:Point, br:Point, bl:Point) :Void {
		
		var dx30 = bl.x - tl.x;
		var dy30 = bl.y - tl.y;
		var dx21 = br.x - tr.x;
		var dy21 = br.y - tr.y;
		var l = points.length;
		
		while (--l> -1) {
			var point = points[ l ];
			var gx = ( point.x - _xMin ) / _w;
			var gy = ( point.y - _yMin ) / _h;
			var bx = tl.x + gy * ( dx30 );
			var by = tl.y + gy * ( dy30 );
			point.sx = bx + gx * ( ( tr.x + gy * ( dx21 ) ) - bx );
			point.sy = by + gx * ( ( tr.y + gy * ( dy21 ) ) - by );
		}
		
		__render();
	}
	
	
	
	function renderVector (source:DisplayObject, offsetRect:Rectangle) :Void {
		
		if (offsetRect != null) {
			texture = new BitmapData (	Math.round (offsetRect.width),
										Math.round (offsetRect.height), true, 0x000000ff);
		}
		else {
			texture = new BitmapData (	Math.round (source.width),
										Math.round (source.height), true, 0x000000ff);
			offsetRect = new Rectangle (0, 0, texture.width, texture.height);
		}
		
		var m = new Matrix();
			m.translate (offsetRect.x * -1, offsetRect.y * -1);
		texture.draw (source, m);
		_container.transform.matrix.translate (source.transform.matrix.tx, source.transform.matrix.ty);
		_w = offsetRect.width;
		_h = offsetRect.height;
	}
	
	
	/**
	 * Tesselate the area into triangles.
	 */
	function __init() :Void {
		points = new Array<SandyPoint>();
		_tri = new Array<Triangle>();
		
		var ix:Int, iy:Int;
		var x:Float, y:Float;
		var p0:SandyPoint, p1:SandyPoint, p2:SandyPoint;
		
		
		var w2 = _w / 2;
		var h2 = _h / 2;
		_xMin = _yMin = 0;
		_xMax = _w;
		_yMax = _h;
		_hsLen = _w / ( _hseg + 1 );
		_vsLen = _h / ( _vseg + 1 );
		
		// -- we create the points
		for (ix in 0...(_hseg + 2)) {
			for (iy in 0...(_vseg + 2)) {
				
				x = ix * _hsLen;
				y = iy * _vsLen;
				points.push (new SandyPoint (x, y, x, y));
			}
		}
		
		// -- we create the triangles
		for (ix in 0...(_vseg + 1)) {
			for (iy in 0...(_hseg + 1)) {
				
				p0 = points[ iy + ix * ( _hseg + 2 ) ];
				p1 = points[ iy + ix * ( _hseg + 2 ) + 1 ];
				p2 = points[ iy + ( ix + 1 ) * ( _hseg + 2 ) ];
				__addTriangle (p0, p1, p2);
				// --
				p0 = points[ iy + ( ix + 1 ) * ( _vseg + 2 ) + 1 ];
				p1 = points[ iy + ( ix + 1 ) * ( _vseg + 2 ) ];
				p2 = points[ iy + ix * ( _vseg + 2 ) + 1 ];
				__addTriangle (p0, p1, p2);
			}
		}			
	}
	
	function __addTriangle (p0:SandyPoint, p1:SandyPoint, p2:SandyPoint) :Void {
		var u0:Float, v0:Float, u1:Float, v1:Float, u2:Float, v2:Float;
		var tMat = new Matrix();
		// --		
		u0 = p0.x; v0 = p0.y;
		u1 = p1.x; v1 = p1.y;
		u2 = p2.x; v2 = p2.y;
		tMat.tx = -v0*(_w / (v1 - v0));
		tMat.ty = -u0*(_h / (u2 - u0));
		tMat.a = tMat.d = 0;
		tMat.b = _h / (u2 - u0);
		tMat.c = _w / (v1 - v0);
		// --
		_tri.push ( new Triangle( p0, p1, p2, tMat ) );
	}
	
	
	/**
	 * Distorts the provided BitmapData and draws it onto the provided Graphics.
	 */
	function __render() :Void {
		
		var p0:SandyPoint, p1:SandyPoint, p2:SandyPoint;
		var x0:Float, y0:Float;
		var ih:Float = 1/_h, iw:Float = 1/_w;
		var c = _container;
			c.graphics.clear();
		var a:Triangle;
		var sM = new Matrix(), tM = new Matrix();
		
		//--
		var l = _tri.length;
		while ( --l > -1 ) {
			a 	= _tri[ l ];
			p0 	= a.p0;
			p1 	= a.p1;
			p2 	= a.p2;
			tM = a.tMat;
			// --
			sM.a = ( p1.sx - ( x0 = p0.sx ) ) * iw;
			sM.b = ( p1.sy - ( y0 = p0.sy ) ) * iw;
			sM.c = ( p2.sx - x0 ) * ih;
			sM.d = ( p2.sy - y0 ) * ih;
			sM.tx = x0;
			sM.ty = y0;
			// --
			sM = __concat( sM, tM );
			
			c.graphics.beginBitmapFill ( texture, sM, false, SMOOTH );
			c.graphics.moveTo ( x0, y0 );
			c.graphics.lineTo ( p1.sx, p1.sy );
			c.graphics.lineTo ( p2.sx, p2.sy );
			c.graphics.endFill();
		}
	}
	
	inline function __concat ( m1:Matrix, m2:Matrix ) :Matrix {
		//Relies on the original triangles being right angled with p0 being the right angle. 
		//Therefore a = d = zero (before and after invert)
		var mat = new Matrix();
			mat.a  = m1.c * m2.b;
			mat.b  = m1.d * m2.b;
			mat.c  = m1.a * m2.c;
			mat.d  = m1.b * m2.c;
			mat.tx = m1.a * m2.tx + m1.c * m2.ty + m1.tx;
			mat.ty = m1.b * m2.tx + m1.d * m2.ty + m1.ty;
		
		return mat;
	}
}



private class SandyPoint extends Point {
		
	public var sx :Float;
	public var sy :Float;
		
	public function new (x:Float, y:Float, sx:Float, sy:Float) {
		super ( x, y );
		this.sx = sx;
		this.sy = sy;
	}
}



private class Triangle {
	
	public var p0 :SandyPoint;
	public var p1 :SandyPoint;
	public var p2 :SandyPoint;
	public var tMat :Matrix;
	
	public function new (p0:SandyPoint, p1:SandyPoint, p2:SandyPoint, tMat:Matrix) {
		this.p0 = p0;
		this.p1 = p1;
		this.p2 = p2;
		this.tMat = tMat;			
	}
}