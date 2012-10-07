//
//  RCPageControl.hx
//  UIKit
//
//  Copyright (c) 2012, ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCPageControl extends RCControl {
	
	var indicators :Array<RCView>;
	var displayedPage :Int;
	
	public var numberOfPages :Int;// default is 0
	public var currentPage :Int;// default is 0. value pinned to 0..numberOfPages-1
	public var hidesForSinglePage :Bool;// hide the indicator if there is only one page. default is NO
	public var defersCurrentPageDisplay :Bool;// if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
	
	
	public function new (x, y, w, h, ?skin:RCSkin) {
		super (x, y, w, h);
		currentPage = 0;
		hidesForSinglePage = false;
	}
	// Set here the currentPage because is called before anything else
	override function clickHandler (e:EVMouse) :Void {
		currentPage = 0;
		onClick();
	}
	
	
	// update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately
	public function updateCurrentPageDisplay () :Void {
		
	}
	// Returns minimum size required to display dots for given page count. can be used to size control if page count could change
	public function sizeForNumberOfPages (pageCount:Int) :RCSize {
		return new RCSize (0, 0);
	}
}
