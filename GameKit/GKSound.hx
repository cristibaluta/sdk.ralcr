//
//  GKSound.hx
//
//  Created by Cristi Baluta on 2010-12-09.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKSound {
	
	static var sounds :Map<String,RCAudio>;
	static var muted :Bool;
	
	public static function init () :Void {
		
		if (sounds == null) {
			sounds = new Map<String,RCAudio>();
			muted = false;
		}
	}
	
	
	/**
	 *  In NME you can specify when is a background music and iPhone will use a
	 *  hardware decoder. It is good performance for long sounds
	 **/
	public static function preloadBackgroundMusic (id:String, url:String) :Void {
		trace(id+", "+url);
		var snd = new RCAudio (url #if openfl , true #end);
			snd.init();
		sounds.set (id, snd);
	}
	
	/**
	 *  An effect sound is a very short sound. It is decoded software
	 **/
	public static function preloadEffectSound (id:String, url:String) :Void {
		var snd = new RCAudio (url);
			snd.init();
		sounds.set (id, snd);
	}
	
	public static function playBackgroundMusic (id:String, repeat:Bool=true) {
		if (!muted) {
			var snd = sounds.get ( id );
			if (snd != null) {
				snd.repeat = repeat;
				snd.start();
			}
		}
	}
	public static function playEffectSound (id:String, repeat:Bool=false) {
		if (!muted) {
			var snd = sounds.get ( id );
			if (snd != null) {
				snd.repeat = repeat;
				snd.start();
			}
		}
	}
	
	public static function stopSound (id:String) :Void {
		var snd = sounds.get ( id );
		if (snd != null) {
			snd.stop();
		}
	}
	
	public static function mute (b:Bool) :Void {
		muted = b;
		for (snd in sounds)
			if (muted) snd.stop();
	}
	public static function isMuted () :Bool {
		return muted;
	}
}
