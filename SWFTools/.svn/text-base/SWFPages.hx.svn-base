//
//  SWFPages
//
//  Created by Baluta Cristian on 2008-11-11.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
class SWFPages {
	
	static var title :String;
	static var pages :Hash<Dynamic>; // [page name, function to call]
	
	
	/**
	 * Init the process of listening to address changes
	 */
	public static function init (title:String) {
		SWFPages.title = title;
		SWFPages.pages = new Hash<Dynamic>();
	}
	
	
	/**
	 * Add a new page in the hash table
	 * key = page name
	 * func = the function asociated with this page
	 */
	public static function registerPage (key:String="", func:Dynamic) :Void {
		if (pages == null) init ("SWFAddress");
		if (!Reflect.isFunction (func)) return;
		pages.set (key, func);
	}
	
	
	/**
	 *	Change the page. Call this from anywhere in your application to produce the change
	 */
	public static function deepLinking (addr:String) :Void {
		SWFAddress.setValue ("/" + addr);
	}
	
	
	/**
	 *	Call this function whenever the CHANGE event is dispatched from SWFAddress
	 */
	public static function call (key:String="") :Void {
		// Make a safer key, decode it
		if (key != null)
			key = StringTools.urlDecode ( key );
		
		if (pages.exists( key )) {
			// Try executing the function asociated with this page
			try {
				pages.get( key )();
			}
			catch (e:Dynamic) {
				trace ("[SWFPages error on executing: "+pages.get( key )+"], {"+e+"}");
				var stack = haxe.Stack.exceptionStack();
				trace ( haxe.Stack.toString ( stack ) );
			}
		}
    }
	
	
	/**
	 *	Call this function whenever the CHANGE event is dispatched from SWFAddress
	 */
	public static function onChange () :Void {
        SWFAddress.setTitle ( formatTitle (SWFAddress.getValue()) );
		call ( SWFAddress.getPathNames().shift() );
    }
	
	
	// UTILITIES:
	
	/**
	 *	Format the title
	 */
	static function formatTitle (title:String) :String {
		return SWFPages.title + (title != '/'
				? ' / ' + toTitleCase (StringTools.replace (title.substr(1, title.length-1), '/', ' / '))
				: '');
	}
	static function toTitleCase (str:String) :String {
        return str.substr(0, 1).toUpperCase() + str.substr(1);
    }
}
