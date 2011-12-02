//
//  RCTabBarController
//
//  Created by Baluta Cristian on 2011-08-18.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import Shortcuts;


class TabBarController extends Sprite {
	
	inline static var LABELS = ["Info", "Bio", "Bauturi", "Rezultate"];
	inline static var SYMBOLS = ["SymbolInfo", "SymbolBio", "SymbolDrinks", "SymbolAlarm"];
	
	var buttons :RCGroupButtons<RCButton>;
	dynamic public function onClick () :Void;
	public var selectedIndex (getIndex, setIndex) :Int;
	public var viewControllers :Array<Dynamic>;
	public var h :Int;
	
	
	public function new(x, y){
		super();
		this.x = x;
		this.y = y;
		this.h = 98;
		viewControllers = new Array<Dynamic>();
		
		this.addChild ( new RCRectangle (0, 0, 640, 49, 0x222222) );
		this.addChild ( new RCRectangle (0, 49, 640, 49, 0x000000) );
		
		buttons = new RCGroupButtons<RCButton> (0, 3, 6, null, constructButton);
		buttons.add ( ["0", "1", "2", "3"] );
		buttons.addEventListener (GroupEvent.CLICK, clickHandler);
		this.addChild ( buttons );
	}
	function constructButton (nr:String) :RCButton {
		var i = Std.parseInt ( nr );
		var s = new SkinButtonTabBar ( LABELS[i], SYMBOLS[i], null );
		var b = new RCButton (0, 0, s);
			b.toggable = true;
		return b;
	}
	function clickHandler (e:GroupEvent) :Void {
		setIndex ( e.index );
		onClick();
	}
	
	
	public function getIndex () :Int {
		return selectedIndex;
	}
	public function setIndex (i:Int) :Int {
		buttons.select ( Std.string(i) );
		selectedIndex = i;
		return getIndex();
	}
	
	
	public function enable (i:Int) :Void {
		buttons.enable( Std.string(i) );
	}
	public function disable (i:Int) :Void {
		buttons.disable( Std.string(i) );
	}
	
	
	public function getViewController (i:Int) :Dynamic {
		return viewControllers[i];
	}
	public function setViewController (i:Int, view:Dynamic) :Void {
		if (viewControllers[i] == null)
			viewControllers[i] = view;
	}
	
}
