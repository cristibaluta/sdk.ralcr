//
//  RCNotification.hx
//	EventsKit
//
//  Created by Cristi Baluta on 2010-03-12.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCNotification {
	
	public var name :String;
	public var functionToCall :Dynamic;
	
	
	public function new (name:String, functionToCall:Dynamic) {
		this.name = name;
		this.functionToCall = functionToCall;
	}
	
	public function toString () :String {
		return "[RCNotification with name: '" + name + "', functionToCall: " + functionToCall + "]";
	}
}
