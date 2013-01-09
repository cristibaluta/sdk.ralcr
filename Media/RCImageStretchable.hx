//
//	RCImageStretchable.hx
//	MediaKit
//
//	This will create a RCView from 3 images and will permit to resize it in a non destructible way

class RCImageStretchable extends RCView {
	
	var l :RCImage;
	var m :RCImage;
	var r :RCImage;
	
	dynamic public function onComplete () :Void {}
	
	/**
	 *  Create a new Image from 3 parts
	 *  @param x = the x position on stage
	 *  @param y = the y position on stage
	 *  @param imageLeft = The path to the image used in the left
	 *  @param imageMiddle = The path to the image used in the middle (this is stretchable)
	 *  @param imageRight = The path to the image used in the right
	 **/
	public function new (x, y, imageLeft:String, imageMiddle:String, imageRight:String) {
		super (x, y);
		//trace("new image with parts: "+imageLeft+", "+imageMiddle+", "+imageRight);
		
		l = new RCImage (0, 0, imageLeft);
		l.onComplete = onCompleteHandler;
		m = new RCImage (0, 0, imageMiddle);
		m.onComplete = onCompleteHandler;
		r = new RCImage (0, 0, imageRight);
		r.onComplete = onCompleteHandler;
		
		addChild ( l );
		addChild ( m );
		addChild ( r );
	}
	
	function onCompleteHandler () {
		if (l.isLoaded && m.isLoaded && r.isLoaded && size.width != 0) {
			setWidth ( size.width );
		}
		onComplete();
	}
	
	
	/**
	 *  Change the width of the image by stretching the element from the middle an reposition the last one
	 *  @param w = the new width of the Image
	 **/
	override public function setWidth (w:Float) :Float {
		
		size.width = w;
		
		// If the images are not loaded yet, call this function again automatically after they are loaded
		if (!l.isLoaded || !m.isLoaded || !r.isLoaded) return w;
		
		// Left element
		l.x = 0;
		
		// Middle element
		m.x = Math.round(l.width);
		var mw = Math.round(w - l.width - r.width);
		if (mw < 0)
			mw = 0;
		m.width = mw;
		
		// Right element
		var rx = Math.round(w - r.width);
		if (rx < m.x + mw)
			rx = Math.round(m.x + mw);
		r.x = rx;
		
		//m.setWidth (Math.round(w-l.width-r.width));trace(m.width);
		return w;
	}
	
	// Clean mess
	override public function destroy () :Void {
		
		l.destroy();
		m.destroy();
		r.destroy();
		
		super.destroy();
	}
}
