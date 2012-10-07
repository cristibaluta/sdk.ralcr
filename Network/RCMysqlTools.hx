//
//  MysqlTools
//
//  Created by Baluta Cristian on 2008-08-14.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class RCMysqlTools extends RCMysql {
	
	public function new (_path:String) {
		super (_path);
	}
	
	//
	// login and retrieve all the data about that user
	//
	public function user_login (user:String, parola:String) :Void {
		
		var login_info = new Array<String>();
		login_info.push (["user", user].join("="));
		login_info.push (["parola", haxe.Md5.encode(parola)].join("="));
		
		//select ("", ["*"], ["useri"], login_info, "AND", "", "", "0, 1");
	}
	
	
	//
	// insert into "useri" the data
	//
	public function user_register (column_list:Array<String>, values_list:Array<String>) :Void {
		var insert_info = new Array<String>();
		
		for (i in 0...column_list.length) {
			insert_info.push ([column_list[i], values_list[i]].join("="));
		}
		
		//insert ("useri", insert_info, ["user"]);
	}
}
