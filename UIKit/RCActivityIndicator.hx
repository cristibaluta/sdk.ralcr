//
//  RCIndeterminateProgressIndicator
//
//  Created by Baluta Cristian on 2008-12-01.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.events.Event;


class RCActivityIndicator extends RCProgressIndicator {
	
	public var stepX :Int;// The distance after the symbol position is reseted to 0
	public var speedX :Int;
	
	
	public function new (x, y, stepX:Int, skin:RCSkin) {
		super (x, y, skin);
		
		this.stepX = stepX;
		this.speedX = 1;
		this.addEventListener (Event.ENTER_FRAME, loop);
	}
	
	function loop (_) :Void {
		symbol.x -= speedX;
		if (Math.abs(symbol.x) >= Math.abs(stepX))
			symbol.x = 0;
	}
	
	// CLEAN MESS
	override public function destroy() :Void {
		this.removeEventListener (Event.ENTER_FRAME, loop);
	}
}
