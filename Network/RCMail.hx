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

class RCMail extends RCRequest {
	
	var apiPath :String;
	
	
	public function new (apiPath:String) {
		this.apiPath = apiPath;
		if (apiPath != "" && ! StringTools.endsWith (apiPath, "/"))
			this.apiPath += "/";
		super();
	}
	
	public function send (to:String, subject:String, message:String, from:String) :Void {
		
		var variables = createVariables ({to : to, subject : subject, message : message, from : from});
		
		load (apiPath + "others/sendMail.php", variables, "POST");
	}
}
