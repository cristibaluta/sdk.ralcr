//
//  The class of a standard button
//
//  Created by Baluta Cristian on 2008-03-23.
//  Copyright (c) 2008-2012 www.ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCControl;// Imports states


class RCButtonRadio extends RCButton {
	
	var toggable_ :Bool;
	public var toggable (getToggable, setToggable) :Bool;// Button can toggle it's state from NORMAL to SELECTED
	
	public function new (x, y, skin:RCSkin) {
		super (x, y, skin);
		toggable_ = true;
	}
	override function mouseDownHandler (e:EVMouse) :Void {
		//setState ( selected ? NORMAL : HIGHLIGHTED );
		onPress();
	}
	override function mouseUpHandler (e:EVMouse) :Void {
		//setState ( selected ? NORMAL : HIGHLIGHTED );
		onRelease();
	}
	override function clickHandler (e:EVMouse) :Void {
		setState ( selected ? NORMAL : SELECTED );
		onClick();
	}
	override function rollOverHandler (e:EVMouse) :Void {
		if (!selected)
			setState ( HIGHLIGHTED );
		onOver();
	}
	override function rollOutHandler (e:EVMouse) :Void {
		if (!selected)
			setState ( NORMAL );
		onOut();
	}
	
	
	/**
	 * toggle = Change the state of the button permanently to SELECTED
	 * untoggle = Change the state of the button to NORMAL
	 */
	public function getToggable () :Bool {
		return toggable_;
	}
	public function setToggable (v:Bool) :Bool {
		if (!v) setState ( NORMAL );
		return toggable_ = v;
	}
	public function toggle () :Void {
		if (toggable_) {
			setState ( SELECTED );
		}
	}
	public function untoggle () :Void {
		if (toggable_) {
			setState ( NORMAL );
		}
	}
}
