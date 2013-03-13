//
//  DateTools2
//
//  Created by Baluta Cristian on 2008-11-19.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCDateTools {
	
	inline public static function MONTHS() :Array<String> {
		return ["January", "February", "March", "April", "May", "June",
				"July", "August", "September", "October", "November", "December"];
	}
	
	inline public static function DAYS () :Array<String> {
		return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	}
	
	
	/**
	 * Convert a date from Y-m-d to plain text format: Saturday 24 February 2009
	 */
	public static function decodeDate (s:String) :String {
		var date = Date.fromString ( s );
		return ( DAYS()[date.getDay()] +" "+ date.getDate() +" "+ MONTHS()[date.getMonth()] +" "+ date.getFullYear() );
	}
	
	/**
	 *	Extract the time
	 */
	public static function decodeTime (s:String) :String {
		var date = Date.fromString ( s );
		return ( add0 ( date.getHours() ) + ":" + add0 ( date.getMinutes() ) );
	}
	
	public static function extractDate (s:String) :String {
		return s.split(" ").shift();
	}
	
	
	static function add0 (nr:Int) :String {
		return Std.string ((nr >= 10 ? "" : "0") + nr);
	}
}
