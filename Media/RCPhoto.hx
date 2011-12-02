//
//  Photo
//
//  Created by Baluta Cristian on 2008-04-01.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
#if flash
import flash.display.Sprite;
import flash.display.Loader;
import flash.system.LoaderContext;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
#elseif js
import js.Dom;
import RCView;
typedef Loader = js.Dom.Image;
typedef ProgressEvent = Event;
typedef ErrorEvent = Event;
typedef IOErrorEvent = Event;
#end

class RCPhoto extends RCView {
	
	var loader :Loader;
	
	public var isLoaded :Bool;
	public var percentLoaded :Int;
	public var errorMessage :String;
	
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	
	public function new (x, y, URL:String) {
		super(x, y);
		load( URL );
		addListeners();
	}


	public function load (URL:String) {
		isLoaded = false;
		percentLoaded = 0;
#if flash
		loader = new Loader();
		loader.load ( new URLRequest ( URL ), new LoaderContext (true) );
#elseif js
		loader = cast js.Lib.document.createElement("img");
		loader.src = URL;
#end
	}
	
	
	/**
	 *	Handlers.
	 */
	function completeHandler (e:Event) :Void {
#if flash
		this.size.width = this.lastW = loader.content.width;
		this.size.height = this.lastH = loader.content.height;
		this.isLoaded = true;
		this.view.addChild ( loader );
		
		bitmapize();
#elseif js
		this.size.width = this.lastW = this.width = loader.width;
		this.size.height = this.lastH = this.height = loader.height;
		this.isLoaded = true;
		this.view.appendChild ( loader );
#end
		onComplete();
	}
#if flash
	function progressHandler (e:ProgressEvent) :Void {
		percentLoaded = Math.round (e.target.bytesLoaded * 100 / e.target.bytesTotal);
		onProgress ();
	}
#end
	function errorHandler (e:ErrorEvent) :Void {
		errorMessage = Std.string(e);
		onError();
	}
	
	function ioErrorHandler (e:IOErrorEvent) :Void {
		errorMessage = Std.string(e);
		onError();
	}
	
#if flash	
	/**
	 * Bitmapize the loaded photo. This will prevent pixelizing when photo is scaled
	 */
	function bitmapize () :Void {
		
		var d = duplicate();
		if (d != null) {
			this.view.removeChild ( loader );
			this.view.addChild ( d );
		}
	}
	
	
	/**
	 *	Get a duplicate of the photo.
	 */
	public function duplicate () :Sprite {
		
		if (loader.content.width > 2880 || loader.content.height > 2880) return null;
		
		var bitmap = new BitmapData (	Math.round (loader.content.width),
										Math.round (loader.content.height), true, 0x000000ff );
		
		bitmap.draw ( loader.content );
		
		var d = new Sprite();
			d.addChild ( new Bitmap (bitmap, PixelSnapping.AUTO, true) );
		
		return d;
	}
#end	
	
	function addListeners () :Void {
#if flash
		loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeHandler);
		loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		loader.contentLoaderInfo.addEventListener (ErrorEvent.ERROR, errorHandler);
		loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
#elseif js
		loader.onload = completeHandler;
		loader.onerror = errorHandler;
#end
	}
	
	function removeListeners () :Void {
#if flash
		loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, completeHandler);
		loader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
		loader.contentLoaderInfo.removeEventListener (ErrorEvent.ERROR, errorHandler);
		loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
#elseif js
		loader.onload = null;
		loader.onerror = null;
#end
	}
	
	
	override public function destroy() :Void {
		removeListeners();
		//loader.close();
#if flash		loader.unload(); #end
		loader = null;
	}
	
#if js
	override public function scaleToFit (w:Int, h:Int) :Void {
		super.scaleToFit (w, h);
		loader.style.width = width+"px";
		loader.style.height = height+"px";
	}
	override public function scaleToFill (w:Int, h:Int) :Void {
		super.scaleToFill (w, h);
		loader.style.width = width+"px";
		loader.style.height = height+"px";
	}
#end
}
