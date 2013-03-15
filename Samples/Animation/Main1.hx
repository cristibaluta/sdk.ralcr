//
//  TestTweeners
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.utils.Timer;


class Main1 {
	
	inline static var TWEENERS = ["RCAnimation", "HTween", "TweenerHX", "GTweenHX", "", "start", "stop", "up", "down"];
	static var timeIn = 2.4;
	inline static var timeOut = 4;
	static var container :RCView;
	static var photo :RCImage;
	static var m :RCRectangle;
	static var c = 20;
	static var particlesTxt :RCTextView;
	
	static var tweener :String = "RCAnimation";
	//static var tweener :String = "GTweenHX";
	static var logo :flash.display.MovieClip;
	static var menu :RCGroup<RCButton>;
	static var timer : haxe.Timer;
	
	
	static function main () {
		haxe.Firebug.redirectTraces();
		RCWindow.sharedWindow().init();
		
		menu = new RCGroup<RCButton>(50, 50, null, 20, constructButton);
		menu.add ( TWEENERS );
		//menu.select( "RCAnimation" );
		RCWindow.sharedWindow().addChild ( menu );
		RCWindow.sharedWindow().addChild ( new RCStats (5, 5) );
		
		particlesTxt = new RCTextView (5, 100+menu.height, null, null, "Particles: "+c+"->50ms", RCFont.systemFontOfSize(12));
		RCWindow.sharedWindow().addChild ( particlesTxt );
		
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
		container = new RCView(200, 50);
		
		photo = new RCImage (200, 0, "3134265_large.jpg");
		photo.onComplete = fadePhoto;
		RCWindow.sharedWindow().addChild ( container );
		
/*		m = new RCRectangle (200, 50, 500, 500, 0x000000, 0.3);
		RCWindow.sharedWindow().addChild ( m );
		container.mask = m;*/
		
		//RCWindow.sharedWindow().addChild ( new LayerOldTV (200, 50, 500, 500) );
	}
	
	
	static function fadePhoto(){
		var p = photo.copy();
		container.addChild ( p );
		
		var obj = new CATKenBurns (p, {}, 10, 0, eq.Linear.NONE);
			obj.constraintBounds = new RCRect(0, 0, 500, 500);
			obj.animationDidStop = destroyPhoto;
			//obj.animationDidStart = st;
			obj.arguments = [p];
			//obj.kenBurnsDidFadedIn = p1;
			obj.kenBurnsBeginsFadingOut= fadePhoto;
		//obj.kenBurnsPointIn = 1000;
		//obj.kenBurnsPointOut= 6000;
				
		RCAnimation.add ( obj );
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
			var obj = new RCEllipse(RCWindow.sharedWindow().width/2, RCWindow.sharedWindow().height/2, 2, 2, 0xffffff, 0.6);
			RCWindow.sharedWindow().addChild ( obj );
			t5 ( obj );
		}
	}
	
	
	
	
	static function constructButton (index:RCIndexPath) :RCButton {
		var s = new SKSimpleButtonWithText (TWEENERS[index.row], [0xcccccc, 0x999999, 0x000000, 0xb1e6f0]);
		var b = new RCButton (0, 0, s);
		b.onClick = clickHandler.bind (TWEENERS[index.row]);
		return b;
	}
	static function clickHandler (label:String) :Void {
		switch (label) {
			case "start": timer = new haxe.Timer(50); timer.run = genParticles;
			case "stop": timer.stop();
			case "up": c+=20;
			case "down": c-=20;
			default:
				tweener = label;
				//menu.select( tweener );
		}
		particlesTxt.text = "Particles: "+c+"->50ms";
	}
	
	static function t1(){
		switch (tweener) {
			case TWEENERS[0]:
				var obj = new CATween (logo, {x:800, scaleX:3, scaleY:3}, timeIn, 0, eq.Cubic.IN_OUT);
					obj.animationDidStop = t2;
				RCAnimation.add ( obj );
			
			case TWEENERS[1]:
				HTween.add (logo, timeIn, {x:800, scaleX:3, scaleY:3, onComplete:t2});
									
			case TWEENERS[2]:
				Tweener.addTween (logo, {x:800, scaleX:3, scaleY:3, time:timeIn, transition:"easeinoutcubic", onComplete:t2});
				
			case TWEENERS[3]:
				new GTween (logo, timeIn, {x:800, scaleX:3, scaleY:3}, {ease:Cubic.easeInOut, onComplete:t2});
		}
	}
	static function t2(){
		switch (tweener) {
			case TWEENERS[0]:
				var obj = new CATween (logo, {x:50, scaleX:1, scaleY:1}, timeOut, 0, eq.Cubic.IN_OUT);
					obj.animationDidStop = t1;
				RCAnimation.add ( obj );
			
			case TWEENERS[1]:
				HTween.add (logo, timeOut, {x:50, scaleX:1, scaleY:1, onComplete:t1});
									
			case TWEENERS[2]:
				Tweener.addTween (logo, {x:50, scaleX:1, scaleY:1, time:timeOut, transition:"easeinoutcubic", onComplete:t1});
				
			case TWEENERS[3]:
				new GTween (logo, timeOut, {x:50, scaleX:1, scaleY:1}, {ease:Cubic.easeInOut, onComplete:t1});
		}
	}
	
	
	
	
	// Particles
	static function t5(obj:RCEllipse){
		timeIn = 0.2+Math.random()*1;
		var nx = RCWindow.sharedWindow().width-Math.random()*RCWindow.sharedWindow().width*2;
		var ny = RCWindow.sharedWindow().height-Math.random()*RCWindow.sharedWindow().height*2;
		
		switch (tweener) {
			case TWEENERS[0]:
				var anim = new CATween (obj, {x:nx, y:ny, scaleX:3, scaleY:3}, timeIn, 0, eq.Linear.NONE);
					anim.animationDidStop = remove;
					anim.arguments = [obj];
				RCAnimation.add ( anim );
			
			case TWEENERS[1]:
				HTween.add (obj, timeIn, {x:nx, y:ny, scaleX:3, scaleY:3, onComplete:remove, onCompleteParams:[obj]});
			
			case TWEENERS[2]:
				Tweener.addTween (obj, {x:nx, y:ny, scaleX:3, scaleY:3, time:timeIn, transition:"linear",
									onComplete:remove, onCompleteParams:[obj]});
				
			case TWEENERS[3]:
				new GTween (obj, timeIn, {x:nx, y:ny, scaleX:3, scaleY:3}, {ease:Linear.easeNone, onComplete:remove2 });
		}
	}
	static function remove (obj:RCEllipse) {//trace("remove "+obj);
		RCWindow.sharedWindow().removeChild ( obj );
		obj = null;
	}
	static function remove2(tween:GTween):Void {
		//trace("tween completed");
		RCWindow.sharedWindow().removeChild ( tween.target );
		tween.target = null;
	}
}