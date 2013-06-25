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
	
	static var ralcr_https_get :Dynamic;
	static var ralcr_https_post :Dynamic;
	static var ralcr_https_put :Dynamic;
	static var ralcr_https_cancel :Dynamic;
	static var ralcr_https_is_ready :Dynamic;
	static var ralcr_https_is_successful :Dynamic;
	static var ralcr_https_get_result :Dynamic;
	
	var request :Dynamic;
	var requestTimer :haxe.Timer;
	
	public function new () {
		trace("new NMEHttps");
		didFinishLoad = new RCSignal<String->Void>();
		didFinishWithError = new RCSignal<String->Void>();
		
		ralcr_https_get = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_get", "(Ljava/lang/String;Ljava/lang/String;)V");
		ralcr_https_post = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_post", "(Ljava/lang/String;Ljava/lang/String;)V");
		ralcr_https_put = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_put", "(Ljava/lang/String;Ljava/lang/String;)V");
		ralcr_https_cancel = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_cancel", "()V");
		ralcr_https_is_ready = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_is_ready", "()Z");
		ralcr_https_is_successful = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_is_successful", "()Z");
		ralcr_https_get_result = nme.JNI.createStaticMethod("NMEHttps", "ralcr_https_get_result", "()Ljava/lang/String;");
	}
	public function call (url:String, variables:Dynamic, ?method:String="GET") {
		
		var vars = "";
		for (f in Reflect.fields (variables))
			vars += f + "=" + Reflect.field (variables, f) + "&";
		
		trace("call: "+url+" method "+method);
		trace("vars: "+vars);
		
		switch (method) {
			case "POST" : nme.Lib.postUICallback ( function() { ralcr_https_post (url, vars);});
			case "PUT" : nme.Lib.postUICallback ( function() { ralcr_https_put (url, vars);});
			case "GET" : nme.Lib.postUICallback ( function() { ralcr_https_get (url, vars);});
/*			case "DELETE" : ralcr_https_delete ( url, vars );*/
			default : trace("Unknown method "+method);
		}
		
		requestTimer = haxe.Timer.delay ( checkRequestStatus, 200);
	}
	function checkRequestStatus () {
		trace("check status");
		if (requestTimer != null)
			requestTimer.stop();
		
		if (ralcr_https_is_ready()) {
			trace("ralcr_https_is_ready");
			if (ralcr_https_is_successful()) {
				trace("ralcr_https_is_successful");
				var str :String = ralcr_https_get_result();
				trace("ralcr_https_get_result "+str);
				didFinishLoadHandler ( str );
			}
			else didFinishWithErrorHandler ( ralcr_https_get_result() );
		}
		else {
			trace("ralcr_https_is_not_ready");
			requestTimer = haxe.Timer.delay (checkRequestStatus, 100);
		}
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
		
		trace("call: "+url);
		trace("vars: "+vars);
		
		switch (method) {
			case "POST" : ralcr_https_post ( url, vars );
			case "PUT" : ralcr_https_put ( url, vars );
			case "GET" : ralcr_https_get ( url, vars );
/*			case "DELETE" : ralcr_https_delete ( url, vars );*/
			default : trace("Unknown method "+method);
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
	static var ralcr_https_put = nme.Loader.load("ralcr_https_put", 2);
	static var ralcr_https_get = nme.Loader.load("ralcr_https_get", 2);
	static var ralcr_https_cancel = nme.Loader.load("ralcr_https_cancel", 0);
	static var ralcr_https_set_did_finish_load_handle = nme.Loader.load("ralcr_https_set_did_finish_load_handle", 1);
	static var ralcr_https_set_did_finish_with_error_handle = nme.Loader.load("ralcr_https_set_did_finish_with_error_handle", 1);
#end
	
	
	public function didFinishLoadHandler (e:String) {
		trace("didFinishLoadHandler ");
		if (didFinishLoad != null) didFinishLoad.dispatch ( e );
	}
	public function didFinishWithErrorHandler (e:String) {
		trace("didFinishWithErrorHandler "+e);
		if (didFinishWithError != null) didFinishWithError.dispatch ( e );
	}
	
}
#end
