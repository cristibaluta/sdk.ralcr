package haxe {
	import flash.Boot;
	public class Log {
		static public var trace : Function = function(v : *,infos : * = null) : void {
			flash.Boot.__trace(v,infos);
		}
		static public var clear : Function = function() : void {
			flash.Boot.__clear_trace();
		}
		static public var setColor : Function = function(rgb : int) : void {
			flash.Boot.__set_trace_color(rgb);
		}
	}
}
