//
//  Mysql
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.net.URLVariables;


class RCMysql extends RCRequest {
	
	var scriptsPath :String;
	
	public function new (scriptsPath:String) {
		this.scriptsPath = scriptsPath;
		super();
	}
	
	/**
	 * SELECT is used for retrieving records from one or more tables in a database.
	 * Syntax:
	 * SELECT   [DISTINCT] select_list   FROM table_list   [WHERE where_expression]
	 * [ORDER BY col_name | formula]   [ASC | DESC]   [LIMIT [skip_count,] show_count]
	 * mysql interogation returns a xml
	 */
	/*	distinct:String,
		select_list:Array<String>,
		table_list:Array<String>, 
		where_list:Array<String>,
		where_separator:String,
		order_by:String,
		order_rule:String,
		limit:String,
		?explode_by:String*/
	public function select (variables:Dynamic) :Void {
		call (scriptsPath + "mysql/select.php", variables);
	}
	
	
	/**
	 * INSERT command is used to add new records to a database
	 * Syntax:
	 * INSERT INTO table_name (column_names) VALUES (values)
	 */
	public function insert (variables:Dynamic) :Void {
		call (scriptsPath + "mysql/insert.php", variables);
	}
		
	
	/**
	 * UPDATE is used for changing existing records. The syntax is almost identical to the alternative INSERT syntax
	 * Syntax:
	 * UPDATE table_name SET col_name = value [, col_name = value] [WHERE where_expression]
	 */
	public function update (variables:Dynamic) :Void {
		call (scriptsPath + "mysql/update.php", variables);
	}
	
	
	/**
	 * DELETE 
	 * Syntax:
	 * DELETE FROM table_name [WHERE where_expression]
	 */
	public function delete (variables:Dynamic) :Void {
		call (scriptsPath + "mysql/delete.php", variables);
	}
	
	
	/**
	 * Get the number of records from a table
	 */
	public function length (variables:Dynamic) :Void {
		call (scriptsPath + "mysql/length.php", variables);
	}
	
	
	/**
	 * Calls a custom script
	 */
	public function call (script:String, variables_list:Dynamic) :Void {
		var variables :URLVariables = createVariables (variables_list);trace(variables_list);
		load ( script, variables );
	}
	
	
	/**
	 * Extract matching variables from an object
	 * Some fields possible to be arrays, and need to be joined by the separator ", "
	 */
	function createVariables (variables_list:Dynamic) :URLVariables {
		
		var variables = new URLVariables();
		
		if (variables_list != null)
			for (field in Reflect.fields (variables_list)) {
				var val = Reflect.field (variables_list, field);
				Reflect.setField (variables, field, val);
			}
			
		return variables;
	}
}
