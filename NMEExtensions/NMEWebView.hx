#if nme
class NMEWebView {
	
	public var didFinishLoad :RCSignal<String->Void>;
	
#if android
	
	var ralcr_show_web_view :Dynamic;
	var ralcr_hide_web_view :Dynamic;
	var ralcr_set_did_finish_load_handle :Dynamic;
	
	public function new (x:Float, y:Float, w:Float, h:Float, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		
		trace("DEST ========= " + url);
		var launch:Dynamic = nme.JNI.createStaticMethod("NMEWebView", "nmeCreate", "(Ljava/lang/String;)Landroid/view/View;");
		trace("LAUNCH ========= " + launch);
		if (launch!=null)
			nme.Lib.postUICallback( function() { launch(url); } );
			  
			  
/*		if (ralcr_set_did_finish_load_handle == null)
			ralcr_set_did_finish_load_handle = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		ralcr_set_did_finish_load_handle ( [didFinishLoadHandler] );
		
		if (ralcr_show_web_view == null)
			ralcr_show_web_view = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		ralcr_show_web_view ( [x, y, w, h, url] );*/
	}
	function didFinishLoadHandler (e:Dynamic) {
		didFinishLoad.dispatch ( Std.string(e) );
	}
    
	public function destroy() :Void {
/*		if (ralcr_hide_web_view == null)
			ralcr_hide_web_view = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		ralcr_hide_web_view();*/
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