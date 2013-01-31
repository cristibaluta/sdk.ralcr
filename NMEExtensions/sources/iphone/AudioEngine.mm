#import <UIKit/UIKit.h>
#include <AudioEngine.h>
#include <CocosDenshion/CocosDenshion/SimpleAudioEngine.h>


namespace ralcr {
	
	void preload_background_music (const char *filePath) {
		NSString *path = [[[NSString alloc] initWithUTF8String:filePath] autorelease];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:path];
	}
	/** plays background music in a loop*/
	void play_background_music (const char *filePath, bool loop) {
		NSString *path = [[[NSString alloc] initWithUTF8String:filePath] autorelease];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:path loop:loop];
	}
	/** stops playing background music */
	void stop_background_music () {
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	/** pauses the background music */
	void pause_background_music () {
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	}
	/** resume background music that has been paused */
	void resume_background_music () {
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	}
	/** rewind the background music */
	void rewind_background_music () {
		[[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
	}
	/** returns whether or not the background music is playing */
	bool is_background_music_playing () {
		return [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
	}
	/** plays an audio effect with a file path*/
	int play_effect (const char *filePath, bool loop) {
		NSString *path = [[[NSString alloc] initWithUTF8String:filePath] autorelease];
		return [[SimpleAudioEngine sharedEngine] playEffect:path loop:loop];
	}
	void stop_effect (int soundId) {
		[[SimpleAudioEngine sharedEngine] stopEffect:soundId];
	}
	/** preloads an audio effect */
	void preload_effect (const char *filePath) {
		NSString *path = [[[NSString alloc] initWithUTF8String:filePath] autorelease];
		[[SimpleAudioEngine sharedEngine] preloadEffect:path];
	}
	/** unloads an audio effect from memory */
	void unload_effect (const char *filePath) {
		NSString *path = [[[NSString alloc] initWithUTF8String:filePath] autorelease];
		[[SimpleAudioEngine sharedEngine] unloadEffect:path];
	}
	
}
