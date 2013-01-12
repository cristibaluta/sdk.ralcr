/**
 * CollisionDetection
 *
 * @author		scratchbrain
 * @version		1.0.0
 * @update      2008/07/08
 * @web site    http://www.scratchbrain.net/
 * @blog        http://www.scratchbrain.net/blog/ver2/
 *
 * Licensed under the MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#if flash
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;


class CollisionDetection {
	
	
	public static function check (p_obj1:DisplayObject, p_obj2:DisplayObject) :Rectangle {
		
		var bounds1 :Rectangle = p_obj1.getBounds ( p_obj1.root );
		var bounds2 :Rectangle = p_obj2.getBounds ( p_obj2.root );
		
		
		if (((bounds1.right < bounds2.left) || 
			(bounds2.right < bounds1.left)) || 
			((bounds1.bottom < bounds2.top) || 
			(bounds2.bottom < bounds1.top)))
		{
			return null;
		}
		
		
		var bounds = new Rectangle();
			bounds.left = Math.max (bounds1.left, bounds2.left);
			bounds.right= Math.min (bounds1.right, bounds2.right);
			bounds.top = Math.max (bounds1.top, bounds2.top);
			bounds.bottom = Math.min (bounds1.bottom, bounds2.bottom);
		
		
		var w = bounds.right - bounds.left;
		var h = bounds.bottom - bounds.top;

		// 『ArgumentError: Error #2015: BitmapData
		if (w < 1 || h < 1)
			return null;
		

		// BitmapData
		var bitmapData = new BitmapData (Math.round (w), Math.round (h), false);
		
		var matrix :Matrix = p_obj1.transform.concatenatedMatrix;
			matrix.tx -= bounds.left;
			matrix.ty -= bounds.top;
		bitmapData.draw (p_obj1, matrix, new ColorTransform (1,1,1,1,255,-255,-255,255));
		
			matrix = p_obj2.transform.concatenatedMatrix;
			matrix.tx -= bounds.left;
			matrix.ty -= bounds.top;
		bitmapData.draw (p_obj2, matrix, new ColorTransform (1,1,1,1,255,255,255,255), BlendMode.DIFFERENCE);
	
		// 0xFF00FFFF
		var intersection :Rectangle = bitmapData.getColorBoundsRect (0xFFFFFFFF,0xFF00FFFF);
		
		//『ArgumentError: Error #2015: BitmapData が無効です。』予防
		/*try{
			bitmapData.dispose();
		}catch(e:Error){}*/
		
		if (intersection.width == 0) return null;
			intersection.x += bounds.left;
			intersection.y += bounds.top;
		
		return intersection;
	}
}
#end