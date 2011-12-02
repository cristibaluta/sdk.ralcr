package  {
	import com.gskinner.motion.GTween;
	import haxe.Firebug;
	import com.gskinner.motion.easing.Linear;
	import caequations.Linear;
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import haxe.Log;
	import flash.geom.Rectangle;
	import com.gskinner.motion.easing.Cubic;
	import caequations.Cubic;
	import flash.display.Sprite;
	import haxe.Timer;
	public class Main1 {
		static protected var tweeners : Array = ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"];
		static protected var timeIn : Number = 2.4;
		static protected var timeOut : int = 4;
		static protected var container : flash.display.Sprite;
		static protected var photo : RCPhoto;
		static protected var m : RCRectangle;
		static protected var c : int = 20;
		static protected var particlesTxt : RCTextView;
		static protected var tweener : String = "CoreAnimation";
		static protected var logo : flash.display.MovieClip;
		static protected var menu : RCGroupButtons;
		static protected var timer : haxe.Timer;
		static public function main() : void {
			haxe.Firebug.redirectTraces();
			RCStage.init();
			FontManager.init();
			Main1.menu = new RCGroupButtons(50,50,null,10,Main1.constructButton);
			menu.add(["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"]);
			menu.addEventListener("group_click",Main1.clickHandler);
			menu.select("CoreAnimation");
			RCStage.addChild(menu);
			RCStage.addChild(new RCStats(5,5));
			Main1.particlesTxt = new RCTextView(5,50 + menu.height,null,null,"Particles: " + c + "->50ms",FontManager.getRCFont("system",{ embedFonts : false}));
			RCStage.addChild(particlesTxt);
			Main1.timer = new haxe.Timer(50);
			timer.run = Main1.genParticles;
		}
		
		static protected function kenburns() : void {
			Main1.container = new flash.display.Sprite();
			container.x = 200;
			container.y = 50;
			Main1.photo = new RCPhoto(200,0,"3134265_large.jpg");
			photo.onComplete = Main1.fadePhoto;
			RCStage.addChild(container);
			Main1.m = new RCRectangle(200,50,500,500,0,0.3);
			RCStage.addChild(m);
			container.mask = m;
			RCStage.addChild(new LayerOldTV(200,50,500,500));
		}
		
		static protected function fadePhoto() : void {
			var p : flash.display.Sprite = photo.duplicate();
			container.addChild(p);
			var obj : CATKenBurns = new CATKenBurns(p,{ },10,0,caequations.Linear.NONE,{ fileName : "Main1.hx", lineNumber : 96, className : "Main1", methodName : "fadePhoto"});
			obj.constraintBounds = new flash.geom.Rectangle(0,0,500,500);
			obj.delegate.animationDidStop = Main1.destroyPhoto;
			obj.delegate.arguments = [p];
			obj.delegate.kenBurnsBeginsFadingOut = Main1.fadePhoto;
			CoreAnimation.add(obj);
		}
		
		static protected function destroyPhoto(e : flash.display.Sprite) : void {
			Fugu.safeRemove(e);
			e = null;
		}
		
		static protected function stopLogo(a : int,b : int) : void {
			haxe.Log.trace("STOP LOGO " + a + " / " + b,{ fileName : "Main1.hx", lineNumber : 113, className : "Main1", methodName : "stopLogo"});
		}
		
		static protected function st(e : flash.display.Sprite) : void {
			haxe.Log.trace("animation started",{ fileName : "Main1.hx", lineNumber : 116, className : "Main1", methodName : "st"});
		}
		
		static protected function p1() : void {
			haxe.Log.trace("kenburn 1= ",{ fileName : "Main1.hx", lineNumber : 117, className : "Main1", methodName : "p1"});
		}
		
		static protected function p2() : void {
			haxe.Log.trace("kenburn 2= ",{ fileName : "Main1.hx", lineNumber : 118, className : "Main1", methodName : "p2"});
		}
		
		static protected function genParticles() : void {
			{
				var _g1 : int = 0, _g : int = c;
				while(_g1 < _g) {
					var i : int = _g1++;
					var obj : RCEllipse = new RCEllipse(RCStage.width / 2,RCStage.height / 2,2,2,16777215,0.6);
					RCStage.addChild(obj);
					t5(obj);
				}
			}
		}
		
		static protected function constructButton(_label : String) : RCButton {
			var s : SKSimpleButtonWithText = new SKSimpleButtonWithText(_label,[13421772,10066329,0,11658992]);
			var b : RCButton = new RCButton(0,0,s);
			return b;
		}
		
		static protected function clickHandler(e : GroupEvent) : void {
			switch(e._label) {
			case "start":{
				Main1.timer = new haxe.Timer(50);
				timer.run = Main1.genParticles;
			}break;
			case "stop":{
				timer.stop();
			}break;
			case "up":{
				Main1.c += 20;
			}break;
			case "down":{
				Main1.c -= 20;
			}break;
			default:{
				Main1.tweener = e._label;
				menu.select(tweener);
			}break;
			}
			particlesTxt.setText("Particles: " + c + "->50ms");
		}
		
		static protected function t1() : void {
			switch(tweener) {
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][0]:{
				var obj : CATween = new CATween(logo,{ x : 800, scaleX : 3, scaleY : 3},timeIn,0,caequations.Cubic.IN_OUT,{ fileName : "Main1.hx", lineNumber : 151, className : "Main1", methodName : "t1"});
				obj.delegate.animationDidStop = Main1.t2;
				CoreAnimation.add(obj);
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][1]:{
				HTween.add(logo,timeIn,{ x : 800, scaleX : 3, scaleY : 3, onComplete : Main1.t2});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][2]:{
				caurina.transitions.Tweener.addTween(logo,{ x : 800, scaleX : 3, scaleY : 3, time : timeIn, transition : "easeinoutcubic", onComplete : Main1.t2});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][3]:{
				new com.gskinner.motion.GTween(logo,timeIn,{ x : 800, scaleX : 3, scaleY : 3},{ ease : com.gskinner.motion.easing.Cubic.easeInOut, onComplete : Main1.t2});
			}break;
			}
		}
		
		static protected function t2() : void {
			switch(tweener) {
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][0]:{
				var obj : CATween = new CATween(logo,{ x : 50, scaleX : 1, scaleY : 1},4,0,caequations.Cubic.IN_OUT,{ fileName : "Main1.hx", lineNumber : 168, className : "Main1", methodName : "t2"});
				obj.delegate.animationDidStop = Main1.t1;
				CoreAnimation.add(obj);
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][1]:{
				HTween.add(logo,4,{ x : 50, scaleX : 1, scaleY : 1, onComplete : Main1.t1});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][2]:{
				caurina.transitions.Tweener.addTween(logo,{ x : 50, scaleX : 1, scaleY : 1, time : 4, transition : "easeinoutcubic", onComplete : Main1.t1});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][3]:{
				new com.gskinner.motion.GTween(logo,4,{ x : 50, scaleX : 1, scaleY : 1},{ ease : com.gskinner.motion.easing.Cubic.easeInOut, onComplete : Main1.t1});
			}break;
			}
		}
		
		static protected function t5(obj : RCEllipse) : void {
			Main1.timeIn = 0.2 + Math.random();
			var nx : Number = RCStage.width - Math.random() * RCStage.width * 2;
			var ny : Number = RCStage.height - Math.random() * RCStage.height * 2;
			switch(tweener) {
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][0]:{
				var anim : CATween = new CATween(obj,{ x : nx, y : ny, scaleX : 3, scaleY : 3},timeIn,0,caequations.Linear.NONE,{ fileName : "Main1.hx", lineNumber : 194, className : "Main1", methodName : "t5"});
				anim.delegate.animationDidStop = Main1.remove;
				anim.delegate.arguments = [obj];
				CoreAnimation.add(anim);
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][1]:{
				HTween.add(obj,timeIn,{ x : nx, y : ny, scaleX : 3, scaleY : 3, onComplete : Main1.remove, onCompleteParams : [obj]});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][2]:{
				caurina.transitions.Tweener.addTween(obj,{ x : nx, y : ny, scaleX : 3, scaleY : 3, time : timeIn, transition : "linear", onComplete : Main1.remove, onCompleteParams : [obj]});
			}break;
			case ["CoreAnimation","HTween","TweenerHX","GTweenHX","","start","stop","up","down"][3]:{
				new com.gskinner.motion.GTween(obj,timeIn,{ x : nx, y : ny, scaleX : 3, scaleY : 3},{ ease : com.gskinner.motion.easing.Linear.easeNone, onComplete : Main1.remove2});
			}break;
			}
		}
		
		static protected function remove(obj : RCEllipse) : void {
			RCStage.removeChild(obj);
			obj = null;
		}
		
		static protected function remove2(tween : com.gskinner.motion.GTween) : void {
			RCStage.removeChild(tween.target);
			tween.target = null;
		}
		
	}
}
