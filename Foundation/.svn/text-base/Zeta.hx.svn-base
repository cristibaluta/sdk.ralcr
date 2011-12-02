//
//  Zeta
//
//  Created by Baluta Cristian on 2007-12-27.
//  Copyright (c) 2007 ralcr.com. All rights reserved.
//
// a colection of useful functions

class Zeta {
	
	// Is in
	inline public static var FIT :String = "fit";
	inline public static var END :String = "end";
	inline public static var ANYWHERE :String = "anywhere";
	inline public static var LOWERCASE :String = "lowercase";
	
	
	/**
	 * Analyze if the comparing array or string matches the compared array or string
	 * Generaly compare if files are matching a list of extensions
	 *
	 * pos can take the following values:
	 * - anywhere (anywhere in the string),
	 * - end (at the end of the string),
	 * - fit (must be the exact string)
	 */
	public static function isIn (search_this:Dynamic, in_this:Dynamic, ?pos:String="fit") :Bool {
		
		if (search_this == null || in_this == null) return false;
		
		var arr1 :Array<Dynamic> = Std.is (search_this, Array)	? search_this	: [search_this];
		var arr2 :Array<Dynamic> = Std.is (in_this, Array)		? in_this		: [in_this];
		
		// compare each with each
		for (a1 in arr1)
			for (a2 in arr2)
				switch (pos.toLowerCase()) {
					case ANYWHERE:
						if (a1.toLowerCase().indexOf (a2.toLowerCase()) != -1) return true;
					case END:
						if (a1.toLowerCase().substr (a1.length - a2.length) == a2.toLowerCase()) return true;
					case FIT:
						if (a1 == a2) return true;
					case LOWERCASE:
						if (a1.toLowerCase() == a2.toLowerCase()) return true;
					default:
						trace ("Position in string not implemented");
						return false;
				}
		
		return false;
	}
	
	
	/**
	 *	Concat multiple objects
	 */
	public static function concatObjects (objs:Array<Dynamic>) :Dynamic {
		
		var finalObject :Dynamic = {};
		
		for (currentObject in objs)
			for (prop in Reflect.fields (currentObject))
				if (Reflect.field (currentObject, prop) != null)
					Reflect.setField (finalObject, prop, Reflect.field (currentObject, prop));
					
		return finalObject;
	}
	
	
	
	/**
	 *	Sort the array
	 *	Usualy received as descending by modified date
	 *	array2 is used to sort the array with priority on elements from array2
	 */
	public static function sort<T> (array:Array<T>, sort_type:String, ?sort_array:Array<T>) :Array<T> {
		
		if (sort_type.toLowerCase() == "lastmodifieddescending") return array;
		if (sort_type.toLowerCase() == "lastmodifiedascending") sort_type = "reverse";
		if (sort_type.toLowerCase() == "customascending" && sort_array != null) sort_type = "custom";
		if (sort_type.toLowerCase() == "customdescending" && sort_array != null) {
			sort_array.reverse();
			sort_type = "custom";
		}
		
		switch ( sort_type.toLowerCase() ) {
			case "reverse": 	array.reverse();
			case "ascending": 	array.sort ( ascendingSort );
			case "descending": 	array.sort ( descendingSort );
			case "random":		array.sort ( randomSort );
			case "custom":		var arr = new Array<T>();
								for (a in sort_array)
								for (b in array)
									if (a == b) {
										arr.push ( a );
										array.remove ( a );
										break;
									}
								return arr.concat ( array );
			default:			untyped array.sortOn ( sort_type, /*Array.ASCENDING | */Array.NUMERIC );
		}
		return array;
	}
	inline static function randomSort<T> (a:T, b:T) :Int { 
		return -1 + Std.random (3);
	}
	inline static function ascendingSort<T> (a:T, b:T) :Int { 
		return (Std.string(a) > Std.string(b)) ? 1:-1;
	}
	inline static function descendingSort<T> (a:T, b:T) :Int { 
		return (Std.string(a) > Std.string(b)) ? -1:1;
	}
	
	
	
	/**
	 *	Return an array filled with ascending numbers
	 */
	inline public static function array (len:Int, ?zeros:Bool=false) :Array<Int> {
		var a = new Array<Int>();
		for (i in 0...len)
			a.push ( zeros ? 0 : i );
		return a;
	}
	
	inline public static function duplicateArray<T> (arr:Array<T>) :Array<T> {
		var newArr = new Array<T>();
		for (a in arr) {
			newArr.push ( a );
		}
		return newArr;
	}
	
	
	
	/** The equation of a stright line

	 ( x0 - x1 )   ( y0 - y1 )
	 ----------- = -----------
	 ( x2 - x1 )   ( y2 - y1 )

	       (x2-x1)*(y0-y1)
	 x0 = ----------------- +x1
	           (y2-y1)

	       (x0-x1)*(y2-y1)
	 y0 = ----------------- +y1
	           (x2-x1)
	*/
	inline public static function lineEquation (x1:Float, x2:Float, y0:Float, y1:Float, y2:Float) :Float {
		return (x2 - x1) * (y0 - y1) / (y2 - y1) + x1;
	}
	
	inline public static function lineEquationInt (x1:Float, x2:Float, y0:Float, y1:Float, y2:Float) :Int {
		return Math.round ( (x2 - x1) * (y0 - y1) / (y2 - y1) + x1 );
	}
	
	
	/**
	 *	Check a value to be in the limits
	 */
	inline public static function limits (val:Float, min:Float, max:Float) :Float {
		return if (val < min) min; else if (val > max) max; else val;
	}
	
	inline public static function limitsInt (val:Float, min:Float, max:Float) :Int {
		return Math.round ( if (val < min) min; else if (val > max) max; else val );
	}
	
	
}
