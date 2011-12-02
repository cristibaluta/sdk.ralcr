package  {
	import flash.geom.Rectangle;
	import flash.Boot;
	public class RCRectangle extends RCDraw implements RCDrawInterface{
		public function RCRectangle(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,color : * = null,alpha : Number = 1.0,r : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y,w,h,color,alpha);
			this.roundness = r;
			this.redraw();
		}}
		
		public var roundness : *;
		public function redraw() : void {
			this.graphics.clear();
			this.configure();
			if(this.roundness != null) this.graphics.drawRoundRect(0,0,this.w,this.h,this.roundness);
			else this.graphics.drawRect(0,0,this.w,this.h);
			this.graphics.endFill();
		}
		
		public function rectangle() : flash.geom.Rectangle {
			return new flash.geom.Rectangle(this.x,this.y,this.w,this.h);
		}
		
	}
}
