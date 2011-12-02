package  {
	import flash.display.PixelSnapping;
	import flash.events.ErrorEvent;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import haxe.Log;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.Boot;
	import flash.events.ProgressEvent;
	public class RCPhoto extends RCView {
		public function RCPhoto(x : Number = NaN,y : Number = NaN,URL : String = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y);
			this.load(URL);
			this.addListeners();
		}}
		
		protected var loader : flash.display.Loader;
		public var isLoaded : Boolean;
		public var percentLoaded : int;
		public var errorMessage : String;
		public var onComplete : Function = function() : void {
			null;
		}
		public var onProgress : Function = function() : void {
			null;
		}
		public var onError : Function = function() : void {
			null;
		}
		public function load(URL : String) : void {
			this.isLoaded = false;
			this.percentLoaded = 0;
			this.loader = new flash.display.Loader();
			this.loader.load(new flash.net.URLRequest(URL),new flash.system.LoaderContext(true));
		}
		
		protected function completeHandler(e : flash.events.Event) : void {
			this.w = this.lastW = this.loader.content.width;
			this.h = this.lastH = this.loader.content.height;
			this.isLoaded = true;
			this.addChild(this.loader);
			this.bitmapize();
			this.onComplete();
		}
		
		protected function progressHandler(e : flash.events.ProgressEvent) : void {
			this.percentLoaded = Math.round(e.target.bytesLoaded * 100 / e.target.bytesTotal);
			this.onProgress();
		}
		
		protected function errorHandler(e : flash.events.ErrorEvent) : void {
			this.errorMessage = e.toString();
			haxe.Log.trace(this.errorMessage,{ fileName : "RCPhoto.hx", lineNumber : 68, className : "RCPhoto", methodName : "errorHandler"});
			this.onError();
		}
		
		protected function ioErrorHandler(e : flash.events.IOErrorEvent) : void {
			this.errorMessage = e.toString();
			haxe.Log.trace(this.errorMessage,{ fileName : "RCPhoto.hx", lineNumber : 73, className : "RCPhoto", methodName : "ioErrorHandler"});
			this.onError();
		}
		
		protected function bitmapize() : void {
			var d : flash.display.Sprite = this.duplicate();
			if(d != null) {
				this.removeChild(this.loader);
				this.addChild(d);
			}
		}
		
		public function duplicate() : flash.display.Sprite {
			if(this.loader.content.width > 2880 || this.loader.content.height > 2880) return null;
			var bitmap : flash.display.BitmapData = new flash.display.BitmapData(Math.round(this.loader.content.width),Math.round(this.loader.content.height),true,255);
			bitmap.draw(this.loader.content);
			var d : flash.display.Sprite = new flash.display.Sprite();
			d.addChild(new flash.display.Bitmap(bitmap,flash.display.PixelSnapping.AUTO,true));
			return d;
		}
		
		protected function addListeners() : void {
			this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,this.completeHandler);
			this.loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS,this.progressHandler);
			this.loader.contentLoaderInfo.addEventListener(flash.events.ErrorEvent.ERROR,this.errorHandler);
			this.loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR,this.ioErrorHandler);
		}
		
		protected function removeListeners() : void {
			this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,this.completeHandler);
			this.loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS,this.progressHandler);
			this.loader.contentLoaderInfo.removeEventListener(flash.events.ErrorEvent.ERROR,this.errorHandler);
			this.loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,this.ioErrorHandler);
		}
		
		public override function destroy() : void {
			this.removeListeners();
			this.loader.unload();
			this.loader = null;
		}
		
	}
}
