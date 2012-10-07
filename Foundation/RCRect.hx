//
//  RCRect.hx
//
//  Created by Baluta Cristian on 2011-11-12.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class RCRect {
	
	public var origin :RCPoint;
	public var size :RCSize;
	
	public function new (x, y, w, h) {
		this.origin = new RCPoint (x, y);
		this.size = new RCSize (w, h);
	}
	public function copy () :RCRect {
		return new RCRect (origin.x, origin.y, size.width, size.height);
	}
	public function toString () :String {
		return "[RCRect x:"+origin.x+", y:"+origin.y+", width:"+size.width+", height:"+size.height+"]";
	}
}
