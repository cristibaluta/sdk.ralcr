package haxe {
	import flash.external.ExternalInterface;
	import haxe.Log;
	public class Firebug {
		static public function detect() : Boolean {
			if(!flash.external.ExternalInterface.available) return false;
			return flash.external.ExternalInterface.call("console.error.toString") != null;
		}
		
		static public function redirectTraces() : void {
			haxe.Log.trace = haxe.Firebug.trace;
		}
		
		static public function onError(err : String,stack : Array) : void {
			var buf : String = err + "\n";
			{
				var _g : int = 0;
				while(_g < stack.length) {
					var s : String = stack[_g];
					++_g;
					buf += "Called from " + s + "\n";
				}
			}
			trace(buf,null);
		}
		
		static public function trace(v : *,inf : * = null) : void {
			var type : String = ((inf != null && inf.customParams != null)?inf.customParams[0]:null);
			if(type != "warn" && type != "info" && type != "debug" && type != "error") type = ((inf == null)?"error":"log");
			var str : String = ((inf == null)?"":inf.fileName + ":" + inf.lineNumber + " : ");
			try {
				str += Std.string(v);
			}
			catch( e : * ){
				str += "????";
			}
			str = str.split("\\").join("\\\\");
			flash.external.ExternalInterface.call("console." + type,str);
		}
		
	}
}
