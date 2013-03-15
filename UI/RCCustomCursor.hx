//
//  RCCustomCursor.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-12-29.
//  Copyright (c) 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme || cpp || neko)
	import flash.ui.Mouse;
#elseif js
	//import js.html.DivElement;
#end


class RCCustomCursor extends RCView {
	
	var target :Dynamic;
	var cursor :Dynamic;
	var mouseMove :EVMouse;
	
	
	public function new (target:Dynamic) {
		
		super (0, 0);
		
		this.target = target;
		
		//Stage.MC.addEventListener (Event.MOUSE_LEAVE, hideCustomCursor);
		mouseMove = new EVMouse (EVMouse.MOVE, target);
		mouseMove.add ( moveHandler );
	}
	
	/**
	 *  Use an object as a custom cursor
	 *  @param obj : for flash can be a RCView, for js should be a String path to an image
	 **/
	public function draw (obj:Dynamic) :Void {
		
		#if (flash || nme || cpp || neko)
			Fugu.safeRemove ( cursor );
			cursor = obj;
			cursor.layer.mouseEnabled = false;
			Fugu.safeAdd (this, cursor);
			layer.mouseEnabled = false;
			Mouse.hide();
		#elseif js
			//js.Browser.document.body.style.cursor = "none";
			var x = 0, y=0;
			js.Browser.document.body.style.cursor = "url(" + obj + ") " + x +" " + y +", auto";
		#end
	}
	
	
	function moveHandler (e:EVMouse) :Void {
		//if (!cursor.visible) cursor.visible = true;
		#if (flash || nme || cpp || neko)
			set_x ( e.e.stageX );
			set_y ( e.e.stageY );
			e.updateAfterEvent();
		#end
	}
/*	function hideCustomCursor (event:Event) :Void {
		cursor.visible = false;
	}*/
	
	override public function destroy () :Void {
		
		#if (flash || nme || cpp || neko)
			Mouse.show();
		#elseif js
			js.Browser.document.body.style.cursor = "auto";
		#end
		
		//Stage.MC.removeEventListener (Event.MOUSE_LEAVE, hideCustomCursor);
		mouseMove.destroy();
		super.destroy();
	}
}