//
//  RCNotificationCenter.hx
//	EventsKit
//
//  Created by Cristi Baluta on 2010-03-12.
//  Copyright (c) 2010-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCNotificationCenter {
	
	static var notificationsList :List<RCNotification>;
	
	
	public static function init () {
		if (notificationsList == null) {
			notificationsList = new List<RCNotification>();
			
			// Add by default resize and fullscreen events
			var fs = new EVFullScreen();
				fs.add ( fullScreenHandler );
			var rs = new EVResize();
				rs.add ( resizeHandler );
		}
	}
	static function resizeHandler (w:Int, h:Int) :Void {
		postNotification ("resize", [w, h]);
	}
	static function fullScreenHandler (b:Bool) :Void {
		postNotification ("fullscreen", [b]);
	}
	
	/**
	 *  Add an observer to an event name
	 *  @ name :String
	 *  @ func :Dynamic
	 */
	public static function addObserver (name:String, func:Dynamic) :Void {
		init();
		notificationsList.add ( new RCNotification (name, func) );
	}
	
	/**
	 *  Remove an observer from an event name
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
					trace ("[RCNotificationCenter error calling function: " + notification.functionToCall + " from: " + Std.string ( pos ) + "]");
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
