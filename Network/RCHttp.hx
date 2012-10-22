//
//  RCHttp.hx
//
//  Created by Baluta Cristian on 2008-09-06.
//  Copyright (c) 2008-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.net.URLVariables;
#elseif js
	private class URLVariables implements Dynamic { public function new(){} }
#end


class RCHttp extends RCRequest {
	
	var apiPath :String; // Path to the folder that contains all php scripts
	
	/**
	 *  Some of the features require the api.ralcr php scripts. 
	 *  You need to include it in the exported app and pass here the path to the folder
	 **/
	public function new (?apiPath:String) {
		this.apiPath = apiPath;
		if ( apiPath != null && ! StringTools.endsWith (apiPath, "/"))
			this.apiPath += "/";
		super();
	}
	
	
	/**
	 * Reads a file and returns it's raw data in public "result" variable.
	 */
	public function readFile (file:String) :Void {
		load ( file );
	}
	
	
	/**
	 * Read the content of a folder.
	 */
	public function readDirectory (directoryName:String) :Void {
		var variables = new URLVariables();
			variables.path = directoryName;
		
		load ( apiPath + "filesystem/readDirectory.php", variables );
	}
	
	
	/**
	 * Call a custom script and pass some variables
	 */
	public function call (script:String, variables_list:Dynamic, ?method:String="POST") :Void {
		var variables = new URLVariables();
		if (variables_list != null)
			for (f in Reflect.fields (variables_list))
				Reflect.setField (variables, f, Reflect.field (variables_list, f));
		
		load (apiPath + script, variables, method);
	}
}
