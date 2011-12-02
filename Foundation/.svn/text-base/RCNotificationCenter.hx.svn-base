//
//  RCNotificationCenter
//
//  Created by Cristi Baluta on 2010-03-12.
//  Copyright (c) 2010-2011 ralcr.com. All rights reserved.
//
#if flash
import flash.events.Event;
import flash.events.FullScreenEvent;
#elseif js
import js.Dom;// typedef js.Event
#end

class RCNotificationCenter {
	
	static var notificationsList :List<RCNotification>;
	
	
	public static function init () {
		if (notificationsList == null) {
			notificationsList = new List<RCNotification>();
#if flash			
			flash.Lib.current.stage.addEventListener (Event.RESIZE, resizeHandler);
			flash.Lib.current.stage.addEventListener (FullScreenEvent.FULL_SCREEN, fullScreenHandler);
#elseif js
			js.Lib.window.onresize = resizeHandler;
#end
		}
	}

	/**
	 *  Default notifications: RESIZE, FULL_SCREEN
	 */
	static function resizeHandler (e:Event) {
#if flash
		var w = flash.Lib.current.stage.stageWidth;
		var h = flash.Lib.current.stage.stageHeight;
#elseif js
		var w = js.Lib.document.body.scrollWidth;
		var h = js.Lib.document.body.scrollHeight;
#end
		postNotification ("resize", [w, h]);
	}
	
#if flash
	static function fullScreenHandler (e:FullScreenEvent) {
	    postNotification ("fullscreen");
	}
#end
	
	/**
	 *  Add an observer to an event
	 *  @ name :String
	 *  @ func :Dynamic
	 */
	public static function addObserver (name:String, func:Dynamic) :Void {
		init();
		notificationsList.add ( new RCNotification (name, func) );
	}
	
	/**
	 *  Remove an observer from an event
	 *  @ name :String
	 *  @ func :Dynamic
	 */
	public static function removeObserver (name:String, func:Dynamic) :Void {
		init();
		for (notification in notificationsList)
			if (notification.name == name && Reflect.compareMethods (notification.functionToCall, func))
				notificationsList.remove ( notification );
	}
	
	
	/**
	 *  Posting a notification will call all the registered observer functions
	 *  @ name :String
	 *  @ ?args:Array<Dynamic> - If this argument is passed, the called function will expect the same nr of arguments
	 */
	public static function postNotification (name:String, ?args:Array<Dynamic>, ?pos:haxe.PosInfos) :Bool {
		init();
		var notificationFound = false;
		
		for (notification in notificationsList)
			if (notification.name == name)
				try {
					notificationFound = true;
					Reflect.callMethod (null, notification.functionToCall, args);
				}
				catch (e:Dynamic) {
					trace ("[RCNotificationCenter error: " + Std.string ( pos ) + "]");
				}
		
		return notificationFound;
	}
	
	
	/**
	 *  Trace all the registered observers
	 */
	public static function list () :Void {
		for (notification in notificationsList) trace ( notification );
	}
}
