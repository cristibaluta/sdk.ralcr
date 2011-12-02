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


class RCRtmp extends RCVideo, implements RCVideoInterface {
	
	var file :String;
	
	
	public function new (x, y, URL:String, ?w:Null<Int>, ?h:Null<Int>) {
		super (x, y, URL, w, h);
	}
	
	// sets up the rtmp stream
	override public function init () :Void {
		
		// Create timer to update all visual parts of the player
		//timer = new Timer ( RCVideo.DISPLAY_TIMER_UPDATE_DELAY );
		//timer.addEventListener (TimerEvent.TIMER, timerHandler);
		
		NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
		
		nc = new NetConnection();
		nc.client = this;
		nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
		nc.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
		nc.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		nc.addEventListener (AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		nc.connect ( videoURL );
	}
	public function onBWDone():Void {
		trace("BWDone");
		startVideo ( file );
	}
	
		
	override function initHandler () :Void {
		
		ns = new NetStream ( nc );
		ns.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
		ns.addEventListener (AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		ns.client = this;// call onMetaData and onCuePoint
		ns.bufferTime = RCVideo.BUFFER_TIME;
		
		video = new Video (w, h);
		video.attachNetStream ( ns );
		video.smoothing = true;
		this.addChild ( video );
		
		setVolume ( RCVideo.DEFAULT_VOLUME );
		startVideo ( file );
		onInit();
		this.dispatchEvent ( new VideoEvent (VideoEvent.INIT, 0.0, 0) );
	}
	
	
	/**
	 *	Control the player
	 *	The rtmp needs to specify a file to play, something like : a1, l3, ...
	 */
	override public function startVideo (?file:String) :Void {
		if (file != null) this.file = file;
		
		if (ns == null) return;
		//ns.play ( file );return;
		// check's, if the flv has already begun
		// to download. if so, resume playback, else
		// load the file
		if (!inited) {
			ns.play ( file );
			inited = true;
		}
		else {
			ns.close();
			ns.play ( file );
		}
	}
}
