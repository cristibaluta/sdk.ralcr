//
//  JSAudio
//
//  Created by Baluta Cristian on 2012-01-23.
//  Copyright (c) 2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import js.Lib;
import js.Dom;
import haxe.Timer;

#if js
/*extern class Audio extends HtmlDom, implements Dynamic {
	public function new (url:String) :Void;
}*/
#end

class JSAudio implements RCAudioInterface {
	
	public static var DISPLAY_TIMER_UPDATE_DELAY :Int = 1000;
	
	var URL :String;
	var sound :Dynamic;//HtmlDom;
	var channel :HtmlDom;
	var timer :Timer;
	var volume_ :Float;
	var loaded_ :Bool;
	var playing_ :Bool;
	var medatadaReady :Bool;
	
	public var errorMessage :String;
	public var percentLoaded :Int;
	public var percentPlayed :Int;
	public var updateTime :Int;
	public var time :Int;
	public var duration :Float;
	public var id3 :Dynamic;
	public var volume (get_volume, set_volume) :Float;
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
	
	//
	public function new (URL:String) {
		this.URL = URL;
		this.updateTime = DISPLAY_TIMER_UPDATE_DELAY;
		this.repeat = false;
		this.volume_ = 1;
	}
	public function init () :Void {
		this.loaded_ = true;
		this.playing_ = false;
		
		sound = js.Lib.document.createElement('audio');
		//untyped __js__ ("sound = new Audio ( this.URL );");
/*		untyped sound.onloadedmetadata = id3Handler;
		untyped sound.onloadstart = function(){trace("onloadstart");};
		untyped sound.onplay = function(){trace("onplay");};*/
		untyped sound.autoplay = false;
		untyped sound.preload = "auto";//"auto";//none, metadata
		untyped sound.loop = false;
		untyped sound.src = URL;
		untyped sound.load();
		js.Lib.document.body.appendChild ( sound );

		timer = new haxe.Timer ( updateTime );
		//timer.run = loop;
	}
	
	/**
	 * Controls for audio
	 */
	public function start (?time:Null<Int>) :Void {
		
		if (sound == null) init();
		if (sound != null /*loaded_ && !playing_*/ /*&& medatadaReady*/) {
			try { untyped sound.currentTime = 0; }catch(e:Dynamic){trace(e);}
			untyped sound.play();
			this.playing_ = true;
		}
		
		//timer.run = loop;
		//setVolume ( volume_ );
		
		soundDidStartPlaying();
	}
	
	public function stop () :Void {
		if (playing_ && sound != null) {
			untyped sound.pause();
			this.playing_ = false;
		}
		
		time = 0;
		
		if (timer != null)
			timer.stop();
		
		soundDidStopPlaying();
	}
/*	var mediaElement = document.getElementById('mediaElementID');
	mediaElement.seekable.start();  // Returns the starting time (in seconds)
	mediaElement.seekable.end();    // Returns the ending time (in seconds)
	mediaElement.currentTime = 122; // Seek to 122 seconds
	mediaElement.played.end();      // Returns the number of seconds the browser has played*/
	
	
	function completeHandler (e:Event) :Void {
		onLoadComplete();
	}
	function id3Handler () :Void {
		medatadaReady = true;
		onID3();
	}
/*	function ioErrorHandler (e:Event) :Void {
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
	}*/
	
	// Loop
	function loop () :Void {
/*		time = Math.round ( channel.position / 1000 );
		duration = Math.round ( sound.length / 1000 );
		percentPlayed = Math.round ( time * 100 / duration );*/
		
		onPlayingProgress();
	}
	
	
	/**
	 *	Control the volume
	 */
	public function get_volume () :Float {
		return volume_;
	}
	
	public function set_volume (volume:Float) :Float {
		volume_ = volume > 1 ? 1 : volume;
		if (sound != null) untyped sound.volume = volume_;
		return volume_;
	}
	
	
	public function destroy () :Void {
		stop();
		if (timer != null)
			timer.stop();
			timer = null;
	}
}
