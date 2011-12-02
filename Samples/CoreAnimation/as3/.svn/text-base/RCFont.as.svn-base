package  {
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.StyleSheet;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.Boot;
	public class RCFont {
		public function RCFont() : void { if( !flash.Boot.skip_constructor ) {
			this.html = true;
			this.embedFonts = true;
			this.type = flash.text.TextFieldType.DYNAMIC;
			this.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			this.autoSize = flash.text.TextFieldAutoSize.LEFT;
			this.selectable = false;
			this.format = new flash.text.TextFormat();
			this.style = new flash.text.StyleSheet();
		}}
		
		public var html : Boolean;
		public var format : flash.text.TextFormat;
		public var style : flash.text.StyleSheet;
		public var embedFonts : Boolean;
		public var type : String;
		public var antiAliasType : String;
		public var autoSize : String;
		public var displayAsPassword : Boolean;
		public var selectable : Boolean;
		public var sharpness : int;
		public var thickness : Number;
		public var align : String;
		public var blockIndent : *;
		public var bold : *;
		public var bullet : *;
		public var color : *;
		public var display : String;
		public var font : String;
		public var indent : *;
		public var italic : *;
		public var kerning : *;
		public var leading : *;
		public var leftMargin : *;
		public var letterSpacing : *;
		public var rightMargin : *;
		public var size : *;
		public var tabStops : Array;
		public var target : String;
		public var underline : *;
		public var url : String;
		public function copy(exceptions : * = null) : RCFont {
			var rcfont : RCFont = new RCFont();
			var fields : Array = Type.getInstanceFields(RCFont);
			{
				var _g : int = 0;
				while(_g < fields.length) {
					var field : String = fields[_g];
					++_g;
					if(field == "copy") continue;
					Reflect.setField(rcfont,field,Reflect.field(this,field));
				}
			}
			if(exceptions != null) {
				{
					var _g2 : int = 0, _g1 : Array = Reflect.fields(exceptions);
					while(_g2 < _g1.length) {
						var excp : String = _g1[_g2];
						++_g2;
						if(Reflect.hasField(rcfont,excp)) {
							Reflect.setField(rcfont,excp,Reflect.field(exceptions,excp));
						}
					}
				}
			}
			rcfont.format = new flash.text.TextFormat();
			rcfont.format.align = rcfont.align;
			rcfont.format.blockIndent = rcfont.blockIndent;
			rcfont.format.bold = rcfont.bold;
			rcfont.format.bullet = rcfont.bullet;
			rcfont.format.color = rcfont.color;
			rcfont.format.font = rcfont.font;
			rcfont.format.italic = rcfont.italic;
			rcfont.format.indent = rcfont.indent;
			rcfont.format.kerning = rcfont.kerning;
			rcfont.format.leading = rcfont.leading;
			rcfont.format.leftMargin = rcfont.leftMargin;
			rcfont.format.letterSpacing = rcfont.letterSpacing;
			rcfont.format.rightMargin = rcfont.rightMargin;
			rcfont.format.size = rcfont.size;
			rcfont.format.tabStops = rcfont.tabStops;
			rcfont.format.target = rcfont.target;
			rcfont.format.underline = rcfont.underline;
			rcfont.format.url = rcfont.url;
			return rcfont;
		}
		
	}
}
