package haxe {
	import haxe.StackItem;
	public class Stack {
		static public function callStack() : Array {
			var a : Array = makeStack(new Error().getStackTrace());
			a.shift();
			return a;
		}
		
		static public function exceptionStack() : Array {
			return new Array();
		}
		
		static public function toString(stack : Array) : String {
			var b : StringBuf = new StringBuf();
			{
				var _g : int = 0;
				while(_g < stack.length) {
					var s : haxe.StackItem = stack[_g];
					++_g;
					b.add("\nCalled from ");
					itemToString(b,s);
				}
			}
			return b.toString();
		}
		
		static protected function itemToString(b : StringBuf,s : haxe.StackItem) : void {
			{
				var $e : enum = s;
				switch( $e.index ) {
				case 0:
				{
					b.add("a C function");
				}break;
				case 1:
				var m : String = $e.params[0];
				{
					b.add("module ");
					b.add(m);
				}break;
				case 2:
				var line : int = $e.params[2], file : String = $e.params[1], s1 : haxe.StackItem = $e.params[0];
				{
					if(s1 != null) {
						itemToString(b,s1);
						b.add(" (");
					}
					b.add(file);
					b.add(" line ");
					b.add(line);
					if(s1 != null) b.add(")");
				}break;
				case 3:
				var meth : String = $e.params[1], cname : String = $e.params[0];
				{
					b.add(cname);
					b.add(".");
					b.add(meth);
				}break;
				case 4:
				var n : int = $e.params[0];
				{
					b.add("local function #");
					b.add(n);
				}break;
				}
			}
		}
		
		static protected function makeStack(s : String) : Array {
			var a : Array = new Array();
			var r : EReg = new EReg("at ([^/]+?)\\$?(/[^\\(]+)?\\(\\)(\\[(.*?):([0-9]+)\\])?","");
			var rlambda : EReg = new EReg("^MethodInfo-([0-9]+)$","g");
			while(r.match(s)) {
				var cl : String = r.matched(1).split("::").join(".");
				var meth : String = r.matched(2);
				var item : haxe.StackItem;
				if(meth == null) {
					if(rlambda.match(cl)) item = haxe.StackItem.Lambda(Std._parseInt(rlambda.matched(1)));
					else item = haxe.StackItem.Method(cl,"new");
				}
				else item = haxe.StackItem.Method(cl,meth.substr(1));
				if(r.matched(3) != null) item = haxe.StackItem.FilePos(item,r.matched(4),Std._parseInt(r.matched(5)));
				a.push(item);
				s = r.matchedRight();
			}
			return a;
		}
		
	}
}
