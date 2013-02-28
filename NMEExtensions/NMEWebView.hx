#if nme
class NMEWebView {
	
	public var didFinishLoad :RCSignal<String->Void>;
	
#if android
	
	var ralcr_new_web_view :Dynamic;
	var ralcr_destroy_web_view :Dynamic;
	var ralcr_set_did_finish_load_handle :Dynamic;
	
	public function new (x:Float, y:Float, w:Float, h:Float, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		trace(x);trace(y);trace(w);trace(h);trace(url);
		ralcr_new_web_view = nme.JNI.createStaticMethod("NMEWebView", "ralcr_new_web_view", "(IIIILjava/lang/String;)Landroid/view/View;");
		nme.Lib.postUICallback ( function() { ralcr_new_web_view (x, y, w, h, url);});
	}
	function didFinishLoadHandler (e:Dynamic) {
		didFinishLoad.dispatch ( Std.string(e) );
	}
    
	public function destroy() :Void {
		trace("destroy nmewebview");
		ralcr_destroy_web_view = nme.JNI.createStaticMethod("NMEWebView", "ralcr_destroy_web_view", "()V");
		trace("destroy nmewebview");
		nme.Lib.postUICallback ( function() { ralcr_destroy_web_view();});
		trace("destroy nmewebview");
	}
	
#else
	
	public function new (x:Float, y:Float, w:Float, h:Float, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		
		ralcr_set_did_finish_load_handle ( didFinishLoadHandler );
		ralcr_new_web_view (x, y, w, h, url);
	}
	function didFinishLoadHandler (e:Dynamic) {
		didFinishLoad.dispatch ( Std.string(e) );
	}
    
	public function destroy() :Void {
		ralcr_destroy_web_view();
	}
    
	static var ralcr_new_web_view = nme.Loader.load("ralcr_new_web_view", 5);
	static var ralcr_destroy_web_view = nme.Loader.load("ralcr_destroy_web_view", 0);
	static var ralcr_set_did_finish_load_handle = nme.Loader.load("ralcr_set_did_finish_load_handle", 1);
#end
}
#end