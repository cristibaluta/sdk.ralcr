//
//	RCRequest.hx
//  Make a http request
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	private typedef Result = Event;
	#if flash
		import flash.events.HTTPStatusEvent;
		import flash.net.URLVariables;
		import flash.net.URLRequestMethod;
	#else
		private typedef HTTPStatusEvent = Dynamic;
		private typedef URLRequestMethod = Dynamic;
		private class URLVariables implements Dynamic { public function new(){} }
	#end
#elseif js
	import js.Dom;
	import haxe.Http;
	private typedef URLLoader = Http;
	private typedef URLRequest = Http;
	private typedef IEventDispatcher = Http;
	private typedef ProgressEvent = Dynamic;
	private typedef SecurityErrorEvent = String;
	private typedef IOErrorEvent = String;
	private typedef Result = String;
	private typedef HTTPStatusEvent = Int;
	private class URLVariables implements Dynamic { public function new(){} }
#end

class RCRequest {
	
	var loader :URLLoader;
	public var result :String; // Returned data or error message
	public var status :Int; //
	public var percentLoaded :Int;
	
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
	 *	@param URL - the url of the reuest
	 *	@param varaibles - An object containing the variables to send along the request
	 *	@param method - GET/POST. By default is POST
	 */
	public function load (URL:String, ?variables:URLVariables, ?method:String="POST") :Void {
		
		#if (flash || nme)
			loader = new URLLoader();
			addListeners ( loader );
			loader.load ( createRequest (URL, variables, method) );
		#elseif js
			loader = new Http ( URL );
			loader.async = true;
			for (key in Reflect.fields(variables)) {
				loader.setParameter (key, Reflect.field (variables, key));
			}
			addListeners ( loader );
			loader.request ( method == "POST" ? true : false );
		#end
	}
	
	
	
	/**
	 * Configure and remove listeners
	 */
	function addListeners (dispatcher:IEventDispatcher) :Void {
		#if (flash || nme)
			dispatcher.addEventListener (Event.OPEN, openHandler);
			dispatcher.addEventListener (Event.COMPLETE, completeHandler);
			dispatcher.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			#if flash
				dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			#end
		#elseif js
			dispatcher.onData = completeHandler;
			dispatcher.onError = securityErrorHandler;
			dispatcher.onStatus = httpStatusHandler;
		#end
    }

	function removeListeners (dispatcher:IEventDispatcher) :Void {
		#if (flash || nme)
			dispatcher.removeEventListener (Event.OPEN, openHandler);
			dispatcher.removeEventListener (Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			#if flash
				dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			#end
		#elseif js
			dispatcher.onData = null;
			dispatcher.onError = null;
			dispatcher.onStatus = null;
		#end
    }
	
	
	/**
	 *	Handle events
	 */
	function openHandler (e:Event) :Void {
		onOpen();
	}
	
	function completeHandler (e:Result) :Void {
		#if (flash || nme)
			result = e.target.data;
		#elseif js
			result = e;
		#end
		
		// ralcr error convention, put error:: in front of the result
		(result.indexOf("error::") != -1)
		? {
			result = result.split("error::").pop();
			onError();
		}
		: onComplete();
	}
	
	function progressHandler (e:ProgressEvent) :Void {
		#if (flash || nme)
			percentLoaded = Math.round ( e.bytesLoaded / e.bytesTotal * 100 );
			onProgress ();
		#end
    }
	function securityErrorHandler (e:SecurityErrorEvent) :Void {
		#if (flash || nme)
			result = e.text;
		#elseif js
			result = e;
		#end
		onError();
    }
	function httpStatusHandler (e:HTTPStatusEvent) :Void {
		#if (flash || nme)
			status = e.status;
		#elseif js
			status = e;
		#end
		onStatus();
    }
	function ioErrorHandler (e:IOErrorEvent) :Void {
		#if (flash || nme)
			result = e.text;
		#elseif js
			result = e;
		#end
		onError();
    }
	
	
	// Utils
	function createRequest (URL:String, variables:URLVariables, method:String) :URLRequest {
		#if nme
		URL += "?";
		for (f in Reflect.fields (variables))
			URL += f + "=" + Reflect.field (variables, f) + "&";
		#end
		
		var request = new URLRequest ( URL );
		#if (flash || nme)
			request.data = variables;
		#if flash
			request.method = method == "POST" ? URLRequestMethod.POST : URLRequestMethod.GET;
		#end
		#end
			//trace(request);trace(request.url);
		return request;
	}
	function createVariables (variables_list:Dynamic) :URLVariables {
		
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
	}
}
