//
//  RCArray
//
//  Created by Cristi Baluta on 2010-06-24.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//

class RCArray<T> {
	
	var arr :Array<T>;
	
	
	var length (getLength, null) : Int;
	function getLength () :Int { return arr.length; }
	
	function new() : Void { arr = new Array<T>(); }
	
	function concat( a : Array<T> ) : Array<T> { return arr.concat ( a ); }
	
	function join( sep : String ) : String { return arr.join ( sep ); }
	
	function pop() : Null<T> { return arr.pop(); }
	
	function push(x : T) : Int { return arr.push ( x ); }
	
	function reverse() : Void { arr.reverse(); }
	
	function shift() : Null<T> { return arr.shift(); }
	
	function slice( pos : Int, ?end : Int ) : Array<T> { return arr.slice (pos, end); }
	
	function sort( f : T -> T -> Int ) : Void { arr.sort ( f ); }
	
	function splice( pos : Int, len : Int ) : Array<T> { return arr.splice (pos, len); }
	
	function toString() : String { return arr.toString(); }
	
	function unshift( x : T ) : Void { arr.unshift ( x ); }
	
	function insert( pos : Int, x : T ) : Void { arr.insert (pos, x); }
	
	function remove( x : T ) : Bool { return arr.remove ( x ); }
	
	function copy() : Array<T> { return arr.copy(); }
	
	function iterator() : Iterator<Null<T>> { return arr.iterator(); }
}
