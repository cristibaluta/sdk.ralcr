package  {
	import flash.Lib;
	import flash.events.Event;
	import haxe.Log;
	import flash.events.FullScreenEvent;
	public class RCNotificationCenter {
		static protected var notificationsList : List;
		static public function init() : void {
			if(RCNotificationCenter.notificationsList == null) {
				RCNotificationCenter.notificationsList = new List();
				flash.Lib.current.stage.addEventListener(flash.events.Event.RESIZE,RCNotificationCenter.resizeHandler);
				flash.Lib.current.stage.addEventListener(flash.events.FullScreenEvent.FULL_SCREEN,RCNotificationCenter.fullScreenHandler);
			}
		}
		
		static protected function resizeHandler(e : flash.events.Event) : void {
			postNotification("resize",[flash.Lib.current.stage.stageWidth,flash.Lib.current.stage.stageHeight],{ fileName : "RCNotificationCenter.hx", lineNumber : 29, className : "RCNotificationCenter", methodName : "resizeHandler"});
		}
		
		static protected function fullScreenHandler(e : flash.events.FullScreenEvent) : void {
			postNotification("fullscreen",null,{ fileName : "RCNotificationCenter.hx", lineNumber : 33, className : "RCNotificationCenter", methodName : "fullScreenHandler"});
		}
		
		static public function addObserver(name : String,func : *) : void {
			init();
			notificationsList.add(new RCNotification(name,func));
		}
		
		static public function removeObserver(name : String,func : *) : void {
			init();
			{ var $it : * = notificationsList.iterator();
			while( $it.hasNext() ) { var notification : RCNotification = $it.next();
			if(notification.name == name && Reflect.compareMethods(notification.functionToCall,func)) notificationsList.remove(notification);
			}}
		}
		
		static public function postNotification(name : String,args : Array = null,pos : * = null) : Boolean {
			init();
			var notificationFound : Boolean = false;
			{ var $it : * = notificationsList.iterator();
			while( $it.hasNext() ) { var notification : RCNotification = $it.next();
			if(notification.name == name) try {
				notificationFound = true;
				Reflect.callMethod(null,notification.functionToCall,args);
			}
			catch( e : * ){
				haxe.Log.trace("[RCNotificationCenter error: " + Std.string(pos) + "]",{ fileName : "RCNotificationCenter.hx", lineNumber : 76, className : "RCNotificationCenter", methodName : "postNotification"});
			}
			}}
			return notificationFound;
		}
		
		static public function list() : void {
			{ var $it : * = notificationsList.iterator();
			while( $it.hasNext() ) { var notification : RCNotification = $it.next();
			haxe.Log.trace(notification,{ fileName : "RCNotificationCenter.hx", lineNumber : 87, className : "RCNotificationCenter", methodName : "list"});
			}}
		}
		
	}
}
