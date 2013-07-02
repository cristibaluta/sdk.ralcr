//
//  RCHttp.hx
//
//  Created by Baluta Cristian on 2008-09-06.
//  Copyright (c) 2008-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCHttp extends RCRequest {
	
	var apiPath :String; // Path to the folder that contains all php scripts
	
	/**
	 *  @param apiPath - Some of the features require the api.ralcr external php scripts. 
	 *  You need to include it in the exported app and pass here the path to the folder
	 **/
	public function new (?apiPath:String="") {
		this.apiPath = apiPath;
		if (apiPath != "" && ! StringTools.endsWith (apiPath, "/"))
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
	 *	Read the content of a folder.
	 *	Require the apiPath
	 */
	public function readDirectory (directoryName:String) :Void {
		trace("read dir "+directoryName);
		var variables = createVariables ( { path : directoryName } );
		load ( apiPath + "filesystem/readDirectory.php", variables );
	}
	
	
	/**
	 *	Call an url and pass some variables
	 *  In ios we use the NMEHttps request because haxe-cpp does not support https
	 */
	public function call (script:String, variables_list:Dynamic, ?method:String="POST") :Void {
		load (apiPath + script, createVariables (variables_list), method);
	}
	
	public function navigateToURL (URL:String, variables_list:Dynamic, ?method:String="POST", ?target:String="_self") :Void {
		//trace(URL);trace(variables_list);trace(method);trace(target);
		var variables = createVariables ( variables_list );
		#if (flash || nme)
			flash.Lib.getURL ( createRequest (URL, variables, method), target);
		#end
	}
}
