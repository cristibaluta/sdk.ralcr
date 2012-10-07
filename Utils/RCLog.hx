//
//  RCLog.hx
//	Utils
//
//  Created by Baluta Cristian
//  2011 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCDevice;

class RCLog {
	
	public static function redirectTraces () {
		
		#if !nme
			haxe.Log.trace = RCLog.trace;
		#end
			
	}
	
	public static var ALLOW_TRACES_FROM = [];
	public static function allowClasses (arr:Array<String>) {
		ALLOW_TRACES_FROM = ALLOW_TRACES_FROM.concat( arr );
	}
	
	static var lastMethod = "";
	public static function trace (v : Dynamic, ?inf : haxe.PosInfos) : Void
	{
		#if js
			if (RCDevice.currentDevice().userAgent == MSIE) return;
		#end
		if ( ALLOW_TRACES_FROM.length == 0 ) {
			firebugTrace ( v, inf );
		}
		else for (c in ALLOW_TRACES_FROM) {
			if (c == inf.className.split(".").pop()) {
				firebugTrace ( v, inf );
			}
		}
	}
	public static function firebugTrace (v : Dynamic, ?inf : haxe.PosInfos) :Void
	{
		var newLineIn = (lastMethod == inf.methodName) ? "" : "\n---> ";
		var newLineOut = (lastMethod == inf.methodName) ? "" : "\n\n";
		
		haxe.Firebug.trace ( inf.methodName + " : " + newLineIn + Std.string(v) + newLineOut, inf );
		
		lastMethod = inf.methodName;
	}
}
