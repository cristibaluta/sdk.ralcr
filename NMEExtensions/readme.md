## Overview

The extensions started from nmex but degenerated in something cleaner and better. It contains:
For ios: AlertView, WebView, SimpleAudioEngine
For android: AlertView, WebView

## Recompile

If you make some changes to the sources you need to recompile. The commands are for armv7, armv6 and simulator:

	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphonesim

To compile them all in one step use

	./build.sh
	
If it's not working you probably need to give executable access to the shell script with

	chmod 777 build.sh

If you've added a new extension and is using some framework that NME does not include by default you have to add them as dependencies to the nmml file of your project or better to the include.nmml of NMEExtensions

	<dependency name="GameKit.framework" if="ios"/>
	<dependency name="StoreKit.framework" if="ios"/>
	

##About extensions

####WebView
You can create a native UIWebView at a specified position and size, and you can listen for a signal event when the page was loaded which returns its URL

####AlertView
You can only set a UIAlertView with a title, a description and an OK button

####CocosDenshion
CocosDenshion is an extension for playing sounds on ios. The library is from Cocos2D framework and performs very well. Read all about CocosDenshion here http://cocos2d-iphone.org/wiki/doku.php/cocosdenshion%3afaq

Due to the way NME handles resources, there's a low level C call in CocosDenshion that fails for files without extension, and NME resources are files without extensions. This happens only for effect sounds but here is a workaround to fix it:
1. Do not add your sounds through NME
2. Play the sounds in your app as you normaly do by sending the name of the file
3. Compile the app for ios. At this point there will be no sound
4. Open the xcode project with
	
	nme update ios
	
5. Add your sounds to xcode and press the build and run button.
Now you have sound. The good news is that the next time you compile the app the sounds will not be removed, so you don't need to repeat the steps 4 and 5. Unless you remove it from the device and will be a fresh install of course.

Not sure which audio formats are the best yet but i use caff. Use this osx command line to convert to caff format

	afconvert -f caff -d ima4 mysound.wav