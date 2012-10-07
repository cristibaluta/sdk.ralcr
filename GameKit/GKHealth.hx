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
	public var health (getHealth, setHealth) :Int;
	
	
	public function new () {
		
	}
	
	public function init () :Void {
		
	}
	
	public function getHealth () :Int {
		return health;
	}
	public function setHealth (h:Int) :Int {
		return health = h;
	}
	
	public function destroy () :Void {
		
	}
}