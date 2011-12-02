//
//  Request a link
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;


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
	
	
	public function new () {
		loader = new URLLoader();
		configureListeners ( loader );
	}
	
	/**
	 * Execute a request
	 */
	public function load (URL:String, variables:URLVariables, ?method:String="POST") :Void {
		
		var request = new URLRequest ( URL );
			request.data = variables;
			request.method = method == "POST" ? URLRequestMethod.POST : URLRequestMethod.GET;
		
		loader.load ( request );
	}
	
	
	/**
	 * Configure and remove listeners
	 */
	function configureListeners (dispatcher:IEventDispatcher) :Void {
        dispatcher.addEventListener (Event.OPEN, openHandler);
        dispatcher.addEventListener (Event.COMPLETE, completeHandler);
        dispatcher.addEventListener (ProgressEvent.PROGRESS, progressHandler);
        dispatcher.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

	function removeListeners (dispatcher:IEventDispatcher) :Void {
        dispatcher.removeEventListener (Event.OPEN, openHandler);
        dispatcher.removeEventListener (Event.COMPLETE, completeHandler);
        dispatcher.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
        dispatcher.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
    }
	
	
	/**
	 *	Handle events
	 */
	function openHandler (e:Event) :Void {
		onOpen();
	}
	
	function completeHandler (e:Event) :Void {
		
		result = e.target.data;
		
		(result.indexOf("error::") != -1)
		? {
			result = result.split("error::").pop();
			onError();
		}
		: onComplete();
	}
	
	function progressHandler (e:ProgressEvent) :Void {
		percentLoaded = Math.round ( e.bytesLoaded / e.bytesTotal * 100 );
		onProgress ();
    }
	
	function securityErrorHandler (e:SecurityErrorEvent) :Void {
		result = e.text;
		onError();
    }
	
	function httpStatusHandler (e:HTTPStatusEvent) :Void {
		status = e.status;
		onStatus();
    }
	
	function ioErrorHandler (e:IOErrorEvent) :Void {
		result = e.text;
		onError();
    }
	
	
	/** Stop executing any request and remove listeners
	 */
	public function destroy () :Void {
		removeListeners ( loader );
		loader = null;
	}
}
