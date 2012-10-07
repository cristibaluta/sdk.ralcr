package pathfinding;

class GKAstar {
	
	private var graph :GKGraph;
	private var SPT :Array<GKEdge>;
	private var G_Cost :Array<Float>;	//This vector will store the G cost of each node
	private var F_Cost :Array<Float>;	//This vector will store the F cost of each node
	private var SF :Array<GKEdge>;
	private var source :Int;
	private var target :Int;
	
	
	public function new (n_graph:GKGraph, src:Int, tar:Int) {
		
		graph = n_graph;
		source = src;
		target = tar;
		SPT = new Array<GKEdge>();// ( graph.numNodes());
		G_Cost = new Array<Float>();// ( graph.numNodes());
		F_Cost = new Array<Float>();// ( graph.numNodes());		
		SF = new Array<GKEdge>();// ( graph.numNodes());
		search();
	}
	
	function search () :Void {
		//The pw is now sorted depending on the F cost vector
		var pq = new IndexedPriorityQ ( F_Cost );
			pq.insert ( source );
			
		while (!pq.isEmpty()) {
			var NCN = pq.pop();
			SPT[NCN] = SF[NCN];
			
			/*if (SPT[NCN]) {
				SPT[NCN].drawGKEdge(
					graph.getNode(SPT[NCN].getFrom()).getPos(),
					graph.getNode(SPT[NCN].getTo()).getPos(),
					"visited"
				);
			}*/
			if (NCN == target) return;
			var edges = graph.getEdges(NCN);
			for (edge in edges) {
				//The H cost is obtained by the distance between the target node
				// and the arrival node of the edge being analyzed
				var Hcost = RCVector.distanceBetween (graph.getNode( edge.to ).pos, graph.getNode( target ).pos);
				var Gcost = G_Cost[NCN] + edge.cost;
				var to:Int = edge.to;
				
				if (SF[edge.to] == null) {
					F_Cost[edge.to] = Gcost + Hcost;
					G_Cost[edge.to] = Gcost;
					pq.insert ( edge.to );
					SF[edge.to] = edge;
				}
				else if (Gcost < G_Cost[edge.to] && SPT[edge.to] == null) {
					F_Cost[edge.to] = Gcost + Hcost;
					G_Cost[edge.to] = Gcost;
					pq.reorderUp();
					SF[edge.to] = edge;
				}
			}
		}
	}
	
	public function getPath () :Array<GKNode> {
		
		var path = new Array<Int>();
		var nodes = new Array<GKNode>();
		
		if (target < 0) return nodes;
		var nd:Int = target;
		path.push( nd );
		
		while (nd != source && SPT[nd] != null) {
			//SPT[nd].drawEdge (graph.getNode(SPT[nd].from).pos, graph.getNode(SPT[nd].to).pos, "path");
			nd = SPT[nd].from;
			path.push ( nd );
		}
		path.reverse();
		
		for (i in 0...path.length) {
			//trace( graph.getNode( path[i] ).getIndex() );
			nodes.push ( graph.getNode( path[i] ) );
		}
		
		return nodes;
	}
}
