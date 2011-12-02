//
//  Mix
//
//  Created by Baluta Cristian on 2008-07-09.
//  Copyright (c) 2008 milc.ro. All rights reserved.
//
// buggy in flash player 9
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

class RCRadioStream extends flash.display.Sprite {
	
	var URL : String;
	var sound : Sound;
	var soundChannel : SoundChannel;
	var _volume :Float;
	
	public var volume (getVolume, setVolume) :Float;
	
	dynamic public function onStart () : Void {}
	
	
	public function new (URL:String) {
		super();
		this.URL = URL + ((URL.indexOf("/;") == -1) ? "/;" : "");
	}
	
	
	// play audio
	public function start () :Void {
		
		sound = new Sound();
		sound.addEventListener (Event.COMPLETE, completeHandler);
		sound.addEventListener (Event.ID3, id3Handler);
		sound.addEventListener (ErrorEvent.ERROR, errorHandler);
		sound.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		sound.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		
		sound.load ( new URLRequest ( URL ) );
		soundChannel = sound.play();
		
		onStart();
	}
	
	public function stop () : Void {
		if (soundChannel == null) return;
		
		soundChannel.stop();
		soundChannel = null;
		sound.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		sound.close();
		sound = null;
	}
	
	
	
	/**
	 *	Control the volume
	 */
	public function getVolume () :Float {
		return _volume;
	}
	public function setVolume (volume:Float) :Float {
		_volume = volume > 1 ? 1 : volume;
		if (soundChannel != null)
			soundChannel.soundTransform = new SoundTransform ( _volume );
		return _volume;
	}
	
	
	
	
	function completeHandler (e:Event) :Void {
		trace(e);
	}
	function id3Handler (e:Event) :Void {
		trace(e);
	}
	function ioErrorHandler (e:Event) :Void {
		trace(e);
	}
	function errorHandler (e:ErrorEvent) :Void {
		trace(e);
	}
	function progressHandler (e:ProgressEvent) :Void {
		//trace(e);
	}
	
	
	// clean mess
	public function destroy () : Void {
		stop();
	}
}
