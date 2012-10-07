package pathfinding;

class GKGrapher {
	
	var cells :Array<Array<Int>>;
	var valuesToIgnore :Array<Int>;
	
	
	public function new (cells:Array<Array<Int>>, n_graph:GKGraph, valuesToIgnore:Array<Int>) {
			
		this.cells = cells;
		var cellsX :Int = cells.length;
		var cellsY :Int = cells.length;
			
		var dx :Int = 1;
		var dy :Int = 1;
			
		for (x in 0...cellsX) {
			for (y in 0...cellsY) {
				var node = new GKNode (GKGraph.getNextIndex(), new RCVector (x*dx, y*dy));
				n_graph.addNode ( node );
			}
		}
			
		for (node_x in 0...cellsX) {
			for (node_y in 0...cellsY) {
				
				var cell :Int = cells[node_y][node_x];
				if (cell < 0 || cell == 20) {
					addNeighbours (n_graph, node_y, node_x, cellsX, cellsY);
				}
			}
		}
	}
		
	public function addNeighbours (n_graph:GKGraph, row:Int, col:Int, cellsX:Int, cellsY:Int) :Void {
			
		var cc:Int = cells[row][col];// current cell
			
		for (i in -1...1) {
			for (j in -1...1) {
				
				var nodeY = row + j;
				var nodeX = col + i;
				
				if (i==0 && j==0) continue;
				
				if (nodeX >= 0 && nodeX < cellsX && nodeY >= 0 && nodeY < cellsY) {
					
					var nc :Int = cells[nodeY][nodeX];// neighbour cell
					
					// Neighbours to ignore
					if (nc >= 0 && nc != 20) continue;
					if (cc == -6 && i == -1 && j == 1) continue;
					if (cc == -7 && i == 1 && j == 1) continue;
					if (cc == -8 && i == 1 && j == -1) continue;
					if (nc == -6 && i == 1 && j == -1) continue;
					if (nc == -7 && i == -1 && j == -1) continue;
					if (nc == -8 && i == -1 && j == 1) continue;
					
					
					var nodeIdx:Int = col*cellsY + row;
					var nIdx:Int = nodeX*cellsY + nodeY;
					var nodePos = n_graph.getNode( nodeIdx ).pos;
					var neighbourPos = n_graph.getNode( nIdx ).pos;
					
					var cost = RCVector.distanceBetween (nodePos, neighbourPos);
					var edge = new GKEdge (nodeIdx, nIdx, cost);
					
					n_graph.addEdge ( edge );
				}
			}
		}
	}
}
