//
//  CheckBox
//
//  Created by Baluta Cristian on 2008-09-07.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.events.IEventDispatcher;

private enum State {
	checked;
	unchecked;
}


class RCCheckBox extends RCButton {
	
	
	public function new (x, y, skin:RCSkin) {
		super (x, y, skin);
	}
	
	override function configureListeners (dispatcher:IEventDispatcher) :Void {
		this.useHandCursor = true;
		this.buttonMode = true;
		dispatcher.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		dispatcher.addEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.addEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
		dispatcher.addEventListener (MouseEvent.CLICK, clickHandler);
	}
	override function removeListeners (dispatcher:IEventDispatcher) :Void {
		dispatcher.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
	}
}
