import Shortcuts;
import flash.events.IOErrorEvent;
import flash.display.Loader;
import flash.system.Security;


class NptAd extends Sprite {
	
	var id :String;
	var npt :Loader;
	var plugin :Dynamic;
	var makeRequestAfterLoading :Bool;
	var isStreaming :Bool;
	var w :Float;
	var h :Float;
	var duration :Int;
	var title :String;
	var streamer :String;
	var volume :Float;
	
	dynamic public function onAdStart() :Void {}
	dynamic public function onAdStop() :Void {}
	dynamic public function playerShouldStart() :Void {}
	dynamic public function playerShouldResume() :Void {}
	dynamic public function playerShouldPause() :Void {}
	
	
	public function new (url:String, nptChannelIdentifier:String, isStreaming:Bool) {
		super();
		this.id = nptChannelIdentifier;
		this.makeRequestAfterLoading = false;
		this.isStreaming = isStreaming;
		
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		
		npt = new Loader();
        npt.contentLoaderInfo.addEventListener (Event.COMPLETE, onPluginLoaded);
		npt.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onPluginError);
        npt.load ( new flash.net.URLRequest ( url ) );
	}
	function onPluginLoaded (e:Event) :Void {
		plugin = npt.content;
		this.addChild ( plugin );
		
		plugin.NptComp.addEventListener ("getAdListSuccess", onGetAdListSuccess);
		plugin.NptComp.addEventListener ("startPlayback", onPlayerStartPlayback);
		plugin.NptComp.addEventListener ("resumePlayback", onPlayerResumePlayback);
		plugin.NptComp.addEventListener ("pausePlayback", onPlayerPausePlayback);
		plugin.NptComp.addEventListener ("adStart", onNptAdStart);
		plugin.NptComp.addEventListener ("adEnd", onNptAdEnd);
		
		if (makeRequestAfterLoading)
			makeAdRequest (w, h, duration, title, streamer, isStreaming, volume);
	}
	function onPluginError (evt:IOErrorEvent) {
		trace(evt);
		playerShouldStart();// The ad was not loaded, start the player
	}
	
	public function makeAdRequest(w, h, duration, title, streamer, isStreaming:Bool, volume:Float){
		
		if (plugin == null) {
			this.makeRequestAfterLoading = true;// Wait the plugin to load first then make the request
			this.w = w;
			this.h = h;
			this.duration = duration;
			this.title = title;
			this.streamer = streamer;
			this.isStreaming = isStreaming;
			this.volume = volume;
			return;
		}
		trace("makeAdRequest "+streamer);trace("id "+id);
		var config :Dynamic = {};
		var channelType = 'vod';
		
		if (!isStreaming) {
			config = {	channelIdentifier : id,
						playerWidth : w,
						playerHeight : h,
						volume : volume,
						muted : false,
						movieDuration : duration,
						videoFileName : title,
						playerVersion : 'UTVPlayer'};
		}
		else {
			config = {	channelIdentifier : id,
						playerWidth : w,
						playerHeight : h,
						volume : volume,
						muted : false,
						videoFileName : title,
						serverStreamingAddress :  streamer,
						playerVersion : 'UTVLivePlayer'};
		}
		trace("requestAdList "+Std.string(config));
		plugin.NptComp.requestAdList ( config );
	}
	
	function onGetAdListSuccess (evt:Event) {
		trace("onGetAdListSuccess ");
		plugin.NptComp.checkPrerollAd();
		// Disable all buttons
	}
	
	function onPlayerStartPlayback (evt:Event) { trace("startPlayback"); playerShouldStart(); }
	function onPlayerResumePlayback(evt:Event){ trace("resumePlayback"); playerShouldResume(); }
	function onPlayerPausePlayback(evt:Event){ trace("pausePlayback"); playerShouldPause(); }
	function onNptAdStart(evt:Event){ trace("npt ad start"); onAdStart(); }
	function onNptAdEnd(evt:Event){ trace("npt ad stop"); onAdStop(); }
	
	
	public function setMetadata (o:Dynamic) {
		if (plugin != null)
			plugin.NptComp.setMetadata ( o );
	}
	
	public function checkPostRollAd(){
		if (plugin != null)
			plugin.NptComp.checkPostRollAd();
	}
	
	public function playerSeek(){
		if (plugin != null)
			plugin.NptComp.playerSeek();
	}
	public function checkStatus (time:Float) {
		if (plugin != null)
			try{plugin.NptComp.checkStatus ( time );}catch(e:Dynamic){trace(e);}
	}
	
	public function setVolume (v:Float) {
		if (plugin != null)
			plugin.NptComp.setFlvVolume (v, false);
	}
	
	public function setScale (isFullScreen:Bool, w, h) {
		if (plugin != null)
			plugin.NptComp.setScale (isFullScreen, w, h);
	}
	
	public function destroy() {
		if (plugin != null) { try {
			plugin.NptComp.reset(); }catch(e:Dynamic){ trace("error reseting the npt " + e); }
			plugin = null;
			npt.contentLoaderInfo.removeEventListener (Event.COMPLETE, onPluginLoaded);
			npt.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, onPluginError);
			npt = null;
		}
	}
}
