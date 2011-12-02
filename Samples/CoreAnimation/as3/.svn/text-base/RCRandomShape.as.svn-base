package  {
	import flash.display.Shape;
	import flash.Boot;
	public class RCRandomShape extends RCDraw implements RCDrawInterface{
		public function RCRandomShape(x : Number = NaN,y : Number = NaN,w : * = null,h : * = null,color : * = null,alpha : Number = 1.0,points : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y,w,h,color,alpha);
			this.points = points;
			this.redraw();
		}}
		
		public var points : int;
		public function redraw() : void {
			var shape : flash.display.Shape = new flash.display.Shape();
			shape.graphics.beginFill(this.color,1);
			{
				var _g1 : int = 0, _g : int = this.points;
				while(_g1 < _g) {
					var i : int = _g1++;
					shape.graphics.curveTo(Math.random() * 50,-Math.random() * 30,50,30);
					shape.graphics.curveTo(60 - Math.random() * 60,30 + Math.random() * 30,30,60);
					shape.graphics.curveTo(30 - Math.random() * 60,Math.random() * 60,0,0);
				}
			}
		}
		
	}
}
