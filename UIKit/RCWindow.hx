//
//  RCWindow.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-03-21.
//  Updated 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
// RCWindow is the main view of the application and can be only one.
// It has some suplimentar properties than the RCView
// Note:
// NME crashes if you're trying to init some static variables.

#if (flash || nme)
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
#elseif objc
	import objc.ios.ui.UIView;
#elseif js
	import js.Dom;
#end
	import RCDevice;// RCUserAgent


class RCWindow extends RCView {
	
	static var sharedWindow_ :RCWindow;
	public static function sharedWindow (?id:String) :RCWindow {
		if (sharedWindow_ == null)
			sharedWindow_ = new RCWindow ( id );
		return sharedWindow_;
	}
	
	
#if (flash || nme)
	public var target :MovieClip;
	public var stage :Stage;
#elseif js
	public var target :HtmlDom;
	public var stage :HtmlDom;
#end

	public var SCREEN_W :Float;
	public var SCREEN_H :Float;
	public var modalView :RCView;// Modal views are added to the window. Can be only one at a time
	
	
	/**
	 *  Create a new Window
	 *  @param id - Used only in js, the id of your div
	 **/
	public function new (id:String) {
		
		if (sharedWindow_ != null) {
			var err = "RCWindow is a singletone, create and access it with RCWindow.sharedWindow(?id)";
			trace ( err );
			throw err;
		}
		
		super (0.0, 0.0, 0.0, 0.0);
		
		#if (flash || nme)
			
			target = flash.Lib.current;
			stage = flash.Lib.current.stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			size.width = stage.stageWidth;
			size.height = stage.stageHeight;
			SCREEN_W = flash.system.Capabilities.screenResolutionX;
			SCREEN_H = flash.system.Capabilities.screenResolutionY;
			
			target.addChild ( layer );
			
		#elseif js
			
			stage = js.Lib.document;
			setTarget ( id );
			
			SCREEN_W = js.Lib.window.screen.width;
			SCREEN_H = js.Lib.window.screen.height;
			
		#end
		
		// RCNotificationCenter.addObserver ("fullscreen", fullScreenHandler);
		RCNotificationCenter.addObserver ("resize", resizeHandler);
	}
	
	function resizeHandler (w, h) {
		size.width = w;
		size.height = h;
	}
	
	
	/**
	* JS can permit to change the target of the RCWindow
	*/
	public function setTarget (id:String) :Void {
		#if js
			
			if (id != null) {
				target = js.Lib.document.getElementById( id );
			}
			else {
				target = js.Lib.document.body;
				target.style.margin = "0px 0px 0px 0px";
				target.style.overflow = "hidden";
				
				if (RCDevice.currentDevice().userAgent == MSIE) {
					target.style.width = untyped js.Lib.document.documentElement.clientWidth + "px";
					target.style.height = untyped js.Lib.document.documentElement.clientHeight + "px";
				}
				else {
					target.style.width = js.Lib.window.innerWidth + "px";
					target.style.height = js.Lib.window.innerHeight + "px";
				}
			}
			
			size.width = target.scrollWidth;
			size.height = target.scrollHeight;
			trace(size);
			target.appendChild ( layer );
			
		#end
	}
	
	override public function setBackgroundColor (color:Null<Int>) :Null<Int> {
		#if js
			
			if (color == null) {
				target.style.background = null;
			}
			else {
				var red   = (color & 0xff0000) >> 16;
				var green = (color & 0xff00) >> 8;
				var blue  = color & 0xFF;
				var alpha = 1;
				target.style.background = "rgba("+red+","+green+","+blue+","+alpha+")";
			}
			
		#end
		
		return color;
	}
	
	
	
	
	// FullScreen support
	
	var fsprefix :String;
	public function fullscreen () {
		
		#if (flash || cpp || neko)
			
			stage.displayState = StageDisplayState.FULL_SCREEN;
		
		#elseif js
			
			if ( supportsFullScreen() ) {
				if (fsprefix == null)
					Reflect.callMethod (target, 'requestFullScreen', []);
				else
					Reflect.callMethod (target, Reflect.field(target, fsprefix + 'RequestFullScreen'), []);
			}
		#end
	}
	public function normal () {
		
		#if (flash || cpp || neko)
			stage.displayState = StageDisplayState.NORMAL;
		#elseif js
			
			if ( supportsFullScreen() ) {
				if (fsprefix == "")
					Reflect.callMethod (target, 'cancelFullScreen', []);
				else
					Reflect.callMethod (target, Reflect.field(target, fsprefix + 'CancelFullScreen'), []);
			}
		#end
	}
	public function isFullScreen () :Bool {
		
		#if (flash || cpp || neko)
			return stage.displayState == StageDisplayState.FULL_SCREEN;
		#elseif js
			if (supportsFullScreen())
			switch (fsprefix) {
				case '': return untyped target.fullScreen;
				case 'webkit': return untyped target.webkitIsFullScreen;
				default: return Reflect.field (target, fsprefix + 'FullScreen');
			}
			return false;
		#end
	}
	public function supportsFullScreen () :Bool {
		
		#if flash
			
			return true;
		
		#elseif js
			
		    // Check for native support
		    if (Reflect.field (target, "cancelFullScreen") != null) {
		        return true;
		    }
			// Check for fullscreen support by vendor prefix
			else for (prefix in ['webkit', 'moz', 'o', 'ms', 'khtml']) {
				if (Reflect.field (js.Lib.document, prefix + 'CancelFullScreen') != null) {
					fsprefix = prefix;
					return true;
				}
			}
			return false;
			
		#end
		
			return false;
	}
	
	
	
	/**
	 *  Add a modal view controller. This is a window that stays on top of everything
	 *  Only one can exist at a given time
	 *  @param view - it can be any view. It will be animated from bottom to top
	 **/
	public function addModalViewController (view:RCView) :Void {
		if (modalView != null) return;
		modalView = view;
		modalView.x = 0;//RCWindow.getCenterX ( view.width );
		
		CoreAnimation.add ( new CATween (modalView, {y:{fromValue:height, toValue:0}}, 0.5, 0, caequations.Cubic.IN_OUT) );
		addChild ( modalView );
	}
	/**
	 *  Remove the modalView id we have one
	 *  When the fade out animation finishes it is destroyed and removed from window
	 **/
	public function dismissModalViewController () :Void {
		if (modalView == null) return;
		var anim = new CATween (modalView, {y:height}, 0.3, 0, caequations.Cubic.IN);
			anim.delegate.animationDidStop = destroyModalViewController;
		CoreAnimation.add ( anim );
	}
	function destroyModalViewController () :Void {
		modalView.removeFromSuperview();
		modalView.destroy();
		modalView = null;
	}
	
	
	
	/**
	 *	Return the x and y of an object that should be centered in the window
	 *  @param w - the with of the object
	 */
	public function getCenterX (w:Float) :Int {
		return Math.round (width/2 - w/RCDevice.currentDevice().dpiScale/2);
	}
	public function getCenterY (h:Float) :Int {
		return Math.round (height/2 - h/RCDevice.currentDevice().dpiScale/2);
	}
	
	override public function toString () :String {
		return "[RCWindow target="+target+"]";
	}
}
