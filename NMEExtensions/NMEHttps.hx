/**
*  Feb 1 2013
*  In NME POST requests are not working
*  In CPP haxe.Http https requests are not working
*  This extension fix them all for ios
*  Although is called Https you can make Http calls as well
*/

#if nme
class NMEHttps {
	
	public var didFinishLoad :RCSignal<String->Void>;
	public var didFinishWithError :RCSignal<String->Void>;
	
#if android
	
	public function new () {
		
	}
	public function call (url:String, variables:Dynamic, ?method:String="GET") {
		
	}
	public function destroy() :Void {
		
	}
    
#elseif ios
	
	public function new () {
		
		didFinishLoad = new RCSignal<String->Void>();
		didFinishWithError = new RCSignal<String->Void>();
		
		ralcr_https_set_did_finish_load_handle ( didFinishLoadHandler );
		ralcr_https_set_did_finish_with_error_handle ( didFinishWithErrorHandler );
	}
	
	public function call (url:String, variables:Dynamic, ?method:String="GET") {
		
		var vars = "";
		for (f in Reflect.fields (variables))
			vars += f + "=" + Reflect.field (variables, f) + "&";
		
		if (method == "POST") {
			ralcr_https_post ( url, vars );
		}
		else if (method == "GET") {
			ralcr_https_get ( url, vars );
		}
		else if (method == "DELETE") {
			//ralcr_https_delete ( url, vars );
		}
	}
	function didFinishLoadHandler (e:String) {
		didFinishLoad.dispatch ( e );
	}
	function didFinishWithErrorHandler (e:String) {
		didFinishWithError.dispatch ( e );
	}
    
	public function destroy() :Void {
		ralcr_https_cancel();
		didFinishLoad.destroy();
		didFinishLoad = null;
		didFinishWithError.destroy();
		didFinishWithError = null;
	}
    
	static var ralcr_https_post = nme.Loader.load("ralcr_https_post", 2);
	static var ralcr_https_get = nme.Loader.load("ralcr_https_get", 2);
	static var ralcr_https_cancel = nme.Loader.load("ralcr_https_cancel", 0);
	static var ralcr_https_set_did_finish_load_handle = nme.Loader.load("ralcr_https_set_did_finish_load_handle", 1);
	static var ralcr_https_set_did_finish_with_error_handle = nme.Loader.load("ralcr_https_set_did_finish_with_error_handle", 1);
#end
}
#end