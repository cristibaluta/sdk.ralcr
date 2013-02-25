package org.haxe.nme;


import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.util.HashMap;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.adwhirl.AdWhirlLayout;
import com.adwhirl.AdWhirlTargeting;

import dalvik.system.DexClassLoader;


public class GameActivity extends Activity {

    MainView mView;
    static RelativeLayout mAdLayout;
    static AssetManager mAssets;
    static SoundPool mSoundPool;
    static int       mSoundPoolID;
    static Context mContext;
    static MediaPlayer mMediaPlayer = null;
    static final String GLOBAL_PREF_FILE="nmeAppPrefs";
    static GameActivity activity;
    public android.os.Handler mHandler;
    static HashMap<String,Class> mLoadedClasses = new HashMap<String,Class>();
	static DisplayMetrics metrics;

    protected void onCreate(Bundle state) {
        super.onCreate(state);
        activity=this;
        mContext = this;
        mHandler = new android.os.Handler();
        mAssets = getAssets();
        setVolumeControlStream(android.media.AudioManager.STREAM_MUSIC);  

        mSoundPoolID = 1;
        mSoundPool = new SoundPool(8,android.media.AudioManager.STREAM_MUSIC,0);
       //getResources().getAssets();

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		metrics = new DisplayMetrics ();
		getWindowManager().getDefaultDisplay().getMetrics (metrics);
		
        // Pre-load these, so the c++ knows where to find them
        
           System.loadLibrary("std");
         
           System.loadLibrary("regexp");
         
           System.loadLibrary("zlib");
         
           System.loadLibrary("nme");
           
           
        org.haxe.HXCPP.run("ApplicationMain");
        
        /*
        mView = new MainView(getApplication(),this);
        setContentView(mView);
        */
        
        FrameLayout rootLayout = new FrameLayout(this);        
        
        mView = new MainView(getApplication(),this);
        mAdLayout = new RelativeLayout(this);
        
        RelativeLayout.LayoutParams adWhirlLayoutParams = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT); 
        
        rootLayout.addView(mView);
        rootLayout.addView(mAdLayout, adWhirlLayoutParams);

        setContentView(rootLayout);		
        		
    }

    public static GameActivity getInstance() { return activity; }

    public static void showKeyboard(boolean show) 
    {
        InputMethodManager mgr = (InputMethodManager)
           activity.getSystemService(Context.INPUT_METHOD_SERVICE);

        mgr.hideSoftInputFromWindow(activity.mView.getWindowToken(), 0);
        if (show) {
            mgr.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);
            // On the Nexus One, SHOW_FORCED makes it impossible
            // to manually dismiss the keyboard.
            // On the Droid SHOW_IMPLICIT doesn't bring up the keyboard.
        }
    }

    static public byte [] getResource(String inResource) {

           //Log.e("GameActivity","Get resource------------------>" + inResource);
           try {
                  java.io.InputStream inputStream = mAssets.open(inResource,AssetManager.ACCESS_BUFFER);
                  long length = inputStream.available();
                  byte[] result = new byte[(int) length];
                  inputStream.read(result);
                  inputStream.close();
                  return result;
           } catch (java.io.IOException e) {
               Log.e("GameActivity",e.toString());
           }

           return null;
    }

    static public void defineClass(byte [] inData,String inClassName)
    {
       Log.e("GameActivity" ,"defineClass " + inData.length );
       File dexOutputDir = mContext.getDir("dex", 0);
       Log.e("GameActivity" ,"dex output dir " + dexOutputDir.toString() );
       String tmp = dexOutputDir.getAbsolutePath() + "/classes.jar";

       try
       {
           Log.e("GameActivity" ,"dex tmp " + tmp );
           OutputStream out = null;
           out = new FileOutputStream( new File(tmp),false);
           out.write(inData);
           Log.e("GameActivity" ,"wrote file");
           if (out != null)
              out.close();
       }
       catch(java.io.IOException e)
       {
           Log.e("GameActivity" ,"problem writing file");
       }

       Log.e("GameActivity" ,"creating loader");
       DexClassLoader loader = new DexClassLoader(tmp, dexOutputDir.getAbsolutePath(),
          "", mContext.getClass().getClassLoader());
       Log.e("GameActivity" ,"Load name " + inClassName);
       try
       {
          Class c = loader.loadClass(inClassName);
          mLoadedClasses.put(inClassName,c);
          Log.e("GameActivity" ,"loaded.");
       }
       catch( java.lang.ClassNotFoundException e )
       {
           Log.e("GameActivity" ,"Class not found.");
       }
    
       Log.e("GameActivity" ,"Load name done.");
       createInterfaceInstance(inClassName,0);
    }

    static public Object createInterfaceInstance(String inClassName,long inHandle)
    {
       Class c = mLoadedClasses.get(inClassName);
       if (c!=null)
       {
          try {
             Constructor construct = c.getConstructor(long.class);
             Object result = construct.newInstance(inHandle);
             Log.e("GameActivity" ,"Created instance:" + result);
             return result;
          }
          catch( NoSuchMethodException e )
          {
             Log.e("GameActivity" ,"No method");
          }
          catch( SecurityException e )
          {
             Log.e("GameActivity" ,"Security Error");
          }
          catch( java.lang.InstantiationException e )
          {
             Log.e("GameActivity" ,"InstantiationException Error");
          }
          catch( java.lang.IllegalAccessException e )
          {
             Log.e("GameActivity" ,"IllegalAccessException Error");
          }
          catch( java.lang.reflect.InvocationTargetException e )
          {
             Log.e("GameActivity" ,"InvocationTargetException Error");
          }
       }
       return null;
    }


    static public int getSoundHandle(String inFilename)
    {
       int id = -1;

       Log.v("GameActivity","Get sound handle ------" + inFilename + " = " + id);
       if (id>0)
       {
          int index = mSoundPool.load(mContext,id,1);
          Log.v("GameActivity","Loaded index" + index);
          return index;
       }
       else
          Log.v("GameActivity","Resource not found" + (-id) );

       return -1;
    }

    static public int getMusicHandle(String inFilename)
    {
       int id = -1;
       Log.v("GameActivity","Get music handle ------" + inFilename);

       Log.v("GameActivity","Got music handle ------" + id);

       return id;
    }

    static public int getSoundPoolID() { return mSoundPoolID; }

    static public Context getContext() { return mContext; }

    static public int playSound(int inSoundID, double inVolLeft, double inVolRight, int inLoop)
    {
       Log.v("GameActivity","PlaySound -----" + inSoundID);
       return mSoundPool.play(inSoundID,(float)inVolLeft,(float)inVolRight, 1, inLoop, 1.0f);
    }

    static public int playMusic(int inResourceID, double inVolLeft, double inVolRight, int inLoop)
    {
       Log.v("GameActivity","playMusic -----" + inResourceID);
       if (mMediaPlayer!=null)
       {
          Log.v("GameActivity","stop MediaPlayer");
          mMediaPlayer.stop();
          mMediaPlayer = null;
       }
    
       mMediaPlayer = MediaPlayer.create(mContext, inResourceID);
       if (mMediaPlayer==null)
           return -1;

       mMediaPlayer.setVolume((float)inVolLeft,(float)inVolRight);
       if (inLoop<0)
          mMediaPlayer.setLooping(true);
       else if (inLoop>0)
       {
       }
       mMediaPlayer.start();

       return 0;
    }
    
	static public void stopMusic() {
		Log.v("GameActivity","stop MediaPlayer");
		if (mMediaPlayer != null)
			mMediaPlayer.stop();
	}

    static public void postUICallback(final long inHandle)
    {
       activity.mHandler.post(new Runnable() {
         @Override public void run() {
                NME.onCallback(inHandle); } });
    }

    static public void launchBrowser(String inURL)
    {
      Intent browserIntent=new Intent(Intent.ACTION_VIEW).setData(Uri.parse(inURL));
      try
      {
         activity.startActivity(browserIntent);
      }
      catch (Exception e)
      {
         Log.e("GameActivity",e.toString());
         return;
      }

    }
	
	static public double CapabilitiesGetPixelAspectRatio () {
		
		return metrics.xdpi / metrics.ydpi;
		
	}
	
	static public double CapabilitiesGetScreenDPI () {
		
		return metrics.xdpi;
		
	}
	
	static public double CapabilitiesGetScreenResolutionX () {
		
		return metrics.widthPixels;
		
	}
	
	static public double CapabilitiesGetScreenResolutionY () {
		
		return metrics.heightPixels;
		
	}
    
    static public String getUserPreference(String inId)
    {
      SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE,MODE_PRIVATE);
      return prefs.getString(inId,"");
    }
    
    static public void setUserPreference(String inId, String inPreference)
    {
      SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE,MODE_PRIVATE);
      SharedPreferences.Editor prefEditor = prefs.edit();
      prefEditor.putString(inId,inPreference);
      prefEditor.commit();
    }
    
    static public void clearUserPreference(String inId)
    {
      SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE,MODE_PRIVATE);
      SharedPreferences.Editor prefEditor = prefs.edit();
      prefEditor.putString(inId,"");
      prefEditor.commit();
    }

    @Override protected void onPause() {
        super.onPause();
        mSoundPool = null;
        mView.sendActivity(NME.DEACTIVATE);
        mView.onPause();
        if (mMediaPlayer!=null)
           mMediaPlayer.pause();
    }

    @Override protected void onResume() {
        mSoundPoolID++;
        mSoundPool = new SoundPool(8,android.media.AudioManager.STREAM_MUSIC,0);
        super.onResume();
        mView.onResume();
        if (mMediaPlayer!=null)
           mMediaPlayer.start();
        mView.sendActivity(NME.ACTIVATE);
    }
   
   @Override protected void onDestroy() {
      // TODO: Wait for result?
      mView.sendActivity(NME.DESTROY);
      activity=null;
      super.onDestroy();
   }
   
   //admob
	static AdView adView;
	static Boolean adInited = false;
	//static Boolean adReceived = false;
	static Boolean adHided = true;
	
	static RelativeLayout.LayoutParams adWhirlLayoutParams;
	
	static public void initAd(final String id, final int x, final int y,final int size){
		
		activity.runOnUiThread(new Runnable() {
			public void run() {
				String adID = id;
				adView = new AdView(activity, AdSize.SMART_BANNER, adID);
				adView.setAdListener(activity);
				adView.loadAd(new AdRequest());	
				
				Log.e("Ads", "init");
				adWhirlLayoutParams = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); 
				 
				if(x == 0 && y == 0){
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
				}else if(x == 0 && y == -1){
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
				}else if(x == -1 && y == 0){
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
				}else if(x == -1 && y == 0){
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
				}else{
					adWhirlLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
				}
				
				adInited = true;
			}
		});
	}
	
	static public void showAd(final String id, final int x, final int y,final int size, final int preLoad) {
		activity.runOnUiThread(new Runnable() {
	
			public void run() {
				
				if(preLoad != 0 || adInited==false){
					initAd(id, x, y, size);
				}else{
					mAdLayout.removeAllViews();
					mAdLayout.addView(adView, adWhirlLayoutParams);
					adHided = false;
				}
			}
		});
	}
	
	static public void hideAd() {
		activity.runOnUiThread(new Runnable() {
			public void run() {
				
				if(null != adView && adHided == false){
					mAdLayout.removeAllViews(); 
					adView.loadAd(new AdRequest());
				}
			}
		});
	}

	public void onReceiveAd(Ad ad){		
		//adReceived = true;
	}
	
	public void onFailedToReceiveAd(Ad ad, AdRequest.ErrorCode error){}
	public void onPresentScreen(Ad ad){}
	public void onDismissScreen(Ad ad){}
	public void onLeaveApplication(Ad ad){}
	
	/**
	 *  startTracker
	 */
	static public void startTracker(final String id, final int disPatchPeriod){
		if(0 < disPatchPeriod){
			GoogleAnalyticsTracker.getInstance().startNewSession(id, disPatchPeriod, activity);
		}else{
			GoogleAnalyticsTracker.getInstance().startNewSession(id, activity);
		}
	}
	
	static public void trackEvent(final String category,final String action,final String label, final int value){
		GoogleAnalyticsTracker.getInstance().trackEvent(category, action, label, value);
	}

	/**
 	*  trackPage
 	*/	
	static public void trackPage(final String pageName){
		GoogleAnalyticsTracker.getInstance().trackPageView(pageName);
	}

	/**
 	*  dispatchTracker
 	*/
	static public void dispatchTracker(){
		GoogleAnalyticsTracker.getInstance().dispatch();
	}
	
	/**
 	*  stopTracker
 	*/
	static public void stopTracker(){
		GoogleAnalyticsTracker.getInstance().stopSession();
	}
	
	/**
	 * OpenFeint
	 */
	public static void reportAchievement(String achievement){
		
    	new Achievement(achievement).unlock(new Achievement.UnlockCB () {
    		@Override 
    		public void onSuccess(boolean newUnlock) {
    		}

    		@Override 
    		public void onFailure(String exceptionMessage) {
    			Toast.makeText(activity,
    				"Error (" + exceptionMessage + ") unlocking achievement.",
    				Toast.LENGTH_SHORT).show();
    		}
    	});
    }
    
    public static void reportScoreForCategory(int score, String leaderboardID){
    	
    	Log.e("submitScore", leaderboardID+":   "+score);
    	long scoreValue = score;

    	Score s = new Score(scoreValue, null); // Second parameter is null to indicate that custom display text is not used.
    	Leaderboard l = new Leaderboard(leaderboardID);	
		s.submitTo(l, new Score.SubmitToCB() {
			@Override 
			public void onSuccess(boolean newHighScore) {
				// sweet, score posted
				Log.e("submitScore", "onSuccess");
			}

			@Override 
			public void onFailure(String exceptionMessage) {
				Log.e("submitScore", "onFailure");
				Toast.makeText(activity, "Error (" + exceptionMessage + ") posting score.", Toast.LENGTH_SHORT).show();
			}
		});
    }
    
    public static void showOpenFientDashboard(){
    	Dashboard.open();
    }
    
    public static void showLeaderboardForCategory(String leaderID){
    	
    	Dashboard.openLeaderboard(leaderID);
    }
    public static void showAchievements(){
    	
    	Dashboard.openAchievements();
    }
	
	/**
	 * NativeUI
	 * @param title
	 * @param message
	 */
	public static void showDialog(String title, String message){
    	Dialog dialog = new AlertDialog.Builder(activity)
	    .setTitle(title)
	    .setMessage(message)
	    .setPositiveButton("Ok",
	    new DialogInterface.OnClickListener(){
	    	public void onClick(DialogInterface dialog, int whichButton){
	    		
	    	}
	    }).create();

	    dialog.show();
    }
	


}

