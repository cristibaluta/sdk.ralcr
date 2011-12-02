#if flash
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;
#elseif js
import js.Lib;
import js.Dom;
#end


class Main {
	
	inline static var PARTICLES = 200;
	
	#if flash
		var root : flash.display.MovieClip;
		var defaultFrameRate : Float;
	#elseif js
		var root : HtmlDom;
		var timer : haxe.Timer;
	#end
	
	
	static function main() {
		haxe.Firebug.redirectTraces();
#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		var root = flash.Lib.current;
#elseif js
		var root = js.Lib.document.getElementById("draw");
#end
		
		new Main(root);
	}
	
	
	
	public function new ( root ) {
#if flash
		this.root = root;
		this.root.graphics.lineStyle (1, 0x000000);
		this.root.graphics.moveTo (0, 0);
#end	
		heart1();
		//heart2();
	}
	
	
	function heart1 () {
		// Add all particles at once
		for (i in 0...PARTICLES)
			drawParticle ( i );
			
/*		var iterator = new RCIterator (25, 0, PARTICLES, 1);
			iterator.run = drawParticle;
			iterator.start();*/
	}
	function drawParticle (i:Float) {
		var t = i / PARTICLES;
		
		var p1 = new Particle(400, 400, t, -1);
		var p2 = new Particle(400, 400, t, 1);
		root.addChild( p1 );
		root.addChild( p2 );
	}
	/*
	function heart2 () {
		var iterator = new RCIterator (4, 0, PARTICLES, 1);
			iterator.run = drawParticle2;
			iterator.start();
	}
	function drawParticle2 (i:Float) {		
		var scale = 20;
		var t = i/(PARTICLES/60);
		var a = 0.01 * (-t*t + 40*t + 1200);
		// Heart equation
		var x = a * Math.sin(Math.PI*t/180);
		var y = a * Math.cos(Math.PI*t/180);
		
		this.graphics.drawRect (800-x*scale, 400-y*scale, 1, 1);
		this.graphics.drawRect (800+x*scale, 400-y*scale, 1, 1);
	}
	*/
	function logx(val:Float, base:Float=10):Float {
		return Math.log(val) / Math.log(base);
	}
	function log10(val:Float):Float {
		return Math.log(val) * 0.434294481904;
	}
}



class Particle #if flash extends Sprite #end {
	
	var timer :haxe.Timer;
	var o_x :Float;
	var o_y :Float;
	var f_x :Float;
	var f_y :Float;
	var theta :Float;
	var current_theta :Float;
	var sign :Int;
	
	
	public function new (x, y, t, s) {
#if flash	super(); #end
		
		this.x = o_x = x;
		this.y = o_y = y;
		theta = t;
		f_x = x;
		f_y = y;
		current_theta = 0.001;
		sign = s;
		
		this.graphics.lineStyle (1, 0x000000);
		this.graphics.moveTo (0, 0);
		this.graphics.drawRect (0, 0, 1, 1);
		
		timer = new haxe.Timer ( 40/*Math.round (50*t)*/ );
		timer.run = advanceTheta;
#if flash
		this.addEventListener (flash.events.Event.ENTER_FRAME, loopTheta);
#end
	}
	function advanceTheta () {
		current_theta += (theta - current_theta)/5;
		fxy();
		
		if (Math.abs(current_theta - theta) <= 0.001) {
			current_theta = theta;
			timer.stop();
#if flash
			this.removeEventListener (flash.events.Event.ENTER_FRAME, loopTheta);
#end
			fxy();
			o_x = o_x - f_x*500*sign;
			o_y = o_y - f_y*500;
			
			changeDirection();
#if flash
			this.addEventListener (flash.events.Event.ENTER_FRAME, loop);
#end
		}
	}
	// Heart equation
	function fxy(){
		f_x = Math.sin(current_theta) * Math.cos(current_theta) * Math.log(Math.abs(current_theta));
		f_y = Math.sqrt(Math.abs(current_theta)) * Math.cos(current_theta);
	}
	function changeDirection () {
		f_x = o_x + 6 - Math.random()*12;
		f_y = o_y + 6 - Math.random()*12;
	}
	function loopTheta (_) {
		// Multiply the heart scale by 500
		this.x = o_x - f_x*500*sign;
		this.y = o_y - f_y*500;
	}
	function loop (_) {
		this.x += (f_x - this.x) / 3;
		this.y += (f_y - this.y) / 3;
		
/*		var dx = this.x - o_x;
		var dy = this.y - o_y;
		var d = Math.sqrt (dx*dx + dy*dy);
		this.alpha = 1/d;*/
		
		if (Math.abs (this.x - f_x) < 1)
			changeDirection();
	}
	
/*	public function destroy () {
		if (timer != null) {
			timer.stop();
			timer.removeEventListener (TimerEvent.TIMER, loop);
			timer = null;
		}
	}*/
}
