//
//  RollingText
//
//  Created by Baluta Cristian on 2007-10-02.
//  Copyright (c) 2007 http://imagin.ro. All rights reserved.
//
import flash.display.Sprite;
import flash.events.Event;


class RCTextRoll extends Sprite {
	
	inline static var PAS :Int = 20; // space between the two text fields
	
	var maskSprite :RCRectangle;
	var txt1 :RCTextView;
	var txt2 :RCTextView;
	var w :Float; // maximum visible surface
	var timer :haxe.Timer;
	
	public var continuous :Bool;
	
	
	public function new (x, y, w:Float, h:Null<Float>, str:String, properties:RCFont) {
		super();
		this.x = x;
		this.y = y;
		this.w = w;
		this.continuous = true;
		
		// add first textfield
		txt1 = new RCTextView (0, 0, null, h, str, properties);
		this.addChild ( txt1 );
		
		// add the second textfield
		if (txt1.width > w) {
			txt2 = new RCTextView (Math.round (txt1.width + PAS), 0, null, h, str, properties);
			this.addChild ( txt2 );
			
			maskSprite = new RCRectangle (0, 0, w, this.height);
			this.addChild ( maskSprite );
			this.mask = maskSprite;
		}
	}
	
	
	public function over () :Void {
		if (txt2 == null) return;
		if (continuous)
			this.addEventListener (Event.ENTER_FRAME, onEnterFrame);
		else
			timer = haxe.Timer.delay (startRolling, 3000);
	}
	function startRolling(){
		this.addEventListener (Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function out () :Void {
		if (txt2 == null) return;
		this.removeEventListener (Event.ENTER_FRAME, onEnterFrame);
		reset();
	}
	
	
	function onEnterFrame (e:Event) :Void {
		
		txt1.x --;
		txt2.x --;
		
		if (!continuous && txt2.x <= 0) {
			out();
			timer = haxe.Timer.delay (startRolling, 3000);
		}
		if (txt1.x < -txt1.width) txt1.x = Math.round (txt2.x + txt2.width + PAS);
		if (txt2.x < -txt2.width) txt2.x = Math.round (txt1.x + txt1.width + PAS);
	}
	
	function reset () :Void {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
		txt1.x = 0;
		txt2.x = Math.round (txt1.width + PAS);
	}
	
	public function destroy () :Void {
		out();
	}
}
