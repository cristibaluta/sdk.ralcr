//
//  RCTextRoll.hx
//
//  Created by Baluta Cristian on 2007-10-02.
//  Copyright (c) 2007-2012 http://imagin.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCView;


class RCTextRoll extends RCView {
	
	inline static var GAP :Int = 20; // space between the two text fields
	
	var txt1 :RCTextView;
	var txt2 :RCTextView;
	var timer :haxe.Timer;
	var timerLoop :haxe.Timer;
	
	public var continuous :Bool;
	public var text (getText, setText) :String;
	
	
	public function new (x, y, w:Float, h:Null<Float>, str:String, properties:RCFont) {
		
		super(x, y, w, h);
		this.continuous = true;
		
		// Add the first TextField
		txt1 = new RCTextView (0, 0, null, h, str, properties);
		this.addChild ( txt1 );
		viewDidAppear.add ( viewDidAppear_ );
	}
	
	// JS target is not able to get elements dimensions if they are not on the display list.
	// So we decide if we need a second textfield only after the component is added to stage
	
	function viewDidAppear_ () :Void {
		
		this.size.height = txt1.contentSize.height;
		
		if (txt1.contentSize.width > size.width) {
			if (txt2 != null) return;
			txt2 = new RCTextView (Math.round (txt1.contentSize.width + GAP), 0, null, null, text, txt1.rcfont);
			this.addChild ( txt2 );
			this.clipsToBounds = true;
		}
	}
	
	public function getText() :String {
		return txt1.text;
	}
	public function setText (str:String) :String {
		return str;
	}
	
	
	/**
	 *  Start and stop the rolling text
	 **/
	public function start () :Void {
		if (txt2 == null) return;
		if (continuous)
			startRolling();
		else
			timer = haxe.Timer.delay (startRolling, 3000);
	}
	public function stop () :Void {
		if (txt2 == null) return;
		stopRolling();
		reset();
	}
	
	function stopRolling(?pos:haxe.PosInfos){
		if (timerLoop != null)
			timerLoop.stop();
			timerLoop = null;
	}
	function startRolling(){
		stopRolling();
		timerLoop = new haxe.Timer(20);
		timerLoop.run = loop;
	}
	
	
	
	
	function loop () :Void {
		
		txt1.x--;
		txt2.x--;
		
		if (!continuous && txt2.x <= 0) {
			stop();
			timer = haxe.Timer.delay (startRolling, 3000);
		}
		if (txt1.x < -txt1.contentSize.width)
			txt1.x = Math.round (txt2.x + txt2.contentSize.width + GAP);
		if (txt2.x < -txt2.contentSize.width)
			txt2.x = Math.round (txt1.x + txt1.contentSize.width + GAP);
	}
	
	function reset () :Void {
		
		if (timer != null) {
			timer.stop();
			timer = null;
		}
		txt1.x = 0;
		txt2.x = Math.round (txt1.width + GAP);
	}
	
	override public function destroy () :Void {
		stop();
		super.destroy();
	}
}
