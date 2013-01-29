#import <UIKit/UIKit.h>
#include <AudioEngine.h>



namespace ralcr {
	
	void preload_background_music (const char *filePath) {
		NSString *path = [[NSString alloc] initWithUTF8String:filePath];
		NSLog(@"preload %@", path);
	}
	/** plays background music in a loop*/
	void play_background_music (const char *filePath, bool loop) {
		NSString *path = [[NSString alloc] initWithUTF8String:filePath];
		NSLog(@"play %@", path);
	}
	/** stops playing background music */
	void stop_background_music () {
		
	}
	/** pauses the background music */
	void pause_background_music () {
		
	}
	/** resume background music that has been paused */
	void resume_background_music () {
		
	}
	/** rewind the background music */
	void rewind_background_music () {
		
	}
	/** returns whether or not the background music is playing */
	bool is_background_music_playing () {
		return false;
	}
	/** plays an audio effect with a file path*/
	/* -(ALuint)*/ void play_effect (const char *filePath) {
		
	}
	/** preloads an audio effect */
	void preload_effect (const char *filePath) {
		
	}
	/** unloads an audio effect from memory */
	void unload_effect (const char *filePath) {
		
	}
	
}
