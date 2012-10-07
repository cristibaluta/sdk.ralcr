using Zeta;

class RCFiles {
	
	inline public static var PHOTOS :Array<String> = [".jpg", ".jpeg", ".png", ".gif"];
	inline public static var MUSIC :Array<String> = [".mp3"];
	inline public static var FLASH :Array<String> = [".swf"];
	inline public static var PANO2VR :Array<String> = [".pano2vr"];
	inline public static var VIDEOS :Array<String> = [".flv", ".f4v", ".mp4", ".m4v", ".webm", ".ogv", ".ytb"];
	inline public static var TEXT :Array<String> = [".txt", ".data"];
	inline public static var IGNORE :Array<String> = ['.', '..', '.DS_Store', '_vti_cnf', 'Thumbs.db', '_thumb.jpg'];
	
	public var dir :Array<String>;
	public var media :Array<String>;//all pictures and videos
	public var images :Array<String>;
	public var flash :Array<String>;
	public var pano2vr :Array<String>;
	public var music :Array<String>;
	public var video :Array<String>;
	public var text :Array<String>;
	public var xml :Array<String>;
	public var extra :Array<String>;// Add here any other files
	
	
	/**
	*  Create RCFiles with the files from a serialized string in the following format: [FILES::file1*file2*file3::FILES]
	*  The default separator is * but can be replaced with another one
	*/
	public static function filesWithString (str:String, ?separator:String="*") :RCFiles {
		return new RCFiles ( str.split ("[FILES::").pop().split ("::FILES]").shift().split ( separator ));
	}
	
	
	public function new (files:Array<String>) {
		
		dir		= new Array<String>();
		media	= new Array<String>();//all pictures and videos
		images	= new Array<String>();
		flash	= new Array<String>();
		pano2vr	= new Array<String>();
		music	= new Array<String>();
		video	= new Array<String>();
		text	= new Array<String>();
		xml		= new Array<String>();
		extra	= new Array<String>();
		
		for (file in files) {
			push ( file );
		}
	}
	
	public function push (file:String) :Void {
		
		if (file.isIn (IGNORE, "end")) return;
		
		if (file.isIn (PHOTOS, "end")) {
			images.push ( file );
			media.push ( file );
		}
		else if (file.isIn (MUSIC, "end")) {
			music.push ( file );
		}
		else if (file.isIn (VIDEOS, "end")) {
			video.push ( file );
			media.push ( file );
		}
		else if (file.isIn (FLASH, "end")) {
			flash.push ( file );
			media.push ( file );
		}
		else if (file.isIn (PANO2VR, "end")) {
			pano2vr.push ( file );
			media.push ( file );
		}
		else if (file.isIn (TEXT, "end")) {
			text.push ( file );
		}
		else if (file.isIn ([".xml"], "end")) {
			xml.push ( file );
		}
		else {
			dir.push ( file );
		}
	}
	
	/**
	*  If it's not a known file means it's a directory
	*/
	public static function isDirectory (file:String) :Bool {
		return ! file.isIn (PHOTOS.concat(MUSIC).concat(FLASH).concat(VIDEOS).concat(TEXT).concat(PANO2VR), "end");
	}
	
	
	public function toString():String {
		return "[Files:\ndir: "+dir+
				"\nmedia: "+media+
				"\nimages: "+images+
				"\nflash: "+flash+
				"\npano2vr: "+pano2vr+
				"\nmusic: "+music+
				"\nvideo: "+video+
				"\ntext: "+text+
				"\nxml: "+xml+
				"\nextra: "+extra+"]";
	}
}
