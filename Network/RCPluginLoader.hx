//
//  RCPlugin
//
//  Created by Cristi Baluta on 2011-02-23.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.display.Loader;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;


class RCPluginLoader extends Loader {
	
	var loader :URLLoader;
	public var percentLoaded :Int;
	
	dynamic public function onProgress() :Void {}
	dynamic public function onComplete() :Void {}
	dynamic public function onError() :Void {}
	
	
	public function new (path:String) {
		super();
		init ( path );
	}
	
	function init (path:String) :Void {
		loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener (Event.COMPLETE, binaryLoaded);
		loader.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		loader.addEventListener (ErrorEvent.ERROR, errorHandler);
		loader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		loader.load ( new URLRequest ( path ) );
	}
	
	// URLLoader events
	function binaryLoaded (e:Event) :Void {
		var byteArray :ByteArray = loader.data;
		this.contentLoaderInfo.addEventListener (Event.INIT, completeHandler);
		this.loadBytes (byteArray, new LoaderContext (false, ApplicationDomain.currentDomain));
	}
	function progressHandler (e:ProgressEvent) :Void {
		percentLoaded = Math.round (e.target.bytesLoaded / e.target.bytesTotal * 100);
		onProgress();
	}
	function errorHandler (e:ErrorEvent) :Void {
		trace (e.toString());
		onError();
	}
	function ioErrorHandler (e:IOErrorEvent) :Void {
		trace(e.toString());
		onError();
	}
	
	
	// Loader events
	function completeHandler (e:Event) :Void {
		percentLoaded = 100;
		onComplete();
		clean();
	}
	
	
	
	function clean () :Void {
		if (loader != null) {
			loader.removeEventListener (Event.COMPLETE, binaryLoaded);
			loader.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			loader.removeEventListener (ErrorEvent.ERROR, errorHandler);
			loader.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.close();
			loader = null;
		}
	}
	public function destroy () :Void {
		clean();
		this.contentLoaderInfo.removeEventListener (Event.INIT, completeHandler);
	}
	
	
	
	public static function exists (key:String) {
		return ApplicationDomain.currentDomain.hasDefinition ( key );
	}
}
