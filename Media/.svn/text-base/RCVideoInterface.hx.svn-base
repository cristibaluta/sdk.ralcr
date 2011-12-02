//
//  IVideo
//
//  Created by Cristi Baluta on 2009-11-02.
//  Copyright (c) 2009 ralcr.com. All rights reserved.
//
interface RCVideoInterface {
	
/*	dynamic public function onInit () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function onLoadingProgress () :Void {}
	dynamic public function onPlayingProgress () :Void {}*/
	
	public function init () :Void;
	public function startVideo (?file:String) :Void;// Used in RTMP
	public function stopVideo () :Void;
	public function seekTo (time:Float) :Bool;// Can seek to this value?
	public function stopSeeking () :Void;
	public function pauseVideo  () :Void;
	public function resumeVideo () :Void;
	public function replayVideo () :Void;
	public function togglePause () :Void;
	public function destroy () :Void;
}
