//
//	YouTubePlayer
//
//	Created by Cristi Baluta on 2009-10-28.
//	Copyright (c) 2009 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.display.Sprite;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.AsyncErrorEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.net.URLRequest;
import flash.system.Security;


class YouTube extends RCVideo, implements RCVideoInterface, implements RCAudioInterface {
	
	var videoId :String;
	var loader :Loader;
	var player:Dynamic;// This will hold the API player instance once it is initialized.
	public var suggestedQuality :String;
	
	
	public function new (x, y, videoId:String, ?w:Null<Float>, ?h:Null<Float>) {
		super(x, y, null, w, h);
		
		this.videoId = videoId;
		this.suggestedQuality = "default";
		
		Security.allowDomain('www.youtube.com'); 
		Security.allowDomain('gdata.youtube.com'); 
		Security.allowInsecureDomain('gdata.youtube.com'); 
		Security.allowInsecureDomain('www.youtube.com');
	}
	
	
	// sets up the YouTube API
	override public function init () :Void {
		if (videoId == null) return;
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener (Event.INIT, onLoaderInit);
		loader.contentLoaderInfo.addEventListener (ErrorEvent.ERROR, onLoaderError);
		loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onLoaderError);
		loader.load ( new URLRequest("http://www.youtube.com/apiplayer?version=3") );
	}
	
	function onLoaderInit(event:Event):Void {
		layer.addChild ( loader );
		
		loader.content.addEventListener("onReady", onPlayerReady);
		loader.content.addEventListener("onError", onPlayerError);
		loader.content.addEventListener("onStateChange", onPlayerStateChange);
		loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
	}
	function onLoaderError (e:Dynamic) :Void {
		statusMessage = e.text;
		trace("Loading Youtube API failed with message: "+statusMessage);
		onError();
	}
	
	function onPlayerReady(e:Event):Void {
		// Event.data contains the event parameter, which is the Player API ID 
		// Once this event has been dispatched by the player, we can use
		// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
		// to load a particular YouTube video.
		player = loader.content;
		
		timer = new Timer ( RCVideo.DISPLAY_TIMER_UPDATE_DELAY );
		timer.addEventListener (TimerEvent.TIMER, loop);
		//timer.start();
		
		onInit();
	}
	
	function onPlayerError(e:Event):Void {
		// Event.data contains the event parameter, which is the error code
		statusMessage = untyped e.data;
		trace("error code "+statusMessage);
		onError();
	}
	
	function onPlayerStateChange(e:Event):Void {
		//trace("onPlayerStateChange: "+untyped e.data);
		// Event.data contains the event parameter, which is the new player state
		switch ( untyped e.data ) {
			case "0":	videoDidFinishPlaying(); onBufferFull();// video stopped playing (ended)
			case "1":	onBufferFull();// 1 means is playing
			case "2":	null;// 2 means Paused
			case "3":	onBufferEmpty();// 3 means is buffering
		}
	}
	
	function onVideoPlaybackQualityChange(e:Event):Void {
		// Event.data contains the event parameter, which is the new video quality
		statusMessage = untyped e.data;
	}
	
	
	/**
	 * Handlers
	 */
	override function loop (e:TimerEvent) :Void {
		// checks, if user is scrubbing. if so, seek in the video
		// if not, just update the position of the scrubber according
		// to the current time
		if (!seeking_) {
			time = player.getCurrentTime();
			duration = player.getDuration();
			onPlayingProgress();
			//this.dispatchEvent ( new VideoEvent (VideoEvent.PLAYING_PROGRESS, time, duration));
		}
		
		if (time >= duration && duration > 0)
			timer.stop();
		
		// Update the loading progress bar
		if (!loaded_) {
			percentLoaded = Math.round (player.getVideoBytesLoaded() / player.getVideoBytesTotal() * 100);
			if (percentLoaded >= 100)
				loaded_ = true;
			onLoadingProgress();
		}
	}
		
	
	/**
	 * Control the player
	 */
	override public function startVideo (?file:String) :Void {
		if (player == null) return;
		// check's, if the flv has already begun
		// to download. if so, resume playback, else
		// load the file
		if (!inited_) {
			player.loadVideoById ( file != null ? file : videoId, 0, suggestedQuality );
			setSize (size.width, size.height);
			inited_ = true;
			timer.start();
		}
		else {
			resumeVideo();
			timer.start();
		}
		isPlaying = true;
	}
	
	override public function stopVideo () : Void {
		timer.stop();
		pauseVideo();
		seekTo ( 0 );
		seeking_ = false;
		isPlaying = false;
	}
	
	override public function seekTo (time:Float) :Bool {
		seeking_ = true;
		if (player != null)
			player.seekTo ( time );
		return true;
	}
	
	override public function pauseVideo	() :Void {
		if (player != null) {
			player.pauseVideo();
			isPlaying = false;
		}
	}
	
	override public function resumeVideo () :Void {
		if (player != null) {
			player.playVideo();
			isPlaying = true;
		}
	}
	
	override public function togglePause () :Void {
		if (player != null)
			player.pauseVideo();
	}
	
	public function cueVideo () :Void {
		player.cueVideoById (videoId, 0);
	}
	
	public function setPlaybackQuality (suggestedQuality:String) {
		if (player != null)
			player.setPlaybackQuality ( suggestedQuality );
	}
	
	public function getAvailableQualityLevels () :Array<String> {
		return player.getAvailableQualityLevels();
	}
	
	
	
	override public function setVolume (volume:Float) :Float {
		volume_ = volume > 1 ? 1 : volume;
		if (player != null)
			player.setVolume ( volume_*100 );
		return volume_;
	}
	
	
	/**
	 *	Sets the size of the video object
	 */
	override public function setSize (w, h) :Void {
		size.width = w;
		size.height = h;
		if (player != null)
			player.setSize (w, h);
	}
	
	
	override public function destroy () :Void {
		
		//trace("destroy youtube: "+loader+" , "+player+", "+videoId);
		videoId = null;
		
		if (timer != null) {
			timer.stop();
			timer.removeEventListener (TimerEvent.TIMER, loop);
			timer = null;
		}
		
		if (loader != null) {
			loader.contentLoaderInfo.removeEventListener (Event.INIT, onLoaderInit);
			loader = null;
		}
		
		if (player != null) {
			player.stopVideo();
			player.destroy();
			player = null;
		}
	}
}
