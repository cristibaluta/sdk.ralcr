//
//  Pano2VR
//
//  Created by Baluta Cristian on 2009-07-23.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
/* API:
	vr.pano.cleanup();
	<panoclip>.pano.setWindowSize(<width>,<height>); - sets the current panorama window size
	<panoclip>.pano.setWindowPos(<x>,<y>); - sets the panorama window position
*/
import flash.events.Event;
import flash.display.MovieClip;


class Pano2VR extends RCImage {
	
	var vr :Dynamic;// main MovieClip from loaded swf
	
	
	public function new (x, y, w:Int, h:Int, URL:String) {
		super (x, y, URL);
		
		loader.contentLoaderInfo.addEventListener (Event.INIT, initHandler);
		this.addEventListener (Event.ENTER_FRAME, initPanorama);
	}
	
	// do not bitmapize the swf
	override function completeHandler (e:Event) :Void {}
	
	
	function initHandler (e:Event) :Void {
		this.addChild ( loader );
		isLoaded = true;
		
		vr = cast (loader.content, flash.display.MovieClip);
		vr.isFlash10 = false;
	}
	
	function initPanorama (e:Event) {
		// check if the panorama object is available and initialize it
		if (vr != null)
		if (vr.pano != null) {
			this.removeEventListener (Event.ENTER_FRAME, initPanorama);
			// pano2vr specific methods
			vr.pano.setWindowSize (w, h);
			vr.pano.setWindowPos (0, 0);
			
			//onComplete();
			haxe.Timer.delay (wait, 1000);
		}
	}
	
	function wait() {
		onComplete();
	}
	
	
	override public function destroy() :Void {
		removeListeners();
		loader.contentLoaderInfo.removeEventListener (Event.INIT, initHandler);
		this.removeEventListener (Event.ENTER_FRAME, initPanorama);
		
		// Remove any resource from swf if a cleanup method exists
		try {
			vr.pano.cleanup();
		}
		catch (e:Dynamic) {
			trace (e);
		}
		
		//loader.close();
		loader.unload();
		loader = null;
	}
}
