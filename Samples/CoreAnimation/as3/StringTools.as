package  {
	public class StringTools {
		static public function urlEncode(s : String) : String {
			return encodeURIComponent(s);
		}
		
		static public function urlDecode(s : String) : String {
			return decodeURIComponent(s.split("+").join(" "));
		}
		
		static public function htmlEscape(s : String) : String {
			return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
		}
		
		static public function htmlUnescape(s : String) : String {
			return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
		}
		
		static public function startsWith(s : String,start : String) : Boolean {
			return s.length >= start.length && s.substr(0,start.length) == start;
		}
		
		static public function endsWith(s : String,end : String) : Boolean {
			var elen : int = end.length;
			var slen : int = s.length;
			return slen >= elen && s.substr(slen - elen,elen) == end;
		}
		
		static public function isSpace(s : String,pos : int) : Boolean {
			var c : * = s["charCodeAt"](pos);
			return c >= 9 && c <= 13 || c == 32;
		}
		
		static public function ltrim(s : String) : String {
			var l : int = s.length;
			var r : int = 0;
			while(r < l && isSpace(s,r)) {
				r++;
			}
			if(r > 0) return s.substr(r,l - r);
			else return s;
		}
		
		static public function rtrim(s : String) : String {
			var l : int = s.length;
			var r : int = 0;
			while(r < l && isSpace(s,l - r - 1)) {
				r++;
			}
			if(r > 0) {
				return s.substr(0,l - r);
			}
			else {
				return s;
			}
		}
		
		static public function trim(s : String) : String {
			return ltrim(rtrim(s));
		}
		
		static public function rpad(s : String,c : String,l : int) : String {
			var sl : int = s.length;
			var cl : int = c.length;
			while(sl < l) {
				if(l - sl < cl) {
					s += c.substr(0,l - sl);
					sl = l;
				}
				else {
					s += c;
					sl += cl;
				}
			}
			return s;
		}
		
		static public function lpad(s : String,c : String,l : int) : String {
			var ns : String = "";
			var sl : int = s.length;
			if(sl >= l) return s;
			var cl : int = c.length;
			while(sl < l) {
				if(l - sl < cl) {
					ns += c.substr(0,l - sl);
					sl = l;
				}
				else {
					ns += c;
					sl += cl;
				}
			}
			return ns + s;
		}
		
		static public function replace(s : String,sub : String,by : String) : String {
			return s.split(sub).join(by);
		}
		
		static public function hex(n : int,digits : * = null) : String {
			var n1 : uint = n;
			var s : String = n1.toString(16);
			s = s.toUpperCase();
			if(digits != null) while(s.length < digits) s = "0" + s;
			return s;
		}
		
		static public function fastCodeAt(s : String,index : int) : int {
			return s.charCodeAt(index);
		}
		
		static public function isEOF(c : int) : Boolean {
			return c == 0;
		}
		
	}
}
