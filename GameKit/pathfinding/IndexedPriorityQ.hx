package pathfinding;

class IndexedPriorityQ {
	
	var keys:Array<Float>;
	var data:Array<Int>;
	
	
	public function new (n_keys:Array<Float>) {
		
		keys = n_keys;
		data = new Array<Int>();
	}
	
	public function insert (idx:Int) :Void {
		
		data[data.length] = idx;
		reorderUp();
	}
	
	public function pop () :Int {
		
		var rtn = data[0];
		data[0] = data[data.length-1];
		data.pop();
		reorderDown();
		return rtn;
	}
	
	public function reorderUp () :Void {
		
		for (a in data.length-1...0) {
			if (keys[data[a]] < keys[data[a-1]]) {
				var tmp:Int=data[a];
				data[a]=data[a-1];
				data[a-1]=tmp;
			}
			else return;
		}
	}
		
	public function reorderDown():Void {
		
		for (a in 0...data.length-1) {
			if (keys[data[a]] > keys[data[a+1]]) {
				var tmp = data[a];
				data[a] = data[a+1];
				data[a+1] = tmp;
			}
			else return;
		}
	}
	public function isEmpty () :Bool {
		return (data.length == 0);
	}
}
