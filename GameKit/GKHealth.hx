//
//  GKHealth
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKHealth {
	
	public var minHealth :Int;
	public var maxHealth :Int;
	public var health (get_health, set_health) :Int;
	var health_ :Int;
	
	
	public function new () {
		health_ = 0;
	}
	
	public function init () :Void {
		
	}
	
	public function get_health () :Int {
		return health_;
	}
	public function set_health (h:Int) :Int {
		return health_ = h;
	}
	
	public function destroy () :Void {
		
	}
}