package  {
	import com.gskinner.motion.GTween;
	import flash.Boot;
	import flash.Lib;
	public class __main__ extends flash.Boot {
		public function __main__() {
			super();
			flash.Lib.current = this;
			{
				com.gskinner.motion.GTween.version = 0.2;
				com.gskinner.motion.GTween.defaultEase = com.gskinner.motion.GTween.linearEase;
				com.gskinner.motion.GTween.timeScaleAll = 1;
				com.gskinner.motion.GTween.plugins = new Hash();
				com.gskinner.motion.GTween.tickList = new IntHash();
				com.gskinner.motion.GTween.keyMarker = -2147483647;
			}
			{
				var aproto : * = Array.prototype;
				aproto.copy = function() : * {
					return this.slice();
				}
				aproto.insert = function(i : *,x : *) : void {
					this.splice(i,0,x);
				}
				aproto.remove = function(obj : *) : Boolean {
					var idx : int = this.indexOf(obj);
					if(idx == -1) return false;
					this.splice(idx,1);
					return true;
				}
				aproto.iterator = function() : * {
					var cur : int = 0;
					var arr : Array = this;
					return { hasNext : function() : Boolean {
						return cur < arr.length;
					}, next : function() : * {
						return arr[cur++];
					}}
				}
				aproto.setPropertyIsEnumerable("copy",false);
				aproto.setPropertyIsEnumerable("insert",false);
				aproto.setPropertyIsEnumerable("remove",false);
				aproto.setPropertyIsEnumerable("iterator",false);
				String.prototype.charCodeAt = function(i : *) : * {
					var s : String = this;
					var x : Number = s.charCodeAt(i);
					if(isNaN(x)) return null;
					return Std._int(x);
				}
			}
			{
				Math["NaN"] = Number.NaN;
				Math["NEGATIVE_INFINITY"] = Number.NEGATIVE_INFINITY;
				Math["POSITIVE_INFINITY"] = Number.POSITIVE_INFINITY;
				Math["isFinite"] = function(i : Number) : Boolean {
					return isFinite(i);
				}
				Math["isNaN"] = function(i : Number) : Boolean {
					return isNaN(i);
				}
			}
			Main1.main();
		}
	}
}
