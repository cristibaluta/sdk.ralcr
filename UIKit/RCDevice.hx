//
//  RCDevice.hx
//  UIKit
//
//  Updated 2012, ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

enum RCDeviceOrientation {
    UIDeviceOrientationUnknown;
    UIDeviceOrientationPortrait;            // Device oriented vertically, home button on the bottom
    UIDeviceOrientationPortraitUpsideDown;  // Device oriented vertically, home button on the top
    UIDeviceOrientationLandscapeLeft;       // Device oriented horizontally, home button on the right
    UIDeviceOrientationLandscapeRight;      // Device oriented horizontally, home button on the left
    UIDeviceOrientationFaceUp;              // Device oriented flat, face up
    UIDeviceOrientationFaceDown;            // Device oriented flat, face down
}

enum RCDeviceType {
    IPhone;
    IPad;
    IPod;
	Android;
	WebOS;
	Mac;
	Flash;
	Playstation;
	Other;
}
enum RCUserAgent {
	MSIE;
	MSIE9;
	GECKO;
	WEBKIT;
	OTHER;
}


class RCDevice {
	
	static var _currentDevice :RCDevice;
	public static function currentDevice () :RCDevice {
		if (_currentDevice == null)
			_currentDevice = new RCDevice();
		return _currentDevice;
	}
	
	
	public var name :String;// e.g. "My iPhone"
	public var model :String;// e.g. @"iPhone", @"iPod touch"
	public var systemName :String;// e.g. @"iOS"
	public var systemVersion :String;// e.g. @"5.0"
	public var orientation :RCDeviceOrientation;
	public var userInterfaceIdiom :RCDeviceType;
	public var uniqueIdentifier :String;// a string unique to each device based on various hardware info.
	public var dpiScale :Float;
	public var userAgent :RCUserAgent;
	
	
	public function new ()
	{
		#if (cpp || neko)
			dpiScale = flash.Lib.current.stage.dpiScale;
		#else
			dpiScale = 1;
			#if js
				userAgent = detectUserAgent();
				userInterfaceIdiom = detectUserInterfaceIdiom();
			#end
		#end
	}

#if js
	
	function detectUserAgent() :RCUserAgent {
		
		var agent = js.Lib.window.navigator.userAgent.toLowerCase();
		if (agent.indexOf("msie") > -1) return MSIE;
		if (agent.indexOf("msie 9.") > -1) return MSIE9;
		if (agent.indexOf("webkit") > -1) return WEBKIT;
		if (agent.indexOf("gecko") > -1) return GECKO;
			 
		return OTHER;
	}
	function detectUserInterfaceIdiom() :RCDeviceType {
		
		var agent = js.Lib.window.navigator.userAgent.toLowerCase();
		if (agent.indexOf("iphone") > -1) return IPhone;
		if (agent.indexOf("ipad") > -1) return IPad;
		if (agent.indexOf("ipod") > -1) return IPod;
		if (agent.indexOf("playstation") > -1) return Playstation;
		
		return Other;
	}
	
#end

}
