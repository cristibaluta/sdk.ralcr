//
//  Fugu.hx
//	A static class that operates on RCView
//
//  Created by Baluta Cristian on 2008-10-13.
//  Copyright (c) 2008 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class Fugu {
	
	/**
	 * Destroy and/or remove from DisplayObjectList a list of objects
	 */
	public static function safeDestroy (obj:Dynamic, ?destroy:Null<Bool>=true, ?pos:haxe.PosInfos) :Bool {
		
		if (obj == null) return false;
		
		var objs :Array<Dynamic> = Std.is (obj, Array) ? obj : [obj];
		
		for (o in objs) {
			if (o == null)	continue;
			if (destroy) {
				try {
					o.destroy();
				}
				catch (e:Dynamic) {
					trace ("[Error when destroying object: "+o+", called from "+Std.string(pos)+"]");
					trace ( stack() );
				}
			}
			if (Std.is (o, RCView)) {
				cast (o, RCView).removeFromSuperView();// This cast will help DCE to compile removeFromSuperView method
			}
			else {
				// This must be a native flash display object
				var parent = null;
				try { parent = o.parent; } catch (e:Dynamic) { null; }
				if (parent != null) if (parent.contains ( o )) parent.removeChild ( o );
			}
		}
		return true;
	}
	
	public static function safeRemove (obj:Dynamic) :Bool {
		return safeDestroy (obj, false);
	}
	
	public static function safeAdd (target:RCView, obj:Dynamic) :Bool {
		
		if ( target == null || obj == null ) return false;
		
		var objs :Array<Dynamic> = Std.is (obj, Array) ? obj : [obj];
		
		for (o in objs) if (o != null) target.addChild ( o );
		
		return true;
	}
	
	
	
	
	/**
	 * Draws a glow on a target object
	 */
	public static function glow (	target:RCView,
									color:Null<Int>,
									alpha:Null<Float>,
									blur:Null<Float>,
									strength:Float=0.6)
	{
		#if (flash || nme)
			var filters :Array<flash.filters.BitmapFilter> = [];
			var filter = new flash.filters.GlowFilter (color, alpha, blur, blur, strength, 3, false, false);
			filters.push ( filter );
			target.layer.filters = blur==null ? null : filters;
		#end
	}
	
	
	/**
	 * Changes the color of the targeted object
	 */
	public static function color (target:RCView, color:Int) :Void {
		#if (flash || nme)
		var red   = color >> 16 & 0xFF;
		var green = color >> 8 & 0xFF;
		var blue  = color & 0xFF;
		target.layer.transform.colorTransform = new flash.geom.ColorTransform (0, 0, 0, 1, red, green, blue, 1);
		#end
	}
	
	public static function resetColor (target:RCView) :Void {
		#if (flash || nme)
		target.layer.transform.colorTransform = new flash.geom.ColorTransform (1,	1,	1,	1, 0,	0,	0,	0);
		#end
	}
	
	
	public static function brightness (target:RCView, brightness:Int) :Void {
		#if flash
        var m =  [	1,0,0,0,brightness,
					0,1,0,0,brightness,
					0,0,1,0,brightness,
					0,0,0,1,0,
					0,0,0,0,1];
		
		var matrix :Array<Dynamic> = [];
		var col :Array<Dynamic> = [];
		
		for (i in 0...5) {
			for (j in 0...5) {
				col[j] = m[j + i * 5];
			}
			for (j in 0...5) {
				var val = 0.0;
				for (k in 0...5) {
					val += m[j + k * 5] * col[k];
				}
				matrix[j + i * 5] = val;
			}
		}
		
		target.layer.filters = [new flash.filters.ColorMatrixFilter ( matrix )];
		#end
	}
	
	
	/**
	 *	Align an object in the specified width and height, with a margin of x and y px
	 *	alignment string is of form: B,M or 20,20 or T,20
	 */
	public static function align (	obj:RCView, alignment:String,
									constraint_w:Float, constraint_h:Float,
									?obj_w:Null<Float>, ?obj_h:Null<Float>,
									?delay_x:Int=0, ?delay_y:Int=0)
	{
		
		if (obj == null) return;
		
		var arr = alignment.toLowerCase().split(",");
		if (obj_w == null) obj_w = obj.width;
		if (obj_h == null) obj_h = obj.height;
		
		obj.x = switch ( arr[0] ) {
			case "l": delay_x;
			case "m": Math.round ((constraint_w - obj_w) / 2);
			case "r": Math.round ( constraint_w - obj_w - delay_x);
			default : Std.parseInt ( arr[0] );
		}
		obj.y = switch ( arr[1] ) {
			case "t": delay_y;
			case "m": Math.round ((constraint_h - obj_h) / 2);
			case "b": Math.round ( constraint_h - obj_h - delay_y);
			default : Std.parseInt ( arr[1] );
		}
	}
	
	inline public static function stack () :Void {
		var stack = haxe.Stack.exceptionStack();
		trace ( haxe.Stack.toString ( stack ) );
	}
}
