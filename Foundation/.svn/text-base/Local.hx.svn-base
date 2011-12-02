//
//  Class that stores local variables, that are used only in this running session
//	You can get and set them from anywhere in the application
//
//  Created by Baluta Cristian on 2009-01-09.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class Local {

	static var inited :Bool = false;
	static var localVariables :Dynamic;
	
	static function init () :Void {
		if (inited) return;
		localVariables = {};
		inited = true;
	}
	
	/**
	 * Local variables. Are available only during the currently running session
	 */
	public static function get (key:String) :Dynamic {
		init();
		return Reflect.field (localVariables, key);
	}
	
	public static function set (key:String, value:Dynamic) :Dynamic {
		init();
		Reflect.setField (localVariables, key, value);
		return value;
	}
	
}
