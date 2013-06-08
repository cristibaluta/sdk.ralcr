#if openfl
class NMEWebView {
	
	public var didFinishLoad :RCSignal<String->Void>;
	
#if android
	
	public function new (x, y, w, h, url:String) {
		var _showAlert_func = openfl.utils.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		_showAlert_func ( [title, msg] );
	}
	public function destroy() :Void {
		
	}
    
#else
	
	public function new (x, y, w, h) {
		
		didFinishLoad = new RCSignal<String->Void>();
		new_web_view (x, y, w, h, url);
	}
	function didFinishLoadHandler () {
		didFinishLoad.dispatch ( "url" );
	}
    
	public function destroy() :Void {
		destroy_web_view();
	}
    
	static var new_web_view = cpp.Lib.load("new_web_view", 5);
	static var destroy_web_view = cpp.Lib.load("destroy_web_view", 0);
#end
}
#end