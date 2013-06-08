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
	//Flash;
	Playstation;
	Other;
}
enum RCUserAgent {
	MSIE;
	MSIE9;
	GECKO;
	WEBKIT;
	PRESTO;
	OTHER;
}

class RCDevice {
	
	static var _currentDevice :RCDevice;
	public static function currentDevice () :RCDevice {
		if (_currentDevice == null)
			_currentDevice = new RCDevice();
		return _currentDevice;
	}
	
	
	//public var name :String;// e.g. "My iPhone"
	//public var model :String;// e.g. @"iPhone", @"iPod touch"
	//public var systemName :String;// e.g. @"iOS"
	//public var systemVersion :String;// e.g. @"5.0"
	public var language (get, null) :String;
	public var orientation (get, null) :RCDeviceOrientation;
	public var type :RCDeviceType;
	//public var uniqueIdentifier :String;// a string unique to each device based on various hardware info.
	public var dpiScale :Float;
	public var userAgent :RCUserAgent;
	
	
	public function new () {
		
		#if (cpp || neko)
			dpiScale = flash.Lib.current.stage.dpiScale;
			#if iphone
				type = IPhone;
			#elseif android
				type = Android;
			#end
		#elseif objc
			dpiScale = 1;
			type = #if ios IPhone #elseif osx Mac #end;
		#else
			dpiScale = 1;
			#if js
				//dpiScale = untyped js.Browser.window.devicePixelRatio;
				userAgent = detectUserAgent();
				type = detectType();
			#end
		#end
	}
	
	public function isTouch() :Bool {
		#if js
		untyped __js__("return !!('ontouchstart' in window) // works on most browsers 
	      || !!('onmsgesturechange' in window); // works on ie10");
		#elseif objc
			return true;
		#end
		return false;
	}
	
	public function get_language () :String {
		#if (flash || nme)
			return flash.system.Capabilities.language;
		#elseif js
			return js.Browser.window.navigator.language.substr(0, 2).toLowerCase();
		#elseif objc
			return NSLocale.preferredLanguages[0];
		#end
	}
	public function get_orientation () :RCDeviceOrientation {
		return UIDeviceOrientationPortrait;
	}

#if js
	
	function detectUserAgent() :RCUserAgent {
		//Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17
		//Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0.1 
		//Opera/9.80 (Macintosh; Intel Mac OS X 10.7.5; U; en) Presto/2.10.289 Version/12.02
		//Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.52 Safari/537.17
		var agent = js.Browser.window.navigator.userAgent.toLowerCase();
		if (agent.indexOf("msie") > -1) return MSIE;
		if (agent.indexOf("msie 9.") > -1) return MSIE9;
		if (agent.indexOf("webkit") > -1) return WEBKIT;
		if (agent.indexOf("gecko") > -1) return GECKO;
		if (agent.indexOf("presto") > -1) return PRESTO;// Opera
		
		return OTHER;
	}
	function detectType() :RCDeviceType {
		
		var agent = js.Browser.window.navigator.userAgent.toLowerCase();
		if (agent.indexOf("iphone") > -1) return IPhone;
		if (agent.indexOf("ipad") > -1) return IPad;
		if (agent.indexOf("ipod") > -1) return IPod;
		if (agent.indexOf("android") > -1) return Android;
		if (agent.indexOf("macintosh") > -1) return Mac;
		if (agent.indexOf("playstation") > -1) return Playstation;
		
		return Other;
	}
	
#end

}
