//
//  mc
//
//  Created by Baluta Cristian on 2008-03-23.
//  Copyright (c) 2008 www.lib.com. All rights reserved.
//
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.IEventDispatcher;


class RCControl extends RCView {
	
	public var locked (getLocked, null) :Bool;
	public var toggled (getToggled, null) :Bool;
	public var toggable (getToggable, setToggable) :Bool;
	public var clickable (getClickable, setClickable) :Bool;
	public var lockable (getLockable, setLockable) :Bool;
	
	var _toggled :Bool;
	var _toggable :Bool;
	var _clickable :Bool; // weather you can click the button or not
	var _lockable :Bool; // weather you can make the button clickagle or not
	
	/**
	 * Dispatch events by replacing this functions
	 */
	dynamic public function onClick () :Void {}
	dynamic public function onPress () :Void {}
	dynamic public function onRelease () :Void {}
	dynamic public function onOver () :Void {}
	dynamic public function onOut () :Void {}
	
	
	public function new (x, y) {
		super(x, y);
		
		_toggled = false;
		_toggable = false;
		_clickable = true;
		_lockable = true;
		
		this.useHandCursor = true;
		this.buttonMode = true;
		//this.mouseChildren = false;
		
		configureListeners ( this );
	}
	function configureListeners (dispatcher:IEventDispatcher) :Void {
		this.useHandCursor = true;
		this.buttonMode = true;
		dispatcher.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		dispatcher.addEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.addEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
		dispatcher.addEventListener (MouseEvent.CLICK, clickHandler);
	}
	function removeListeners (dispatcher:IEventDispatcher) :Void {
		this.useHandCursor = false;
		this.buttonMode = false;
		dispatcher.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
		dispatcher.removeEventListener (MouseEvent.CLICK, clickHandler);
	}
	
	
	/**
	 * Mouse Handlers
	 */
	function mouseDownHandler (e:MouseEvent) :Void {
		onPress();
	}
	function mouseUpHandler (e:MouseEvent) :Void {
		onRelease();
	}
	function clickHandler (e:MouseEvent) :Void {
		onClick();
	}
	function rollOverHandler (e:MouseEvent) :Void {
		if (_toggled) return;
		onOver();
	}
	function rollOutHandler (e:MouseEvent) :Void {
		if (_toggled) return;
		onOut();
	}
	
	
	
	/**
	 * Getter and setter
	 */
	function getToggled () :Bool {
		return _toggled;
	}
	function getLocked () :Bool {
		return !_clickable;
	}
	//
	function getToggable () :Bool {
		return _toggable;
	}
	function setToggable (t:Bool) :Bool {
		return _toggable = t;
	}
	//
	function getClickable () :Bool {
		return _clickable;
	}
	function setClickable (c:Bool) :Bool {
		if (!_lockable) return c;
		c ? configureListeners ( this ) : removeListeners ( this );
		return _clickable = c;
	}
	//
	function getLockable () :Bool {
		return _lockable;
	}
	function setLockable (l:Bool) :Bool {
		return _lockable = l;
	}
	
	
	/**
	 * lock = If the button is locked, you are no longer able to click it,
	 * 			onClock, onPress, onRelease will not by dispactched
	 *			hand cursor is also disabled
	 *			You can lock/unlock a button only if is lockable
	 * unlock = Events are dispatched again
	 */
	public function lock () :Void {
		setClickable ( false );
	}
	public function unlock () :Void {
		setClickable ( true );
	}
	
	
	/**
	 * toggle = Change the state of the button to Over
	 * untoggle = Change the state of the button to Normal
	 */
	public function toggle () :Void {
		if (_toggable && _lockable) {
			// Set the state to Over than make the button toggled so you can't go to normal state when you rollout
			toggledState ();
			_toggled = true;
		}
	}
	public function untoggle () :Void {
		if (_toggable && _lockable) {
			// Change first the variable to untoggled, then change the state of the button to normal
			_toggled = false;
			untoggledState ();
		}
	}
	function toggledState () :Void {}
	function untoggledState () :Void {}
	
	
	// Clean mess
	override public function destroy () :Void {
		removeListeners ( this );
		super.destroy();
	}
}
