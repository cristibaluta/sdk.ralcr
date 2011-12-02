//
//  HTTPTokenizedRequest
//
//  Created by Cristi Baluta on 2011-02-14.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import Shortcuts;


class HTTPTokenizedRequest extends RCRequest {
	
	var scripts_path :String; // Path to the folder that contains all php scripts
	
	
	public function new (?scripts_path:String) {
		this.scripts_path = scripts_path;
		super ();
	}
	
	public function init () :Void {
		
	}
	
	
	override public function destroy () :Void {
		
	}
}