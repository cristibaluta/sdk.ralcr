//
//  RCTabBar.hx
//	UIKit
//	A group of RCTabBarItem's aligned horiz
//
//  Created by Baluta Cristian on 2012-02-02.
//  Copyright (c) 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCTabBar extends RCGroup<RCTabBarItem> {
	
	public var selectedItem :RCTabBarItem;
	public var selectedIndex (getIndex, setIndex) :Int;
	public var didSelectItem :RCSignal<RCTabBarItem->Void>;// called when a new view is selected by the user (but not programatically)
	var constructor2_ :Int->RCTabBarItem;// RCGroup already have a constructor
	var selectedIndex_ :Int;
	var background :RCRectangle;
	
	
	public function new (x, y, w:Float, h:Float, constructor2_:Int->RCTabBarItem) {
		
		this.constructor2_ = constructor2_;
		this.selectedIndex_ = -1;
		didSelectItem = new RCSignal<RCTabBarItem->Void>();
		
		super (x, y, 2, null, constructButton);
		size.width = w;
		size.height = h;
		
		// Draw background
		background = new RCRectangle (0, 0, this.size.width, this.size.height, 0x222222);
		background.addChild ( new RCRectangle (0, this.size.height/2, this.size.width, this.size.height/2, 0x000000) );
		this.addChild ( background );
	}
	function constructButton (indexPath:RCIndexPath) :RCTabBarItem {
		var but:RCTabBarItem = constructor2_ ( indexPath.row );
			but.click.add ( clickHandler );
		return but;
	}
	function clickHandler (s:EVMouse) :Void {
		selectedItem = cast s.target;
		didSelectItem.dispatch ( selectedItem );
	}
	
	
	public function getIndex () :Int {
		return selectedIndex_;
	}
	public function setIndex (i:Int) :Int {trace(items);
		if (items == null) return selectedIndex_;
		trace("setIndex "+i);trace(selectedIndex_);
		if (selectedIndex_ > -1)
		items[selectedIndex_].untoggle();
		selectedIndex_ = i;
		items[selectedIndex_].toggle();
		return selectedIndex_;
	}
	
	public function enable (i:Int) :Void {
		items[i].enabled = true;
		items[i].alpha = 1;
	}
	public function disable (i:Int) :Void {
		items[i].enabled = false;
		items[i].alpha = 0.4;
	}
	
	override public function keepItemsArranged () :Void {
		
		// The gap between the left corners of 2 items
		gapX = Math.round ( size.width / items.length );
		
		// iterate over items
		for (i in 0...items.length) {
			items[i].x = i*gapX;
			items[i].y = 2;
		}
		update.dispatch();
	}
	
	
	override public function toString () :String {
		return "[RCTabBar selectedIndex:"+selectedIndex_+"]";
	}
	
}
