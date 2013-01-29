#if nme
class NMEWebView {
	
	public var didFinishLoad :RCSignal<String->Void>;
	
#if android
	
	public function new (x, y, w, h, url:String) {
		var _showAlert_func = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		_showAlert_func ( [title, msg] );
	}
	public function destroy() :Void {
		
	}
    
#else
	
	public function new (x, y, w, h, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		
		ralcr_set_did_finish_load_handle ( didFinishLoadHandler );
		ralcr_show_web_view (x, y, w, h, url);
	}
	function didFinishLoadHandler (e:Dynamic) {
		didFinishLoad.dispatch ( Std.string(e) );
	}
    
	public function destroy() :Void {
		ralcr_hide_web_view();
	}
    
	static var ralcr_show_web_view = nme.Loader.load("ralcr_show_web_view", 5);
	static var ralcr_hide_web_view = nme.Loader.load("ralcr_hide_web_view", 0);
	static var ralcr_set_did_finish_load_handle = nme.Loader.load("ralcr_set_did_finish_load_handle", 1);
#end
}
#end