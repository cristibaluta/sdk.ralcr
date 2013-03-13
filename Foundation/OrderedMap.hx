// A Hash structure that keeps the keys arranged in an array
// The Haxe Hash does not do this by itself

class OrderedMap<T> extends haxe.ds.StringMap<T> {
	
	public var array :Array<String>;
	
	
	public function new () {
		
		super();
		array = new Array<String>();
	}
	
	// In neko this methods are inlined
#if !neko
	override public function set (key : String, value : T) : Void {
		if (!super.exists( key ))
			array.push ( key );
		super.set (key, value);
	}
	
	override public function remove (key : String) : Bool {
		array.remove( key );
		return super.remove( key );
	}
#end
	public function insert (pos : Int, key : String, value : T) : Void {
		if (super.exists( key )) return;
		array.insert (pos, key);
		super.set (key, value);
	}
	
	public function indexForKey (key:String) :Int {
		for (i in 0...array.length)
			if (array[i] == key)
				return i;
				return -1;
	}
}
