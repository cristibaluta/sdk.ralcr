//
//  RCTabBarController
//
//  Created by Baluta Cristian on 2011-06-09.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCTabBarController extends RCView {
	
	var labels :Array<String>;
	var symbols :Array<String>;
	var controllers :Array<Class<Dynamic>>;
	var constructor_ :Int->RCTabBarItem;
	
	public var placeholder :RCView;
	public var tabBar :RCTabBar;
	public var viewControllers :Array<RCView>;
	public var selectedIndex (getIndex, setIndex) :Int;
	
	public var didSelectViewController :RCSignal<Dynamic->Void>;
	
	
	public function new (x, y, w:Float, h:Float, ?constructor_:Int->RCTabBarItem) {
		
		super (x, y, w, h);
		
		this.constructor_ = (constructor_ == null) ? constructButton : constructor_;
		viewControllers = new Array <RCView>();
		didSelectViewController = new RCSignal <Dynamic->Void>();
		
		placeholder = new RCView (0, 0);
		this.addChild ( placeholder );
	}
	
	/**
	 *  Init the RCTabBarController. all arrays must have the same lengths
	 *  @param labels - Labels used for the images
	 *  @param symbols - Images used for the buttons
	 *  @param controllers - The class names of the controllers that will be instantiated when needed
	 **/
	public function initWithLabels (labels:Array<String>, symbols:Array<String>, controllers:Array<Class<Dynamic>>) {
		
		this.labels = labels;
		this.symbols = symbols;
		this.controllers = controllers;
		
		tabBar = new RCTabBar (0, size.height-50, size.width, 50, constructor_);
		this.addChild ( tabBar );
		tabBar.add ( labels );
		tabBar.didSelectItem.add ( didSelectItemHandler );
	}
	
	/**
	 *  Default constructor for the RCTabBarItem
	 *  Pass a different constructor if you want to use a custom RCTabBarItem
	 **/
	function constructButton (i:Int) :RCTabBarItem {
		var s = new ios.SKTabBarItem ( labels[i], symbols[i] );
		var b = new RCTabBarItem (0, 0, s);
		return b;
	}
	
	function didSelectItemHandler (item:RCTabBarItem) :Void {
		var i = 0;
		for (it in tabBar.items) {
			if (it == item) {
				break;
			}
			i++;
		}
		setIndex ( i );
	}
	
	
	
	/**
	 *  selectedIndex getter and setter
	 **/
	public function getIndex () :Int {
		return tabBar.selectedIndex;
	}
	public function setIndex (i:Int) :Int {
		trace("setIndex "+i);
		if (tabBar.selectedIndex == i) return i;// Can't select twice the same element
		
		tabBar.setIndex ( i );
		
		var view = getViewController(i);
		if (view == null) try{
			view = Type.createInstance ( controllers[i], [] );
			setViewController (i, view);
		}
		catch(e:Dynamic){ trace(e); Fugu.stack(); }
		
		Fugu.safeRemove ( viewControllers );
		placeholder.addChild ( view );
		didSelectViewController.dispatch ( view );
		
		return i;
	}
	
	
	public function enable (i:Int) :Void {
		tabBar.enable( i );
	}
	public function disable (i:Int) :Void {
		tabBar.disable( i );
	}
	
	
	public function getViewController (i:Int) :Dynamic {
		return viewControllers[i];
	}
	public function setViewController (i:Int, view:Dynamic) :Void {
		if (viewControllers[i] == null)
			viewControllers[i] = view;
	}
}
