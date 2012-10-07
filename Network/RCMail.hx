//
//  RCMail
//
//  Created by Baluta Cristian on 2008-07-23.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
/**
 *  Sent mails through the mail php script
 **/

#if (flash || (flash && nme))
	import flash.net.URLVariables;
#else
	private class URLVariables implements Dynamic { public function new(){} }
#end


class RCMail extends RCRequest {
	
	var scripts_path :String;
	
	
	public function new (scripts_path:String) {
		this.scripts_path = scripts_path;
		super();
	}
	
	public function send (to:String, subject:String, message:String, from:String) :Void {
		
		var variables = new URLVariables();
			variables.to = to;
			variables.subject = subject;
			variables.message = message;
			variables.from = from;
		
		load (scripts_path + "others/sendMail.php", variables, "POST");
	}
}
