//
//  RCApplication
//
//  Created by Cristi Baluta on 2010-05-14.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
#if flash
import flash.display.MovieClip;
#elseif js
typedef MovieClip = JSView;
#end

class RCAppDelegate extends MovieClip {
	
	dynamic public function applicationDidLaunch () :Void {}
	dynamic public function onDataLoaded () :Void {}
	dynamic public function onInit () :Void {}
	
	
	public function new () {
		super();
		
		// The RCStage should be initialized before anything
		RCStage.init();
		RCNotificationCenter.addObserver ("resize", resize);
		RCNotificationCenter.addObserver ("fullscreen", fullscreen);
		
		applicationDidFinishLaunching();
	}
	
	// Override this methods
	public function applicationDidFinishLaunching () :Void {}
	public function resize (w:Int, h:Int) :Void {}
	public function fullscreen () :Void {}
}
