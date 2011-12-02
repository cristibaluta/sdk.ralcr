package  {
	import haxe.Timer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.Boot;
	public class LayerOldTV extends flash.display.Sprite {
		public function LayerOldTV(x : Number = NaN,y : Number = NaN,w : int = 0,h : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			super();
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			this.noisyLines = new Array();
			this.blackShapes = new Array();
			this.randomCurves = new Array();
			{
				var _g1 : int = 0, _g : int = Math.round(10);
				while(_g1 < _g) {
					var i : int = _g1++;
					this.noisyLines.push(new RCNoisyRectangle(0,0,1,h));
				}
			}
			{
				var _g12 : int = 0, _g2 : int = Math.round(10);
				while(_g12 < _g2) {
					var i2 : int = _g12++;
					this.randomCurves.push(new RCRandomCurve(0,0,50,40,16777215));
				}
			}
			{
				var _g13 : int = 0, _g3 : int = Math.round(10);
				while(_g13 < _g3) {
					var i3 : int = _g13++;
					this.blackShapes.push(new RCRandomShape(0,0,100,60));
				}
			}
			this.timer = new flash.utils.Timer(1000);
			this.timer.addEventListener(flash.events.TimerEvent.TIMER,this.addCurve);
			this.timer.start();
			this.timer2 = new flash.utils.Timer(5000);
			this.timer2.addEventListener(flash.events.TimerEvent.TIMER,this.addShape);
			this.timer2.start();
			this.timer3 = new flash.utils.Timer(1000);
			this.timer3.addEventListener(flash.events.TimerEvent.TIMER,this.addLine);
			this.timer3.start();
		}}
		
		protected var noisyLines : Array;
		protected var blackShapes : Array;
		protected var randomCurves : Array;
		protected var timer : flash.utils.Timer;
		protected var timer2 : flash.utils.Timer;
		protected var timer3 : flash.utils.Timer;
		protected var w : int;
		protected var h : int;
		protected function addCurve(e : flash.events.TimerEvent) : void {
			var scope : LayerOldTV = this;
			{
				var _g1 : int = 0, _g : int = Std.random(3);
				while(_g1 < _g) {
					var i : int = _g1++;
					var curve : Array = [this.randomCurves[Std.random(this.randomCurves.length)]];
					curve[0].x = Math.random() * (this.w - 100);
					curve[0].y = Math.random() * (this.h - 100);
					this.addChild(curve[0]);
					haxe.Timer.delay(function(curve2 : Array) : Function {
						return function() : void {
							scope.removeElement(curve2[0]);
						}
					}(curve),Math.round(5 + Math.random() * 20));
				}
			}
		}
		
		protected function addShape(e : flash.events.TimerEvent) : void {
			var scope : LayerOldTV = this;
			{
				var _g1 : int = 0, _g : int = Std.random(2);
				while(_g1 < _g) {
					var i : int = _g1++;
					var shape : Array = [this.blackShapes[Std.random(this.blackShapes.length)]];
					shape[0].x = Math.random() * (this.w - 100);
					shape[0].y = Math.random() * (this.h - 100);
					this.addChild(shape[0]);
					haxe.Timer.delay(function(shape2 : Array) : Function {
						return function() : void {
							scope.removeElement(shape2[0]);
						}
					}(shape),Math.round(5 + Math.random() * 20));
				}
			}
		}
		
		protected function addLine(e : flash.events.TimerEvent) : void {
			var scope : LayerOldTV = this;
			{
				var _g1 : int = 0, _g : int = Std.random(5);
				while(_g1 < _g) {
					var i : int = _g1++;
					var line : RCNoisyRectangle = this.noisyLines[Std.random(this.noisyLines.length)];
					line.x = Math.random() * this.w;
					this.addChild(line);
					var obj : CATween = new CATween(line,{ x : line.x + 50 - Math.random() * 100, alpha : 0},Math.random(),0,null,{ fileName : "LayerOldTV.hx", lineNumber : 81, className : "LayerOldTV", methodName : "addLine"});
					obj.delegate.animationDidStop = this.removeElement;
					obj.delegate.arguments = [line];
					CoreAnimation.add(obj);
				}
			}
		}
		
		protected function removeElement(e : *) : void {
			if(this.contains(e)) this.removeChild(e);
		}
		
		protected function loop(e : flash.events.Event) : void {
			null;
		}
		
		public function destroy() : void {
			if(this.timer != null) {
				this.timer.stop();
				this.timer = null;
			}
		}
		
	}
}
