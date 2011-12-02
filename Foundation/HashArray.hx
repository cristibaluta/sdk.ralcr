// A Hash structure that keeps the elements arranged
// The haXe Hash does not do this by itself

class HashArray<T> extends Hash<T> {
	
	public var arr :Array<String>;
	
	
	public function new () {
		
		super();
		arr = new Array<String>();
	}
	
	override public function set (key : String, value : T) : Void {
		if (!super.exists( key ))
			arr.push ( key );
		super.set (key, value);
	}
	
	override public function remove (key : String) : Bool {
		arr.remove( key );
		return super.remove( key );
	}
	
	public function insert (pos : Int, key : String, value : T) : Void {
		if (super.exists( key )) return;
		arr.insert (pos, key);
		super.set (key, value);
	}
	
	public function array () :Array<String> {
		return arr;
	}
}
