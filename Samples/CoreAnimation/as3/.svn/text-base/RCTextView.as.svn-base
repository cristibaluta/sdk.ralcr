package  {
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.Boot;
	public class RCTextView extends RCView {
		public function RCTextView(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,str : String = null,properties : RCFont = null) : void { if( !flash.Boot.skip_constructor ) {
			super(Math.round(x),Math.round(y));
			this.w = w;
			this.h = h;
			this.init(properties);
			this.setText(str);
		}}
		
		public var target : flash.text.TextField;
		public var properties : RCFont;
		public function get text() : String { return getText(); }
		public function set text( __v : String ) : void { setText(__v); }
		protected var $text : String;
		public function init(properties : RCFont) : void {
			this.properties = properties;
			this.redraw();
			this.target.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL,this.wheelHandler);
		}
		
		public function redraw() : void {
			if(this.target != null) if(this.view.contains(this.target)) this.view.removeChild(this.target);
			this.target = new flash.text.TextField();
			this.target.embedFonts = this.properties.embedFonts;
			this.target.type = this.properties.type;
			this.target.autoSize = this.properties.autoSize;
			this.target.antiAliasType = this.properties.antiAliasType;
			this.target.wordWrap = ((this.w == null)?false:true);
			this.target.multiline = ((this.h == 0)?false:true);
			this.target.sharpness = this.properties.sharpness;
			this.target.selectable = this.properties.selectable;
			this.target.border = false;
			if(this.w != null) this.target.width = this.w;
			if(this.h != null && this.h != 0) this.target.height = this.h;
			if(this.properties.format != null) this.target.defaultTextFormat = this.properties.format;
			if(this.properties.style != null) this.target.styleSheet = this.properties.style;
			this.view.addChild(this.target);
		}
		
		public function getText() : String {
			return this.target.text;
		}
		
		public function setText(str : String) : String {
			if(this.properties.html) {
				this.target.htmlText = str;
			}
			else {
				this.target.text = str;
			}
			return str;
		}
		
		protected function wheelHandler(e : flash.events.MouseEvent) : void {
			if(this.target.maxScrollV == 2) this.target.scrollV = 0;
		}
		
		public override function destroy() : void {
			this.target.removeEventListener(flash.events.MouseEvent.MOUSE_WHEEL,this.wheelHandler);
			this.target = null;
			super.destroy();
		}
		
	}
}
