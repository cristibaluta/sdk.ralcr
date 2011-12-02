//
//  Fugu it's a static class that operates on DisplayObjectContainers
//
//  Created by Baluta Cristian on 2008-10-13.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.display.DisplayObjectContainer;


class Fugu {
	
	/**
	 * Destroy and/or remove from DisplayObjectList a list of objects
	 */
	public static function safeDestroy (obj:Dynamic, ?destroy:Null<Bool>, ?pos:haxe.PosInfos) :Bool {
		
		if (obj == null) return false;
		
		var objs :Array<Dynamic> = Std.is (obj, Array) ? obj : [obj];
		
		for (o in objs) {
			if (o == null)	continue;
			if (destroy == true || destroy == null)
				try {
					o.destroy();
				}
				catch (e:Dynamic) {
					trace ("[Error when destroying object: "+o+", called from "+Std.string(pos)+"]");
			 		trace (haxe.Stack.toString ( haxe.Stack.exceptionStack() ));
				}
			
			var parent = null; try { parent = o.parent; } catch (e:Dynamic) { null; }
			if (parent != null) if (parent.contains ( o )) parent.removeChild ( o );
		}
		return true;
	}
	
	public static function safeRemove (obj:Dynamic) :Bool {
		return safeDestroy (obj, false);
	}
	
	public static function safeAdd (target:DisplayObjectContainer, obj:Dynamic) :Bool {
		
		if ( target == null || obj == null ) return false;
		
		var objs :Array<Dynamic> = Std.is (obj, Array) ? obj : [obj];
		
		for (o in objs) if (o != null) target.addChild ( o );
			
		return true;
	}
	
	
	
	
	/**
	 * Draws a glow on a target object
	 */
	public static function glow (	target:DisplayObjectContainer,
									color:Null<Int>,
									alpha:Null<Float>,
									blur:Null<Float>,
									strength:Float=0.6)
	{
		var filter = new flash.filters.GlowFilter (color, alpha, blur, blur, strength, 3, false, false);
		target.filters = blur==null ? null : [filter];
	}
	
	
	/**
	 * Changes the color of the targeted object
	 */
	public static function color (target:DisplayObjectContainer, color:Int) :Void {
		var red   = color >> 16 & 0xFF; 
		var green = color >> 8 & 0xFF; 
		var blue  = color & 0xFF;
		target.transform.colorTransform = new flash.geom.ColorTransform (0, 0, 0, 1, red, green, blue, 1);
	}
	
	public static function resetColor (target:DisplayObjectContainer) :Void {
		target.transform.colorTransform = new flash.geom.ColorTransform (1,	1,	1,	1, 0,	0,	0,	0);
	}
	
	
	public static function brightness (target:DisplayObjectContainer, brightness:Int) :Void {
		
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
		
		target.filters = [new flash.filters.ColorMatrixFilter ( matrix )];
	}
	
	
	/**
	 *	Align an object in the specified width and height, with a margin of x and y px
	 *	alignment string is of form: B,M or 20,20 or T,20
	 */
	public static function align (	obj:DisplayObjectContainer, alignment:String,
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
	
	public static function stack () :Void {
		var stack = haxe.Stack.exceptionStack();
		trace ( haxe.Stack.toString ( stack ) );
	}
}
