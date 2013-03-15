// Used in RCTableView and RCGroup

class RCIndexPath {
	
	public var section :Int;
	public var row :Int;
	
	public function new (section:Int, row:Int) {
		this.section = section;
		this.row = row;
	}
	
	public function hasNext () :Bool {
		return true;
	}
	public function next () :RCIndexPath {
		return this;
	}
	
	public function copy () :RCIndexPath {
		return new RCIndexPath (section, row);
	}
	
	public function toString () :String {
		return ("[RCIndexPath section : "+section+", row : "+row+"]");
	}
}
