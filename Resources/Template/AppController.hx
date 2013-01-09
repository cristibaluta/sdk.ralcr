
class AppController extends RCAppDelegate {
	
	public function new () {
		super();
	}
	
	override public function applicationDidFinishLaunching () :Void {
		
		var dpi = RCDevice.currentDevice().dpiScale;
		//RCWindow.sharedWindow().width = Math.round (RCWindow.sharedWindow().width / dpi);
		//RCWindow.sharedWindow().height = Math.round (RCWindow.sharedWindow().height / dpi);
		
		Initialization.onComplete = initializationReady;
		Initialization.start();
	}
			
	function initializationReady () {
		
		var title = new RCTextView (0,0,RCWindow.sharedWindow().width, 50, "Hello World", RCFont.systemFontOfSize(30));
		addChild ( title );
	}
	
	override public function resize (w:Float, h:Float) :Void {
		//this.x = RCWindow.sharedWindow().getCenterX ( 640 );
		//this.y = RCWindow.sharedWindow().getCenterY ( 1136 );
	}
}
