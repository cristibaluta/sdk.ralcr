//
//  RCProgressivePhoto
//
//  Created by Baluta Cristian on 2009-07-23.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLStream;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;


class RCProgressivePhoto extends Sprite {
	
	var loader :Loader;
	var imageStream :URLStream;
	var imageData :ByteArray;
	
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	
	public function new (x, y, path:String){
		super();
		this.x = x;
		this.y = y;
		
		imageStream = new URLStream();
		imageStream.addEventListener( ProgressEvent.PROGRESS , imageStreamProgress );
		imageStream.addEventListener( Event.COMPLETE , imageStreamComplete );
		imageStream.addEventListener (ErrorEvent.ERROR, imageStreamError);
		imageStream.addEventListener (IOErrorEvent.IO_ERROR, imageStreamError);
		
		loader = new Loader();
		this.addChild ( loader );
		
		imageData = new ByteArray();
		
		//if connected we need to stop that
		if (imageStream.connected)
			imageStream.close();
		imageStream.load ( new URLRequest( path ) );
	}
	
	function imageStreamProgress (e:ProgressEvent) {
		// if there are no bytes do nothing
		if (imageStream.bytesAvailable == 0) return;
		// ooo bytes process the image data
		this.processImageData();
	}
	
	function imageStreamComplete (e:Event) {
		if (imageStream.connected)
			imageStream.close();
			
		onComplete();
	}
	
	function imageStreamError (_) {
		onError();
	}

	function processImageData () {
		if ( imageStream.connected ) imageStream.readBytes( imageData , imageData.length );
		loader.unload();
		loader.loadBytes( imageData );            
	}
	
	
	public function destroy () :Void {
		if (imageStream.connected)
			imageStream.close();
			imageStream.removeEventListener( ProgressEvent.PROGRESS , imageStreamProgress );
			imageStream.removeEventListener( Event.COMPLETE , imageStreamComplete );
			imageStream.removeEventListener (ErrorEvent.ERROR, imageStreamError);
			imageStream.removeEventListener (IOErrorEvent.IO_ERROR, imageStreamError);
	}
}