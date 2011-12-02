package  {
	import flash.filters.GlowFilter;
	import flash.display.DisplayObjectContainer;
	import haxe.Log;
	import flash.filters.ColorMatrixFilter;
	import haxe.Stack;
	import flash.geom.ColorTransform;
	public class Fugu {
		static public function safeDestroy(obj : *,destroy : * = null,pos : * = null) : Boolean {
			if(obj == null) return false;
			var objs : Array = ((Std._is(obj,Array))?obj:[obj]);
			{
				var _g : int = 0;
				while(_g < objs.length) {
					var o : * = objs[_g];
					++_g;
					if(o == null) continue;
					if(destroy == true || destroy == null) try {
						o.destroy();
					}
					catch( e : * ){
						haxe.Log.trace("[Error when destroying object: " + o + ", called from " + Std.string(pos) + "]",{ fileName : "Fugu.hx", lineNumber : 28, className : "Fugu", methodName : "safeDestroy"});
						haxe.Log.trace(haxe.Stack.toString(haxe.Stack.exceptionStack()),{ fileName : "Fugu.hx", lineNumber : 29, className : "Fugu", methodName : "safeDestroy"});
					}
					var parent : * = null;
					try {
						parent = o.parent;
					}
					catch( e2 : * ){
						null;
					}
					if(parent != null) if(parent.contains(o)) parent.removeChild(o);
				}
			}
			return true;
		}
		
		static public function safeRemove(obj : *) : Boolean {
			return safeDestroy(obj,false,{ fileName : "Fugu.hx", lineNumber : 39, className : "Fugu", methodName : "safeRemove"});
		}
		
		static public function safeAdd(target : flash.display.DisplayObjectContainer,obj : *) : Boolean {
			if(target == null || obj == null) return false;
			var objs : Array = ((Std._is(obj,Array))?obj:[obj]);
			{
				var _g : int = 0;
				while(_g < objs.length) {
					var o : * = objs[_g];
					++_g;
					if(o != null) target.addChild(o);
				}
			}
			return true;
		}
		
		static public function glow(target : flash.display.DisplayObjectContainer,color : *,alpha : *,blur : *,strength : Number = 0.6) : void {
			var filter : flash.filters.GlowFilter = new flash.filters.GlowFilter(color,alpha,blur,blur,strength,3,false,false);
			target.filters = ((blur == null)?null:[filter]);
		}
		
		static public function color(target : flash.display.DisplayObjectContainer,color : int) : void {
			var red : int = color >> 16 & 255;
			var green : int = color >> 8 & 255;
			var blue : int = color & 255;
			target.transform.colorTransform = new flash.geom.ColorTransform(0,0,0,1,red,green,blue,1);
		}
		
		static public function resetColor(target : flash.display.DisplayObjectContainer) : void {
			target.transform.colorTransform = new flash.geom.ColorTransform(1,1,1,1,0,0,0,0);
		}
		
		static public function brightness(target : flash.display.DisplayObjectContainer,brightness : int) : void {
			var m : Array = [1,0,0,0,brightness,0,1,0,0,brightness,0,0,1,0,brightness,0,0,0,1,0,0,0,0,0,1];
			var matrix : Array = [];
			var col : Array = [];
			{
				var _g : int = 0;
				while(_g < 5) {
					var i : int = _g++;
					{
						var _g1 : int = 0;
						while(_g1 < 5) {
							var j : int = _g1++;
							col[j] = m[j + i * 5];
						}
					}
					{
						var _g12 : int = 0;
						while(_g12 < 5) {
							var j2 : int = _g12++;
							var val : Number = 0.0;
							{
								var _g2 : int = 0;
								while(_g2 < 5) {
									var k : int = _g2++;
									val += m[j2 + k * 5] * col[k];
								}
							}
							matrix[j2 + i * 5] = val;
						}
					}
				}
			}
			target.filters = [new flash.filters.ColorMatrixFilter(matrix)];
		}
		
		static public function align(obj : flash.display.DisplayObjectContainer,alignment : String,constraint_w : int,constraint_h : int,obj_w : * = null,obj_h : * = null,delay_x : int = 0,delay_y : int = 0) : void {
			if(obj == null) return;
			var arr : Array = alignment.toLowerCase().split(",");
			if(obj_w == null) obj_w = obj.width;
			if(obj_h == null) obj_h = obj.height;
			obj.x = function() : * {
				var $r : *;
				switch(arr[0]) {
				case "l":{
					$r = delay_x;
				}break;
				case "m":{
					$r = Math.round((constraint_w - obj_w) / 2);
				}break;
				case "r":{
					$r = Math.round(constraint_w - obj_w - delay_x);
				}break;
				default:{
					$r = Std._parseInt(arr[0]);
				}break;
				}
				return $r;
			}();
			obj.y = function() : * {
				var $r2 : *;
				switch(arr[1]) {
				case "t":{
					$r2 = delay_y;
				}break;
				case "m":{
					$r2 = Math.round((constraint_h - obj_h) / 2);
				}break;
				case "b":{
					$r2 = Math.round(constraint_h - obj_h - delay_y);
				}break;
				default:{
					$r2 = Std._parseInt(arr[1]);
				}break;
				}
				return $r2;
			}();
		}
		
		static public function stack() : void {
			var stack : Array = haxe.Stack.exceptionStack();
			haxe.Log.trace(haxe.Stack.toString(stack),{ fileName : "Fugu.hx", lineNumber : 143, className : "Fugu", methodName : "stack"});
		}
		
	}
}
