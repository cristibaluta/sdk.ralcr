package org.haxe.nme;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Application;

import com.openfeint.api.OpenFeint;
import com.openfeint.api.OpenFeintDelegate;
import com.openfeint.api.OpenFeintSettings;
import com.openfeint.api.resource.Achievement;
import com.openfeint.api.resource.Leaderboard;

public class OpenFeintApplication extends Application {
	
	
    @Override
    public void onCreate() {
        super.onCreate();

        OpenFeintSettings settings = new OpenFeintSettings("App Name", "App Key", "App Secret", "App ID");
        
        OpenFeint.initialize(this, settings, new OpenFeintDelegate() { });

    }

}
