//
//  OldTV
//
//  Created by Cristi Baluta on 2010-05-06.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.events.Event;


class LayerOldTV extends Sprite {
	
	var noisyLines :Array<RCNoisyRectangle>;
	var blackShapes :Array<RCRandomShape>;
	var randomCurves :Array<RCRandomCurve>;
	var timer :Timer;
	var timer2 :Timer;
	var timer3 :Timer;
	var w :Int;
	var h :Int;
	
	
	public function new (x, y, w:Int, h:Int) {
		super();
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		
		noisyLines = new Array<RCNoisyRectangle>();
		blackShapes = new Array<RCRandomShape>();
		randomCurves = new Array<RCRandomCurve>();
		
		// Create noise
		for (i in 0...Math.round(10)) noisyLines.push ( new RCNoisyRectangle (0, 0, 1, h) );
		for (i in 0...Math.round(10)) randomCurves.push ( new RCRandomCurve (0, 0, 50, 40, 0xFFFFFF) );
		for (i in 0...Math.round(10)) blackShapes.push ( new RCRandomShape (0, 0, 100, 60) );
		
		
		timer = new Timer ( 1000 );
		timer.addEventListener (TimerEvent.TIMER, addCurve);
		timer.start();
		timer2 = new Timer ( 5000 );
		timer2.addEventListener (TimerEvent.TIMER, addShape);
		timer2.start();
		timer3 = new Timer ( 1000 );
		timer3.addEventListener (TimerEvent.TIMER, addLine);
		timer3.start();
		//this.addEventListener (Event.ENTER_FRAME, loop);
	}
	
	function addCurve (e:TimerEvent) :Void {
		var scope = this;
		for (i in 0...Std.random(3)) {
			var curve = randomCurves[Std.random(randomCurves.length)];
				curve.view.x = Math.random()*(w-100);
				curve.view.y = Math.random()*(h-100);
			this.addChild ( curve.view );
			haxe.Timer.delay (function(){scope.removeElement(curve);}, Math.round(5+Math.random()*20));
		}
	}
	function addShape (e:TimerEvent) :Void {
		var scope = this;
		for (i in 0...Std.random(2)) {
			var shape = blackShapes[Std.random(blackShapes.length)];
				shape.view.x = Math.random()*(w-100);
				shape.view.y = Math.random()*(h-100);
			this.addChild ( shape.view );
			haxe.Timer.delay (function(){scope.removeElement(shape);}, Math.round(5+Math.random()*20));
		}
	}
	function addLine (e:TimerEvent) :Void {
		var scope = this;
		for (i in 0...Std.random(5)) {
			var line = noisyLines[Std.random(noisyLines.length)];
				line.view.x = Math.random()*w;
			this.addChild ( line.view );
			
			var obj = new CATween (line.view, {x:line.view.x+50-Math.random()*100, alpha:0}, Math.random(), 0);
				obj.delegate.animationDidStop = removeElement;
				obj.delegate.arguments = [line];
			CoreAnimation.add ( obj );
		}
	}
	function removeElement (e:Dynamic) {
		if (this.contains(e))
			this.removeChild ( e );
	}
	
	function loop (e:Event) :Void {
		
	}
	
	public function destroy () :Void {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}
} 