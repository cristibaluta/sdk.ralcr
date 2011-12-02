package  {
	import flash.Boot;
	public class List {
		public function List() : void { if( !flash.Boot.skip_constructor ) {
			this.length = 0;
		}}
		
		protected var h : Array;
		protected var q : Array;
		public var length : int;
		public function add(item : *) : void {
			var x : Array = [item];
			if(this.h == null) this.h = x;
			else this.q[1] = x;
			this.q = x;
			this.length++;
		}
		
		public function push(item : *) : void {
			var x : Array = [item,this.h];
			this.h = x;
			if(this.q == null) this.q = x;
			this.length++;
		}
		
		public function first() : * {
			return ((this.h == null)?null:this.h[0]);
		}
		
		public function last() : * {
			return ((this.q == null)?null:this.q[0]);
		}
		
		public function pop() : * {
			if(this.h == null) return null;
			var x : * = this.h[0];
			this.h = this.h[1];
			if(this.h == null) this.q = null;
			this.length--;
			return x;
		}
		
		public function isEmpty() : Boolean {
			return this.h == null;
		}
		
		public function clear() : void {
			this.h = null;
			this.q = null;
			this.length = 0;
		}
		
		public function remove(v : *) : Boolean {
			var prev : Array = null;
			var l : Array = this.h;
			while(l != null) {
				if(l[0] == v) {
					if(prev == null) this.h = l[1];
					else prev[1] = l[1];
					if(this.q == l) this.q = prev;
					this.length--;
					return true;
				}
				prev = l;
				l = l[1];
			}
			return false;
		}
		
		public function iterator() : * {
			return { h : this.h, hasNext : function() : * {
				return this.h != null;
			}, next : function() : * {
				{
					if(this.h == null) return null;
					var x : * = this.h[0];
					this.h = this.h[1];
					return x;
				}
			}}
		}
		
		public function toString() : String {
			var s : StringBuf = new StringBuf();
			var first : Boolean = true;
			var l : Array = this.h;
			s.add("{");
			while(l != null) {
				if(first) first = false;
				else s.add(", ");
				s.add(Std.string(l[0]));
				l = l[1];
			}
			s.add("}");
			return s.toString();
		}
		
		public function join(sep : String) : String {
			var s : StringBuf = new StringBuf();
			var first : Boolean = true;
			var l : Array = this.h;
			while(l != null) {
				if(first) first = false;
				else s.add(sep);
				s.add(l[0]);
				l = l[1];
			}
			return s.toString();
		}
		
		public function filter(f : Function) : List {
			var l2 : List = new List();
			var l : Array = this.h;
			while(l != null) {
				var v : * = l[0];
				l = l[1];
				if(f(v)) l2.add(v);
			}
			return l2;
		}
		
		public function map(f : Function) : List {
			var b : List = new List();
			var l : Array = this.h;
			while(l != null) {
				var v : * = l[0];
				l = l[1];
				b.add(f(v));
			}
			return b;
		}
		
	}
}
