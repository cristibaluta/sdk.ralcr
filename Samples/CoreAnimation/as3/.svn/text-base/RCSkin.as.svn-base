package  {
	import flash.display.DisplayObjectContainer;
	import flash.Boot;
	public class RCSkin implements RCSkinInterface{
		public function RCSkin(colors : Array = null,background : flash.display.DisplayObjectContainer = null,up : flash.display.DisplayObjectContainer = null,over : flash.display.DisplayObjectContainer = null,down : flash.display.DisplayObjectContainer = null,hit : flash.display.DisplayObjectContainer = null) : void { if( !flash.Boot.skip_constructor ) {
			this.background = background;
			this.up = up;
			this.over = over;
			this.down = down;
			this.hit = hit;
			if(colors == null) colors = [null,null,null,null];
			this.colors = colors;
			this.backgroundColorUp = colors[0];
			this.backgroundColorOver = colors[1];
			this.symbolColorUp = colors[2];
			this.symbolColorOver = colors[3];
		}}
		
		public var background : flash.display.DisplayObjectContainer;
		public var up : flash.display.DisplayObjectContainer;
		public var over : flash.display.DisplayObjectContainer;
		public var down : flash.display.DisplayObjectContainer;
		public var hit : flash.display.DisplayObjectContainer;
		public var colors : Array;
		public var backgroundColorUp : *;
		public var backgroundColorOver : *;
		public var symbolColorUp : *;
		public var symbolColorOver : *;
	}
}
