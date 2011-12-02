package flash {
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.system.fscommand;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.net.navigateToURL;
	public class Lib {
		static public var current : flash.display.MovieClip;
		static public function _getTimer() : int {
			return flash.utils.getTimer();
		}
		
		static public function eval(path : String) : * {
			var p : Array = path.split(".");
			var fields : Array = new Array();
			var o : * = null;
			while(p.length > 0) {
				try {
					o = flash.utils.getDefinitionByName(p.join("."));
				}
				catch( e : * ){
					fields.unshift(p.pop());
				}
				if(o != null) break;
			}
			{
				var _g : int = 0;
				while(_g < fields.length) {
					var f : String = fields[_g];
					++_g;
					if(o == null) return null;
					o = o[f];
				}
			}
			return o;
		}
		
		static public function getURL(url : flash.net.URLRequest,target : String = null) : void {
			var f : Function = flash.net.navigateToURL;
			if(target == null) f(url);
			else (f)(url,target);
		}
		
		static public function fscommand(cmd : String,param : String = null) : void {
			flash.system.fscommand(cmd,((param == null)?"":param));
		}
		
		static public function trace(arg : *) : void {
			trace(arg);
		}
		
		static public function attach(name : String) : flash.display.MovieClip {
			var cl : * = flash.utils.getDefinitionByName(name) as Class;
			return new cl();
		}
		
		static public function _as(v : *,c : Class) : * {
			return v as c;
		}
		
	}
}
