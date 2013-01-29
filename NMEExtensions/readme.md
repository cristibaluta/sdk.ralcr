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
	


###CocosDenshion

CocosDenshion is an extension for playing sounds on ios. The library is from Cocos2D and performs very well. Read all about CocosDenshion here http://cocos2d-iphone.org/wiki/doku.php/cocosdenshion%3afaq

Use this command line to convert to caff format

	afconvert -f caff -d ima4 mysound.wav