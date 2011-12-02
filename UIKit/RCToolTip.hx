//
//  Tooltip
//
//  Created by Baluta Cristian on 2008-09-05.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
import flash.events.MouseEvent;


class RCToolTip extends RCAlertView {
	
	var target :Dynamic;
	
	
	public function new (skin:RCSkin) {
		super (skin);
	}
	
	public function followMouse (parent:Dynamic) :Void {
		if (parent == null) return;
		target = parent;
		target.addEventListener (MouseEvent.MOUSE_MOVE, dragHandler);
		//dragHandler ( null );
	}
	public function stopFollow () :Void {
		target.removeEventListener (MouseEvent.MOUSE_MOVE, dragHandler);
	}
	
	
	function dragHandler (e:MouseEvent) :Void {
		if (target == null) return;
		this.x = target.mouseX;
		this.y = target.mouseY;
		e.updateAfterEvent();
	}
	
	
	override public function destroy () :Void {
		stopFollow();
	}
}
