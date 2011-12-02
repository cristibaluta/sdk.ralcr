//
//  GKSound
//
//  Created by Cristi Baluta on 2010-12-09.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import Shortcuts;
import flash.media.Sound;

class GKSound {
	
	static var sounds :Hash<Sound>;
	static var mp3s :Hash<RCMp3>;
	
	
	public function new () {
		
	}
	
	public static function init () :Void {
		if (sounds != null) return;
		sounds = new Hash<Sound>();
		mp3s = new Hash<RCMp3>();
	}
	
	
	public static function registerSound (id:String, linkage:String) {
		
	}
	public static function registerMp3 (id:String, mp3:RCMp3) {
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
	
	public function destroy () :Void {
		
	}
}