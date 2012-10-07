//
//  RCSwf
//
//  Created by Baluta Cristian on 2007-07-20.
//  Copyright (c) 2007-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	#if flash
		import flash.system.LoaderContext;
		import flash.system.ApplicationDomain;
	#end
#elseif js
	import js.Dom;// Includes the js.Event
#end


class RCSwf extends RCImage {
	
	public var target :Dynamic;
	public var event :Event;
	var newDomain :Bool;
	var id_ :String;// Generate an unique id (for JS)
	
	
	public function new (x, y, URL:String, ?newDomain:Bool=true) {
		this.newDomain = newDomain;
		this.id_ = "swf_"+Date.now().toString();
		super (x, y, URL);
	}
	
	override public function initWithContentsOfFile (URL:String) {
		isLoaded = false;
		percentLoaded = 0;
		
		#if (flash || (nme && flash))
			if (newDomain)
				loader.load ( new URLRequest ( URL ), new LoaderContext (true, new ApplicationDomain()) );
			else
				loader.load ( new URLRequest ( URL ) );
		#elseif js
			// For JS target use swfobject
			layer.id = id_;
			layer.appendChild ( layer );
/*			target = new js.SWFObject (URL, id_, 500, 400, "9", "#cecece");
			target.addParam("AllowScriptAccess","always");
			target.addParam("AllowNetworking","all");
			target.addParam("wmode", "transparent");
			//target.addVariable("texto", "hello from...");
			target.write(id_);*/
		#end
	}
	
	// Do not bitmapize the swf
	override function completeHandler (e:Event) :Void {trace(e);
		#if flash
			//trace("swf loaded");
			this.isLoaded = true;
			this.event = e;
			this.target = loader.content;
			this.size.width = loader.content.width;
			this.size.height = loader.content.height;
			layer.addChild ( loader );
		#end
		this.isLoaded = true;
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
		#if flash
			loader.unload();
			loader = null;
		#end
	}
}
