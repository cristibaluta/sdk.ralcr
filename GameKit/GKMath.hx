//
//  GKMath.hx
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//


class GKMath {
	
	
	
	
	//-------------------- LineIntersection2D-------------------------
	//
	//  Given 2 lines in 2D space AB, CD this returns true if an 
	//  intersection occurs and sets dist to the distance the intersection
	//  occurs along AB. Also sets the 2d vector point to the point of
	//  intersection
	//	http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/Helpers.cs
	//----------------------------------------------------------------- 
	public static function linesIntersection (A:RCPoint, B:RCPoint, C:RCPoint, D:RCPoint) :RCPoint {
		
		var denominator = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);

        // Lines are parallel
	    if (denominator == 0) {
	        return null;
	    }
		
		var rTop = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
		var sTop = (A.y-C.y)*(B.x-A.x)-(A.x-C.x)*(B.y-A.y);
		var r = rTop/denominator;
		var s = sTop/denominator;
		
		// The fractional point will be between 0 and 1 inclusive if the lines
		// intersect.  If the fractional calculation is larger than 1 or smaller
		// than 0 the lines would need to be longer to intersect.
		if (r > 0 && r < 1 && s > 0 && s < 1) {
			
			//dist = Vec2DDistance(A,B) * r;
			//point = A + r * (B - A);
			return new RCPoint (A.x + r * (B.x - A.x), A.y + r * (B.y - A.y));
		}
		return null; 
	}
	
	public static function distanceToLine (point:RCPoint, A:RCPoint, B:RCPoint) :RCPoint {
		//'kindly borrowed' from: http://paulbourke.net/geometry/pointline/
		var dx = B.x - A.x;
		var dy = B.y - A.y;
		var u = ((point.x - A.x) * dx + (point.y - A.y) * dy) / (dx * dx + dy * dy);
		var closest :RCPoint;
		if (u < 0) {
			closest = new RCPoint (A.x, A.y);
		}
		else if (u > 1) {
			closest = new RCPoint (B.x, B.y);
		}
		else closest = new RCPoint (A.x + u * dx, A.y + u * dy);
			
		return closest;
	}
	
}