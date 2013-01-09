
class Initialization {
	
	dynamic public static function onComplete() :Void{}
	
	
	static public function start () :Void {
		
		RCFontManager.init();
		
		RCAssets.onComplete = init;
		RCAssets.onProgress = progress;
		
		#if !nme
		// In nme this assets are added through nmml file
		//RCAssets.loadFileWithKey (null, "lib.swf?"+Math.random());// For flash load assets from external swf library
		#end
		
		// This will assign a key to every loaded asset
		RCAssets.loadFileWithKey ("key1", "assets/Asset1.png");
		RCAssets.loadFileWithKey ("key2", "assets/Asset2.png");
		
	}
	
	static function init () {
		
		//trace(RCFontManager.enumerateFonts());
		// Register fonts and formats that will be used later in the app
		
		RegisterFonts.init();
		onComplete();
	}
	
	static function progress () {
		// RCAssets.percentLoaded
	}
}
