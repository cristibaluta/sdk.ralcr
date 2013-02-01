#if flash
import flash.external.ExternalInterface;
#end
import haxe.Json;

typedef FacebookAuthResponse = {
	var uid :String;
	var expireDate :Date;
	var accessToken :String;
	var signedRequest :String;
}
typedef FacebookSession = {
	var uid :String;
	var user :Dynamic;
	var sessionKey :String;
	var expireDate :Date;
	var accessToken :String;
	var secret :String;
	var sig :String;
	var availablePermissions :Array<String>;
}


class Facebook {

	inline public static var GRAPH_URL = 'https://graph.facebook.com';
	inline static var API_URL = 'https://api.facebook.com';
	inline static var AUTH_URL = 'https://graph.facebook.com/oauth/authorize';
	inline static var AUTH_URL_CANCEL = 'https://graph.facebook.com/oauth/authorize_cancel';
	inline static var LOGIN_URL = 'https://login.facebook.com/login.php';
	inline static var LOGOUT_URL = 'http://m.facebook.com/logout.php';
	
	inline static var LOGIN_SUCCESS_URL = 'http://www.facebook.com/connect/login_success.html';
	inline static var LOGIN_SUCCESS_SECUREURL = 'https://www.facebook.com/connect/login_success.html';
	inline static var LOGIN_FAIL_URL = 'http://www.facebook.com/connect/login_success.html?error_reason';
	inline static var LOGIN_FAIL_SECUREURL = 'https://www.facebook.com/connect/login_success.html?error_reason';
	
    static var _instance :Facebook;
	
	var openUICalls :Hash<Dynamic>;
    var applicationId :String;
    var _initCallback :FacebookSession->Dynamic->Void;
    var _loginCallback :Dynamic->Dynamic->Void;
    var _logoutCallback :Bool->Void;
	
    var session :FacebookSession;
	var authResponse :FacebookAuthResponse;
	var oauth2 :Bool;
	var locale :String;
    var requests :Array<RCHttp>;
	var resultHash :Array<Dynamic>;
#if (nme && (ios || android))
	var webView :NMEWebView;
#end
	
	
    //Public API
    /**
     * Initializes this Facebook singleton with your Application ID using OAuth 2.0.
     * You must call this method first.
     *
     * @param applicationId The application ID you created at
     * http://www.facebook.com/developers/apps.php
     *
     * @param callback (Optional)
	 * Method to call when initialization is complete.
     * The handler must have the signature of callback(success:Dynamic, fail:Dynamic);
     * Success will be a FacebookSession if successful, or null if not.
     *
     * @param options (Optional)
     * Object of options used to instantiate the underling Javascript SDK
	 * 
	 * @param accessToken (Optional)
     * A valid Facebook access token. If you have a previously saved access token, you can pass it in here.
     *
     * @see http://developers.facebook.com/docs/reference/javascript/FBAS.init
     *
     */
	public static function sharedFacebook () :Facebook {
		if (_instance == null) throw ("Call Facebook.init before obtaining the instance");
		return _instance;
	}
    public static function init (applicationId:String, _callback:FacebookSession->Dynamic->Void, ?options:Dynamic) :Facebook {
    	if (_instance == null)
			_instance = new Facebook (applicationId, _callback, options);
		return _instance;
    }
	
	
	
    public function new (applicationId:String, _callback:FacebookSession->Dynamic->Void, options:Dynamic) {
		
		if (_instance != null) {
			throw ( 'Facebook is a singleton and cannot be instantiated.' );
		}
		openUICalls = new Hash<Dynamic>();
		resultHash = new Array<Dynamic>();
		requests = new Array<RCHttp>();

        _initCallback = _callback;
		var accessToken = RCUserDefaults.stringForKey ( "SocialFacebookAccessToken" );
		this.session = generateSession ( {access_token : accessToken} );
		this.applicationId = applicationId;
		this.oauth2 = true;

        if (options == null) {
			options = {};
		}
        	options.appId = applicationId;
			options.oauth = true;
		
#if nme
		
		//verifyAccessToken();
	
#elseif flash
		
		new FacebookJSBridge();
		
		ExternalInterface.addCallback ('authResponseChange', handleAuthResponseChange);
		ExternalInterface.addCallback ('logout', handleLogout);
		ExternalInterface.addCallback ('uiResponse', handleUI);
        ExternalInterface.call ('FBAS.init', options);
#elseif js
#end
		
		if (accessToken != null) {
			authResponse = {
				uid : null,
				expireDate : null,
				accessToken : accessToken,
				signedRequest : null
			}
		}
		if (options.status != false) {
			getLoginStatus();
		}
		else if (_initCallback != null) {
			_initCallback (session, null);
			_initCallback = null;
		}
	}
	
    
    /**
    * Asynchronous method to get the user's current session from Facebook.
    */
    public function getLoginStatus () :Void {
#if nme
		
#elseif flash
		ExternalInterface.call('FBAS.getLoginStatus');
#elseif js
#end
    }
	public function isConnected () :Bool {
		return getAccessToken() != null;
	}

    /**
     * Shows the Facebook login window to the end user.
     *
     * @param callback(success:Dynamic, fail:Dynamic);
     * Success will be a FacebookSession if successful, or null if not.
     *
     * @param options Values to modify the behavior of the login window.
     * http://developers.facebook.com/docs/reference/javascript/FBAS.login
     */
	public function login (_callback:Dynamic->Dynamic->Void, options:Dynamic) {
		
		_loginCallback = _callback;
		
#if (nme && (ios || android))
		
		var bundle_id = options.bundle_identifier;
		var data = {
			client_id : applicationId,
			redirect_uri : LOGIN_SUCCESS_URL,
			display : "touch",
			type : "user_agent",
			scope : options.scope
		}
		//https://graph.facebook.com/oauth/authorize?client_id=456093077787894&redirect_uri=http://www.facebook.com/connect/login_success.html&display=touch&response_type=token
		var params = 
			"?client_id="+data.client_id+
			"&redirect_uri="+data.redirect_uri+
			"&display="+data.display+
			"&type="+data.type+
			"&scope="+data.scope+
			"&response_type=token";
		webView = new NMEWebView (10, 10, 300, 460, AUTH_URL+params);
		webView.didFinishLoad.add ( webViewDidFinishLoad );
		
#elseif flash
		
		ExternalInterface.call ('FBAS.login', options);
#elseif js
#end
    }
	
#if (nme && (ios || android))
	// https://www.facebook.com/connect/login_success.html#access_token=AAADjPeJ0smYBACHWx0XcB4e2vgebexaAuSxvZCeMKYNa9cZBAmPrWzf72UxSC8ekBaW8mZAKWqeVQluAgoNFSRrZBn7gSaJUjMc6ROZB7vgZDZD&expires_in=5182363&code=AQAoNRwzYf801txpLLv-5rkJDB3aTyeHDjH5S5TCStB4NVvCOiAOHepZ3RvDWCXAPaRaLYyASwETMKFDE7I7Ykro3AAZvW5KcgD54Sjld_ELDfg447uWPNrt3DkX3CHZ34XKpaAAYNv4l9duGRXTCwzqsPH1FBF1D1bVnvrZ2aH0V3Cqs0x_VK1AIBwuCIM3yC4_2XziN8T0_IHkbNfi4JIl

	function webViewDidFinishLoad (url:String) :Void {
		trace(url);
		//AppController.debugger.log(url);
		if (url.indexOf(LOGIN_FAIL_URL) == 0 || url.indexOf(LOGIN_FAIL_SECUREURL) == 0) {
			//webView.destroy();
			//webView = null;
			AppController.debugger.log("FAIL");
		}
		else if (url.indexOf(LOGIN_SUCCESS_URL) == 0 || url.indexOf(LOGIN_SUCCESS_SECUREURL) == 0) {
			AppController.debugger.log("SUCCESS");
			webView.destroy();
			webView = null;
			
			var comps :Array<String> = url.split(LOGIN_SUCCESS_SECUREURL+"#").pop().split("&");
			var access_token = "";
			var expires_in = "";
			var code = "";
			for (s in comps) {
				var a = s.split("=");
				switch (a[0]) {
					case "access_token" : access_token = a[1];
					case "expires_in" : expires_in = a[1];
					case "code" : code = a[1];
				}
			}
/*			AppController.debugger.log(access_token);
			AppController.debugger.log(expires_in);
			AppController.debugger.log("");
			AppController.debugger.log(Std.string(_loginCallback));*/
			session = generateSession ( {access_token : access_token} );
/*			AppController.debugger.log(Std.string(session));*/
			_loginCallback ({accessToken : access_token}, null);
/*			AppController.debugger.log("login called. did it get it?");*/
		}
	}
#end
	
	
	// if a user logs out explicitly, we delete any cached token information, and next
	// time they run the applicaiton they will be presented with log in UX again; most
	// users will simply close the app or switch away, without logging out; this will
	// cause the implicit cached-token login to occur on next launch of the application
	public function logout (_callback:Bool->Void) {
		
		_logoutCallback = _callback;
		
#if nme
		
/*		var data = {
			confirm : 1,
			next : redirectUri,
			access_token : ""
		}
		var req = new RCHttp();
		req.navigateToURL (LOGOUT_URL, data, "GET", "_self");*/
		
		session = null;
		authResponse = null;
		
#elseif flash
	
		ExternalInterface.call('FBAS.logout');
#elseif js
#end
    }
    
	
	function getAuthResponse () :FacebookAuthResponse {

#if nme
		
		
#elseif flash
		
		var result:String = ExternalInterface.call('FBAS.getAuthResponse');
		var authResponseObj:Dynamic;
		try {
			authResponseObj = Json.parse ( result );
		} catch (e:Dynamic) {
			return null;
		}
		trace("authResponseObj: "+authResponseObj);
		this.authResponse = generateAuthResponse ( authResponseObj );
		
#elseif js
#end		
		return authResponse;
	}
	function generateAuthResponse (json:Dynamic) :FacebookAuthResponse {
		return {
			uid : json.userID,
			expireDate : Date.fromTime ( Date.now().getTime() + json.expiresIn * 1000),
			accessToken : json.access_token != null ? json.access_token : json.accessToken,
			signedRequest : json.signedRequest
		}
	}
	function generateSession (json:Dynamic) :FacebookSession {
		
		if (json == null)
			json = {};
		var expireTimestamp = Date.now().getTime() + (json!=null?Std.int(json.expires):0);
		var expireDate = Date.fromTime ( expireTimestamp );
        return {
 			uid : json.uid,
			user : null,
			sessionKey : json.session_key,
			expireDate : expireDate,
			accessToken : json.access_token,
			secret : json.secret,
 			sig : json.sig,
			availablePermissions : []
        }
	}
	function handleLogout() {
		authResponse = null;
		if (_logoutCallback != null) {
			_logoutCallback ( true );
			_logoutCallback = null;
		}
	}
	function handleAuthResponseChange(result:String) {
		trace(result);
		var resultObj :Dynamic = null;
		var success = true;
		
		if (result != null) {
			try {
				resultObj = Json.parse(result);
			} catch (e:Dynamic) {
				success = false;
			}
		} else {
			success = false;
		}
		
		if (success) {
			authResponse = generateAuthResponse ( resultObj );
/*			if (authResponse == null) {
				authResponse = FacebookAuthResponse.fromJson( resultObj );
			} else {
				authResponse = FacebookAuthResponse.fromJson( resultObj );
			}*/
		}
		
		if (_initCallback != null) {
			_initCallback (session, null);
			_initCallback = null;
		}
		
		if (_loginCallback != null) {
			_loginCallback (session, null);
			_loginCallback = null;
		}
	}
	
	function getAccessToken () :String {
		if (oauth2 && authResponse != null) {
			return authResponse.accessToken;
		}
		else if (session != null) {
			return session.accessToken;
		}
		return null;
	}
	
	
	
    /**
     * Shows a Facebook sharing dialog.
     */
	 public function ui (method:String, data:Dynamic, ?_callback:Dynamic, ?display:String) {
		 
		data.method = method;

/*	  if (_callback != null)
		  openUICalls[method] = _callback;*/
	  
		if (display != null)
			data.display = display;
#if nme
#elseif flash
		ExternalInterface.call ('FBAS.ui', Json.stringify(data));
#elseif js
#end
	}
	
	function handleUI( result:String, method:String ) {
		trace("handleUI "+result);trace(method);
		var decodedResult:Dynamic = (result != null) ? Json.parse(result) : null;
		var uiCallback:Dynamic = openUICalls.get(method);
		if (uiCallback != null)
			uiCallback ( decodedResult );
		openUICalls.remove ( method );
	}


	
    /**
     * Makes a new request on the Facebook Graph API.
     *
     * @param method The method to call on the Graph API.
     * For example, to load the user's current friends, pass: /me/friends
     *
     * @param calllback Method that will be called when this request is complete
     * The handler must have the signature of callback(result:Dynamic, fail:Dynamic);

     * @param params Any parameters to pass to Facebook.
     * For example, you can pass {file:myPhoto, message:'Some message'};
     * this will upload a photo to Facebook.
     * @param requestMethod
     * The URLRequestMethod used to send values to Facebook.
     * The graph API follows correct Request method conventions.
     * GET will return data from Facebook.
     * POST will send data to Facebook.
     * DELETE will delete an object from Facebook.
     *
     * @see flash.net.URLRequestMethod
     * @see http://developers.facebook.com/docs/api
     *
     */
	public function api (method:String, _callback:Dynamic->Dynamic->Void, ?params:Dynamic, ?requestMethod:String='GET') {
  		
		if (method.indexOf('/') != 0) method = '/' + method;
		
		if (getAccessToken() != null) {
			if (params == null)
				params = {};
			if (params.access_token == null)
				params.access_token = getAccessToken();
		}
		if (locale != null)
			params.locale = locale;
		
		var req = new RCHttp();
			req.onComplete = callback (completeHandler, req, _callback);
			req.onError = callback (errorHandler, req, _callback);
			req.call (GRAPH_URL + method, params, requestMethod);
		requests.push ( req );
    }
	function completeHandler (req:RCHttp, _callback:Dynamic->Dynamic->Void) {
		//trace(req.result);
		//new NMEAlertView("Facebook ok", req.result);
		var parsedData :Dynamic = null;
		try {
			parsedData = Json.parse ( req.result );
		} catch (e:Dynamic) {
			parsedData = req.result;
			errorHandler (req, _callback);
			return;
		}
		
		_callback (parsedData.data, null);
	}
	function errorHandler (req:RCHttp, _callback:Dynamic->Dynamic->Void) {
		trace(req.result);
		#if nme new NMEAlertView("Facebook err", req.result); #end
		var parsedData = Json.parse ( req.result );
		_callback (null, parsedData);
	}
	/**
	 * Shortcut method to upload video to Facebook.
	 * 
	 * @param method The method to call on the Graph API.
	 * For example, to upload a video, pass in /me/videos. To upload to an friend's wall, pass in /USER_ID/videos.
	 * @param callback Method that will be called when this request is complete
	 * The handler must have the signature of callback(result:Dynamic, fail:Dynamic);
	 * On success, result will be the object data returned from Facebook.
	 * On fail, result will be null and fail will contain information about the error.
	 * @param params An object containing the title, description, fileName (including extension), and video (FileReference or ByteArray) 
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/video/
	 * 
	 */
/*	public function uploadVideo (method:String, _callback:Dynamic, params:Dynamic) {
			
		method = (method.indexOf('/') != 0) ?  '/'+method : method;
			
		if (accessToken() != null){
			if (params == null) params = {};
			if (params.access_token == null) params.access_token = accessToken();
		}
			
		var req = new FacebookRequest();
			req.functionToCall = _callback;
		openRequests.push ( req );
		
		if (locale != null) params.locale = locale;
		
		req.call (VIDEO_URL + method, 'POST', handleRequestLoad, params); 
	}*/
	
	
	
	public function getRawResult (data:Dynamic) :Dynamic {
		return resultHash[data];
	}
    
	/**
     * Asks if another page exists after this result object.
     *
     * @param data The result object.
     * @see http://developers.facebook.com/docs/api#reading
     *
     */
	public function hasNext (data:Dynamic) :Bool {
		var result:Dynamic = getRawResult ( data );
		return (result.paging != null && result.paging.next != null);
	}
	
	public function hasPrevious (data:Dynamic) :Bool {
		var result:Dynamic = getRawResult ( data );
		return (result.paging != null && result.paging.previous != null);
	}
	
	/**
     * Retrieves the next page that is associated with result object passed in.
     *
     * @param data The result object.
	 * @param callback Method that will be called when this request is complete
     * The handler must have the signature of callback(result:Dynamic, fail:Dynamic);
     */
	public function nextPage (data:Dynamic, _callback:Dynamic) :RCHttp {
		
		var req :RCHttp = null;
		var rawObj :Dynamic = getRawResult(data);
		
		if (rawObj && rawObj.paging && rawObj.paging.next) {
			req = pagingCall (rawObj.paging.next, _callback);
		}
		else if (_callback != null) {
			_callback (null, 'no page');
		}
		return req;
	}
	public function previousPage (data:Dynamic, _callback:Dynamic) :RCHttp {
		
		var req :RCHttp = null;
		var rawObj :Dynamic = getRawResult(data);
		
		if (rawObj && rawObj.paging && rawObj.paging.previous) {
			req = pagingCall (rawObj.paging.previous, _callback);
		} else if (_callback != null) {
			_callback (null, 'no page');
		}
		return req;
	}
	function pagingCall (url:String, _callback:Dynamic) :RCHttp {
		
/*		var req = new FacebookRequest();
			req.functionToCall = _callback;
		openRequests.push ( req );
		
		req.callURL (handleRequestLoad, url, locale);*/
		var params = {locale : locale};
		var req = new RCHttp();
			req.onComplete = callback (handleRequestLoad, req, _callback, true);
			req.onError = callback (handleRequestLoad, req, _callback, false);
			req.call (url, params, "GET");
		requests.push ( req );
		
		return req;
	}
	
    function handleRequestLoad (req:RCHttp, _callback:Dynamic, success:Bool) {
		
		var json :Dynamic = Json.parse ( req.result );
		
		if (success) {
			var data :Dynamic = Reflect.field (json, "data") != null ? json.data : json;
			resultHash.push ( data );
			
			if (Reflect.field (data, "error_code") != null) {
				_callback (null, data);
			} else {
				_callback (data, null);
			}
		} else {
			_callback (null, json);
		}
		
		requests.remove ( req );
    }
    /**
     * Used to make old style RESTful API calls on Facebook.
     * Normally, you would use the Graph API to request data.
     * This method is here in case you need to use an old method,
     * such as FQL.
     *
     * @param methodName Name of the method to call on api.facebook.com
     * (ex, fql.query).
     * @param values Any values to pass to this request.
     * @param requestMethod URLRequestMethod used to send data to Facebook.
     *
     */
	function callRestAPI (methodName:String, _callback:Dynamic, ?values:Dynamic, requestMethod:String = 'GET') {

		if (values == null)
			values = {};
			values.format = 'json';

		if (getAccessToken() != null) values.access_token = getAccessToken();
		if (locale != null) values.locale = locale;

/*        var req = new FacebookRequest();
			req.functionToCall = _callback;*/
		//openRequests.push ( req );
        
			
		//keeping a reference to parser using the queries string as key, need to re-key to FacebookRequest so it can reference parser when call completes
		//if (Std.is (parserHash[values["queries"]], IResultParser)) {
/*			var p:IResultParser = parserHash[values["queries"]] as IResultParser;
			parserHash[values["queries"]] = null;
			delete parserHash[values["queries"]];
			parserHash[req] = p;*/
		//}

        //req.call (API_URL + '/method/' + methodName, requestMethod, handleRequestLoad, values);
    }

	/**
	 * Executes an FQL query on api.facebook.com.
	 * 
	 * @param query The FQL query string to execute.
	 * @param values Replaces string values in the in the query. 
	 * ie. Replaces {digit} or {id} with the corresponding key-value in the values object 
	 * @see http://developers.facebook.com/docs/reference/fql/
     * @see com.facebook.graph.net.Facebook#callRestAPI()
	 * 
	 */	
	public function fqlQuery (query:String, _callback:Dynamic, values:Dynamic) {
			
		for (n in Reflect.fields(values)) {
			//query = query.replace ( new RegExp('\\{'+n+'\\}', 'g'), Reflect.field(values, n));
		}
		
		callRestAPI ('fql.query', _callback, {query:query});
	}
	
    /**
     * Deletes an object from Facebook.
     * The current user must have granted extended permission.
     *
     * @param method The ID and connection of the object to delete.
     * For example, /POST_ID/like to remove a like from a message.
     *
     * @see http://developers.facebook.com/docs/api#deleting
     * @see com.facebook.graph.net.FacebookDesktop#api()
     *
     */
    public function deleteObject (method:String, _callback:Dynamic) {
        var params = {method:'delete'};
        api (method, _callback, params, "POST");
	}
}
