
class RCWebView {
	
	// Replicate the NMEWebView events
	public var didFinishLoad :RCSignal<String->Void>;
	public var didFinishWithError :RCSignal<String->Void>;
	
	#if nme
	var webView :NMEWebView;
	#end
	var x :Float;
	var y :Float;
	var w :Float;
	var h :Float;
	var url :String;
	
	/**
	 *  Pass all the details of the webview here
	 **/
	public function new (x:Float, y:Float, w:Float, h:Float, url:String) {
		
		didFinishLoad = new RCSignal<String->Void>();
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.url = url;
		
	}
	
	/**
	 *  call this method in order to instantiate the WebView itself
	 **/
	public function init () {
		#if nme
		webView = new NMEWebView (x, y, w, h, url);
		webView.didFinishLoad.add ( webViewDidFinishLoad );
		#end
	}
	
	function webViewDidFinishLoad (url:String) :Void {
		trace(didFinishLoad);
		didFinishLoad.dispatch ( url );
	}
    
	public function destroy() :Void {
		trace("destroy web view");trace(didFinishLoad);
		#if nme
		Fugu.safeDestroy ( webView );
		webView = null;
		#end
		if (didFinishLoad != null) {
			didFinishLoad.destroy();
			didFinishLoad = null;
		}
	}
}
