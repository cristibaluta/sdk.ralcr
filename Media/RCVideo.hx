//
//  VideoPlayer
//
//  Created by Baluta Cristian on 2007-10-18.
//  Copyright (c) 2007 http://ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.AsyncErrorEvent;
import flash.events.TimerEvent;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.Timer;
import flash.media.SoundTransform;


class RCVideo extends Sprite, implements RCVideoInterface {
	
	public static var BUFFER_TIME :Int = 2;
	public static var DEFAULT_VOLUME :Float = 0.8;
	public static var DISPLAY_TIMER_UPDATE_DELAY :Int = 1000;
	
	public var w :Null<Int>;//width and height that the player is forced to take
	public var h :Null<Int>;
	var videoURL :String;
	var inited :Bool;
	var loaded :Bool;
	var seeking :Bool;
	var _volume :Float;
	
	var timer :Timer;
	var nc :NetConnection;
	var ns :NetStream;
	var video :Video;
	
	public var background :RCRectangle;
	public var updateTime :Int;
	public var isPlaying :Bool;
	public var aspectRatio :Null<Float>;
	public var time :Float;
	public var duration :Float;
	public var percentLoaded :Int;
	public var percentPlayed :Int;
	public var statusMessage :String;
	public var secureToken :String;// This is sent by the server and is stored here for later access
	public var volume (getVolume, setVolume) :Float;
	
	/**
	 * Dispatch events
	 */
	dynamic public function onInit () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function videoDidStart () :Void {}
	dynamic public function videoDidStop () :Void {}
	dynamic public function videoDidFinishPlaying () :Void {}
	dynamic public function onLoadingProgress () :Void {}
	dynamic public function onPlayingProgress () :Void {}
	dynamic public function onBufferEmpty () :Void {}
	dynamic public function onBufferFull () :Void {}
	dynamic public function streamWantsSecureToken () :Void {}
	
	
	public function new (x, y, URL:String, ?w:Null<Int>, ?h:Null<Int>) {
		super();
		
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		
		this.videoURL = URL;
		this.inited = false;
		this.loaded = false;
		this.seeking = false;
		this.isPlaying = false;
		this.percentLoaded = 0;
		this.percentPlayed = 0;
		this.time = 0.0;
		this.duration = 0.0;
		this.statusMessage = "Not inited";
		this.updateTime = DISPLAY_TIMER_UPDATE_DELAY;
		_volume = DEFAULT_VOLUME;
		
		this.addChild ( background = new RCRectangle(0, 0, w, h, 0x000000) );
	}
	
	// sets up the player for video files
	public function init () :Void {
		// Create timer to update all visual parts of the player
		timer = new Timer ( updateTime );
		timer.addEventListener (TimerEvent.TIMER, loop);
		
		// Create a new net connection
		// add event listeners
		// connect to null (because we don't have a media server)
		nc = new NetConnection();
		nc.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
		nc.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		nc.connect ( null );
	}
	
	
	function netStatusHandler (e:NetStatusEvent) :Void {
		
		statusMessage = e.info.description;
		//trace ("RCVideo - "+e.info.code+" - "+statusMessage);
		//trace("e.info.secureToken "+e.info.secureToken);
		switch (e.info.code) {
			case "NetConnection.Connect.Success":
			if (e.info.secureToken != null) {
				secureToken = e.info.secureToken;
				streamWantsSecureToken();
			}
			initHandler();
			
			case "NetConnection.Connect.Rejected": onError();
			
			case "NetStream.Play.StreamNotFound": onError();
			case "NetStream.Play.Start": videoDidStart();
			case "NetStream.Play.Stop": videoDidStop();
			case "NetStream.Play.Complete": trace("NetStream.Play.Complete");
			case "NetStream.Buffer.Full": onBufferFull();
			case "NetStream.Buffer.Empty": onBufferEmpty();
			case "NetStream.Buffer.Flush": null;
			case "NetStream.Seek.InvalidTime": null;
			case "NetStream.Play.InsufficientBW": trace("insufficiend bandwith");
		}
	}
	
	public function secureTokenResponse (token:String) :Void {
		nc.call ("secureTokenResponse", null, token);
	}
	function initHandler () :Void {
		
		var customClient:Dynamic = {};
			customClient.onCuePoint = onCuePoint;
			customClient.onMetaData = onMetaData;
			//customClient.onTextData = onTextDataHandler;
			
		ns = new NetStream ( nc );
		ns.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
		ns.addEventListener (AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		ns.client = customClient;// call onMetaData and onCuePoint
		ns.bufferTime = BUFFER_TIME;
		
		video = new Video();
		video.attachNetStream ( ns );
		video.smoothing = true;
		this.addChild ( video );
		
		setVolume ( _volume );
		
		onInit();
		this.dispatchEvent ( new VideoEvent (VideoEvent.INIT, 0.0, 0));
	}
	
	function securityErrorHandler (e:SecurityErrorEvent) :Void {
		statusMessage = e.text;
		onError();
		var ev = new VideoEvent ( VideoEvent.ERROR, 0.0, 0);
			ev.errorMessage = statusMessage;
		this.dispatchEvent ( ev );
    }
	
	function asyncErrorHandler (e:AsyncErrorEvent) :Void {
		statusMessage = e.text;
		onError();
    }

	
	
	/**
	 * Main loop which dispatch some events: loading progress, playing progress
	 */
	function loop (e:TimerEvent) :Void { try {
		if (ns == null) return;
		if (!seeking) {
			time = ns.time;
			percentPlayed = Math.round (time / duration * 100);
			onPlayingProgress();
			this.dispatchEvent ( new VideoEvent (VideoEvent.PLAYING_PROGRESS, time, duration));
			//trace(time+", "+duration);
			// Fire from here the event that the video did finish playing.
			// The NetStream.Play.Stop is fired too often
			if (Math.abs (duration - time) <= 0.1 && duration > 0) {trace(time+", "+duration);
				stopVideo();
				videoDidFinishPlaying();
			}
		}
		
		// update the loading progress
		if (!loaded) {
			percentLoaded = Math.round (ns.bytesLoaded / ns.bytesTotal * 100);
			if (percentLoaded >= 100) loaded = true;
			onLoadingProgress();
			this.dispatchEvent ( new VideoEvent (VideoEvent.LOADING_PROGRESS, time, duration));
		}
		
		} catch (e:Dynamic) {
			trace(e);
			var stack = haxe.Stack.exceptionStack();
			trace (haxe.Stack.toString ( stack ));
		}
	}
	
	
	/**
	 *	Listeners for metaData and cuePoints
	 */
	function onMetaData (meta:Dynamic) :Void {
		trace("RCVideo medatada received. Now ready to play.");
		if (seeking) return;
		if (duration != 0) return;
		
		aspectRatio = (meta.width != null && meta.height != null) ? (meta.width / meta.height) : null;
		duration = meta.duration;
		
		trace("aspectRatio "+aspectRatio);
		for (m in Reflect.fields(meta)) trace(m + " -> "+Reflect.field(meta, m));
		
		// Check the size specified by the user
		if (w != null && h != null) {
			setSize (w, h);
		}
		// Otherwise set it to the size from metadata
		else setSize (meta.width, meta.height);
		
		// Now that we have the metadata, we can start the timer
		timer.start();
		
		this.dispatchEvent ( new MetaEvent (MetaEvent.META, meta) );
	}
	
	function onCuePoint (cue:Dynamic) :Void {
		//trace(Std.string(cue));
		this.dispatchEvent ( new CuePoint (CuePoint.CUE_POINT, cue) );
	}
	
	
	
	/**
	 * Control the player
	 */
	public function startVideo (?file:String) :Void {
		if (ns == null) return;
		// check's, if the flv has already begun
		// to download. if so, resume playback, else
		// load the file
		if (!inited) {
			ns.play (file != null ? file : videoURL);
			inited = true;
		}
		else {
			ns.resume();
			timer.start();
		}
		isPlaying = true;
	}
	public function replayVideo () : Void {
		// Pause netstream, set time position to zero
		if (ns != null) {
			seeking = true;
			ns.pause();
			ns.seek ( 0 );// This may cause the metadata to be called again
			haxe.Timer.delay (doReplay, 2);
			//doReplay();
		}
	}
	function doReplay(){
		ns.resume();
		isPlaying = true;
		seeking = false;
		timer.start();
	}
	
	public function stopVideo () : Void {
		pauseVideo();
		if (ns != null) {
			ns.seek ( duration );
		}
	}
	
	
	/**
	 *  Pause the video
	 */
	public function pauseVideo () :Void {
		if (ns != null) {
			ns.pause();
			timer.stop();
			isPlaying = false;
		}
	}
	
	/**
	 *  Resume video from where was stopped
	 */
	public function resumeVideo () :Void {
		if (ns != null) {
			ns.resume();
			timer.start();
			isPlaying = true;
		}
	}
	
	/**
	 *  Pause/unpause the video
	 */
	public function togglePause () :Void {
		if (isPlaying)
			pauseVideo();
		else
			resumeVideo();
	}
	
	
	
	/**
	 *  Seek video to time (sec)
	 */
	public function seekTo (time:Float) :Bool {
		seeking = true;
		if (time > duration * percentLoaded / 100) return false;//Do not seek beyound current loaded 
		if (ns != null)
			ns.seek ( time );
		return true;
	}
	
	public function stopSeeking () :Void {
		seeking = false;
	}
	
	
	
	/**
	 *	Control the volume
	 */
	public function getVolume () :Float {
		return _volume;
	}
	
	public function setVolume (volume:Float) :Float {
		_volume = volume > 1 ? 1 : volume;
		if (ns != null)
			ns.soundTransform = new SoundTransform ( _volume );
		return _volume;
	}
	
	
	/**
	 *	Sets the size of the video object and maintains its aspect ratio
	 */
	public function setSize (w, h) :Void {
		this.w = w;
		this.h = h;
		background.width = w;
		background.height = h;
		
		var holderAspectRatio = w / h;
		if (aspectRatio != null) {
			if (aspectRatio < holderAspectRatio) {
				video.height = h;
				video.width = h * aspectRatio;
			}
			else {
				video.width = w;
				video.height = w / aspectRatio;
			}
		}
		else {
			video.width = w;
			video.height = h;
		}
		
		// Center the video object in the provided width and height
		video.x = Math.round ((w - video.width) / 2);
		video.y = Math.round ((h - video.height) / 2);
	}
	
	
	/**
	 * Cleanup the mess, stop the player
	 */
	public function destroy () :Void {
		
		if (timer != null) {
			timer.stop();
			timer.removeEventListener (TimerEvent.TIMER, loop);
		}
		
		if (ns != null) {
			ns.removeEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.removeEventListener (AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.close();
			ns = null;
		}
		
		if (nc != null) {
			nc.removeEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
			nc.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			nc = null;
		}
		
		video = null;
	}
}
