//
//  CustomCursor
//
//  Created by Baluta Cristian on 2008-12-29.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;


class RCCustomCursor extends Sprite {
	
	var target :Dynamic;
	var cursor :Dynamic;
	
	
	public function new (target:Dynamic){
		super();
		this.target = target;
		
		//Stage.MC.addEventListener (Event.MOUSE_LEAVE, hideCustomCursor);
		target.addEventListener (MouseEvent.MOUSE_MOVE, moveHandler);
	}
	
	public function draw (obj:Dynamic) :Void {
		// Remove the current cursor
		Fugu.safeRemove ( cursor );
		
		// Add the new cursor
		cursor = obj;
		cursor.mouseEnabled = false;
		Fugu.safeAdd (this, cursor);
		this.mouseEnabled = false;
		Mouse.hide();
	}
	
	
	function moveHandler (e:MouseEvent) :Void {
		//if (!cursor.visible) cursor.visible = true;
		this.x = e.stageX;
		this.y = e.stageY;
		e.updateAfterEvent();
	}
	function hideCustomCursor (event:Event) :Void {
		cursor.visible = false;
	}
	
	public function destroy () :Void {
		Mouse.show();
		//Stage.MC.removeEventListener (Event.MOUSE_LEAVE, hideCustomCursor);
		target.removeEventListener (MouseEvent.MOUSE_MOVE, moveHandler);
	}
}