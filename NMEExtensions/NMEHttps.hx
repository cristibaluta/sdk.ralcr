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
	
	var request :Dynamic;
	
	public function new () {
		
		didFinishLoad = new RCSignal<String->Void>();
		didFinishWithError = new RCSignal<String->Void>();
		
		// lazy init to avoid crash at startup
		if (native_new == null) {
			native_new = nme.JNI.createStaticMethod("mloader/nme/extension/android/HttpLoader", "<init>", "(Ljava/lang/String;)V");
			native_addHeader = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "addHeader", "(Ljava/lang/String;Ljava/lang/String;)V");
			native_setUserAgent = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "setUserAgent", "(Ljava/lang/String;)V");
			ralcr_https_get = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "get", "(Lorg/haxe/nme/HaxeObject;)V");
			ralcr_https_post = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "post", "(Ljava/lang/String;Lorg/haxe/nme/HaxeObject;)V");
			ralcr_https_cancel = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "cancel", "()V");
		}
	}
	public function call (url:String, variables:Dynamic, ?method:String="GET") {
		request = native_new ( haxe.Utf8.encode ( url));
		
		var vars = "";
		for (f in Reflect.fields (variables))
			vars += f + "=" + Reflect.field (variables, f) + "&";
		//trace(vars);
		
		if (method == "POST") {
			// default content type
			var contentType = "application/octet-stream";
			// stringify and send as application/json
			var data = haxe.Json.stringify ( variables );
			contentType = "application/json";
			
			native_addHeader (request, "Content-Type", "application/json");
			
			var str = haxe.Utf8.encode(Std.string(data));
			ralcr_https_post ( request, str, this);
			
			//ralcr_https_post ( url, vars );
		}
		else if (method == "GET") {
			//ralcr_https_get ( url, vars );
			ralcr_https_get ( request, this );
		}
		else if (method == "DELETE") {
			//ralcr_https_delete ( url, vars );
		}
	}
	public function destroy() :Void {
		ralcr_https_cancel ( request );
		didFinishLoad.destroy();
		didFinishLoad = null;
		didFinishWithError.destroy();
		didFinishWithError = null;
	}
	
	static var native_new:Dynamic;
	static var native_addHeader:Dynamic;
	static var native_setUserAgent:Dynamic;
	static var ralcr_https_get :Dynamic;
	static var ralcr_https_post :Dynamic;
	static var ralcr_https_cancel :Dynamic;
    
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
		trace(vars);
		
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
	
	
	function didFinishLoadHandler (e:String) {
		didFinishLoad.dispatch ( e );
	}
	function didFinishWithErrorHandler (e:String) {
		didFinishWithError.dispatch ( e );
	}
	
}
#end
