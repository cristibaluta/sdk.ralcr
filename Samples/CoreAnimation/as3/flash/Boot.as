package flash {
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import flash.Lib;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	public class Boot extends flash.display.MovieClip {
		public function Boot() : void { if( !flash.Boot.skip_constructor ) {
			super();
		}}
		
		protected function start() : void {
			var c : flash.display.MovieClip = flash.Lib.current;
			try {
				if(c == this && c.stage != null && c.stage.align == "") c.stage.align = "TOP_LEFT";
				else null;
			}
			catch( e : * ){
				null;
			}
			if(c.stage == null) c.addEventListener(flash.events.Event.ADDED_TO_STAGE,this.doInitDelay);
			else if(c.stage.stageWidth == 0) flash.utils.setTimeout(this.start,1);
			else this.init();
		}
		
		protected function doInitDelay(_ : *) : void {
			flash.Lib.current.removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.doInitDelay);
			this.start();
		}
		
		protected function init() : void {
			throw "assert";
		}
		
		static protected var tf : flash.text.TextField;
		static protected var lines : Array;
		static protected var lastError : Error;
		static public var skip_constructor : Boolean = false;
		static public function enum_to_string(e : *) : String {
			if(e.params == null) return e.tag;
			var pstr : Array = [];
			{
				var _g : int = 0, _g1 : Array = e.params;
				while(_g < _g1.length) {
					var p : * = _g1[_g];
					++_g;
					pstr.push(__string_rec(p,""));
				}
			}
			return e.tag + "(" + pstr.join(",") + ")";
		}
		
		static public function __instanceof(v : *,t : *) : Boolean {
			try {
				if(t == Object) return true;
				return v is t;
			}
			catch( e : * ){
				null;
			}
			return false;
		}
		
		static public function __clear_trace() : void {
			if(flash.Boot.tf == null) return;
			tf.parent.removeChild(tf);
			flash.Boot.tf = null;
			flash.Boot.lines = null;
		}
		
		static public function __set_trace_color(rgb : uint) : void {
			getTrace().textColor = rgb;
		}
		
		static public function getTrace() : flash.text.TextField {
			var mc : flash.display.MovieClip = flash.Lib.current;
			if(flash.Boot.tf == null) {
				flash.Boot.tf = new flash.text.TextField();
				var format : flash.text.TextFormat = tf.getTextFormat();
				format.font = "_sans";
				tf.defaultTextFormat = format;
				tf.selectable = false;
				tf.width = ((mc.stage == null)?800:mc.stage.stageWidth);
				tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
				tf.mouseEnabled = false;
			}
			if(mc.stage == null) mc.addChild(tf);
			else mc.stage.addChild(tf);
			return tf;
		}
		
		static public function __trace(v : *,pos : *) : void {
			var tf : flash.text.TextField = getTrace();
			var pstr : String = ((pos == null)?"(null)":pos.fileName + ":" + pos.lineNumber);
			if(flash.Boot.lines == null) flash.Boot.lines = [];
			flash.Boot.lines = lines.concat((pstr + ": " + __string_rec(v,"")).split("\n"));
			tf.text = lines.join("\n");
			var stage : flash.display.Stage = flash.Lib.current.stage;
			if(stage == null) return;
			while(lines.length > 1 && tf.height > stage.stageHeight) {
				lines.shift();
				tf.text = lines.join("\n");
			}
		}
		
		static public function __string_rec(v : *,str : String) : String {
			var cname : String = flash.utils.getQualifiedClassName(v);
			switch(cname) {
			case "Object":{
				var k : Array = function() : Array {
					var $r : Array;
					$r = new Array();
					for(var $k : String in v) $r.push($k);
					return $r;
				}();
				var s : String = "{";
				var first : Boolean = true;
				{
					var _g1 : int = 0, _g : int = k.length;
					while(_g1 < _g) {
						var i : int = _g1++;
						var key : String = k[i];
						if(first) first = false;
						else s += ",";
						s += " " + key + " : " + __string_rec(v[key],str);
					}
				}
				if(!first) s += " ";
				s += "}";
				return s;
			}break;
			case "Array":{
				if(v == Array) return "#Array";
				var s2 : String = "[";
				var i2 : *;
				var first2 : Boolean = true;
				var a : Array = v;
				{
					var _g12 : int = 0, _g2 : int = a.length;
					while(_g12 < _g2) {
						var i1 : int = _g12++;
						if(first2) first2 = false;
						else s2 += ",";
						s2 += __string_rec(a[i1],str);
					}
				}
				return s2 + "]";
			}break;
			default:{
				switch(typeof v) {
				case "function":{
					return "<function>";
				}break;
				}
			}break;
			}
			return new String(v);
		}
		
		static protected function __unprotect__(s : String) : String {
			return s;
		}
		
	}
}
