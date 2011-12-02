//
//  SharedObjects
//	They are available anytime you open the application from the same computer
//
//  Created by Baluta Cristian on 2009-01-09.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.net.SharedObject;

class RCUserDefaults {

	static var inited :Bool = false;
	static var sharedObject :SharedObject;
	
	
	public static function init (?identifier:String="ralcr") :Void {
		if (inited) return;
		sharedObject = SharedObject.getLocal ( identifier );
		
		inited = true;
	}
	
	// Get objects from Shared object
	public static function objectForKey (key:String) :Dynamic {
		init();
		return Reflect.field (sharedObject.data, key);
	}
	public static function arrayForKey (key:String) :Array<Dynamic> {
		return objectForKey ( key );
	}
	public static function boolForKey (key:String) :Bool {
		return objectForKey ( key ) == true;
	}
	public static function stringForKey (key:String) :String {
		return objectForKey ( key );
	}
	public static function intForKey (key:String) :Null<Int> {
		return objectForKey ( key );
	}
	public static function floatForKey (key:String) :Null<Float> {
		return objectForKey ( key );
	}
	
	
	
	public static function set (key:String, value:Dynamic) :Dynamic {
		init();
		try {
			Reflect.setField (sharedObject.data, key, value);
			sharedObject.flush();
		}
		catch (e:Dynamic) { trace("Error setting a SharedObject {"+e+"}"); }
		
		return value;
	}
	
	public static function removeObjectForKey (key:String) :Void {
		set (key, null);
	}
	public static function removeAllObjects () :Void {
		for (key in Reflect.fields(sharedObject.data)) {
			Reflect.deleteField (sharedObject.data, key);
		}
		sharedObject.flush();
	}
}
