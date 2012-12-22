//
//  RCImageAnimated.hx
//
//  Created by Baluta Cristian on 2008-04-01.
//  Copyright (c) 2008 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import haxe.Timer;


class RCImageAnimated extends RCView {
	
	public var images :Array<RCImage>;
	public var currentFrame :Int;
	public var isLoaded :Bool;
	public var percentLoaded :Int;
	public var errorMessage :String;
	public var fps (default, set_fps) :Int;
	public var reverse :Bool;
	public var repeat :Bool;
	var nr :Int;
	var max :Int;
	var timer :Timer;
	var _fps :Int;
	
	
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	
	/**
	 *  Convenience method to create an animated image from an array of images
	 **/
	public static function animatedImageWithImages (x, y, images:Array<RCImage>) {
		var im = new RCImageAnimated (x, y, null);
			im.images = images;
			im.gotoAndStop ( 1 );
		return im;
	}
	
	
	public function new (x, y, urls:Array<String>) {
		
		super (x, y);
		
		isLoaded = false;
		percentLoaded = 0;
		currentFrame = 0;
		_fps = 10;
		reverse = false;
		repeat = false;
		nr = 0;
		max = 0;
		
		
		if (urls == null) return;
		
		images = new Array<RCImage>();
		
		for (url in urls) {
			var im = new RCImage (0, 0, url);
			im.onProgress = progressHandler;
			im.onError = errorHandler;
			im.onComplete = completeHandler;
			images.push ( im );
		}
		max = images.length;
	}
	
	// Controlling the animation
	
	public function gotoAndStop (f:Int) :Void {
		//trace("gotoAndStop "+currentFrame+", "+f);
		if (f == 0 || f > images.length) {
			if (f > images.length && repeat)
				f = 1;
			else
				stop();
		}
		if (currentFrame > 0) removeChild ( images[currentFrame-1] );
		
		addChild ( images[f-1] );
		currentFrame = f;
	}
	public function gotoLastFrame () :Void {
		gotoAndStop ( images.length );
	}
	
	public function play (?newFPS:Null<Int>) :Void {
		
		if (newFPS != null) {
			_fps = newFPS;
			stop();
		}
		if (currentFrame >= images.length && !repeat)
			gotoAndStop ( 1 );
		
		if (timer == null) {
			timer = new Timer ( Math.round ( 1000/_fps) );
			timer.run = loop;
		}
	}
	
	public function stop () :Void {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}
	
	function loop () {
		gotoAndStop ( currentFrame + 1 );
	}
	
	
	/**
	 *	Handlers.
	 */
	function completeHandler () :Void {
		onCompleteHandler();
	}
	function onCompleteHandler () :Void {
		nr ++;
		if (nr >= max)
			onComplete();
	}
	function progressHandler () :Void {
/*		percentLoaded = Math.round (e.target.bytesLoaded * 100 / e.target.bytesTotal);
		onProgress ();*/
	}
	function errorHandler () :Void {
		//errorMessage = e.toString();
		onError();
		onCompleteHandler();
	}
	
	public function set_fps (f:Int) :Int {
		_fps = f;
		if (timer != null) play ( f );
		return f;
	}
	
	override public function destroy() :Void {
		
		stop();
		Fugu.safeDestroy ( images );
		images = null;
		super.destroy();
	}
}
