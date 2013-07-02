//
//	RCRequest.hx
//  Make a http request
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (js || cpp || neko || objc)
	#if js
		import js.Dom;
	#end
	#if (cpp || neko || objc)
		private typedef Event = String;
	#end
	import haxe.Http;
	private typedef URLLoader = Http;
	private typedef URLRequest = #if nme nme.net.URLRequest #else Http #end;
	private typedef IEventDispatcher = Http;
	private typedef ProgressEvent = Dynamic;
	private typedef SecurityErrorEvent = String;
	private typedef IOErrorEvent = String;
	private typedef Result = String;
	private typedef HTTPStatusEvent = Int;
	private class URLVariables implements Dynamic { public function new(){} }
#elseif flash
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	private typedef Result = flash.events.Event;
#end

class RCRequest {
	
	var loader :URLLoader;
	public var result :String; // Returned data or error message
	public var status :Int; //
	public var percentLoaded :Int;
	#if (nme && (ios || android))
		var nme_req :NMEHttps;
	#end
	
	/**
	 * Dispatch events by overriding this functions
	 */
	dynamic public function onOpen () :Void {}
	dynamic public function onComplete () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onStatus () :Void {}
	
	
	public function new () {}
	
	/**
	 * Execute a request
	 *	@param URL - the url of the request
	 *	@param varaibles - An object containing the variables to send along the request
	 *	@param method - GET/POST. By default is POST
	 */
	public function load (URL:String, ?variables:URLVariables, ?method:String="GET") :Void {
		//trace(URL);trace(Std.string(variables));trace(method);
		
		#if (nme && (ios || android))
			
			nme_req = new NMEHttps();
			nme_req.didFinishLoad.add( completeHandler );
			nme_req.didFinishWithError.add( ioErrorHandler );
			nme_req.call (URL, variables, method);
			
		#elseif (js || cpp || neko || objc)
			
			loader = new Http ( URL );
			#if js
				loader.async = true;
			#end
			for (key in Reflect.fields(variables)) {
				loader.setParameter (key, Reflect.field (variables, key));
			}
			//loader.setHeader ("Content-Type", "text/plist");
			addListeners ( loader );
			loader.request ( method == "POST" ? true : false );
			
		#elseif flash
			
			loader = new URLLoader();
			addListeners ( loader );
			loader.load ( createRequest (URL, variables, method) );
			
		#end
	}
	
	
	
	/**
	 * Configure and remove listeners
	 */
	function addListeners (dispatcher:IEventDispatcher) :Void {
		
		if (dispatcher == null) return;
		
		#if (js || cpp || neko || objc)
			dispatcher.onData = completeHandler;
			dispatcher.onError = securityErrorHandler;
			dispatcher.onStatus = httpStatusHandler;
		#elseif flash
			dispatcher.addEventListener (Event.OPEN, openHandler);
			dispatcher.addEventListener (Event.COMPLETE, completeHandler);
			dispatcher.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		#end
    }

	function removeListeners (dispatcher:IEventDispatcher) :Void {
		
		if (dispatcher == null) return;
		
		#if (js || cpp || neko || objc)
			dispatcher.onData = null;
			dispatcher.onError = null;
			dispatcher.onStatus = null;
		#elseif flash
			dispatcher.removeEventListener (Event.OPEN, openHandler);
			dispatcher.removeEventListener (Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		#end
    }
	
	
	/**
	 *	Handle events
	 */
	function openHandler (e:Event) :Void {
		onOpen();
	}
	
	function completeHandler (e:Result) :Void {
		#if (js || cpp || neko || objc)
			result = e;
		#elseif flash
			result = e.target.data;
		#end
		
		// ralcr framework error convention, put error:: in front of the result
		(result.indexOf("error::") != -1)
		? {
			result = result.split("error::").pop();
			onError();
		}
		: onComplete();
	}
	
	function progressHandler (e:ProgressEvent) :Void {
		#if flash
			percentLoaded = Math.round ( e.bytesLoaded / e.bytesTotal * 100 );
			onProgress ();
		#end
    }
	function securityErrorHandler (e:SecurityErrorEvent) :Void {
		#if (js || cpp || neko || objc)
			result = e;
		#elseif flash
			result = e.text;
		#end
		onError();
    }
	function httpStatusHandler (e:HTTPStatusEvent) :Void {
		#if (js || cpp || neko || objc)
			status = e;
		#elseif flash
			status = e.status;
		#end
		onStatus();
    }
	function ioErrorHandler (e:IOErrorEvent) :Void {
		#if (js || cpp || neko || objc)
			result = e;
		#elseif flash
			result = e.text;
		#end
		onError();
    }
	
	
	// Utils
	
	/**
	*  
	*/
	function createRequest (URL:String, variables:URLVariables, method:String) :URLRequest {
		#if nme
			if (method=="GET") URL += "?";
			for (f in Reflect.fields (variables))
				URL += f + "=" + Reflect.field (variables, f) + "&";
		#end
		#if nme
			var request = new nme.net.URLRequest ( URL );
				request.data = variables;
				request.method = method == "POST" ? nme.net.URLRequestMethod.POST : nme.net.URLRequestMethod.GET;
			return request;
		#elseif flash
			var request = new URLRequest ( URL );
				request.data = variables;
				request.method = method == "POST" ? URLRequestMethod.POST : URLRequestMethod.GET;
			return request;
		#end
			return null;
	}
	
	/**
	*  Get the fields of an anonymous objects and put then into an URLVariables
	*/
	function createVariables (variables_list:Dynamic) :URLVariables {
		
		if (variables_list == null) return null;
		
		var variables = new URLVariables();
		
		if (variables_list != null)
			for (f in Reflect.fields (variables_list))
				Reflect.setField (variables, f, Reflect.field (variables_list, f));
		
		return variables;
	}
	
	
	/**
	 *	Stop executing any request and remove listeners
	 */
	public function destroy () :Void {
		removeListeners ( loader );
		//try { loader.close(); } catch (e:Dynamic) { }
		loader = null;
		#if (nme && (ios || android))
			if (nme_req != null) nme_req.destroy(); nme_req = null;
		#end
	}
}
