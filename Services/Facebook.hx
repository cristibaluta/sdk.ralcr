
import flash.external.ExternalInterface;
import haxe.Json;
//import FacebookRequest;// and Session

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
	inline static var LOGOUT_URL = '"http://m.facebook.com/logout.php"';
	inline static var VIDEO_URL = 'https://graph-video.facebook.com';
	
    static var _instance :Facebook;
	
	var openUICalls :Hash<Dynamic>;
    var applicationId :String;
    var _initCallback :Dynamic;
    var _loginCallback :Dynamic;
    var _logoutCallback :Dynamic;
	
    var session :FacebookSession;
	var authResponse :FacebookAuthResponse;
	var oauth2 :Bool;
	var locale :String;
    var requests :Array<RCHttp>;
	var resultHash :Array<Dynamic>;
	
	
	
	
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
		return _instance;
	}
    public static function init (applicationId:String, _callback:Dynamic, ?options:Dynamic, ?accessToken:String) :Facebook {
    	if (_instance == null)
			_instance = new Facebook (applicationId, _callback, options, accessToken);
		return _instance;
    }
	
	
	
    public function new (applicationId:String, _callback:Dynamic, options:Dynamic, accessToken:String) {
		
		if (_instance != null) {
			throw ( 'Facebook is a singleton and cannot be instantiated.' );
		}
		openUICalls = new Hash<Dynamic>();
		resultHash = new Array<Dynamic>();
		requests = new Array<RCHttp>();

        _initCallback = _callback;
	  
		this.applicationId = applicationId;
		this.oauth2 = true;

        if (options == null)
			options = {};
        	options.appId = applicationId;
			options.oauth = true;
		
#if nme
	
#elseif (flash || js)
		new FacebookJSBridge();

		ExternalInterface.addCallback ('authResponseChange', handleAuthResponseChange);
		ExternalInterface.addCallback ('logout', handleLogout);
		ExternalInterface.addCallback ('uiResponse', handleUI);
        ExternalInterface.call ('FBAS.init', options);
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
		} else if (_initCallback != null) {
			_initCallback (authResponse, null);
			_initCallback = null;
		}
	}
	
    /**
     * Re-directs the user to a mobile-friendly login form.
     *
     * @param redirectUri After a successful login,
     * Facebook will redirect the user back to this URL,
     * where the underlying Javascript SDK will notify this swf
     * that a valid login has occurred.
     *
     * @param display Type of login form to show to the user: touch/wap
	 * 
	 * @param extendedPermissions (Optional) Array of extended permissions
     * to ask the user for once they are logged in.
     *
     * @see http://developers.facebook.com/docs/guides/mobile/
     *
     */
    public function mobileLogin (redirectUri:String, ?display:String='touch', ?extendedPermissions:Array<String>) {
		
		var data = {
			client_id : applicationId,
			redirect_uri : redirectUri,
			display : display,
			scope : null
		}
		if (extendedPermissions != null)
			data.scope = extendedPermissions.join(",");
		var req = new RCHttp();
			req.navigateToURL (AUTH_URL, data, "GET", "_self");
    }
	public function mobileLogout(redirectUri:String) {
		
		authResponse = null;
		
		var data = {
			confirm : 1,
			next : redirectUri
		}
		var req = new RCHttp();
			req.navigateToURL (LOGOUT_URL, data, "GET", "_self");			
	}
	

    
	/**
     * Asks if another page exists after this result object.
     *
     * @param data The result object.
     *
     * @see http://developers.facebook.com/docs/api#reading
     *
     */
	public function hasNext (data:Dynamic) :Bool {
		var result:Dynamic = getRawResult( data );
		return (result.paging != null && result.paging.next != null);
	}
	
	public function hasPrevious (data:Dynamic) :Bool {
		var result:Dynamic = getRawResult ( data );
		return (result.paging != null && result.paging.previous != null);
	}
	
    /**
    * Asynchronous method to get the user's current session from Facebook.
    */
    public function getLoginStatus () {
		ExternalInterface.call('FBAS.getLoginStatus');
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
	public function login (_callback:Dynamic, options:Dynamic) {
		_loginCallback = _callback;
#if nme
		
#elseif (flash || js)
		ExternalInterface.call ('FBAS.login', options);
#end
    }
	
	public function logout (_callback:Dynamic) {
		_logoutCallback = _callback;
#if nme
		
#elseif (flash || js)
		ExternalInterface.call('FBAS.logout');
#end
    }
	
	function getAuthResponse () :FacebookAuthResponse {
		
		var result:String = ExternalInterface.call('FBAS.getAuthResponse');
		var authResponseObj:Dynamic;
		try {
			authResponseObj = Json.parse ( result );
		} catch (e:Dynamic) {
			return null;
		}
		trace("authResponseObj: "+authResponseObj);
		this.authResponse = generateAuthResponse ( authResponseObj );
		
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
	
    /**
     * Shows a Facebook sharing dialog.
     */
	 public function ui (method:String, data:Dynamic, ?_callback:Dynamic, ?display:String) {

		 data.method = method;

/*	  if (_callback != null)
		  openUICalls[method] = _callback;*/
	  
		if (display != null)
			data.display = display;

		ExternalInterface.call('FBAS.ui', Json.stringify(data));
	}
	
	function handleUI( result:String, method:String ) {
		trace("handleUI "+result);trace(method);
		var decodedResult:Dynamic = (result != null) ? Json.parse(result) : null;
		var uiCallback:Dynamic = openUICalls.get(method);
		if (uiCallback != null)
			uiCallback ( decodedResult );
		openUICalls.remove ( method );
	}


	function handleLogout() {
		authResponse = null;
		if (_logoutCallback != null) {
			_logoutCallback ( true );
			_logoutCallback = null;
		}
	}
	function handleAuthResponseChange(result:String) {
		//trace(result);
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
			_initCallback (authResponse, null);
			_initCallback = null;
		}
		
		if (_loginCallback != null) {
			_loginCallback (authResponse, null);
			_loginCallback = null;
		}
	}
			
	function accessToken () :String {
		if ((oauth2 && authResponse != null) || session != null) {
			return oauth2 ? authResponse.accessToken : session.accessToken;
		} else {
			return null;
		}
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
	public function api (method:String, _callback:Dynamic, ?params:Dynamic, ?requestMethod:String='GET') {
  		
		if (method.indexOf('/') != 0) method = '/' + method;
		
		if (accessToken() != null) {
			if (params == null)
				params = {};
			if (params.access_token == null)
				params.access_token = accessToken();
		}
		if (locale != null)
			params.locale = locale;
		
		var req = new RCHttp();
			req.onComplete = callback (completeHandler, req, _callback);
			req.onError = callback (errorHandler, req, _callback);
			req.call (GRAPH_URL + method, params, requestMethod);
		requests.push ( req );
    }
	function completeHandler (req:RCHttp, _callback:Dynamic) {
		/*trace(req.result);*/
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
	function errorHandler (req:RCHttp, _callback:Dynamic) {
		trace(req.result);
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
	public function previousPage(data:Dynamic, _callback:Dynamic) :RCHttp {
		
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

		if (accessToken() != null) values.access_token = accessToken();
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
