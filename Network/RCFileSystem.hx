//
//	RCFileSystem.hx
//  Php file manipulation
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

/**
*  
*  To use this class the api.ralcr folder is required
*  
*/

#if (flash || nme)
	import flash.net.URLVariables;
#elseif js
	private class URLVariables implements Dynamic { public function new(){} }
#end



class RCFileSystem extends HTTPRequest {
	
	public function new (apiPath:String) {
		super ( apiPath );
	}
	
	
	/**
	 * Create a directory.
	 */
	public function createDirectory (directory:String) :Void {
		
		var variables = new URLVariables();
		variables.path = directory;
		variables.apiPath = apiPath;
		
		load ( apiPath + "filesystem/createDirectory.php", variables );
	}
	
	
	/**
	 * Delete a directory and all it's containing files.
	 */
	public function deleteDirectory (directory:String) :Void {
		
		var variables = new URLVariables();
		variables.path = directory;
		variables.apiPath = apiPath;
		
		load ( apiPath + "filesystem/deleteDirectory.php", variables );
	}
	
	
	/**
	 * Delete a file.
	 */
	public function deleteFile (file:String) :Void {
		
		var variables = new URLVariables();
		variables.path = file;
		variables.apiPath = apiPath;
		
		load ( apiPath + "filesystem/deleteFile.php", variables );
	}
	
	
	/**
	 * Rename a file or a folder and move it to another location.
	 */
	public function rename (file:String, new_file:String) :Void {
		
		var variables = new URLVariables();
		variables.path = file;
		variables.new_path = new_file;
		variables.apiPath = apiPath;
		
		load ( apiPath + "filesystem/rename.php", variables );
	}
	
}
