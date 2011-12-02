package  {
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.Boot;
	public class RCButton extends RCControl {
		public function RCButton(x : Number = NaN,y : Number = NaN,skin : RCSkin = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y);
			this.backgroundColorUp = skin.backgroundColorUp;
			this.backgroundColorOver = skin.backgroundColorOver;
			this.symbolColorUp = skin.symbolColorUp;
			this.symbolColorOver = skin.symbolColorOver;
			this.background = skin.background;
			this.up = skin.up;
			this.over = ((skin.over == null)?skin.up:skin.over);
			this.down = ((skin.down == null)?skin.up:skin.down);
			this.hit = skin.hit;
			this.hit.alpha = 0;
			this.addChild(this.background);
			this.addChild(this.up);
			this.addChild(this.hit);
			this.rollOutHandler(null);
		}}
		
		public var background : flash.display.DisplayObjectContainer;
		public var up : flash.display.DisplayObjectContainer;
		public var over : flash.display.DisplayObjectContainer;
		public var down : flash.display.DisplayObjectContainer;
		public var hit : flash.display.DisplayObjectContainer;
		protected var backgroundColorUp : *;
		protected var backgroundColorOver : *;
		protected var symbolColorUp : *;
		protected var symbolColorOver : *;
		protected override function rollOverHandler(e : flash.events.MouseEvent) : void {
			this.toggledState();
			this.onOver();
		}
		
		protected override function rollOutHandler(e : flash.events.MouseEvent) : void {
			this.untoggledState();
			this.onOut();
		}
		
		protected override function toggledState() : void {
			if(this._toggled) return;
			if(this.backgroundColorOver == null) this.setBrightness(this.background,30);
			else this.setColor(this.background,this.backgroundColorOver);
			if(this.symbolColorOver == null) {
				if(this.up == this.over) this.setBrightness(this.over,30);
			}
			else this.setColor(this.over,this.symbolColorOver);
			Fugu.safeRemove([this.up,this.down]);
			Fugu.safeAdd(this,[this.over,this.hit]);
		}
		
		protected override function untoggledState() : void {
			if(this._toggled) return;
			if(this.backgroundColorUp == null) this.setBrightness(this.background,0);
			else this.setColor(this.background,this.backgroundColorUp);
			if(this.symbolColorOver == null) this.setBrightness(this.up,0);
			else this.setColor(this.up,this.symbolColorUp);
			Fugu.safeRemove([this.over,this.down]);
			Fugu.safeAdd(this,[this.up,this.hit]);
		}
		
		public function setColor(obj : flash.display.DisplayObjectContainer,color : *) : void {
			if(obj == null || color == null) return;
			Fugu.color(obj,color);
		}
		
		public function setBrightness(obj : flash.display.DisplayObjectContainer,brightness : int) : void {
			if(obj == null) return;
			Fugu.brightness(obj,brightness);
		}
		
	}
}
