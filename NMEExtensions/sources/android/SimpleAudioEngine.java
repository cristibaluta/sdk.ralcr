
import org.haxe.nme.GameActivity;

public class SimpleAudioEngine {
	
    public static void mute() {
    	
    }
    
    public static void unmute() {
    	
    }
    
    public static boolean isMute() {
    	return false;
    }
	
	
	public static void preloadEffect(String filename){
		SoundEngine.sharedEngine().preloadEffect(filename);
	}
	public static int playEffect(String filename, boolean loop) {
		return SoundEngine.sharedEngine().playEffect(filename, loop);
	}
	public static void stopEffect(int streamId) {
		SoundEngine.sharedEngine().stopEffect(streamId);
	}

	public static void preloadSound(final String filename) {
		GameActivity.getInstance().runOnUiThread(new Runnable() {
            @Override
            public void run() {
				SoundEngine.sharedEngine().preloadSound(filename);
            }
        });
	}
	public static void playSound(final String filename, final boolean loop) {
		GameActivity.getInstance().runOnUiThread(new Runnable() {
            @Override
            public void run() {
				SoundEngine.sharedEngine().playSound(filename, loop);
            }
        });
	}
	public static void pauseSound() {
		GameActivity.getInstance().runOnUiThread(new Runnable() {
            @Override
            public void run() {
				SoundEngine.sharedEngine().pauseSound();
            }
        });
	}
	public static void resumeSound() {
		SoundEngine.sharedEngine().resumeSound();
	}
	public static boolean isBackgroundMusicPlaying() {
		return true;
	}
	public static void rewindSound() {
		//SoundEngine.sharedEngine().resumeSound();
	}
}