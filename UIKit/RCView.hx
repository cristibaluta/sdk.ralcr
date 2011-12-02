//
//  RCView
//
//  Created by Baluta Cristian on 2009-02-14.
//  Copyright (c) 2009-2011 http://ralcr.com. All rights reserved.
//

#if flash
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

class RCView extends Sprite {

	public var view :DisplayObjectContainer;
	public var size :RCSize; // Real size of the view
	public var center (default, setCenter) :RCPosition;
	public var clipsToBounds (default, setClipsToBounds) :Bool;
	var viewMask :Sprite;
	var lastW :Float;
	var lastH :Float;
	var caobj :CAObject;
	
	
	public function new (x, y) {
		super();
		size = new RCSize (0, 0);
		
		view = new flash.display.Sprite();
		view.addEventListener (Event.ADDED_TO_STAGE, viewDidAppear);
		view.addEventListener (Event.REMOVED_FROM_STAGE, viewDidDisappear);
		view = this;
		view.x = x;
		view.y = y;
	}
	//function viewWillAppear (_) :Void {}
	//function viewWillDisappear (_) :Void {}
	function viewDidAppear (_) :Void {}
	function viewDidDisappear (_) :Void {}
	
	
	/**
	 *  Change the color of the Sprite
	 */
	public function setColor (color:Int, ?mpl:Float=0) :Void {
		
		var red   = (color & 0xff0000) >> 16;
		var green = (color & 0xff00) >> 8;
		var blue  = color & 0xFF;
		
		view.transform.colorTransform = new flash.geom.ColorTransform ( mpl,mpl,mpl,mpl,
																		red,green,blue,view.alpha*255);
	}
	
	public function resetColor () :Void {
		view.transform.colorTransform = new flash.geom.ColorTransform  (1,	1,	1,	1,
																		0,	0,	0,	0);
	}
	
	public function setCenter (point:RCPosition) :RCPosition {
		this.center = point;
		this.view.x = Std.int (point.x - size.width/2);
		this.view.y = Std.int (point.y - size.height/2);
		return this.center;
	}
	
	public function setClipsToBounds (clip:Bool) :Bool {
		return clip;
	}
	
	
	/**
	 *  Scale methods
	 */
	public function scaleToFit (w:Int, h:Int) :Void {
		
		if (size.width/w > size.height/h && size.width > w) {
			view.width = w;
			view.height = view.width * size.height / size.width;
		}
		else if (size.height > h) {
			view.height = h;
			view.width = view.height * size.width / size.height;
		}
		else if (size.width > lastW && size.height > lastH) {
			view.width = size.width;
			view.height = size.height;
		}
		else
			resetScale();
		
		lastW = view.width;
		lastH = view.height;
	}
	
	public function scaleToFill (w:Int, h:Int) :Void {
		
		if (w/size.width > h/size.height) {
			view.width = w;
			view.height = view.width * size.height / size.width;
		}
		else {
			view.height = h;
			view.width = view.height * size.width / size.height;
		}
	}
	
	public function resetScale () :Void {
		view.width = lastW;
		view.height = lastH;
	}
	
	public function animate (obj:CAObject) :Void {
		CoreAnimation.add ( this.caobj = obj );
	}
	
	/**
	 *  This methos is usually overriten by the extension class.
	 */
	public function destroy () :Void {
		CoreAnimation.remove ( caobj );
		view.removeEventListener (Event.ADDED_TO_STAGE, viewDidAppear);
		view.removeEventListener (Event.REMOVED_FROM_STAGE, viewDidDisappear);
	}
	
	
	public function removeFromSuperView () :Void {
		var parent = null;
		try{parent = view.parent; } catch (e:Dynamic) { null; }
		if (parent != null)
		if (parent.contains ( view ))
			parent.removeChild ( view );
	}
}

#elseif js

typedef RCView = JSView;

#end
