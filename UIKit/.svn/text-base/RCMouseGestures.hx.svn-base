//
//  MouseGestures
//
//  Created by Baluta Cristian on 2008-12-29.
//  Copyright (c) 2008 http://imagin.ro. All rights reserved.
//
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

private enum MovementDirection {
	left;
	right;
	down;
	up;
}

class RCMouseGestures {
	
	var target :DisplayObjectContainer;// Where to attach mouse events to
	var clickableTarget :DisplayObjectContainer;
	var lastDirection :MovementDirection;
	var lastGesture :MovementDirection;
	var lastX :Float;
	var lastY :Float;
	var lastClickedX :Float;
	
	inline static var DELAY_BEFORE_CHANGING_DIRECTION :Int = 10;// px
	
	
	/**
	 * Dispatch events
	 */
	dynamic public function onLeft () :Void {}
	dynamic public function onRight () :Void {}
	dynamic public function onUp () :Void {}
	dynamic public function onDown () :Void {}
	dynamic public function clickDragLeftRelease () :Void {}
	dynamic public function clickDragRightRelease () :Void {}
	dynamic public function onClick () :Void {}
	
	
	public function new (target:DisplayObjectContainer, ?target_click:DisplayObjectContainer) {
		
		this.target = target;
		clickableTarget = target_click == null ? target : target_click;
		lastX = target.mouseX;
		lastY = target.mouseY;
		lastDirection = right;
		
		resume();
	}
	
	
	/**
	 * Start listening for mouse actions
	 */
	public function resume () :Void {
		target.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		clickableTarget.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		clickableTarget.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
	}
	
	
	/**
	 * Hold all mouse actions
	 */
	public function hold () :Void {
		target.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		clickableTarget.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		clickableTarget.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
	}
	
	
	
	/**
	 *	Handlers for finding the right gesture
	 */
	function mouseDownHandler (event:MouseEvent) :Void {
		lastClickedX = target.mouseX;
	}
	function mouseUpHandler (event:MouseEvent) :Void {
		if (target.mouseX > lastClickedX + DELAY_BEFORE_CHANGING_DIRECTION)
			clickDragRightRelease();
		else if (target.mouseX < lastClickedX - DELAY_BEFORE_CHANGING_DIRECTION)
			clickDragLeftRelease();
		else
			onClick();
	}
	
	function mouseMoveHandler (e:MouseEvent) :Void {
		
		if ( updateDirection() )
			if ( dispatchGesture() )
				lastGesture = lastDirection;
		
		e.updateAfterEvent();
	}
	
	// Update the last position
	function updateDirection () :Bool {
		
		// x direction
		if (target.mouseX > lastX + DELAY_BEFORE_CHANGING_DIRECTION) {
			lastX = target.mouseX;
			if (lastDirection != right)
				lastDirection = right;
			return true;
		}
		else if (target.mouseX < lastX - DELAY_BEFORE_CHANGING_DIRECTION) {
			lastX = target.mouseX;
			if (lastDirection != left)
				lastDirection = left;
			return true;
		}
		
		// y direction
		if (target.mouseY > lastY + DELAY_BEFORE_CHANGING_DIRECTION) {
			lastY = target.mouseY;
			if (lastDirection != down)
				lastDirection = down;
			return true;
		}
		else if (target.mouseY < lastY - DELAY_BEFORE_CHANGING_DIRECTION) {
			lastY = target.mouseY;
			if (lastDirection != up)
				lastDirection = up;
			return true;
		}
		
		
		return false;
	}
	
	
	/**
	 *	Dispatch events for the current gesture
	 *	Only if they differ from the last gesture, or they are forced to dispatch
	 */
	function dispatchGesture (?force:Bool=false) :Bool {
		
		switch (lastDirection) {
			case left:	if (lastGesture != left	|| force)	{onLeft();	return true;}
			case right:	if (lastGesture != right|| force)	{onRight();	return true;}
			case up:	if (lastGesture != up	|| force)	{onUp();	return true;}
			case down:	if (lastGesture != down	|| force)	{onDown();	return true;}
		}
		
		return false;
	}
	
	
	public function forceDirection (direction:String) :Void {
		switch (direction) {
			case "left":	lastGesture = left;		lastDirection = left;
			case "right":	lastGesture = right;	lastDirection = right;
			case "up":		lastGesture = up;		lastDirection = up;
			case "down":	lastGesture = down;		lastDirection = down;
		}
	}
	
	
	// clean mess
	public function destroy () :Void {
		hold();
	}
}
