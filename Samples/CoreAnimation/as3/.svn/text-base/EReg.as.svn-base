package  {
	import flash.Boot;
	public class EReg {
		public function EReg(r : String = null,opt : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.r = new RegExp(r,opt);
		}}
		
		protected var r : *;
		protected var result : *;
		public function match(s : String) : Boolean {
			this.result = this.r.exec(s);
			return this.result != null;
		}
		
		public function matched(n : int) : String {
			return ((this.result != null && n >= 0 && n < this.result.length)?this.result[n]:(function($this:EReg) : String {
				var $r : String;
				throw "EReg::matched";
				return $r;
			}(this)));
		}
		
		public function matchedLeft() : String {
			if(this.result == null) throw "No string matched";
			var s : String = this.result.input;
			return s.substr(0,this.result.index);
		}
		
		public function matchedRight() : String {
			if(this.result == null) throw "No string matched";
			var rl : int = this.result.index + this.result[0].length;
			var s : String = this.result.input;
			return s.substr(rl,s.length - rl);
		}
		
		public function matchedPos() : * {
			if(this.result == null) throw "No string matched";
			return { pos : this.result.index, len : this.result[0].length}
		}
		
		public function split(s : String) : Array {
			var d : String = "#__delim__#";
			return s.replace(this.r,d).split(d);
		}
		
		public function replace(s : String,by : String) : String {
			return s.replace(this.r,by);
		}
		
		public function customReplace(s : String,f : Function) : String {
			var buf : StringBuf = new StringBuf();
			while(true) {
				if(!this.match(s)) break;
				buf.add(this.matchedLeft());
				buf.add(f(this));
				s = this.matchedRight();
			}
			buf.add(s);
			return buf.toString();
		}
		
	}
}
