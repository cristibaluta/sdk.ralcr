
class RCWebView {
	
	// Implement the NMEWebView events
	public var didFinishLoad :RCSignal<String->Void>;
	public var didFinishWithError :RCSignal<String->Void>;
	
	#if objc
	var webView :ios.ui.UIWebView;
	#elseif nme
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
		#if openfl
		webView = new NMEWebView (x, y, w, h, url);
		webView.didFinishLoad.add ( webViewDidFinishLoad );
		#end
	}
	
	function webViewDidFinishLoad (url:String) :Void {
		if (didFinishLoad != null)
			didFinishLoad.dispatch ( url );
	}
    
	public function destroy() :Void {
		#if openfl
		Fugu.safeDestroy ( webView );
		webView = null;
		#end
		if (didFinishLoad != null) {
			didFinishLoad.destroy();
			didFinishLoad = null;
		}
	}
}
