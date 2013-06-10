#if openfl
class NMEMicrophone {
	
	public var didFinishLoad :RCSignal<String->Void>;
	
#if android
	
	public function new (x, y, w, h, url:String) {
		var _showAlert_func = openfl.utils.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		_showAlert_func ( [title, msg] );
	}
	public function destroy() :Void {
		
	}
    
#else
	
	public function new (x, y, w, h, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		haxe.Timer.delay (function(){ show_web_view (x, y, w, h, url); }, 100);
	}
	function didFinishLoadHandler () {
		didFinishLoad.dispatch ( "url" );
	}
    
	public function destroy() :Void {
		hide_web_view();
	}
    
	static var show_web_view = flash.Lib.load("nme", "show_web_view", 5);
	static var hide_web_view = flash.Lib.load("nme", "hide_web_view", 0);
#end
}
#end