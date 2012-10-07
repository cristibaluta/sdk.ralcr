package pathfinding;

class GKGraph {
	
	static var nextIndex:Int = 0;
	var nodes:Array<GKNode>;
	var edges:Array<Array<GKEdge>>;
	
	
	public function new () {
		nodes = new Array<GKNode>();
		edges = new Array<Array<GKEdge>>();
	}
    //In order to get the node, we just ask for the index of it, and access the nodes vector with that key
	public function getNode (idx:Int) :GKNode {
		return nodes[idx];
	}

    //To get an edge, we ask for the two nodes that it connects,
    //then we retrieve all the edges of the from node and search if one of them
    //goes to the same node as the edge we are looking for, if it does, thats our edge.
	public function getEdge (from:Int, to:Int) :GKEdge {
		
		var fromEdges = edges[from];
		for (a in 0...fromEdges.length) {
			if (fromEdges[a].to == to) {
				return fromEdges[a];
			}
		}
		return null;
	}

    //To add a node to the graph, we first look if it already exist on it,
    //if it doesnt, then we add it to the nodes vector, and add an array to the
    //edges vector where we will store the edges of that node, finally we increase
    //the next valid index Int in order to give the next avilable index in the graph
	public function addNode (node:GKNode) :Int {
		
		if (validIndex ( node.index)) {
			nodes.push ( node );
			edges.push ( new Array<GKEdge>());
			nextIndex++;
		}
		return 0;
	}
    //To add an edge we must first look if both nodes it connects actually exist,
    //then we must see if this edge already exist on the graph, finally we add it
    //to the array of edges of the node from where it comes
	public function addEdge (edge:GKEdge) :Void {
		if (validIndex(edge.to) && validIndex(edge.from)) {
			if (getEdge(edge.from, edge.to) == null) {
				edges[edge.from].push ( edge );
			}
		}
	}
	
    //To get the edges of a node, just return the array gived by the edges vector
    //at node's index position
	public function getEdges (node:Int) :Array<GKEdge> {
		return edges[node];
	}
	
    //This function checks if the node index is between the range of already added nodes
    //which is form 0 to the next valid index of the graph
	public function validIndex (idx:Int) :Bool {
		return (idx >= 0 && idx <= nextIndex);
	}
	
    //Just returns the amount of nodes already added to the graph
	public function numNodes () :Int {
		return nodes.length;
	}
	
    //This function return the next valid node index to be added
	public static function getNextIndex () :Int {
		return nextIndex;
	}
}

