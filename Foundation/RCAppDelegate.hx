//
//  RCAppDelegate.hx
//	Your application main should extend this class
//
//  Created by Cristi Baluta on 2010-05-14.
//  Copyright (c) 2010-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCAppDelegate extends RCView {
	
	public function new () {
		
		// The RCWindow should be initialized before everything else
		RCWindow.sharedWindow();
		
		super (0, 0);
		
		RCNotificationCenter.addObserver ("resize", resize);
		RCNotificationCenter.addObserver ("fullscreen", fullscreen);
		
		applicationDidFinishLaunching();
		
		#if (nme && (cpp || neko))
			RCWindow.sharedWindow().stage.onQuit = applicationWillTerminate;
		#end
	}
	
	// Override this methods
	public function applicationDidFinishLaunching () :Void {}
	public function applicationDidBecomeActive () :Void {}
	public function applicationWillEnterForeground () :Void {}
	public function applicationWillTerminate () :Void {
		trace("applicationWillTerminate");
		#if (nme && (cpp || neko))
			nme.Lib.close();
		#end
	}
	public function resize (w:Float, h:Float) :Void {}
	public function fullscreen (b:Bool) :Void {}
}
