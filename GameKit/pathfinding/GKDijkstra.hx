package pathfinding;

class Dijkstra {
	
	private var graph :GKGraph;					//The graph where the search will be made
	private var SPT :Array<GKEdge>;			//This vector will store the Shortest Path Three
	private var cost2Node :Array<Float>;	//This vector will store the costs of getting to each node
	private var SF :Array<GKEdge>;			//This will be our search frontier, it will contain
	private var source :Int;
	private var target :Int;
	
	
	public function new (n_graph:GKGraph, src:Int, tar:Int) {
		graph=n_graph;
		source=src;
		target=tar;
		SPT= new Array<GKEdge>(graph.numNodes());
		cost2Node = new Array<Float>(graph.numNodes());
		SF = new Array<GKEdge>(graph.numNodes());
		search();
	}
	private function search () :Void {
		//This will be the indexed priority Queue that will sort the nodes
		var pq:IndexedPriorityQ = new IndexedPriorityQ(cost2Node);
		//To start the algorithm we first add the source to the pq
		pq.insert(source);
		//With this we make sure that we will continue the search until there is no more nodes on the pq
		while (!pq.isEmpty()) {
				
			/* 1.- Take the closest node not yet analysed */
				
			//We get the Next Closest Node (NCN) which is the first element of the pq
			var NCN:Int = pq.pop();
				
			/* 2.-Add its best edge to the Shortest Path Tree (Its best edge is stored on the SF) */
				
			SPT[NCN] = SF[NCN];
				
			//This will color the actual edge to red in order to see which edges algorithm had analyzed
			if (SPT[NCN]) {
				SPT[NCN].drawGKEdge (
					graph.getNode(SPT[NCN].from).getPos(),
					graph.getNode(SPT[NCN].to).getPos(),
					"visited"
				);
			}
			
			/* 3.- If if is the target node, finish the search */
			
			if (NCN == target) return;
			
			/* 4.- Retrieve all the edges of this node */
			
			var edges = graph.getGKEdges( NCN );
			
			//With this loop we will analyse each of the edges of the array
			for (edge in edges) {
				/* 5.- For each edge calculate the cost of moving from the source node to the arrival Node */
				
				//The total cost is calculated by: Cost of the node + Cost of the edge
				var nCost:Float = cost2Node[NCN] + edge.getCost();
				
				//If the arrival node has no edge on the SF, then add its cost to the
				//Cost vector, the arrival node to the pq, and add the edge to the SF
				if (SF[edge.to] == null) {
					cost2Node[edge.to] = nCost;
					pq.insert(edge.to);
					SF[edge.to] = edge;
				}

				/* 6.- If the cost of this edge is less than the cost of the arrival node until now, then update the node cost with the new one */					
				
				else if (nCost < cost2Node[edge.to] && SPT[edge.to] == null) {
					cost2Node[edge.to] = nCost;
					//Since the cost of the node has changed, we need to reorder again the pq to reflect the changes
					pq.reorderUp();
					//Because this edge is better, we update the SF with this edge
					SF[edge.to] = edge;
				}
			}
		}
	}
	
	public function getPath () :Array<Int> {
		//Create the variable where we will store the path
		var path = new Array<Int>();
		//If the target is a not valid index, or the SPT doesn't have a path to the node,
		//meaning that is wasn't found, just return an empty path
		if (target < 0 || SPT[target] == null) return path;
		//nd will store the current node, wich at the beggining is the target
		var nd:Int = target;
		//add the target to the path
		path.push(nd);
		//This loop will work until we find the source, or theres no edge in the SPT for a certain node
		while (nd != source && SPT[nd] != null) {
			//This will change the color of the path to black so we can actually se it
			SPT[nd].drawGKEdge(
				graph.getNode(SPT[nd].from).getPos(),
				graph.getNode(SPT[nd].to).getPos(),
				"path"
			);
			//Get the next node and add it to the path
			nd = SPT[nd].getFrom();
			path.push(nd);
		}
		//Reverse the path so the first element will be the source
		path = path.reverse();
			
		return path;
	}
}
