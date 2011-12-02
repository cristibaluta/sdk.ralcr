//
//  Mix
//
//  Created by Baluta Cristian on 2008-07-09.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.ID3Info;
import flash.media.SoundTransform;
import flash.net.URLRequest;


class RCMp3 implements RCAudioInterface {
	
	public static var DISPLAY_TIMER_UPDATE_DELAY :Int = 1000;
	
	var URL :String;
	var sound :Sound;
	var channel :SoundChannel;
	var timer :Timer;
	var _volume :Float;
	
	public var errorMessage :String;
	public var percentLoaded :Int;
	public var percentPlayed :Int;
	public var updateTime :Int;
	public var time :Int;
	public var duration :Float;
	public var id3 :Dynamic;
	public var volume (getVolume, setVolume) :Float;
	public var repeat :Bool;
	
	
	/**
	 * Dispatch events by replacing this methods
	 */
	dynamic public function onPlayingProgress () :Void {}
	dynamic public function onLoadingProgress () :Void {}
	dynamic public function onLoadComplete () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function onID3 () :Void {}
	dynamic public function soundDidFinishPlaying () :Void {}
	dynamic public function soundDidStartPlaying () :Void {}
	dynamic public function soundDidStopPlaying () :Void {}
	
	
	public function new (URL:String) {
		this.URL = URL;
		this.updateTime = DISPLAY_TIMER_UPDATE_DELAY;
		this.repeat = false;
		this._volume = 1;
	}
	
	public function init () :Void {
		sound = new Sound();
		sound.addEventListener (Event.COMPLETE, completeHandler);
		sound.addEventListener (Event.ID3, id3Handler);
		sound.addEventListener (ErrorEvent.ERROR, errorHandler);
		sound.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		sound.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		sound.load ( new URLRequest ( URL ) );
		
		timer = new Timer ( updateTime );
		timer.addEventListener (TimerEvent.TIMER, loop);
	}
	
	/**
	 * Controls for audio
	 */
	public function start (?time:Null<Int>) :Void {
		
		if (sound == null) init();
		if (channel != null) stop();
		
		channel = sound.play ( time == null ? 0 : Math.round (time * 1000) );
		channel.addEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
		
		timer.start();
		setVolume ( _volume );
		
		soundDidStartPlaying();
	}
	
	public function stop () :Void {
		
		if (channel == null) return;
		
		channel.stop();
		channel.removeEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
		channel = null;
		time = 0;
		
		if (timer != null)
			timer.stop();
		
		soundDidStopPlaying();
	}
	
	
	
	function completeHandler (e:Event) :Void {
		onLoadComplete();
	}
	function id3Handler (e:Event) :Void {
		id3 = e.currentTarget.id3;
		onID3();
	}
	function ioErrorHandler (e:Event) :Void {
		errorMessage = e.toString();
		onError();
	}
	function errorHandler (e:ErrorEvent) :Void {
		errorMessage = e.toString();
		onError();
	}
	function progressHandler (e:ProgressEvent) :Void {
		percentLoaded = Math.round (e.target.bytesLoaded * 100 / e.target.bytesTotal);
		onLoadingProgress();
	}
	function soundCompleteHandler (e:Event) :Void {trace(e);
		if (repeat)
			start ( 0 );
		else if (sound.length > 0) {
			if (timer != null)
				timer.stop();
			soundDidFinishPlaying();
		}
	}
	
	// Loop
	function loop (e:TimerEvent) :Void {
		time = Math.round ( channel.position / 1000 );
		duration = Math.round ( sound.length / 1000 );
		percentPlayed = Math.round ( time * 100 / duration );
		
		onPlayingProgress();
	}
	
	
	/**
	 *	Control the volume
	 */
	public function getVolume () :Float {
		return _volume;
	}
	
	public function setVolume (volume:Float) :Float {
		_volume = volume > 1 ? 1 : volume;
		if (channel != null)
			channel.soundTransform = new SoundTransform ( _volume );
		return _volume;
	}
	
	
	/**
	 * Stop the playing sound and remove event listeners
	 */
	public function destroy () :Void {
		stop();
		
		sound.removeEventListener (Event.COMPLETE, completeHandler);
		sound.removeEventListener (Event.ID3, id3Handler);
		sound.removeEventListener (ErrorEvent.ERROR, errorHandler);
		sound.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		sound.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
		
		timer.removeEventListener (TimerEvent.TIMER, loop);
		timer = null;
	}
}
