package  {
	import flash.geom.Matrix;
	import flash.display.LineScaleMode;
	import flash.Boot;
	public class RCDraw extends RCView {
		public function RCDraw(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,color : * = null,alpha : Number = 1.0) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y);
			this.w = w;
			this.h = h;
			this.alpha = alpha;
			this.borderThickness = 1;
			if(Std._is(color,RCColor) || Std._is(color,RCGradient)) {
				this.color = color;
			}
			else if(Std._is(color,int) || Std._is(color,int)) {
				this.color = new RCColor(color);
			}
			else if(Std._is(color,Array)) {
				this.color = new RCColor(color[0],color[1]);
			}
			else this.color = new RCColor(0);
		}}
		
		public var color : *;
		public var borderThickness : int;
		public function configure() : void {
			if(Std._is(this.color,RCColor)) {
				if(this.color.fillColor != null) this.graphics.beginFill(this.color.fillColor,this.color.alpha);
				if(this.color.borderColor != null) {
					var pixelHinting : Boolean = true;
					var scaleMode : String = flash.display.LineScaleMode.NONE;
					var caps : String = null;
					var joints : String = null;
					var miterLimit : int = 3;
					this.graphics.lineStyle(this.borderThickness,this.color.borderColor,this.color.alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
				}
			}
			else if(Std._is(this.color,RCGradient)) {
				var m : flash.geom.Matrix = new flash.geom.Matrix();
				m.createGradientBox(this.w,this.h,this.color.matrixRotation,this.color.tx,this.color.ty);
				this.graphics.beginGradientFill(this.color.gradientType,this.color.gradientColors,this.color.gradientAlphas,this.color.gradientRatios,m,this.color.spreadMethod,this.color.interpolationMethod,this.color.focalPointRatio);
			}
		}
		
	}
}
