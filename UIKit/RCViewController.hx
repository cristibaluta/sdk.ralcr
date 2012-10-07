//
//	RCViewController.hx
//	UIKit
//

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
	
	override public function destroy () :Void {
		RCNotificationCenter.removeObserver ("orientationWillChange", orientationWillChange);
		RCNotificationCenter.removeObserver ("orientationChanged", orientationChanged);
		super.destroy();
	}
}