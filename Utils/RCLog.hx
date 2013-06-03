//
//  RCLog.hx
//	Utils
//
//  Created by Baluta Cristian
//  2011 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCDevice;

/**
 *  RCLog redirects traces to the firebug console as haxe.Firebug does.
 *  The advantage is that you can chose from which classes to see the traces
 **/
class RCLog {
	
	public static var ALLOW_TRACES_FROM = [];
	static var lastMethod = "";
	
	
	public static function redirectTraces () {
		#if !nme
			haxe.Log.trace = RCLog.trace;
		#end
	}
	
	/**
	 *  Chose the classes you want to see the traces from
	 *  @param arr is an array of strings that represent the class names. 
	 *  Call this method as many times as you like.
	 *  If you don't specify any, all traces are sent to the console
	 **/
	public static function allowClasses (arr:Array<String>) {
		ALLOW_TRACES_FROM = ALLOW_TRACES_FROM.concat( arr );
	}
	
	public static function trace (v : Dynamic, ?inf : haxe.PosInfos) : Void
	{
		#if js
			// IE < 9 does not support console.log
			if (RCDevice.currentDevice().userAgent == MSIE) return;
		#end
		if ( ALLOW_TRACES_FROM.length == 0 ) {
			_trace ( v, inf );
		}
		else for (c in ALLOW_TRACES_FROM) {
			if (c == inf.className.split(".").pop()) {
				_trace ( v, inf );
			}
		}
	}
	
	private static function _trace (v : Dynamic, ?inf : haxe.PosInfos) :Void
	{
		var line1 = (lastMethod == inf.methodName) ? "" : "\n";
		var fileInfo = line1 + inf.fileName + " : " + inf.methodName;
		
		#if flash
			if ((lastMethod != inf.methodName))
			flash.external.ExternalInterface.call ("console.log", fileInfo);
			flash.external.ExternalInterface.call ("console.log", inf.lineNumber + " :  " + Std.string(v));
		#elseif js
			if ((lastMethod != inf.methodName))
			untyped console.log (fileInfo);
			untyped console.log (inf.lineNumber + " :  " + Std.string(v));
		#end
		
		lastMethod = inf.methodName;
	}
}
