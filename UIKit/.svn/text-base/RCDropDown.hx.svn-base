//
//  DropDown is a group of buttons that are masked and only the selected one is shown
//	When you click it all values drops down and you can select a new value
//
//  Created by Baluta Cristian on 2008-07-23.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;


class RCDropDown<T:RCControl> extends Sprite {
	
	var background :DisplayObjectContainer;
	var scrollView :RCScrollView;
	
	var container_mc :Sprite;
	var mask_mc :DisplayObjectContainer;
	var open_but :DisplayObjectContainer;// symbol from Skin
	var selected_but :T;
	var group :RCGroupButtons<T>;
	
	var labels :Array<String>;
	var w :Int;
	var h :Int;
	var maxLines :Int; // max number of lines that should display when opening the drop down
	var button :String->T;
	
	public var label :String; // selected label
	dynamic public function dropDownDidOpen():Void {}
	dynamic public function dropDownDidClose():Void {}
	dynamic public function onClick():Void {}
	
	
	public function new (x, y, w:Int, h:Int, maxLines:Int, labels:Array<String>, skin:RCSkin, button:String->T) {
		super();
		
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.maxLines = maxLines;
		this.button = button;
		this.labels = labels;
		
		background = skin.background;
		open_but = skin.up; // use the symbol as a button
		mask_mc = skin.hit; // use the hitArea as a mask over container_mc
		
		// add selected value
		select ( labels[0] );
	}
	
	
	/**
	 * Add the button with the current label
	 */
	public function select (label:String) :Void {
		clean();
		this.label = label;
		
		selected_but = this.button (label);
		selected_but.onClick = addDropDown;
		
		this.addChild (selected_but);
		//this.addChild (open_but);
	}
	
	function addDropDown () :Void {
		clean();
		dropDownDidOpen();
		
		container_mc = new Sprite();
		container_mc.addChild (background);
		this.addChild (container_mc);
		this.addChild (mask_mc);
		container_mc.mask = mask_mc;
		
		group = new RCGroupButtons<T> (0, 0, null, 0, this.button);
		group.add (labels);
		group.addEventListener (GroupEvent.CLICK, onClickHandler);
		container_mc.addChild (group);
		
		// resize the background and the mask if is bigger than the group height
		if (group.height < background.height) {
			background.height = group.height;
			mask_mc.height = group.height;
		}
		
		mask_mc.y = -mask_mc.height;
		//Tweener.addTween (mask_mc, {y:0, time:0.4});
		
		container_mc.addEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler);
		
	}
	function onClickHandler (e:GroupEvent) :Void {trace(e.label);
		select (e.label);
	}
	
	function mouseOverHandler (e:MouseEvent) :Void {trace("over");
		container_mc.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		container_mc.addEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
	}
	function mouseOutHandler (e:MouseEvent) :Void {trace("mouesout");
		clean();
		select (label);
	}
	function mouseMoveHandler (e:MouseEvent) :Void {
		var xm1 = 10;
		var xm2 = background.height - 10;
		var xm  = background.mouseY;
		if (xm < xm1) xm = xm1;
		if (xm > xm2) xm = xm2;
		var x1  = 0;
		var x2  = x1 - group.height + background.height;
		
		group.y = Zeta.lineEquationInt (x1,x2, xm,xm1,xm2);
	}
	
	
	// clean mess
	function clean () :Void {
		if (container_mc != null) {
			container_mc.removeEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler);
			container_mc.removeEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
			container_mc.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		Fugu.safeRemove ([container_mc, mask_mc, background]);
		Fugu.safeDestroy (group);
		Fugu.safeRemove (selected_but);
		group = null;
		selected_but = null;
		container_mc = null;
	}
	
	public function destroy () :Void {
		clean();
	}
}
