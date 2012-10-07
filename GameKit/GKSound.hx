//
//  GKSound.hx
//
//  Created by Cristi Baluta on 2010-12-09.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKSound {
	
	static var mp3s :Hash<RCAudio>;
	
	
	public static function init () :Void {
		
		if (mp3s != null) return;
		
		//sounds = new Hash<Sound>();
		mp3s = new Hash<RCAudio>();
	}
	
	
	public static function registerSound (id:String, linkage:String) {
		
	}
	public static function registerMp3 (id:String, mp3:RCAudio) {
		mp3s.set (id, mp3);
	}
	
	public static function playMp3 (id:String) :Void {
		if (mp3s.get ( id ) != null)
			mp3s.get ( id ).start();
	}
	public static function stopMp3 (id:String) :Void {
		if (mp3s.get ( id ) != null)
			mp3s.get ( id ).stop();
	}
	
}