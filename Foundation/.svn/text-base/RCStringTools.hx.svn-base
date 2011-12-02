//
//  StringTools
//
//  Created by Baluta Cristian on 2008-09-18.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//

class RCStringTools {
	
	
	
	inline public static var DIGITS :String = "0123456789abcdefghijklmnopqrstuvwxyz";
	
	
	/**
	 * Add zeros
	 */
	public static function add0 (nr:Int) :String {
		return Std.string ((nr >= 10 ? "" : "0") + nr);
	}
	
	
	/**
	 * Returns the minutes and seconds with leading zeros
	 * for example: 70 returns 01:10
	 */
	public static function formatTime (t:Float) :String {
		
		//var h:Int = Math.floor (t / 3600);
		var m = Math.floor ( t / 60 );
		var s = Math.round ( t - m * 60 );
		
		return ( add0( m ) + ":" + add0( s ) );
	}
	
	
	/**
	 * replace a part of the string with ...
	 */
	public static function cutString (str:String, limit:Int) :String {
		var fin = str.length > limit ? "..." : "";
		return ( str.substr (0, limit) + fin );
	}
	public static function cutStringAtLine (textfield:flash.text.TextField, line:Int) :String {
		var index = textfield.getLineOffset ( line );
		return ( textfield.text.substr (0, index) + " ..." );
	}
	
	
	/**
	 *  %@
	 */
	public static function stringWithFormat (str:String, arr:Array<Dynamic>) :String {
		var str_arr = str.split ("%@");
		var str_buf :StringBuf = new StringBuf();
		
		for (i in 0...str_arr.length) {
			str_buf.add ( str_arr[i] );
			if (arr[i] != null)
			str_buf.add ( arr[i] );
		}
		
		return str_buf.toString();
	}
	
	
	/**
	 * Capitalize the first letter
	 */
    public static function toTitleCase (str:String) :String {
        return str.substr(0, 1).toUpperCase() + str.substr(1).toLowerCase();
    }
	
	/**
	 * Add slashes
	 */
	public static function addSlash (str:String) :String {
		str = StringTools.trim ( str );
		return StringTools.endsWith (str, "/") ? str : (str + "/");
	}
	
	
	/**
	 *	Check for the e-mail to be formated corectly
	 */
	public static function validateEmail (email:String) :Bool {
		return (email.indexOf(".") > 0 && email.indexOf("@") > 1);
	}
	
	/**
	 *	Encode and decode the e-mail for when exposed to search engines
	 */
	public static function encodeEmail (email:String, ?replacement:String="[-AT-]") :String {
		return StringTools.replace (email, "@", replacement);
	}
	public static function decodeEmail (email:String, ?replacement:String="[-AT-]") :String {
		return StringTools.replace (email, replacement, "@");
	}
	
	
	/**
	 *	Parse the links and e-mails found in a string
	 */
	public static function parseLinks (str:String) :String {
		// create a list of words
		var str_arr :Array<String> = str.split(" ");
		var str_buf :StringBuf = new StringBuf();
		
		for (word in str_arr) {
			if (word.indexOf("@") > 1 && word.indexOf(".") > 0 && word.indexOf("mailto:") == -1) {
				// e-mail address
				str_buf.add ("<a href='mailto:" + word.toLowerCase() + "' target='_blank'>" + word + "</a>");
			}
			else if (word.indexOf("http://") == 0) {
				// link
				str_buf.add ("<a href='" + word.toLowerCase() + "' target='_blank'>" + word + "</a>");
			}
			else if (word.indexOf("www.") == 0) {
				// link
				str_buf.add ("<a href='http://" + word.toLowerCase() + "' target='_blank'>" + word + "</a>");
			}
			else {
				// no link or e-mail fpund
				str_buf.add ( word );
			}
			
			str_buf.add (" ");
		}
		
		return str_buf.toString();
	}
	
	
	public static function removeLinks (str:String) :String {
		var r1: EReg = ~/<b>/g;
		var r2: EReg = ~/<\/b>/g;
		var r3: EReg = ~/<a.*?">/g;
		var r4: EReg = ~/<\/a>/g;
		var s = r1.replace (str, "");
			s = r2.replace (s, "");
			s = r3.replace (s, "");
			s = r4.replace (s, "");
		return s;
	}
}
