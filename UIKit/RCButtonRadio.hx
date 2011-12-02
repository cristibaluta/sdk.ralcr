//
//  The class of a standard button
//
//  Created by Baluta Cristian on 2008-03-23.
//  Copyright (c) 2008 www.ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.events.IEventDispatcher;


class RCButtonRadio extends RCButton {
	
	
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
		//this.useHandCursor = false;
		//this.buttonMode = false;
		dispatcher.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.removeEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
		//dispatcher.removeEventListener (MouseEvent.CLICK, clickHandler);
	}
}
