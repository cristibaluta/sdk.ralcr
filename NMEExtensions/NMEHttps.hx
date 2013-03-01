/**
*  Feb 1 2013
*  In NME POST requests are not working
*  In CPP haxe.Http https requests are not working
*  This extension fix them all for ios and android
*  Although is called Https you can make Http calls as well
*/

#if nme
class NMEHttps {
	
	public var didFinishLoad :RCSignal<String->Void>;
	public var didFinishWithError :RCSignal<String->Void>;
	
#if android
	
	var request :Dynamic;
	var requestTimer :haxe.Timer;
	
	public function new () {
		
		didFinishLoad = new RCSignal<String->Void>();
		didFinishWithError = new RCSignal<String->Void>();
		
		// lazy init to avoid crash at startup
		//native_addHeader = nme.JNI.createMemberMethod("HttpLoader", "setHeader", "(Ljava/lang/String;Ljava/lang/String;)V");
		//native_setUserAgent = nme.JNI.createMemberMethod("HttpLoader", "setUserAgent", "(Ljava/lang/String;)V");
			
		ralcr_https_get = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_get", "(Ljava/lang/String;Ljava/lang/String;)V");
		ralcr_https_post = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_post", "(Ljava/lang/String;Ljava/lang/String;)V");
		ralcr_https_cancel = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_cancel", "()V");
		ralcr_https_set_delegate = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_set_delegate", "(Lorg/haxe/nme/HaxeObject;)V");
		ralcr_https_is_ready = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_is_ready", "()Z");
		ralcr_https_is_successful = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_is_successful", "()Z");
		ralcr_https_get_result = nme.JNI.createStaticMethod("HttpLoader", "ralcr_https_get_result", "()Ljava/lang/String;");
		
		ralcr_https_set_delegate ( this );
	}
	public function call (url:String, variables:Dynamic, ?method:String="GET") {
		
		if (method == "POST") {
			var contentType = "application/octet-stream";
			var vars = haxe.Json.stringify ( variables );
			contentType = "application/json";
			
			//native_addHeader (request, "Content-Type", "application/json");
			/*
			var str = haxe.Utf8.encode( Std.string ( data));
			*/
			nme.Lib.postUICallback ( function() { ralcr_https_post (url, vars);});
		}
		else if (method == "GET") {
			var vars = "";
			for (f in Reflect.fields (variables))
				vars += f + "=" + Reflect.field (variables, f) + "&";
			
			nme.Lib.postUICallback ( function() { ralcr_https_get (url, vars);});
		}
		else if (method == "DELETE") {
			//ralcr_https_delete ( url, vars );
		}
		
		checkRequestStatus();
	}
	function checkRequestStatus () {
		
		if (requestTimer != null)
			requestTimer.stop();
		
		if (ralcr_https_is_ready()) {
			if (ralcr_https_is_successful()) didFinishLoadHandler ( ralcr_https_get_result() );
			else didFinishWithErrorHandler ( ralcr_https_get_result() );
		}
		else requestTimer = haxe.Timer.delay (checkRequestStatus, 100);
	}
	// Delegate methods
	//public function httpStatus(statusCode:Int):Void { trace(statusCode); }
	
	public function destroy() :Void {
		trace("destroy");
		if (requestTimer != null)
			requestTimer.stop();
			requestTimer = null;
			
		nme.Lib.postUICallback ( function() { ralcr_https_cancel();});
		
		didFinishLoad.destroy();
		didFinishLoad = null;
		didFinishWithError.destroy();
		didFinishWithError = null;
	}
	
	static var native_new :Dynamic;
	static var native_addHeader :Dynamic;
	static var native_setUserAgent :Dynamic;
	
	static var ralcr_https_get :Dynamic;
	static var ralcr_https_post :Dynamic;
	static var ralcr_https_cancel :Dynamic;
	static var ralcr_https_set_delegate :Dynamic;
	static var ralcr_https_is_ready :Dynamic;
	static var ralcr_https_is_successful :Dynamic;
	static var ralcr_https_get_result :Dynamic;
    
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
		
		trace("call: "+url+"?"+vars);
		
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
		trace("destroy");
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
	
	
	public function didFinishLoadHandler (e:String) {
		trace("didFinishLoadHandler "+e);
		if (didFinishLoad != null) didFinishLoad.dispatch ( e );
	}
	public function didFinishWithErrorHandler (e:String) {
		trace("didFinishWithErrorHandler "+e);
		if (didFinishWithError != null) didFinishWithError.dispatch ( e );
	}
	
}
#end
