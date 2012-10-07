//
//  RCPoint.hx
//
//  Created by Baluta Cristian on 2011-09-18.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCPoint {
	
	public var x :Float;
	public var y :Float;
	
	
	public function new (?x:Null<Float>, ?y:Null<Float>) {
		this.x = x == null ? 0 : x;
		this.y = y == null ? 0 : y;
	}
	public function copy () :RCPoint {
		return new RCPoint (x, y);
	}
	public function toString () :String {
		return "[RCPoint x:"+x+", y:"+y+"]";
	}
}
