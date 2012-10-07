//
//  HXAddressManager.hx
//
//  Created by Baluta Cristian on 2008-11-11.
//  Copyright (c) 2008-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class HXAddressManager {
	
	static var _title :String;
	static var _pages :Hash<Dynamic>; // [page name, function to call]
	
	
	public static function init (title:String) {
		_title = title;
		if (_pages != null) return;
		_pages = new Hash<Dynamic>();
		HXAddress.change.add (onChangeHandler);
	}
	
	
	/**
	 * Add a new page in the hash table
	 * key = page name
	 * func = the function asociated with this page
	 */
	public static function registerPage (key:String="", func:Dynamic) :Void {
		if (_pages == null) init ("HXAddress");
		if (!Reflect.isFunction (func)) return;
		_pages.set (key, func);
	}
	
	
	/**
	 *	Tell hxaddress to change the page.
	 *  Call this from anywhere in your application to produce the change
	 */
	public static function navigateToPage (addr:String) :Void {
		HXAddress.setValue ("/" + addr);
	}
	
	
	/**
	 *	Call this function whenever the CHANGE event is dispatched from HXAddress
	 */
	static function onChangeHandler (pathNames:Array<String>) :Void {
        HXAddress.setTitle ( formatTitle ( HXAddress.getValue()));
		call ( pathNames.shift());
    }
	
	static function call (key:String="") :Void {
        trace("call: "+key);
		if (_pages.exists (key)) {
			// Try executing the function asociated with this page
			try {
				_pages.get(key)();
			}
			catch (e:Dynamic) {
				trace ("[HXAddressManager error on executing page key: {"+key+"}], {"+e+"}");
			}
		}
    }
	
	
	
	// UTILITIES:
	static function formatTitle (title:String) :String {
		return _title + (title != '/'
				? ' / ' + toTitleCase (StringTools.replace (title.substr(1, title.length-1), '/', ' / '))
				: '');
	}
	inline static function toTitleCase (str:String) :String {
        return str.substr (0,1).toUpperCase() + str.substr(1);
    }
}
