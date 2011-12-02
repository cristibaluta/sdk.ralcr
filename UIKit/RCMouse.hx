//
//  Mouse
//
//  Created by Baluta Cristian on 2008-09-14.
//  Copyright (c) 2008 http://imagin.ro. All rights reserved.
//
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

private enum Position {
	left;
	middle;
	right;
	outside;
	over;
}
class RCMouse {
	
	var _parent :DisplayObjectContainer;
	var _target :DisplayObjectContainer;
	var _over	:DisplayObjectContainer;
	
	var _last_position :Position;
	var _interval :haxe.Timer;
	var _is_idle :Bool;
	var _is_over :Bool; // mouse is over the "over" object
	var _w :Int; // set the middle width area
	
	inline static var IDLE_TIME :Int = 3000;
	inline static var MIDDLE_W :Int = 200;
	
	
	/**
	 * Custom events
	 */
	dynamic public function onOver () :Void {}
	dynamic public function onOut () :Void {}
	dynamic public function onLeft () :Void {}
	dynamic public function onMiddle () :Void {}
	dynamic public function onMiddleOut () :Void {}
	dynamic public function onRight () :Void {}
	dynamic public function onClick () :Void {}
	dynamic public function onDoubleClick () :Void {}
	dynamic public function onClickLeft () :Void {}
	dynamic public function onClickMiddle () :Void {}
	dynamic public function onClickRight () :Void {}
	dynamic public function onIdle () :Void {}
	dynamic public function onResume () :Void {}
	
	
	public function new (	parent:DisplayObjectContainer,
							target:DisplayObjectContainer,
							?target_over:DisplayObjectContainer)
	{
		
		_w = MIDDLE_W;
		_parent = parent;
		_target = target;
		_over = target_over == null ? target : target_over;//use a different area to attach MouseEvents
		_is_idle = false;
		
		//_target.buttonMode = true;
		//_over.buttonMode = true;
		//_parent.doubleClickEnabled = true;
		
		if (_parent != RCStage.target)
			_parent.mouseEnabled = true;
			
		if (_over != RCStage.target)
			_over.mouseEnabled = true;
		
		resume();
	}
	
	
	/**
	 * Start listening for mouse actions
	 */
	public function resume () :Void {
		
		_interval = new haxe.Timer ( IDLE_TIME );
		
		_over.addEventListener (MouseEvent.ROLL_OVER, mouseOverHandler);
		_over.addEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
		_over.addEventListener (MouseEvent.CLICK, clickHandler);
	}
	
	
	/**
	 * Hold all mouse actions
	 */
	public function hold () :Void {
		
		_interval.stop();
		_interval = null;
		
		_over.removeEventListener (MouseEvent.ROLL_OVER, mouseOverHandler);
		_over.removeEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
		_over.removeEventListener (MouseEvent.CLICK, clickHandler);
	}
	
	
	/**
	 * Handlers
	 */
	function mouseOverHandler (e:MouseEvent) :Void {
		_last_position = over;
		onOver();
		_parent.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		_parent.addEventListener (MouseEvent.DOUBLE_CLICK, doubleClickHandler);
	}
	
	function mouseOutHandler (e:MouseEvent) :Void {
		_parent.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		_parent.removeEventListener (MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		onOut();
	}
	
	function mouseMoveHandler (e:MouseEvent) :Void {
		// for each mousemove reset the counter for going idle
		_interval.stop();
		_interval = new haxe.Timer ( IDLE_TIME );
		_interval.run = goIdle;
		
		if (_is_idle) resumeIdle();
		
		var position = getPosition();
		
		if (_last_position == middle && position != middle)
			onMiddleOut();
		if (_last_position != position) {
			_last_position = position;
			dispatchPosition ( position );
		}
	}
	
	function clickHandler (e:MouseEvent) :Void {
		switch ( getPosition() ) {
			case left:		onClickLeft();		onClick();
			case right:		onClickRight();		onClick();
			case middle:	onClickMiddle();	onClick();
			
			case outside:	return;
			case over:		return;
		}
	}
	
	function doubleClickHandler (e:MouseEvent) :Void {
		onDoubleClick();
	}
	
	function dispatchPosition (position:Position) {
		switch ( position ) {
			case left:		onLeft();
			case middle:	onMiddle();
			case right:		onRight();
			case outside:	mouseOutHandler ( null );
			case over:		null;
		}
	}
	
	
	/**
	 * Force to dispatch events even if mouse is not moving
	 * Usefull if your content was moved but not the mouse
	 */
	public function refresh () :Void {
		mouseMoveHandler ( null );
	}
	
	
	public function setMiddleWidth (w:Int) {
		_w = w;
	}
	
	
	/**
	 * Returns the position of the mouse to the target
	 */
	function getPosition () :Position {
		if (_parent.mouseX > _target.x && _parent.mouseX < _target.x + _target.width &&
			_parent.mouseY > _target.y && _parent.mouseY < _target.y + _target.height) {
				
			var realX = _parent.mouseX - _target.x;
			
			if (realX < (_target.width - _w) / 2)				return left;
			else if (realX > (_target.width - _w) / 2 + _w) 	return right;
			else												return middle;
		}
		return outside;
	}
	
	function goIdle () :Void {
		_interval.stop();
		_is_idle = true;
		onIdle();
	}
	
	function resumeIdle () :Void {
		_is_idle = false;
		onResume();
	}
	
	
	
	public function destroy() :Void {
		hold();
		mouseOutHandler ( null );
	}
}
