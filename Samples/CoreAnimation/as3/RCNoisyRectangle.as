package  {
	import flash.display.BlendMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.Boot;
	public class RCNoisyRectangle extends RCDraw implements RCDrawInterface{
		public function RCNoisyRectangle(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,color : * = null,alpha : Number = 1.0,r : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y,w,h,color,alpha);
			this.roundness = r;
			this.redraw();
		}}
		
		public var roundness : *;
		public function redraw() : void {
			var line : flash.display.BitmapData = new flash.display.BitmapData(Math.round(this.w),Math.round(this.h),true,this.color);
			line.perlinNoise(Math.random(),Math.random() * 5,6,10,true,true,0,true,null);
			var bitmapRectangle : flash.display.Bitmap = new flash.display.Bitmap(line);
			bitmapRectangle.blendMode = flash.display.BlendMode.SCREEN;
			this.addChild(bitmapRectangle);
		}
		
	}
}
