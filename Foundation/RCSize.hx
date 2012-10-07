//
//  RCSize.hx
//
//  Created by Cristi Baluta on 2011-03-10.
//  Copyright (c) 2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCSize {
	
	public var width :Float;
	public var height :Float;
	
	
	public function new (?w:Null<Float>, ?h:Null<Float>) {
		this.width = w == null ? 0 : w;
		this.height = h == null ? 0 : h;
	}
	public function copy () :RCSize {
		return new RCSize (width, height);
	}
	public function toString () :String {
		return "[RCSize width:"+width+", height:"+height+"]";
	}
}
