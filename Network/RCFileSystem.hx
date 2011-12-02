//
//  Php file manipulation
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//
import flash.net.URLVariables;
import flash.net.URLRequest;


class RCFileSystem extends HTTPRequest {
	
	public function new (scripts_path:String) {
		super ( scripts_path );
	}
	
	
	/**
	 * Create a directory.
	 */
	public function createDirectory (directory:String) :Void {
		var variables = new URLVariables();
		variables.path = directory;
		variables.scripts_path = scripts_path;
		
		load ( scripts_path + "filesystem/createDirectory.php", variables );
	}
	
	
	/**
	 * Delete a directory and all it's containing files.
	 */
	public function deleteDirectory (directory:String) :Void {
		var variables = new URLVariables();
		variables.path = directory;
		variables.scripts_path = scripts_path;
		
		load ( scripts_path + "filesystem/deleteDirectory.php", variables );
	}
	
	
	/**
	 * Delete a file.
	 */
	public function deleteFile (file:String) :Void {
		var variables = new URLVariables();
		variables.path = file;
		variables.scripts_path = scripts_path;
		
		load ( scripts_path + "filesystem/deleteFile.php", variables );
	}
	
	
	/**
	 * Rename a file or a folder and move it to another location.
	 */
	public function rename (file:String, new_file:String) :Void {
		var variables = new URLVariables();
		variables.path = file;
		variables.new_path = new_file;
		variables.scripts_path = scripts_path;
		
		load ( scripts_path + "filesystem/rename.php", variables );
	}
	
}
