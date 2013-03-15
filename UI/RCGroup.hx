//
//  RCGroup.hx
//	UIKit
//	This component will align a collection of views horizontally or vertically or in a matrix
//	Matrix is not suported yet
//
//  Created by Cristi Baluta on 2011-02-08.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCGroup<T:RCView> extends RCView {
	
	public var items :Array<T>;
	var constructor_ :RCIndexPath->T;// Javascript conflict names
	var gapX :Null<Int>;
	var gapY :Null<Int>;
	
	public var itemPush :RCSignal<RCIndexPath->Void>;
	public var itemRemove :RCSignal<RCIndexPath->Void>;
	public var update :RCSignal<RCGroup<T>->Void>;
	
	
	public function new (x, y, gapX:Null<Int>, gapY:Null<Int>, constructor_:RCIndexPath->T) {
		
		super (x, y);
		
		this.gapX = gapX;
		this.gapY = gapY;
		this.constructor_ = constructor_;
		this.items = new Array<T>();
		itemPush = new RCSignal<RCIndexPath->Void>();
		itemRemove = new RCSignal<RCIndexPath->Void>();
		update = new RCSignal<RCGroup<T>->Void>();
	}
	
	
	/**
	 *	Add items
	 *	@param params =
	 */
	public function add (params:Array<Dynamic>, ?alternativeConstructor:RCIndexPath->T) :Void {
		
		if (!Reflect.isFunction (constructor_) && !Reflect.isFunction (alternativeConstructor)) return;
		if (alternativeConstructor != null) this.constructor_ = alternativeConstructor;
		if (constructor_ == null) throw "RCGroup needs passed a constructor function.";
		
		// Push the new values into the array
		var i = 0;
		for (param in params) {
			
			// Create a new sprite with the passed function
			var s :T = this.constructor_ ( new RCIndexPath (0, i) );
			this.addChild ( s );
			items.push ( s );
			cast(s).init();
			
			// dispatch an event that the buttons structure has changed
			itemPush.dispatch ( new RCIndexPath (0, i) );
			i++;
		}
		
		// Keep all items arranged
		keepItemsArranged();
	}
	
	public function remove (i:Int) :Void {
		
		Fugu.safeDestroy ( items[i] );
		
		keepItemsArranged();
		
		// dispatch an event that the buttons structure has changed
		itemRemove.dispatch ( new RCIndexPath (0, i) );
	}
	
	
	/**
	 *	Keep all the items arranged after an update operation
	 */
	public function keepItemsArranged () :Void {
		
		// iterate over items
		for (i in 0...items.length) {
			var newX = 0.0, newY = 0.0;
			var new_s = items[i];
			var old_s = items[i-1];
			
			if (i != 0) {
				//if (gapX != null) newX = old_s.x + cast(old_s).skin.normal.background.size.width + gapX;
				if (gapX != null) newX = old_s.x + old_s.width + gapX;
				if (gapY != null) newY = old_s.y + old_s.height + gapY;
			}
			
			new_s.x = newX;
			new_s.y = newY;
			//size.width = newX + cast(new_s).skin.normal.background.size.width;
			size.width = newX + new_s.size.width;
			size.height = newY + new_s.size.height;
		}
		update.dispatch( this );
	}
	
	
	/**
	 *	Returns a reference to a specified view by index
	 *	Usefull if you want to change it's properties
	 */
	public function get (i:Int) :T {
		return items[i];
	}
	
	
	/**
	 *	Returns an array with items but marked as Dynamic
	 *	because RCView will not contain the neccesary methods needed by the code
	 */
		 // problems with cpp
/*	public function getIterator<T>() :Array<T> {
		var typedItems = new Array<T>();
		for (s in items)
			typedItems.push ( cast(s, T) );
			
		return typedItems;
	}*/
	
	
	override public function destroy() :Void
	{
		Fugu.safeDestroy ( items );
		items = null;
		super.destroy();
	}
}
