//
//  RCDropDown is a group of RCButtons that are masked and only the selected one is shown
//	When you click it all values drops down and you can select a new value
//
//  Created by Baluta Cristian on 2008-07-23.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//  Copyright (c) 2010-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCDropDown extends RCView {
	
	var background :RCRectangle;
	var scrollView :RCScrollView;
	
	var open_but :RCButton;// symbol from Skin
	
	var labels :Array<String>;
	var items :RCGroup<RCButton>;
	var currentItem :RCButton;
	
	var maxLines :Int; // max number of lines that should display when opening the drop down
	var button :String->RCButton;
	
	public var dropDownDidOpen :RCSignal<RCDropDown>;
	public var dropDownDidClose :RCSignal<RCDropDown>;
	public var itemDidSelect :RCSignal<RCDropDown->String->Void>;
	
	
	public function new (x, y, w:Int, h:Int, skin:RCSkin) {
		
		super (x, y);
		
		this.size.width = w;
		this.size.height = h;
		//
		//this.button = button;
		
		
		//background = skin.background;
		//open_but = skin.up; // use the symbol as a button
		//mask_mc = skin.hit; // use the hitArea as a mask over container_mc
		
		// add selected value
		//select ( labels[0] );
	}
	public function initWithLabels (labels:Array<String>, ?maxLines:Int=10) :Void {
		
		super.init();
		
		this.labels = labels;
		this.maxLines = maxLines;
	}
	
	/**
	 * Add the button with the current label
	 */
	public function select (label:String) :Void {
		closeDropDown();
		
		currentItem = this.button ( label );
		currentItem.onClick = openDropDown;
		this.addChild ( currentItem );
		//this.addChild (open_but);
	}
	
	public function openDropDown () :Void {
		//currentItem();
		dropDownDidOpen.dispatch ( this );
		
/*		container_mc = new Sprite();
		container_mc.addChild (background);
		this.addChild (container_mc);
		this.addChild (mask_mc);
		container_mc.mask = mask_mc;*/
		
/*		group = new RCGroupButtons<T> (0, 0, null, 0, this.button);
		group.add (labels);
		group.addEventListener (GroupEvent.CLICK, onClickHandler);
		container_mc.addChild (group);*/
		
		// resize the background and the mask if is bigger than the group height
		if (items.height < background.height) {
			background.height = items.height;
			//mask_mc.height = group.height;
		}
		
		//mask_mc.y = -mask_mc.height;
		//Tweener.addTween (mask_mc, {y:0, time:0.4});
		
		//container_mc.addEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler);
	}
	public function closeDropDown () :Void {
/*		if (container_mc != null) {
			//container_mc.removeEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler);
			//container_mc.removeEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
			//container_mc.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}*/
		
/*		Fugu.safeRemove ([container_mc, mask_mc, background]);
		Fugu.safeDestroy (group);
		Fugu.safeRemove (selected_but);
		group = null;
		selected_but = null;
		container_mc = null;*/
	}
	
	
	
	function onClickHandler (e:EVMouse) :Void {
		//select (e.label);
	}
	function mouseOverHandler (e:EVMouse) :Void {trace("over");
		//container_mc.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		//container_mc.addEventListener (MouseEvent.ROLL_OUT, mouseOutHandler);
	}
	function mouseOutHandler (e:EVMouse) :Void {trace("mouesout");
		closeDropDown();
		//select (label);
	}
	function mouseMoveHandler (e:EVMouse) :Void {
		var xm1 = 10;
		var xm2 = background.height - 10;
		var xm  = background.mouseY;
		if (xm < xm1) xm = xm1;
		if (xm > xm2) xm = xm2;
		var x1  = 0;
		var x2  = x1 - items.height + background.height;
		
		items.y = Zeta.lineEquationInt (x1,x2, xm,xm1,xm2);
	}
	
	
	// clean mess
	
	
	override public function destroy () :Void {
		closeDropDown();
		
		super.destroy();
	}
}
