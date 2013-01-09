package ::package::;


class Main {
	
	static public var view :AppController;
	
	
	public static function main() {
		
		RCLog.redirectTraces();
		
		RCWindow.sharedWindow().addChild ( view = new AppController() );
		
		#if nme
			var fps = new nme.display.FPS();
			RCWindow.sharedWindow().target.addChild ( fps );
		#else
			//RCWindow.sharedWindow().addChild ( new RCStats(50,0) );
		#end
	}
}
