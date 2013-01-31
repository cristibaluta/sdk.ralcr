//
//  RCAudio.hx
//	MediaKit
//
//  Created by Baluta Cristian on 2008-07-09.
//  Copyright (c) 2008 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)

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


class RCAudio implements RCAudioInterface {
	
	public static var DISPLAY_TIMER_UPDATE_DELAY :Int = 1000;
	
	var URL :String;
	//var NME_URL :String;
	var sound :Sound;
	var channel :SoundChannel;
	var soundId :Int;//Reference for extension effect sound so we can stop it
	var timer :Timer;
	var _volume :Float;
	var decodeByHardware :Bool;
	
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
	
	
	public function new (URL:String, decodeByHardware:Bool=false) {
		this.URL = URL;
		this.decodeByHardware = decodeByHardware;
		this.updateTime = DISPLAY_TIMER_UPDATE_DELAY;
		this.repeat = false;
		this._volume = 1;
	}
	
	public function init () :Void {
		
		if (sound != null) return;
		
		#if nme
			#if ios
				if (decodeByHardware)
				NMESimpleAudioEngine.preloadBackgroundMusic ( URL );
				else
				NMESimpleAudioEngine.preloadEffect ( URL );
			#else
			sound = nme.Assets.getSound ( URL );
			#end
		#else
			sound = new Sound();
			sound.addEventListener (Event.COMPLETE, completeHandler);
			sound.addEventListener (Event.ID3, id3Handler);
			sound.addEventListener (ErrorEvent.ERROR, errorHandler);
			sound.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			sound.load ( new URLRequest ( URL ) #if nme , null, decodeByHardware #end );
		#end
		
		timer = new Timer ( updateTime );
		timer.addEventListener (TimerEvent.TIMER, loop);
	}
	
	/**
	 * Controls for audio
	 */
	public function start (?time:Null<Int>) :Void {
		
		#if (nme && ios)
			if (decodeByHardware)
			NMESimpleAudioEngine.playBackgroundMusic (URL, repeat);
			else
			soundId = NMESimpleAudioEngine.playEffect ( URL, repeat );
		#else
		if (channel != null) {
			channel.stop();
			channel.removeEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
			channel = null;
		}
		
		if (sound == null) return;
		
		// If we have background music
		// or if the sound is repeating
		// We need to be ble to stop it, so we create the channel
		if (decodeByHardware || repeat) {
			channel = sound.play ( time == null ? 0 : Math.round (time * 1000), repeat ? 10000 : 0 );
			channel.addEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		else {
			sound.play ( time == null ? 0 : Math.round (time * 1000) );
		}
		
		timer.start();
		setVolume ( _volume );
		#end
		soundDidStartPlaying();
	}
	
	public function stop () :Void {
		
		#if (nme && ios)
			if (decodeByHardware)
			NMESimpleAudioEngine.stopBackgroundMusic();
			else
			NMESimpleAudioEngine.stopEffect ( soundId );
		#else
		if (channel != null) {
			channel.stop();
			channel.addEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
			channel = null;
		}
		
		if (timer != null)
			timer.stop();

		time = 0;
		#end
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
	function soundCompleteHandler (e:Event) :Void {
		if (sound.length > 0) {
			if (timer != null)
				timer.stop();
			soundDidFinishPlaying();
		}
	}
	
	// Loop
	function loop (e:TimerEvent) :Void {
		if (channel != null)
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
		#if (nme && ios)
			if (decodeByHardware)
			NMESimpleAudioEngine.stopBackgroundMusic();
			else
			NMESimpleAudioEngine.unloadEffect ( URL );
		#else
		if (channel != null) {
			channel.stop();
			channel.removeEventListener (Event.SOUND_COMPLETE, soundCompleteHandler);
			channel = null;
		}
		
		if (sound != null) {
			sound.close();
			sound.removeEventListener (Event.COMPLETE, completeHandler);
			sound.removeEventListener (Event.ID3, id3Handler);
			sound.removeEventListener (ErrorEvent.ERROR, errorHandler);
			sound.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			sound = null;
		}
		
		if (timer != null) {
			timer.stop();
			timer.removeEventListener (TimerEvent.TIMER, loop);
			timer = null;
		}
		#end
	}
}

#elseif js

typedef RCAudio = JSAudio;

#end