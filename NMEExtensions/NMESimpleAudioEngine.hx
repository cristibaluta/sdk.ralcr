#if nme
class NMESimpleAudioEngine {
	// JNI signatures: http://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/types.html
	// I = int
	// Z = boolean
	
	public static function configure_jni(){
		#if android
		if (ralcr_preload_background_music == null) {
			ralcr_preload_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "preloadSound", "(Ljava/lang/String;)V");
			ralcr_play_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "playSound", "(Ljava/lang/String;Z)V");
			ralcr_stop_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "pauseSound", "()V");
			ralcr_pause_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "pauseSound", "()V");
			ralcr_resume_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "resumeSound", "()V");
			ralcr_rewind_background_music = nme.JNI.createStaticMethod("SimpleAudioEngine", "resumeSound", "()V");
			ralcr_is_background_music_playing = nme.JNI.createStaticMethod("SimpleAudioEngine", "isBackgroundMusicPlaying", "()Z");
			ralcr_play_effect = nme.JNI.createStaticMethod("SimpleAudioEngine", "playEffect", "(Ljava/lang/String;Z)I");
			ralcr_stop_effect = nme.JNI.createStaticMethod("SimpleAudioEngine", "stopEffect", "(I)V");
			ralcr_preload_effect = nme.JNI.createStaticMethod("SimpleAudioEngine", "preloadEffect", "(Ljava/lang/String;)V");
			ralcr_unload_effect = nme.JNI.createStaticMethod("SimpleAudioEngine", "preloadEffect", "(Ljava/lang/String;)V");
		}
		#end
	}
	
	public static function preloadBackgroundMusic (filePath:String) {
		trace("preload "+filePath);
		configure_jni();
		ralcr_preload_background_music ( filePath );
	}
	public static function playBackgroundMusic (filePath:String, loop:Bool) {
		trace("play "+filePath);
		configure_jni();
		ralcr_play_background_music (filePath, loop);
	}
	public static function stopBackgroundMusic () {
		configure_jni();
		ralcr_stop_background_music();
	}
	public static function pauseBackgroundMusic () {
		configure_jni();
		ralcr_pause_background_music();
	}
	public static function resumeBackgroundMusic () {
		configure_jni();
		ralcr_resume_background_music();
	}
	public static function rewindBackgroundMusic () {
		configure_jni();
		ralcr_rewind_background_music();
	}
	public static function isBackgroundMusicPlaying () :Bool {
		configure_jni();
		return ralcr_is_background_music_playing();
	}
	public static function playEffect (filePath:String, ?loop:Bool=false) :Int {
		configure_jni();
		return ralcr_play_effect ( filePath, loop );
	}
	public static function stopEffect (soundId:Int) {
		configure_jni();
		ralcr_stop_effect ( soundId );
	}
	public static function preloadEffect (filePath:String) {
		trace("preload effect "+filePath);
		configure_jni();
		ralcr_preload_effect (filePath);
	}
	public static function unloadEffect (filePath:String) {
		configure_jni();
		ralcr_unload_effect (filePath);
	}
    
#if ios
	static var ralcr_preload_background_music = nme.Loader.load("ralcr_preload_background_music", 1);
	static var ralcr_play_background_music = nme.Loader.load("ralcr_play_background_music", 2);
	static var ralcr_stop_background_music = nme.Loader.load("ralcr_stop_background_music", 0);
	static var ralcr_pause_background_music = nme.Loader.load("ralcr_pause_background_music", 0);
	static var ralcr_resume_background_music = nme.Loader.load("ralcr_resume_background_music", 0);
	static var ralcr_rewind_background_music = nme.Loader.load("ralcr_rewind_background_music", 0);
	static var ralcr_is_background_music_playing = nme.Loader.load("ralcr_is_background_music_playing", 0);
	static var ralcr_play_effect = nme.Loader.load("ralcr_play_effect", 2);
	static var ralcr_stop_effect = nme.Loader.load("ralcr_stop_effect", 1);
	static var ralcr_preload_effect = nme.Loader.load("ralcr_preload_effect", 1);
	static var ralcr_unload_effect = nme.Loader.load("ralcr_unload_effect", 1);
#elseif android
	static var ralcr_preload_background_music :Dynamic;
	static var ralcr_play_background_music :Dynamic;
	static var ralcr_stop_background_music :Dynamic;
	static var ralcr_pause_background_music :Dynamic;
	static var ralcr_resume_background_music :Dynamic;
	static var ralcr_rewind_background_music :Dynamic;
	static var ralcr_is_background_music_playing :Dynamic;
	static var ralcr_play_effect :Dynamic;
	static var ralcr_stop_effect :Dynamic;
	static var ralcr_preload_effect :Dynamic;
	static var ralcr_unload_effect :Dynamic;
#end
}
#end