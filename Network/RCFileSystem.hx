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

class RCFileSystem extends RCHttp {
	
	public function new (apiPath:String) {
		super ( apiPath );
	}
	
	
	/**
	 * Create a directory.
	 */
	public function createDirectory (directory:String) :Void {
		
		var variables = createVariables ({path : directory, apiPath : apiPath});
		
		load ( apiPath + "filesystem/createDirectory.php", variables );
	}
	
	
	/**
	 * Delete a directory and all it's containing files.
	 */
	public function deleteDirectory (directory:String) :Void {
		
		var variables = createVariables ({path : directory, apiPath : apiPath});
		
		load ( apiPath + "filesystem/deleteDirectory.php", variables );
	}
	
	
	/**
	 * Delete a file.
	 */
	public function deleteFile (file:String) :Void {
		
		var variables = createVariables ({path : file, apiPath : apiPath});
		
		load ( apiPath + "filesystem/deleteFile.php", variables );
	}
	
	
	/**
	 * Rename a file or a folder and move it to another location.
	 */
	public function rename (file:String, new_file:String) :Void {
		
		var variables = createVariables ({path : file, new_path : new_file, apiPath : apiPath});
		
		load ( apiPath + "filesystem/rename.php", variables );
	}
	
}
