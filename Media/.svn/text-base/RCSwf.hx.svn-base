//
//  Poza
//
//  Created by Baluta Cristian on 2007-07-20.
//  Copyright (c) 2007 http://ralcr.com. All rights reserved.
//
import flash.events.Event;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.display.Loader;
import flash.net.URLRequest;


class RCSwf extends RCPhoto {
	
	public var target :Dynamic;
	public var event :Event;
	var newDomain :Bool;
	
	
	public function new (x, y, URL:String, ?newDomain:Bool=true) {
		this.newDomain = newDomain;
		super (x, y, URL);
	}
	
	override public function load (URL:String) {
		isLoaded = false;
		percentLoaded = 0;
		
		loader = new Loader();
		
		if (newDomain)
		loader.load ( new URLRequest ( URL ), new LoaderContext (true, new ApplicationDomain()) );
		else
		loader.load ( new URLRequest ( URL ) );
	}
	
	// do not bitmapize the swf
	override function completeHandler (e:Event) :Void {
		//trace("swf loaded");
		this.isLoaded = true;
		this.event = e;
		this.target = loader.content;
		this.size.width = loader.content.width;
		this.size.height = loader.content.height;
		this.view.addChild ( loader );
		
		onComplete();
	}
	
	
	public function callMethod (method:String, params:Array<String>) :Dynamic {
		return Reflect.callMethod (target, Reflect.field (target, method), params);
	}
	
	
	override public function destroy() :Void {
		
		removeListeners();
		
		// Remove any resource from swf if a destroy method exists
		try {
			untyped loader.contentLoaderInfo.content.destroy();
		}
		catch (e:Dynamic) {
			trace ( e );
			var stack = haxe.Stack.exceptionStack();
			trace ( haxe.Stack.toString ( stack ) );
		}
		//loader.close();
		loader.unload();
		loader = null;
	}
}
