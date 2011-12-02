package  {
	import flash.display.Shape;
	import flash.Boot;
	public class RCRandomCurve extends RCDraw implements RCDrawInterface{
		public function RCRandomCurve(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,color : * = null,alpha : Number = 1.0,points : int = 2) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y,w,h,color,alpha);
			this.points = points;
			this.redraw();
		}}
		
		public var points : int;
		public function redraw() : void {
			this.points = ((this.points < 2)?2:this.points);
			var curve : flash.display.Shape = new flash.display.Shape();
			curve.graphics.lineStyle(1,this.color,0.9);
			{
				var _g1 : int = 0, _g : int = this.points;
				while(_g1 < _g) {
					var i : int = _g1++;
					curve.graphics.curveTo(this.w / 2 - Math.random() * this.w,30 - Math.random() * 60,Math.random() * 50,30 + Math.random() * 20);
				}
			}
			this.addChild(curve);
		}
		
	}
}
