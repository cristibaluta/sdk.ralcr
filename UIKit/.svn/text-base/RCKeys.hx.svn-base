//
//  Keys
//
//  Created by Baluta Cristian on 2007-08-17.
//  Copyright (c) 2007 http://ralcr.com. All rights reserved.
//
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;


class RCKeys {
	
	
	/**
	 * Dispatch events by replacing this delegate functions
	 */
	dynamic public function onLeft () :Void {}
	dynamic public function onRight () :Void {}
	dynamic public function onUp () :Void {}
	dynamic public function onDown () :Void {}
	dynamic public function onEnter () :Void {}
	dynamic public function onSpace () :Void {}
	dynamic public function onEsc () :Void {}
	dynamic public function onKeyUp () :Void {}
	dynamic public function onKeyDown () :Void {}
	
	public var char :String;
	public var charCode :Int;
	
	
	public function new () {
		resume();
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		
		charCode = e.charCode;
		char = "";
		onKeyDown();
		
		switch (e.charCode) {
			case 13: onEnter();
		}
		switch (e.keyCode) {
			case Keyboard.LEFT :	onLeft();
			case Keyboard.RIGHT :	onRight();
			case Keyboard.UP :		onUp();
			case Keyboard.DOWN :	onDown();
			case Keyboard.ENTER :	onEnter();
			case Keyboard.SPACE :	onSpace();
			case Keyboard.ESCAPE :	onEsc();
		}
		
		e.updateAfterEvent();
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		charCode = e.charCode;
		char = "";
		onKeyUp();
	}
	
	
	/**
	 * Add or remove the keyboard listener
	 */
	public function resume () :Void {
		flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDownHandler);
		flash.Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	public function hold () :Void {
		flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_DOWN, keyDownHandler);
		flash.Lib.current.stage.removeEventListener (KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	
	/**
	 * Clean mess
	 */
	public function destroy () :Void {
		hold();
	}
}
