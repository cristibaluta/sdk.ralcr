class Main {

	static public function main () :Void {
		
		// Calculate the collision point of 2 lines
		var collision = GKMath.linesIntersection (new RCPoint(10,10), new RCPoint(100,100), new RCPoint(10,100), new RCPoint(100,10));
		trace("collision "+collision);
		
	}
}
