//
//  GKSound.hx
//
//  Created by Cristi Baluta on 2010-12-09.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKSound {
	
	static var mp3s :Hash<RCAudio>;
	static var muted :Bool;
	
	public static function init () :Void {
		
		if (mp3s != null) return;
		
		//sounds = new Hash<Sound>();
		mp3s = new Hash<RCAudio>();
		muted = false;
	}
	
	
/*	public static function registerSound (id:String, linkage:String) {
		
	}*/
	public static function registerMp3 (id:String, mp3:RCAudio) {
		mp3s.set (id, mp3);
	}
	
	public static function playMp3 (id:String) :Void {
		if (mp3s.get ( id ) != null && !muted)
			mp3s.get ( id ).start();
	}
	public static function stopMp3 (id:String) :Void {
		if (mp3s.get ( id ) != null)
			mp3s.get ( id ).stop();
	}
	
	public static function mute (b:Bool) :Void {
		muted = b;
		for (mp3 in mp3s)
			if (muted) mp3.stop();
	}
}