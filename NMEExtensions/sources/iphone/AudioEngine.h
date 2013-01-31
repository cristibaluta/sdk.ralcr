#ifndef AudioEngine
#define AudioEngine

namespace ralcr {
	
	void preload_background_music (const char *filePath);
	/** plays background music in a loop*/
	void play_background_music (const char *filePath, bool loop);
	/** stops playing background music */
	void stop_background_music ();
	/** pauses the background music */
	void pause_background_music ();
	/** resume background music that has been paused */
	void resume_background_music ();
	/** rewind the background music */
	void rewind_background_music ();
	/** returns whether or not the background music is playing */
	bool is_background_music_playing ();

	/** plays an audio effect with a file path*/
	int play_effect (const char *filePath, bool loop);
	/** stop a sound that is playing, note you must pass in the soundId that is returned when you started playing the sound with playEffect */
	void stop_effect (int soundId);
	/** plays an audio effect with a file path, pitch, pan and gain */
	//-(ALuint) playEffect:(NSString*) filePath pitch:(Float32) pitch pan:(Float32) pan gain:(Float32) gain;
	/** preloads an audio effect */
	void preload_effect (const char *filePath);
	/** unloads an audio effect from memory */
	void unload_effect (const char *filePath);
}

#endif
