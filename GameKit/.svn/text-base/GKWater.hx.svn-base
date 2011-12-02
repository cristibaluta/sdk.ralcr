import flash.display.MovieClip;
import flash.events.Event;
import flash.utils.Timer;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.utils.*;


class GKWater extends MovieClip {
	
	public var dots :Array<GKDot>;
	public var waves :Array<GKWave>;
	public var shape :Shape;
	public var numDots :Float;
	public var spacing :Float;
	public var waterWidth :Float;
	public var floatingItems :Array;
	
	
	public function new () {
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);
	}
	public function enterFrameHandler(ev:Event):Void {
		if (Math.round(Math.random()*20) == 0) {
			gentlyDisturbWater();
		}
		propogateWaves();
		renderWater();
		moveFloatingItems();
	}
	public function gentlyDisturbWater():Void {
		injectWave (3, Math.random()*waterWidth);
	}
	public function addWave (A:Float, startx:Float, dir:Float) {
		//f(x) = A*sin(w*t)
		var wave = new GKWave();
			wave.setIndex ( Math.floor(startx/spacing) );
			wave.setA ( A );
			wave.setDir ( dir );
			wave.setFirstOne ( true );
			wave.setStartX ( startx );
			wave.setStartTime ( getTimer() );
		getWaves().push ( wave );
	}
	public function injectWave (A:Float, x:Float) {
		addWave (A, x, 1);
		addWave (A, x, -1);
	}
	
	public function propogateWaves():Void {
		
		var t :Int = getTimer();
		var speed :Float = waterWidth/2000;
		var j :Int = waves.length - 1;
		var wave :GKWave;
		var d :Float;
		var dot :GKDot;
		
		while (j >= 0) {
			wave = getWaves()[j];
			d = .0001;
			wave.setA(wave.getA() / Math.pow(Math.E, d*(t-wave.getStartTime())));
			var index:Number = Math.floor((wave.getStartX()+wave.getDir()*(t-wave.getStartTime())*speed)/spacing);
			if (index < 0 || index > numDots-1) {
				waves.splice(j, 1);
			} else if (index != wave.getIndex() || (index == wave.getIndex() && wave.getDir() == 1 && wave.getFirstOne())) {
				var w:Wave;
				if (wave.getFirstOne() && wave.getDir() == 1) {
					w = new Wave();
					w.setA(wave.getA());
					w.setStartTime(t);
					dot = getDots()[wave.getIndex()];
					dot.getWaves().push(w);
				}
				if (wave.getDir() == 1) {
					for (i=wave.getIndex()+1;i<=index;++i) {
						w = new Wave();
						w.setA(wave.getA());
						w.setStartTime(t);
						dot = getDots()[i];
						dot.getWaves().push(w);
					}
				} else {
					for (i=wave.getIndex()-1;i>=index;--i) {
						w = new Wave();
						w.setA(wave.getA());
						w.setStartTime(t);
						dot = getDots()[i];
						dot.getWaves().push(w);
					}
				}
				wave.setIndex(index);
				wave.setFirstOne(false);
			}
			j--;
		}
		
		for (i in 0...dots.length) {
			dot = dots[i];
			var y = .0;
			j = dot.getWaves().length - 1;
			
			while (j >= 0) {
				wave = dot.getWaves()[j];
				var freq = .005;
				d = .99;
				wave.setA(wave.getA()*d);
				y += wave.getA()*Math.sin(freq*(t-wave.getStartTime()));
				if (wave.getA() <.5) {
					dot.getWaves().splice(j, 1);
				}
			}
			dot.y = y;
		}
	}
	public function moveFloatingItems():Void {
		var g:Number = .25;
		for (var j:int=0;j<getFloatingItems().length;++j) {
			var fi:FloatingItem = getFloatingItems()[j];
			var dob:DisplayObject = fi.getDisplayObject();
			var d:Number = .9;
			var x:Number = Math.round(dob.x);
			var margin:Number = 4;
			var index:Number = Math.floor(x/spacing) - margin/2;
			var y:Number = 0;
			var ang:Number = 0;
			for (var i=index;i<index+margin;++i) {
				y += dots[i].y;
				if (i != index) {
					ang += Math.atan2(dots[i].y-dots[i-1].y, dots[i].x-dots[i-1].x);
				}
			}
			y = y/margin;
			fi.setYVelocity(fi.getYVelocity()+g);
			dob.y += fi.getYVelocity();
			if (dob.y >= y) {
				dob.y = y;
				fi.setYVelocity(fi.getYVelocity()*.4);
				var k:Number = .3;
				dob.rotation += ((ang/margin)*180/Math.PI-dob.rotation)*k;
			}
		}
	}
	public function renderWater():Void {
		
		shape.graphics.clear();
        shape.graphics.beginFill(0x006699);
        shape.graphics.lineStyle(0, 0x000000, 0);
		shape.graphics.moveTo(0, 0);
		var t:Number = getTimer();
		for (var i=0;i<dots.length;++i) {
			var dot:Dot = dots[i];
			shape.graphics.lineTo(dot.x, dot.y);
		}
		shape.graphics.lineTo(dots[dots.length-1].x, 300);
		shape.graphics.lineTo(0, 300);
		shape.graphics.endFill();
	}
	public function getWaves () :Array<GKWave> {
		return waves;
	}
	public function getFloatingItems():Array 	{
		return floatingItems;
	}
	public function addFloatingItem(dob:DisplayObject):Void {
		var fi:IFloatable = new FloatingItem();
		fi.setDisplayObject(dob);
		fi.setYVelocity(0);
		addIFloatable(fi);
	}
	public function addIFloatable(fi:IFloatable):Void {
		getFloatingItems().push(fi);
		addChild(fi.getDisplayObject());
	}
	
	
	
	
	public function addedToStage(ev:Event):Void {
		dots = new Array<GKDot>();
		waves = new Array<GKWave>();
		floatingItems = new Array();
		waterWidth = 600;
		numDots = 60;
		spacing = waterWidth/numDots;
		//
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		initDots();
        shape = new Shape();
        addChild ( shape );
		renderWater();
		gentlyDisturbWater();
		gentlyDisturbWater();
	}
	public function initDots() {
		for (i in 0...numDots) {
			var dot = new GKDot();
				dot.x = i*spacing;
				dot.y = 0;
			addDot ( dot );
		}
	}
	public function addDot (d:GKDot) :Void {
		getDots().push(d);
	}
	public function getDots():Array<GKDot> {
		return dots;
	}
}
