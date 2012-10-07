package pathfinding;

class GKEdge {
		
	public var from :Int; // The index of the node from which this edge departs
	public var to :Int; // The index of the node from which this edge arrives
	public var cost :Float; // The cost of crossing through this node
	
	
	public function new (n_From:Int, n_To:Int, n_Cost:Float=1.0) {
		
		from = n_From;
		to = n_To;
		cost = n_Cost;
	}
}
