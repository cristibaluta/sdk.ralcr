package  {
	import flash.Boot;
	public class Std {
		static public function _is(v : *,t : *) : Boolean {
			return flash.Boot.__instanceof(v,t);
		}
		
		static public function string(s : *) : String {
			return flash.Boot.__string_rec(s,"");
		}
		
		static public function _int(x : Number) : int {
			return int(x);
		}
		
		static public function _parseInt(x : String) : * {
			var v : * = parseInt(x);
			if(isNaN(v)) return null;
			return v;
		}
		
		static public function _parseFloat(x : String) : Number {
			return parseFloat(x);
		}
		
		static public function random(x : int) : int {
			return Math.floor(Math.random() * x);
		}
		
	}
}
