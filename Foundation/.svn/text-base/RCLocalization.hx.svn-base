//
//  Handle localization
//
//  Created by Baluta Cristian on 2010-04-16.
//  Copyright (c) 2010 http://ralcr.com. All rights reserved.
//
class RCLocalization {
	
	static var inited :Bool = false;
	public static var percentLoaded :Int;
	public static var hash :Hash<String>;
	public static var list :RCLocalizationProxy;// Has autocomplete
	
	
	public static function init () :Void {
		
		if (inited) return;
		
		percentLoaded = 0;
		hash = new Hash<String>();
		list = new RCLocalizationProxy ( hash.get );
		inited = true;
	}
	
	public static function setDictionary (dict:String) :Void {
		//trace("dictionary loaded "+e.target.data);
		if (dict == null) return;
		init();
		
		var xml = Xml.parse( dict ).firstElement();
		
		// Iterate over words
		for (e in xml.elements()) try {
			set (e.get("id"), e.firstChild().nodeValue);
		}
		catch (e:Dynamic) { trace(e); }
	}
	
	/**
	 *	Set localization values.
	 */
	public static function set (key:String, value:String) :Void {
		init();
		//trace([key.toLowerCase(), value].join(" - "));
		hash.set (key, value);
	}
	
	
	/**
	 *	Returns the localized string
	 */
	public static function get (key:String) :String {
		
		init();
		
		if (key == null) return "";
		//var key2 = StringTools.replace (key.toLowerCase(), " ", "_");
		
		return hash.exists( key ) ? hash.get( key ) : key;
	}
	
	
	public static function clean () {
		hash = new Hash<String>();
	}
}
