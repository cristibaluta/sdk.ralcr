using StringTools;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

class Run {
	
	public static var output = "";
	public static var me = "";
	public static function main() {
		
		loop(".");
		
		var args = Sys.args();
		
		if (args.length > 0) {
			var last:String = ( new Path ( args.pop())).toString();
			var slash = last.substr(-1);
			if (slash=="/"|| slash=="\\") 
			    me = last.substr(0,last.length-1);
			if (args[0] == "new") {
				generateNewProject();
			}
		}
		
		trace("Generating "+me + "/sdk.ralcr.hxml with content:\n"+output);
		
		File.saveContent ( me + "/sdk.ralcr.hxml", output);
	}
	static function loop (path:String) {
		var files = FileSystem.readDirectory(path);
		for (f in files) {
			try{
			//if (FileSystem.isDirectory ( FileSystem.fullPath ( f ))) {//Neko error on files
			if (f.indexOf(".") == -1) {
				if (!isPackage( f ) && 
					!f.startsWith(".") && 
					!f.endsWith(".hx") && 
					f != "samples" && 
					f != "Resources")
				{
					output += "-cp " + FileSystem.fullPath ( path + "/" + f ) + "\n";
					loop(path+"/"+f);
				}
			}
			}catch(e:Dynamic){trace(e);}
		}
	}
	inline static function isPackage(path:String) :Bool {
		return !(path.substr(0,1) == path.substr(0,1).toUpperCase());
	}
	
	
	
	static function generateNewProject () {
		
		trace("Generating project structure...");
		
		var paths = me.split("/");
		var projName = paths.pop();
		var directories = [
			"Publish",
			"Resources",
			"src",
			"src/com",
			"src/com/ralcr",
			"src/com/ralcr/"+projName.toLowerCase(),
			"src/Controller",
			"src/Model",
			"src/View"
		];
		for (dir in directories) {
			//trace("Generating "+dir);
			if(!FileSystem.exists ( me + "/" + dir))
				FileSystem.createDirectory ( me + "/" + dir);
		}
		var files = [
			["Resources/Template/compile.hxml", me + "/compile.hxml"],
			["Resources/Template/compile.nmml", me + "/compile.nmml"],
			["Resources/Template/index.html", me + "/Publish/index.html"],
			["Resources/Template/swfobject.js", me + "/Publish/swfobject.js"],
			["Resources/Template/AppController.hx", me + "/src/Controller/AppController.hx"],
			["Resources/Template/Initialization.hx", me + "/src/Model/Initialization.hx"],
			["Resources/Template/RegisterFonts.hx", me + "/src/Model/RegisterFonts.hx"],
			["Resources/Template/Main.hx", me + "/src/com/ralcr/"+projName.toLowerCase() + "/Main.hx"]
		];
		for (f in files) {
			var str = File.getContent(f[0]);
			str = StringTools.replace (str, "::app_name::", projName);
			str = StringTools.replace (str, "::package::", "com.ralcr."+projName.toLowerCase());
			File.saveContent ( f[1], str);
/*			if (!FileSystem.exists (f[1])) {
				File.copy (f[0], f[1]);
			}*/
		}
		
		// Open the project in TextMate if present
		trace("Attempting to open the project in TextMate...");
		Sys.command ("mate", ["."]);
	}
}
