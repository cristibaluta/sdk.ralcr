package  {
	import flash.geom.ColorTransform;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.Boot;
	public class RCView extends flash.display.Sprite {
		public function RCView(x : Number = NaN,y : Number = NaN) : void { if( !flash.Boot.skip_constructor ) {
			super();
			this.x = x;
			this.y = y;
			this.view = new flash.display.Sprite();
			this.addChild(this.view);
		}}
		
		public var view : flash.display.DisplayObjectContainer;
		public var w : *;
		public var h : *;
		protected var lastW : Number;
		protected var lastH : Number;
		protected var caobj : CAObject;
		public function setColor(color : int,mpl : Number = 0) : void {
			var red : int = (color & 16711680) >> 16;
			var green : int = (color & 65280) >> 8;
			var blue : int = color & 255;
			this.transform.colorTransform = new flash.geom.ColorTransform(mpl,mpl,mpl,mpl,red,green,blue,this.alpha * 255);
		}
		
		public function resetColor() : void {
			this.transform.colorTransform = new flash.geom.ColorTransform(1,1,1,1,0,0,0,0);
		}
		
		public function scaleToFit(w : int,h : int) : void {
			if(this.w / w > this.h / h && this.w > w) {
				this.width = w;
				this.height = this.width * this.h / this.w;
			}
			else if(this.h > h) {
				this.height = h;
				this.width = this.height * this.w / this.h;
			}
			else if(this.w > this.lastW && this.h > this.lastH) {
				this.width = this.w;
				this.height = this.h;
			}
			else this.resetScale();
			this.lastW = this.width;
			this.lastH = this.height;
		}
		
		public function scaleToFill(w : int,h : int) : void {
			if(w / this.w > h / this.h) {
				this.width = w;
				this.height = this.width * this.h / this.w;
			}
			else {
				this.height = h;
				this.width = this.height * this.w / this.h;
			}
		}
		
		public function resetScale() : void {
			this.width = this.lastW;
			this.height = this.lastH;
		}
		
		public function animate(obj : CAObject) : void {
			CoreAnimation.add(this.caobj = obj);
		}
		
		public function destroy() : void {
			CoreAnimation.remove(this.caobj);
		}
		
		public function removeFromSuperView() : void {
			var parent : flash.display.DisplayObjectContainer = null;
			try {
				parent = this.parent;
			}
			catch( e : * ){
				null;
			}
			if(parent != null) if(parent.contains(this)) parent.removeChild(this);
		}
		
	}
}
