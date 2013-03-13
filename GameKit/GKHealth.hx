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
	
	
	public function new () {
		
	}
	
	public function init () :Void {
		
	}
	
	public function get_health () :Int {
		return health;
	}
	public function set_health (h:Int) :Int {
		return health = h;
	}
	
	public function destroy () :Void {
		
	}
}