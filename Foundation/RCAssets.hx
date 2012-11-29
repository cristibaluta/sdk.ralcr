//
//	RCAssets.hx
//	Foundation
//  Lib to load external swfs, images, fonts... into an async way
//	
//
//  Created by Baluta Cristian on 2009-01-09.
//  Copyright (c) 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash && nme)
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
#end
#if (flash || nme)
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
#end


class RCAssets {
	
	static var INSTANCE :RCAssets;
	
	var imagesList :Hash<RCImage>;
	var swfList :Hash<RCSwf>;// Keep a reference to the loaded swf Event in order to acces its assets later
	var dataList :Hash<String>;
	var nr :Int;
	var max :Int;
	
	public static var errorMessage :String; // Error message that should be accessed after onError is fired
	public static var currentPercentLoaded :Hash<Int>;
	public static var percentLoaded :Int;
	public static var useCache :Bool;
	
	
	dynamic public static function onComplete () :Void {}
	dynamic public static function onProgress () :Void {}
	dynamic public static function onError () :Void {}
	
	
	static function init () :Void {
		if (INSTANCE != null) return;
			INSTANCE = new RCAssets();
		currentPercentLoaded = new Hash<Int>();
		useCache = false;
	}
	
	/**
	 *  Convenience class methods to load assets and extract assets
	 **/
	public static function sharedAssets () : RCAssets {
		init();
		return INSTANCE;
	}
	public static function loadFileWithKey (key:String, URL:String) :Bool {
		return sharedAssets().set (key, URL);
	}
	public static function loadFontWithKey (key:String, URL:String) :Bool {
		return sharedAssets().set (key, URL, false);
	}
	public static function getFileWithKey (key:String, returnAsBitmap:Bool=true) :Dynamic {
		return sharedAssets().get (key, returnAsBitmap);
	}
	
	
	
	/**
	 *  RCAssets can be initialized only once
	 */
	function new () {
		imagesList = new Hash<RCImage>();
		swfList = new Hash<RCSwf>();
		dataList = new Hash<String>();
		nr = 0;
		max = 0;
	}
	
	public function set (key:String, URL:String, ?newDomain:Bool=true) :Bool {
		//trace("set "+key+", "+URL);
		max ++;
		
		if (key == null)
			key = Std.string ( Math.random() );
			
		if (URL.toLowerCase().indexOf(".swf") != -1)
		{
			loadSwf (key, URL, newDomain);
		}
		else if(URL.toLowerCase().indexOf(".xml") != -1 ||
				URL.toLowerCase().indexOf(".txt") != -1 ||
				URL.toLowerCase().indexOf(".css") != -1)
		{
			loadText (key, URL);
		}
		else if(URL.toLowerCase().indexOf(".ttf") != -1 ||
				URL.toLowerCase().indexOf(".otf") != -1)
		{
			loadFont (key, URL);
		}
		else {
			if (RCDevice.currentDevice().dpiScale == 2) {
				// Resolve url for retina image assets
				var u = URL.split(".");
				var ext = u.pop();
				URL = u.join(".") + "@2x." + ext;
			}
			
			loadPhoto (key, URL);
		}
		return true;
	}
	function loadPhoto (key:String, URL:String) :Void {
		trace("load photo "+key+", "+URL);
		var photo = new RCImage (0, 0, URL);
			photo.onProgress = callback (progressHandler, key, photo);
			photo.onComplete = callback (completeHandler, key, photo);
			photo.onError = callback (errorHandler, key, photo);
	}
	function loadSwf (key:String, URL:String, ?newDomain:Bool=true) :Void {
		//trace("load swf "+key+", "+URL);
		var swf = new RCSwf (0, 0, URL, newDomain);
			swf.onProgress = callback (progressHandler, key, swf);
			swf.onComplete = callback (completeHandler, key, swf);
			swf.onError = callback (errorHandler, key, swf);
	}
	function loadText (key:String, URL:String) :Void {
		//trace("load text "+key+", "+URL);
		var data = new RCHttp();
		#if nme
			// Search for the asset in NME library first
			data.result = nme.Assets.getText ( URL );
		#end
		if (data.result == null) {
			// If NME assets didn't contained the asset, load them with http request
			data.onProgress = callback (progressHandler, key, data);
			data.onComplete = callback (completeHandler, key, data);
			data.onError = callback (errorHandler, key, data);
			data.readFile ( URL );
		}
		else {
			haxe.Timer.delay ( function() { completeHandler (key, data); }, 10);
		}
	}
	function loadFont (key:String, URL:String) :Void {
#if js
		// http://www.css3.info/preview/web-fonts-with-font-face/
		//@font-face { font-family: Delicious; src: url('Delicious-Roman.otf'); } 
		//@font-face { font-family: Delicious; font-weight: bold; src: url('Delicious-Bold.otf'); }\
		//h3 { font-family: Delicious, sans-serif; }
		var fontType:String = "";
/*		if (URL.toLowerCase().indexOf(".ttf") != -1)
			fontType = " format(\"truetype\")";*/
			
		// Create a 'style' element	
		var st = js.Lib.document.createElement("style");
			st.innerHTML = "@font-face{font-family:"+key+"; src: url('"+URL+"')" +fontType+ ";}";
			
		// Now add this new element to the head tag
		js.Lib.document.getElementsByTagName("head")[0].appendChild(st);
		// Make the load async by calling onComplete a little later
		haxe.Timer.delay (onCompleteHandler, 16);
#end
	}
	
	
	
	/**
	*  Dispatch onComplete and onError events
	*/
	function errorHandler (key:String, media:Dynamic) :Void {
		//trace("Error loading URL for key: '"+key+"' with object: "+media);
		max --;
		onError();
		if (nr >= max)
			onComplete();
	}
	function progressHandler (key:String, obj:Dynamic) :Void {
		currentPercentLoaded.set ( key, obj.percentLoaded );// All supported objects have this property
		totalProgress();
	}
	function completeHandler (key:String, obj:Dynamic) :Void {
		//trace("completeHandler for key: '"+key+"' with object: "+obj);
		// RCImage has some static fields that is causing Type.getClass to return a complex type
		// instead a simple class name
		var class_name = Type.getClassName ( Type.getClass ( obj));
		switch (class_name) {
			case "RCImage" : imagesList.set ( key, obj );
			case "RCHttp" : dataList.set ( key, obj.result );
			case "RCSwf" : swfList.set ( key, obj );
			default : trace("Asset not supported: key="+key+", class_name="+class_name);
		}
		onCompleteHandler();
	}
	
	/**
	 *  Count the total assets loaded
	 **/
	function onCompleteHandler () :Void {
		nr ++;
		if (nr >= max)
			onComplete();
	}
	
	
	function totalProgress () :Void {
		var totalPercent = 0;
		var i = 0;
		for (key in currentPercentLoaded.keys()) {
			i++;
			totalPercent += currentPercentLoaded.get( key );
		}
		percentLoaded = Math.round (totalPercent / i);
		onProgress();
	}
	
	
	
	/**
	 *	Get the asset.
	 *  Can be RCImage, RCSwf, String, and Sprite or MovieClip as a RCView
	 *	@param key - The key on which the asset was registered
	 *  @param returnAsBitmap - When the asset is from an external swf you can force it to return as a Bitmap Sprite
	 */
	public function get (key:String, returnAsBitmap:Bool=true) :Dynamic {
		init();
		//trace("get key "+key);//trace(swfList.exists ( key ));
		// Search for assets in the Hash of imagesList first
		if (imagesList.exists ( key )) {
			return imagesList.get( key ).copy();// Returns RCImage
		}
		
		else if (dataList.exists ( key )) {
			return dataList.get( key );// Returns String
		}
		
		else if (swfList.exists ( key )) {
			return swfList.get( key );// Returns RCSwf
		}
		
#if (flash || nme)
		// In the last instance search for assets in each of the loaded swf files, might be there
		else {
			var classInstance :Dynamic = createInstance ( key );// Can be Sprite or MovieClip
			if (classInstance == null) {
				trace("Asset with key: "+key+"  was not found in swf assets.");
				return null;
			}
			
			if (returnAsBitmap) {
				return bitmapize ( classInstance );// Returns a RCView
			}
			else {
				var view = new RCView(0,0);
					view.layer.addChild ( classInstance );
				return view;
			}
		}
#end
		// No class was found with this definition name
		trace("Asset with key: "+key+"  was not found.");
		return null;
	}
	
#if (flash || nme)
	/**
	 *  Create an instance from an asset found in an external swf
	 *  For NME the swf was converted to classes already by the compiler
	 *  For flash search into each loaded swf
	 *  @param className = the name of the asset
	 *  @param args = Pass some params if you need them
	 */
	public function createInstance (className:String, ?args:Array<Dynamic>) :Dynamic {
		
		if (args == null)
			args = [];
		
		#if (cpp || neko)
			// Search for the asset in NME swf library assets
			return Type.createInstance ( Type.resolveClass ( className), args);
		#else
		
			for (swf in swfList)
			if (swf.event.target.applicationDomain.hasDefinition ( className ))
			{
				var def = swf.event.target.applicationDomain.getDefinition ( className );
				var classInstance = Type.createInstance ( cast ( def, Class<Dynamic>), args );
				return classInstance;
			}
			
		#end
		return null;
	}
	
	
	/**
	 *  Create a Bitmap from the input mc and returns it as a RCView
	 */
	function bitmapize (mc:Dynamic) :RCView {
		
		if (mc.width > 2880 || mc.height > 2880) return null;
		
		#if neko
		var bitmapData = new BitmapData (Math.round (mc.width), Math.round (mc.height), true, {rgb:0x000000, a:0} );
		#else
		var bitmapData = new BitmapData (Math.round (mc.width), Math.round (mc.height), true, 0x000000ff );
		#end
			bitmapData.draw ( mc );
		
		var d = new RCView(0,0);
			d.layer.addChild ( new Bitmap (bitmapData, PixelSnapping.AUTO, true) );
		
		return d;
	}
#end
}
