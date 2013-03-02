//
//	RCViewController.hx
//	UIKit
//
/*
	RCViewController is the controller of the MVC pattern. When you build a controller you should extend RCViewController
	RCViewController is also a RCView, so you can add it to stage easily.
	
	TODO: notify the controller that the device orientation has changed
*/
import RCDevice;


class RCViewController extends RCView {
	
	
	public function new (x, y, ?w, ?h) {
		
		super (x, y, w, h);
		
		RCNotificationCenter.addObserver ("orientationWillChange", orientationWillChange);
		RCNotificationCenter.addObserver ("orientationChanged", orientationChanged);
	}
	
	function orientationWillChange () {
	}
	function orientationChanged () {
	}
	
	// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
	public function shouldAutorotateToInterfaceOrientation (toOrientation :RCDeviceOrientation) :Bool {
		return true;
	}
	
	
	
	/**
	*  Add a view on top of everything with an animation from bottom to top.
	*  A modalView can be added to any controller, but underneath is added to the RCWindow
	*  So you can also use RCWindow.sharedWindow().addModalViewController ( view );
	**/
	public function addModalViewController (view:RCModalViewController) :Void {
		RCWindow.sharedWindow().addModalViewController ( view );
	}
	/**
	 *  Remove the modalView with an animation from top to bottom then destroy it
	 **/
	public function dismissModalViewController () :Void {
		RCWindow.sharedWindow().dismissModalViewController();
	}
	
	
	
	override public function destroy () :Void {
		RCNotificationCenter.removeObserver ("orientationWillChange", orientationWillChange);
		RCNotificationCenter.removeObserver ("orientationChanged", orientationChanged);
		super.destroy();
	}
}
