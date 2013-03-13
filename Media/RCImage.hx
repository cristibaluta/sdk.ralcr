//
//  RCImage.hx
//	MediaKit
//
//  Created by Baluta Cristian on 2008-04-01.
//  Copyright (c) 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || (nme && (cpp || neko)))
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	#if flash
		import flash.system.LoaderContext;
	#end
#elseif js
	import js.Dom;
	import RCView;
	typedef Loader = js.Dom.Image;
	typedef BitmapData = Dynamic;
	typedef ErrorEvent = Event;
	typedef IOErrorEvent = Event;
#end
	import RCDevice;


class RCImage extends RCView {
	
	public var loader :Loader;
	public var bitmapData :BitmapData;
	
	public var isLoaded :Bool;
	public var percentLoaded :Int;
	public var errorMessage :String;
	
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	// Some convenient methods to create an image
	//
	/**
	 *  Create an instance of the rcimage with the path to the photo
	 *  Or id of the photo for NME
	 *  Asyncronous operation
	 **/
	public static function imageNamed (name:String) :RCImage {
		return new RCImage (0,0,name);
	}
	/**
	 *  NME method to load an image. Syncronous operation.
	 **/
	public static function imageWithContentsOfFile (path:String) :RCImage {
		return new RCImage (0,0,path);
	}
	/**
	 *  Create a non-distorted stretchable image
	 **/
	public static function resizableImageWithCapInsets (path:String, capWidth:Int) :RCImage {
		return new RCImage (0,0,path);
	}
	
#if (flash || (nme && (cpp || neko)))
	/**
	 *  Create an image from the ByteArray. Sync operation
	 **/
	public static function imageWithBytes (data:flash.utils.ByteArray) :RCImage {
		var im = new RCImage (0,0,null);
			im.loader.loadBytes ( data );
		return im;
	}
	/**
	 *  This will create a RCImage based on a BitmapData. onComplete event is dispatched after
	 *  10ms to keep the asyncronous operations compatible.
	 *  The bitmapdata is cloned because when the RCImage is destroyed the bitmapdata is disposed
	 **/
	public static function imageWithBitmapData (bitmapBata:BitmapData) :RCImage {
		var im = new RCImage (0,0,null);// Create a blank image
			im.bitmapData = bitmapBata.clone();// Set the BitmapData
			im.completeHandler(null);// Display the image in it's container
		return im;// Returns it
	}
#end
	
	/**
	*  @param image = The image from where to copy smaller images
	*  @param size = the size of the final image
	*  @param source_rect = the rect of the desired crop
	*  @param draw_at = clip everything that is not in this rect
	*  
	*/
	public static function imageWithRegionOfImage (image:RCImage, size:RCSize, source_rect:RCRect, draw_at:RCRect) :RCImage {
		
#if (flash || (nme && (cpp || neko)))
		
		var color = #if neko {rgb:0x000000, a:0} #else 0x000000ff #end ;
		var bitmapData = new BitmapData (Math.round(size.width), Math.round(size.height), true, color);
		var matrix = new Matrix();
			matrix.tx = - source_rect.origin.x + draw_at.origin.x;
			matrix.ty = - source_rect.origin.y + draw_at.origin.y;
			bitmapData.draw ( image.bitmapData, matrix, null, null, new Rectangle(draw_at.origin.x, draw_at.origin.y, draw_at.size.width, draw_at.size.height) );
		var bitmap = new Bitmap (bitmapData, PixelSnapping.AUTO, true);
		
		var im = new RCImage (0, 0, null);
			im.bitmapData = bitmapData;
			im.layer.addChild ( bitmap );
			im.size.width = bitmap.width;// Update the size of the image
			im.size.height = bitmap.height;
		return im;
		
#elseif js
	
		return null;
#end
	}
	
	
	
	/**
	*  @param URL - For NME it tries to load the image from the assets with nme.Assets.getBitmapData.
	*  For flash it tries to load it from external file with URLRequest.
	*  For JS it loads it from external or from cache
	**/
	public function new (x, y, URL:String) {
		
		super (x, y);
		
		#if (nme || flash)
			loader = new Loader();
		#elseif js
			loader = cast js.Lib.document.createElement("img");
		#end
		
		addListeners();
		initWithContentsOfFile ( URL );
	}
	
	/**
	 *  The image created through the constructor. This method is asyncronous for all platforms
	 *  @param URL = The path to the image
	 *  For NME it tries to load it from the bundle resources
	 *  For flash is trying to load from external file
	 *  For JS is trying to load from external file
	 **/
	public function initWithContentsOfFile (URL:String) {
		
		isLoaded = false;
		percentLoaded = 0;
		if (URL == null) return;
		
		#if nme
			// Nme has the assets already embeded
			bitmapData = nme.Assets.getBitmapData ( URL );
			haxe.Timer.delay (function() { (bitmapData != null) ? completeHandler(null) : errorHandler(null); }, 10);
		#elseif flash
			loader.load ( new URLRequest ( URL ), new LoaderContext ( true ) );
		#elseif js
			untyped loader.draggable = false;
			loader.src = URL;
		#end
	}
	
	
	/**
	 *	Bitmapize and add the image to the displaylist.
	 */
	public function completeHandler (e:Event) :Void {
		
		#if (flash || (nme && (cpp || neko)))
			if (bitmapData != null) {
				// We already have the bitmapData at this point
				var bitmap = new Bitmap (bitmapData, PixelSnapping.AUTO, true);
				size_.width = bitmapData.width;
				size_.height = bitmapData.height;
				layer.addChild ( bitmap );
			}
			else {
				var w = Math.round (loader.content.width);
				var h = Math.round (loader.content.height);
				// Add the image to the view
				size_.width = w;
				size_.height = h;
				layer.addChild ( loader );
				// Get the BitmapData of the image
				
				if (w <= 2880 && h <= 2880) {
				
				}
				
				#if neko
					// Neko uses a typedef for the color: {rgb:Int, a:Float}
					bitmapData = new BitmapData (w, h, true, {rgb:0x000000, a:0});
				#else
					bitmapData = new BitmapData (w, h, true, 0x000000ff);
				#end
					bitmapData.draw ( loader.content );
				
				var bitmap = new Bitmap (bitmapData, PixelSnapping.AUTO, true);
				layer.removeChild ( loader );
				layer.addChild ( bitmap );
			}
		#elseif js
			size_.width = loader.width;
			size_.height = loader.height;
			layer.appendChild ( loader );
		#end
		
		originalSize_ = size.copy();
		this.isLoaded = true;
		
		#if js
			// onload is called too soon in IE if the image is cached
			if (RCDevice.currentDevice().userAgent == MSIE) {
				haxe.Timer.delay (function() { onComplete(); }, 10);
				return;
			}
		#end
		onComplete();
	}
	
	
#if (flash || (nme && (cpp || neko)))
	
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

	/**
	 *	Get a copy of the RCImage.
	 *  In flash and NME it creates in RCImage based on the existing BitmapData.
	 *  In JS it loads again the image, hopefully from cache.
	 */
	public function copy () :RCImage {
		#if (flash || (nme && (cpp || neko)))
			return imageWithBitmapData ( bitmapData );
		#elseif js
			return new RCImage (0, 0, loader.src);
		#end
	}
	
	function addListeners () :Void {
		#if (flash || (nme && (cpp || neko)))
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
		#if (flash || (nme && (cpp || neko)))
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.removeEventListener (ErrorEvent.ERROR, errorHandler);
			loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		#elseif js
			loader.onload = null;
			loader.onerror = null;
		#end
	}
	
	
	// Clan mess
	override public function destroy() :Void {
		removeListeners();
		#if (flash || (nme && (cpp || neko)))
			//loader.close();
			loader.unload();
			if (bitmapData != null)
				bitmapData.dispose();
		#elseif js
			//untyped loader.unload();
		#end
		loader = null;
		super.destroy();
	}

#if js
	// In js we need to resize the loader(image) and not only the layer
	override public function scaleToFit (w:Float, h:Float) :Void {
		super.scaleToFit (w, h);
		loader.style.width = size_.width + "px";
		loader.style.height = size_.height + "px";
	}
	override public function scaleToFill (w:Float, h:Float) :Void {
		super.scaleToFill (w, h);
		loader.style.width = size_.width + "px";
		loader.style.height = size_.height + "px";
	}
#end
}
