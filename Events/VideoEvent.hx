class VideoEvent extends flash.events.Event {
	
	public var time :Float;
	public var duration :Float;
	public var errorMessage :String;
	
	inline public static var START	 :String = "on_flv_start";
	inline public static var STOP	 :String = "on_flv_stop";
	inline public static var LOADING_PROGRESS :String = "on_flv_loadingProgress";
	inline public static var PLAYING_PROGRESS :String = "on_flv_playingProgress";
	inline public static var COMPLETE:String = "on_flv_complete";
	inline public static var ERROR	 :String = "on_flv_error";
	inline public static var INIT	 :String = "on_flv_init";
	
	
	public function new (type:String, time:Float, duration:Float, ?bubbles:Bool=false, ?cancelable:Bool=false) {
		this.time = time;
		this.duration = duration;
		
		super ( type, bubbles, cancelable );
	}
}
