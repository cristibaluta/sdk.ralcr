//
//	RCViewController.hx
//	UIKit
//
/*
	RCViewController is the controller of the MVC pattern. When you build a controller you should extend RCViewController
	RCViewController is also a RCView, so you can add it to stage easily.
	
	TODO: notify the controller that the device orientation has changed
*/

class RCModalViewController extends RCViewController {
	
	/**
	 *  Override this method to get notified when the modalView did finished it's fade in animation
	 *  Useful if you want to add some intensive operations that will slow down the animation
	 *  Or if you want to add a native NME ios view that can't be added as a modalView child
	 **/
	public function modalViewDidAppear () :Void {
		
	}
	
	/**
	 *  Called before the disappearing animation will start
	 **/
	public function modalViewWillDisappear () :Void {
		
	}
}
