package  {
	public class Reflect {
		static public function hasField(o : *,field : String) : Boolean {
			return o.hasOwnProperty(field);
		}
		
		static public function field(o : *,field : String) : * {
			return ((o == null)?null:o[field]);
		}
		
		static public function setField(o : *,field : String,value : *) : void {
			o[field] = value;
		}
		
		static public function callMethod(o : *,func : *,args : Array) : * {
			return func.apply(o,args);
		}
		
		static public function fields(o : *) : Array {
			if(o == null) return new Array();
			var a : Array = function() : Array {
				var $r : Array;
				$r = new Array();
				for(var $k : String in o) $r.push($k);
				return $r;
			}();
			var i : int = 0;
			while(i < a.length) {
				if(!o.hasOwnProperty(a[i])) a.splice(i,1);
				else ++i;
			}
			return a;
		}
		
		static public function isFunction(f : *) : Boolean {
			return typeof f == "function";
		}
		
		static public function compare(a : *,b : *) : int {
			var a1 : * = a;
			var b1 : * = b;
			return ((a1 == b1)?0:((a1 > b1)?1:-1));
		}
		
		static public function compareMethods(f1 : *,f2 : *) : Boolean {
			return f1 == f2;
		}
		
		static public function isObject(v : *) : Boolean {
			if(v == null) return false;
			var t : String = typeof v;
			if(t == "object") {
				try {
					if(v.__enum__ == true) return false;
				}
				catch( e : * ){
					null;
				}
				return true;
			}
			return t == "string";
		}
		
		static public function deleteField(o : *,f : String) : Boolean {
			if(o.hasOwnProperty(f) != true) return false;
			delete(o[f]);
			return true;
		}
		
		static public function copy(o : *) : * {
			var o2 : * = { }
			{
				var _g : int = 0, _g1 : Array = fields(o);
				while(_g < _g1.length) {
					var f : String = _g1[_g];
					++_g;
					setField(o2,f,field(o,f));
				}
			}
			return o2;
		}
		
		static public function makeVarArgs(f : Function) : * {
			return function(__arguments__ : Array) : * {
				return f(__arguments__);
			}
		}
		
	}
}
