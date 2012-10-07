//
//  SKSlider.hx
//	Skins iOS
//
//  Created by Baluta Cristian on 2011-03-07.
//  Updated 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

// This class assumes that you already have the assets loaded with RCAssets

package ios;


class SKSlider extends RCSkin {
	
	public function new () {
		super ( null );
		
		var hd = RCDevice.currentDevice().dpiScale == 2 ? "@2x" : "";
		
		// Create elements without size and position because it's managed by the RCSlider component
		var sl = "Resources/ios/RCSlider/L"+hd+".png";
		var sm = "Resources/ios/RCSlider/M"+hd+".png";
		var sr = "Resources/ios/RCSlider/R"+hd+".png";
		var ss = "Resources/ios/RCSlider/Scrubber"+hd+".png";
		normal.background = new RCImageStretchable (0, 0, sl, sm, sr);
		normal.otherView = new RCImage (0, 0, ss);
		
		var sls = "Resources/ios/RCSlider/LSelected"+hd+".png";
		var sms = "Resources/ios/RCSlider/MSelected"+hd+".png";
		var srs = "Resources/ios/RCSlider/RSelected"+hd+".png";
		var sss = "Resources/ios/RCSlider/ScrubberSelected"+hd+".png";
		highlighted.background = new RCImageStretchable (0, 0, sls, sms, srs);
		highlighted.otherView = new RCImage (0, 0, sss);
		
		// Creates a transparent background for mouse hit area
		hit = new RCView (0, 0);
	}
}
