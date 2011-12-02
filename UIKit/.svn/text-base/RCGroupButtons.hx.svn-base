//
//  Grup_items
//
//  Created by Baluta Cristian on 2008-04-06.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObject;


class RCGroupButtons<T:RCControl> extends RCView {
	
	public var gapX :Null<Int>;
	public var gapY :Null<Int>;
	var constructButton :String->RCControl;
	var items :HashArray<RCControl>;
	
	dynamic public function onClick () :Void {}
	public var label :String;// currently selected item label
	
	
	public function new (x, y, gapX:Null<Int>, gapY:Null<Int>, constructor:String->RCControl) :Void {
		super (x, y);
		
		this.gapX = gapX;
		this.gapY = gapY;
		this.constructButton = constructor;
		this.items = new HashArray<RCControl>();
	}
	
	
	/**
	 * Add and remove buttons
	 */
	public function add (labels:Array<String>, ?constructor:String->RCControl) :Void {
		
		var constructorNow :String->RCControl = this.constructButton;
		
		if (Reflect.isFunction (constructor)) {
			constructorNow = constructor;
		}
		if (!Reflect.isFunction (constructorNow)) return;
		
		// push the new values into main array
		for (label in labels) {
			
			if (items.exists( label )) continue;
			
			var b = constructorNow ( label );
				b.onClick = callback (clickHandler, label);
				b.toggable = true;// All the buttons are by default toggable
			
			// set the button into hash table
			items.set( label, b);
			
			// dispatch an event that the buttons structure has changed
			this.dispatchEvent ( new GroupEvent (GroupEvent.PUSH, label, getPositionForLabel( label )) );
		}
		
		// finaly arrange all buttons and add them to stage
		keepButtonsArranged();
	}
	
	public function remove (label:String) :Void {
		//trace("REMOVE FROM HASH: "+label);
		if (items.exists( label )) {
			Fugu.safeDestroy ( items.get( label ) );
			items.remove( label );
		}
		
		// finaly arrange all buttons and add them to stage
		keepButtonsArranged();
		
		// dispatch an event that the buttons structure has changed
		this.dispatchEvent ( new GroupEvent (GroupEvent.REMOVE, label, getPositionForLabel( label )) );
	}
	
	public function update (labels:Array<String>, ?constructor:String->RCControl) :Void {
		// Delete the old buttons
		destroy();
		// Recreate the array
		items = new HashArray<RCControl>();
		// Add the new buttons
		add (labels, constructor);
	}
		
	
	/**
	 *	Keep all the buttons arranged after an update operation
	 */
	public function keepButtonsArranged () :Void {
		
		// iterate over buttons
		for (i in 0...items.array().length) {
			var newX = 0.0, newY = 0.0;
			var new_b = items.get ( items.array()[i] );
			var old_b = items.get ( items.array()[i-1] );
			
			if (i != 0) {
				if (gapX != null) newX = old_b.x + old_b.width + gapX;
				if (gapY != null) newY = old_b.y + old_b.height + gapY;
			}
			
			new_b.x = newX;
			new_b.y = newY;
			
			this.addChild ( new_b );
		}
		
		this.dispatchEvent ( new GroupEvent (GroupEvent.UPDATED, null, -1));
	}
	
	public function getPositionForLabel (label:String) :Int {
		for (i in 0...items.arr.length)
			if (items.arr[i] == label)
				return i;
				return -1;
	}
	
	
	/**
	 * Select the currently pressed button
	 * unselect = if set to true, keep selected only the pressed button
	 * otherwise 
	 */
	public function select (label:String, ?can_unselect:Bool=true) :Void {
		
		this.label = label;
		
		if (items.exists( label )) {
			// Select the current label
			items.get( label ).toggle();

			if (can_unselect)
				items.get( label ).lock()
			else
				items.get( label ).unlock();
		}
		
		// Unselect other labels
		if (can_unselect)
			for (key in items.keys())
				if (key != label)
					if (items.get( key ).toggable)
						unselect ( key );
	}
	
	public function unselect (label:String) :Void {
		items.get( label ).unlock();
		items.get( label ).untoggle();
	}
	
	public function toggled (label:String) :Bool {
		return items.get( label ).toggled;
	}
	
	/**
	 *	Returns a reference to a specified button
	 *	Usefull if you want to change it's properties
	 */
	public function get (label:String) :RCControl {
		return items.get( label );
	}
	
	/**
	 *	Checks if a specified key exists already
	 */
	public function exists (key:String) :Bool {
		return items.exists( key );
	}
	
	
	/**
	 *	Enable or disable a button to be clicked
	 */
	public function enable (label:String) :Void {
		items.get( label ).unlock();
		items.get( label ).alpha = 1;
	}
	public function disable (label:String) :Void {
		items.get( label ).lock();
		items.get( label ).alpha = 0.4;
	}
	
	
	/**
	 * Dispatch events
	 */
	function clickHandler (label:String) :Void {
		this.label = label;
		this.dispatchEvent ( new GroupEvent (GroupEvent.CLICK, label, getPositionForLabel( label )) );
		onClick();
	}
	
	
	override public function destroy () :Void {
		if (items != null)
		for (key in items.keys()) Fugu.safeDestroy ( items.get( key ) );
			items = null;
	}
}
