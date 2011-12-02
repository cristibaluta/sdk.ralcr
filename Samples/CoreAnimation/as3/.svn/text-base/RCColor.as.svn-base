package  {
	import flash.Boot;
	public class RCColor {
		public function RCColor(fillColor : * = null,borderColor : * = null,a : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.borderColor = borderColor;
			this.fillColor = fillColor;
			this.alpha = ((a == null)?1.0:a);
		}}
		
		public var alpha : Number;
		public var borderColor : *;
		public var fillColor : *;
		static public var RED : int = 16711680;
		static public var GREEN : int = 16711680;
		static public var BLUE : int = 16711680;
		static public function initWithColor(fillColor : *,borderColor : * = null) : RCColor {
			return new RCColor(fillColor,borderColor);
		}
		
	}
}
