//
//  RCLog.hx
//	Utils
//
//  Created by Baluta Cristian
//  2011 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

/**
 *  RCLog redirects traces to the firebug console as haxe.Firebug does.
 *  The advantage is that you can chose from which classes to see the traces
 **/
class RCLog {
	
	public static var ALLOW_TRACES_FROM = [];
	static var lastMethod = "";
	static var type = "log";
	
	
	public static function redirectTraces () {
		#if !nme
			haxe.Log.trace = RCLog.log;
		#end

		#if js
			// IE Console fix, for the unfortunate situation when you want to debug in IE < 9
			untyped __js__("if (!window.console) window.console = {};
			if (!window.console.log) window.console.log = function () { };");
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
	
	/**
	 *  Logging through this method will ignore the traces that come from non-allowed classes
	 **/
	public static function log (v:Dynamic, ?inf:haxe.PosInfos) :Void {
		
		if ( ALLOW_TRACES_FROM.length == 0 ) {
			print ( v, inf );
		}
		else for (c in ALLOW_TRACES_FROM) {
			if (c == inf.className.split(".").pop()) {
				print ( v, inf );
			}
		}
	}
	
	/**
	 *  Logging through this method will print in red color
	 **/
	public static function error (v:Dynamic, ?inf:haxe.PosInfos) :Void {
		
		type = "error";
		log ( v, inf );
		type = "log";
	}
	
	/**
	 *  Logging through this method will print a yellow warn triangle in front of the trace
	 **/
	public static function warn (v:Dynamic, ?inf:haxe.PosInfos) :Void {
		
		type = "warn";
		log ( v, inf );
		type = "log";
	}
	
	
	static function print (v:Dynamic, ?inf:haxe.PosInfos) :Void {
		
		var line1 = (lastMethod == inf.methodName) ? "" : "\n";
		var fileInfo = line1 + inf.fileName + " : function " + inf.methodName + "()";
		
		#if flash
			if ((lastMethod != inf.methodName))
			flash.external.ExternalInterface.call ("console."+type, fileInfo);
			flash.external.ExternalInterface.call ("console."+type, inf.lineNumber + " :  " + Std.string(v));
		#elseif js
			if ((lastMethod != inf.methodName)) untyped console.log (fileInfo);
			
			if (type=="log") untyped console.log (":::: " + inf.lineNumber + " : " + Std.string(v));
			else if (type=="error") untyped console.error (":::: " + inf.lineNumber + " : " + Std.string(v));
			else if (type=="warn") untyped console.warn (":::: " + inf.lineNumber + " : " + Std.string(v));
		#end
		
		lastMethod = inf.methodName;
	}
}
