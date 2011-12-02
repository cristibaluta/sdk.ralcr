//
//  TestTweeners
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import caurina.transitions.Tweener;
import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Linear;	
import com.gskinner.motion.easing.Quadratic;
import com.gskinner.motion.easing.Cubic;
import com.gskinner.motion.easing.Quartic;
import com.gskinner.motion.easing.Quintic;
import com.gskinner.motion.easing.Exponential;
import com.gskinner.motion.easing.Sine;
import com.gskinner.motion.easing.Circular;
import com.gskinner.motion.easing.Back;
import com.gskinner.motion.easing.Bounce;
import com.gskinner.motion.easing.Elastic;
import flash.utils.Timer;


class Main1 {
	
	inline static var tweeners = ["CoreAnimation", "HTween", "TweenerHX", "GTweenHX", "", "start", "stop", "up", "down"];
	static var timeIn = 2.4;
	inline static var timeOut = 4;
	static var container :flash.display.Sprite;
	static var photo :RCPhoto;
	static var m :RCRectangle;
	static var c = 20;
	static var particlesTxt :RCTextView;
	
	static var tweener :String = "CoreAnimation";
	//static var tweener :String = "GTweenHX";
	static var logo :flash.display.MovieClip;
	static var menu :RCGroupButtons<RCButton>;
	static var timer : haxe.Timer;
	
	
	static function main () {
		haxe.Firebug.redirectTraces();
		RCStage.init();
		FontManager.init();
		//TestColors.init();
		
		menu = new RCGroupButtons<RCButton>(50, 50, null, 10, constructButton);
		menu.add ( tweeners );
		menu.addEventListener (GroupEvent.CLICK, clickHandler);
		menu.select( "CoreAnimation" );
		RCStage.addChild ( menu );
		RCStage.addChild ( new RCStats (5, 5) );
		
		particlesTxt = new RCTextView (5, 50+menu.height, null, null, "Particles: "+c+"->50ms", FontManager.getRCFont("system",{embedFonts:false}));
		RCStage.addChild ( particlesTxt );
		
		timer = new haxe.Timer(50);
		timer.run = genParticles;
		//genParticles();
		
		/*var st = flash.Lib.getTimer();
		var f = 0;var t : Test;
		var j = 0;
		while (j < 1000000){
		//for (i in 0...1000000) {
			//t = new Test();
			f = Test.staticcalc (j, f);
			j ++;
		}
		trace( flash.Lib.getTimer() - st );*/
		
		//kenburns();
	}
	
	static function kenburns () {
		container = new flash.display.Sprite();
		container.x = 200;
		container.y = 50;
		
		photo = new RCPhoto (200, 0, "3134265_large.jpg");
		photo.onComplete = fadePhoto;
		RCStage.addChild ( container );
		
		m = new RCRectangle (200, 50, 500, 500, 0x000000, 0.3);
		RCStage.addChild ( m );
		container.mask = m;
		
		RCStage.addChild ( new LayerOldTV (200, 50, 500, 500) );
	}
	
	
	static function fadePhoto(){
		var p = photo.duplicate();
		container.addChild ( p );
		
		var obj = new CATKenBurns (p, {}, 10, 0, caequations.Linear.NONE);
			obj.constraintBounds = new RCRect(0, 0, 500, 500);
			obj.delegate.animationDidStop = destroyPhoto;
			//obj.delegate.animationDidStart = st;
			obj.delegate.arguments = [p];
			//obj.delegate.kenBurnsDidFadedIn = p1;
			obj.delegate.kenBurnsBeginsFadingOut= fadePhoto;
		//obj.delegate.kenBurnsPointIn = 1000;
		//obj.delegate.kenBurnsPointOut= 6000;
				
		CoreAnimation.add ( obj );
	}
	static function destroyPhoto (e:flash.display.Sprite) {
		Fugu.safeRemove ( e );
		e = null;
	}
	static function stopLogo (a:Int, b:Int) {
		trace("STOP LOGO "+a+ " / "+b);
	}
	
	static function st(e:flash.display.Sprite){trace("animation started");}
	static function p1(){trace("kenburn 1= ");}
	static function p2(){trace("kenburn 2= ");}
	static function genParticles() :Void {
		for (i in 0...c) {
			var obj = new RCEllipse(RCStage.width/2, RCStage.height/2, 2, 2, 0xffffff, 0.6);
			RCStage.addChild ( obj );
			t5 ( obj );
		}
	}
	
	
	
	
	static function constructButton (label:String) :RCButton {
		var s = new SKSimpleButtonWithText (label, [0xcccccc, 0x999999, 0x000000, 0xb1e6f0]);
		var b = new RCButton (0, 0, s);
		return b;
	}
	static function clickHandler (e:GroupEvent) :Void {
		switch (e.label) {
			case "start": timer = new haxe.Timer(50); timer.run = genParticles;
			case "stop": timer.stop();
			case "up": c+=20;
			case "down": c-=20;
			default:
				tweener = e.label;
				menu.select( tweener );
		}
		particlesTxt.text = "Particles: "+c+"->50ms";
	}
	
	static function t1(){
		switch (tweener) {
			case tweeners[0]:
				var obj = new CATween (logo, {x:800, scaleX:3, scaleY:3}, timeIn, 0, caequations.Cubic.IN_OUT);
					obj.delegate.animationDidStop = t2;
				CoreAnimation.add ( obj );
			
			case tweeners[1]:
				HTween.add (logo, timeIn, {x:800, scaleX:3, scaleY:3, onComplete:t2});
									
			case tweeners[2]:
				Tweener.addTween (logo, {x:800, scaleX:3, scaleY:3, time:timeIn, transition:"easeinoutcubic", onComplete:t2});
				
			case tweeners[3]:
				new GTween (logo, timeIn, {x:800, scaleX:3, scaleY:3}, {ease:Cubic.easeInOut, onComplete:t2});
		}
	}
	static function t2(){
		switch (tweener) {
			case tweeners[0]:
				var obj = new CATween (logo, {x:50, scaleX:1, scaleY:1}, timeOut, 0, caequations.Cubic.IN_OUT);
					obj.delegate.animationDidStop = t1;
				CoreAnimation.add ( obj );
			
			case tweeners[1]:
				HTween.add (logo, timeOut, {x:50, scaleX:1, scaleY:1, onComplete:t1});
									
			case tweeners[2]:
				Tweener.addTween (logo, {x:50, scaleX:1, scaleY:1, time:timeOut, transition:"easeinoutcubic", onComplete:t1});
				
			case tweeners[3]:
				new GTween (logo, timeOut, {x:50, scaleX:1, scaleY:1}, {ease:Cubic.easeInOut, onComplete:t1});
		}
	}
	
	
	
	
	// Particles
	static function t5(obj:RCEllipse){
		timeIn = 0.2+Math.random()*1;
		var nx = RCStage.width-Math.random()*RCStage.width*2;
		var ny = RCStage.height-Math.random()*RCStage.height*2;
		
		switch (tweener) {
			case tweeners[0]:
				var anim = new CATween (obj, {x:nx, y:ny, scaleX:3, scaleY:3}, timeIn, 0, caequations.Linear.NONE);
					anim.delegate.animationDidStop = remove;
					anim.delegate.arguments = [obj];
				CoreAnimation.add ( anim );
			
			case tweeners[1]:
				HTween.add (obj, timeIn, {x:nx, y:ny, scaleX:3, scaleY:3, onComplete:remove, onCompleteParams:[obj]});
			
			case tweeners[2]:
				Tweener.addTween (obj, {x:nx, y:ny, scaleX:3, scaleY:3, time:timeIn, transition:"linear",
									onComplete:remove, onCompleteParams:[obj]});
				
			case tweeners[3]:
				new GTween (obj, timeIn, {x:nx, y:ny, scaleX:3, scaleY:3}, {ease:Linear.easeNone, onComplete:remove2 });
		}
	}
	static function remove (obj:RCEllipse) {//trace("remove "+obj);
		RCStage.removeChild ( obj );
		obj = null;
	}
	static function remove2(tween:GTween):Void {
		//trace("tween completed");
		RCStage.removeChild ( tween.target );
		tween.target = null;
	}
}