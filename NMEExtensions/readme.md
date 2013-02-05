## Overview

The extensions started from nmex and some of them kept a part of its native code. It contains:
For ios: ActivityIndicator, AlertView, WebView, SimpleAudioEngine
For android: Nothing yet

## Recompile

If you make some changes to the sources you need to recompile. The commands are for armv7, armv6 and simulator:

	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphonesim

To compile them all in one step use

	./build.sh

If you've added a new extension and is using some framework that NME does not include by default you have to add them as dependencies to the nmml file of your project or better to the include.nmml of NMEExtensions

	<dependency name="GameKit.framework" if="ios"/>
	<dependency name="StoreKit.framework" if="ios"/>
	

##About extensions

###ActivityIndicator
It adds a spinning style loading indicator. You can specify the position on screenwith the center on the wheel, you can set if it's white (if it's not white it's gray), and if it's white you can specify if it's large or not.

	new NMEActivityIndicator (x, y, white:Bool=false, large:Bool=false);
	
###WebView
You can create a native UIWebView at a specified position and size, and you can listen for a signal event when the page was loaded, which returns its URL

	var w = new NMEWebView (x:Float, y:Float, w:Float, h:Float, url:String);
	w.didFinishLoad.add( function(e){trace(e);} );

###AlertView
You can only set a UIAlertView with a title, a description and an OK button

	new NMEAlertView (title:String, message:String);

###CocosDenshion
CocosDenshion is an extension for playing sounds on ios. The library is from Cocos2D framework and performs very well. Read all about CocosDenshion here http://cocos2d-iphone.org/wiki/doku.php/cocosdenshion%3afaq

Due to the way NME handles resources, there's a low level C call in CocosDenshion that fails for files without extension, and NME resources are files without extensions. This happens only for effect sounds but here is a workaround to fix it:
* Do not add your sounds through NME
* Use the sounds in your app with their full name

		NMESimpleAudioEngine.preloadBackgroundMusic("background_music.mp3");

* Compile the app for ios. At this point there will be no sound because you didn't add them
* Open the xcode project with
	
		nme update ios
	
* Add your sounds to xcode and press the build and run button.
Now you have sound. The good news is that the next time you compile the app the sounds will not be removed, so you don't need to repeat the steps 4 and 5. Unless you remove it from the device and will be a fresh install of course.

Not sure which audio formats are the best yet but i use caff. Use this osx command line to convert to caff format

	afconvert -f caff -d ima4 mysound.wav

###Https
In NME URLRequest does not work when using POST

In haxe.Http for cpp the Https requests are not working at all

This extension solves all the troubles on ios

(Feb 1 2013)

		var h = new NMEHttps();
		h.call (url:String, variables:Dynamic, ?method:String="GET");
		h.didFinishLoad.add( function(e){trace(e);} );
		h.didFinishWithError.add( function(e){trace(e);} );
		