package;

import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import haxe.Json;
import FacebookRequest;// and Session
typedef JsonParseError = Dynamic;

class Facebook {

	inline public static var GRAPH_URL = 'https://graph.facebook.com';
	inline public static var API_URL = 'https://api.facebook.com';
	inline public static var AUTH_URL = 'https://graph.facebook.com/oauth/authorize';
	inline public static var VIDEO_URL = 'https://graph-video.facebook.com';
	
	    /**
	     * Used for AIR applications only.
	     * URL to re-direct to after a successfull login to Facebook.
	     *
	     * @see com.facebook.graph.FacebookDesktop#login
	     * @see http://developers.facebook.com/docs/authentication/desktop
	     *
	     */
	inline public static var LOGIN_SUCCESS_URL = 'http://www.facebook.com/connect/login_success.html';
	inline public static var LOGIN_SUCCESS_SECUREURL = 'https://www.facebook.com/connect/login_success.html';
	inline public static var LOGIN_FAIL_URL = 'http://www.facebook.com/connect/login_success.html?error_reason';
	inline public static var LOGIN_FAIL_SECUREURL = 'https://www.facebook.com/connect/login_success.html?error_reason';
	inline public static var LOGIN_URL = 'https://login.facebook.com/login.php';
	inline public static var AUTHORIZE_CANCEL = 'https://graph.facebook.com/oauth/authorize_cancel';
		

    static var _instance :Facebook;
	
    var jsCallbacks :Dynamic;
	var openUICalls :Hash<Dynamic>;
    var applicationId :String;
    var _initCallback :Dynamic;
    var _loginCallback :Dynamic;
    var _logoutCallback :Dynamic;
	
    var session :FacebookSession;
	var authResponse :FacebookAuthResponse;
	var oauth2 :Bool;
	var locale :String;
    var openRequests :Array<FacebookRequest>;
	var resultHash :Array<Dynamic>;
	var parserHash :Array<Dynamic>;
	
	
	
	
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
		trace("new");
		if (_instance != null) {
			throw ( 'Facebook is a singleton and cannot be instantiated.' );
		}
		jsCallbacks = {};
		openUICalls = new Hash<Dynamic>();
        openRequests = new Array<FacebookRequest>();
		resultHash = new Array<Dynamic>();
		parserHash = new Array<Dynamic>();

        _initCallback = _callback;
	  
		this.applicationId = applicationId;
		this.oauth2 = true;

        if (options == null)
		options = {};
        options.appId = applicationId;
		options.oauth = true;
		
		new FacebookJSBridge();
        
		ExternalInterface.addCallback('authResponseChange', handleAuthResponseChange);
		ExternalInterface.addCallback('logout', handleLogout);
		ExternalInterface.addCallback('uiResponse', handleUI);
        ExternalInterface.call ('FBAS.init', options);
		
		if (accessToken != null) {
			authResponse = new FacebookAuthResponse();
			authResponse.accessToken = accessToken;
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
     * @param display Type of login form to show to the user.
     * <ul>
     *	<li>touch Default; (Recommended)
     * 		Smartphone, full featured web browsers.
     * 	</li>
     *
     *	<li>wap;
     *		Older mobile web browsers,
     * 		shows a slimmer UI to the end user.
     * 	</li>
     * </ul>
	 * 
	 * @param extendedPermissions (Optional) Array of extended permissions
     * to ask the user for once they are logged in.
     *
     * @see http://developers.facebook.com/docs/guides/mobile/
     *
     */
/*    public static function mobileLogin (redirectUri:String, display:String='touch', extendedPermissions:Array<String>) {

      var data:URLVariables = new URLVariables();
      data.client_id = sharedFacebook().applicationId;
      data.redirect_uri = redirectUri;
      data.display = display;	  
	  if (extendedPermissions != null) { data.scope = extendedPermissions.join(","); }

      var req:URLRequest = new URLRequest ( AUTH_URL );
      req.method = URLRequestMethod.GET;
      req.data = data;

      flash.Lib.getURL (req, '_self');
    }*/
	
	/**
	 * Logs the user out after being logged in with mobileLogin().
	 *
	 * @param redirectUri After logout, Facebook will redirect
	 * the user back to this URL.
	 *
	 */
/*	public static function mobileLogout(redirectUri:String) {
		sharedFacebook().authResponse = null;
		
		var data = new URLVariables();
		data.confirm = 1;
		data.next = redirectUri;	
		
		var req = new URLRequest("http://m.facebook.com/logout.php");
		req.method = URLRequestMethod.GET;
		req.data = data;
		
		flash.Lib.getURL (req, '_self');				
	}*/
	

    
	/**
     * Asks if another page exists after this result object.
     *
     * @param data The result object.
     *
     * @see http://developers.facebook.com/docs/api#reading
     *
     */
	public static function hasNext (data:Dynamic) :Bool {
		var result:Dynamic = sharedFacebook().getRawResult(data);
		if(!result.paging){ return false; }
		return (result.paging.next != null);
	}
	
	public static function hasPrevious (data:Dynamic) :Bool {
		var result = sharedFacebook().getRawResult ( data );
		if (result.paging == null) return false;
		return (result.paging.previous != null);
	}
	
    /**
     * Shortcut method to post data to Facebook.
     * @see com.facebook.graph.net.Facebook#api()
     */
    public static function postData( method:String, _callback:Dynamic, params:Dynamic) {
		sharedFacebook().api (method, _callback, params, URLRequestMethod.POST);
    }
	
    /**
    * Asynchronous method to get the user's current session from Facebook.
    *
    * This method calls out to the underlying Javascript SDK
    * to check what the current user's login status is.
    * You can listen for a javscript event by using
    * Facebook.addJSEventListener('auth.sessionChange', callback)
    * @see http://developers.facebook.com/docs/reference/javascript/FBAS.getLoginStatus
    *
    */
    public function getLoginStatus() {
		ExternalInterface.call('FBAS.getLoginStatus');
    }

    /**
     * Shows the Facebook login window to the end user.
     *
     * @param callback The method to call when login is successful.
     * The handler must have the signature of callback(success:Dynamic, fail:Dynamic);
     * Success will be a FacebookSession if successful, or null if not.
     *
     * @param options Values to modify the behavior of the login window.
     * http://developers.facebook.com/docs/reference/javascript/FBAS.login
     */
	public function login (_callback:Dynamic, options:Dynamic) {
		 _loginCallback = _callback;
		 ExternalInterface.call ('FBAS.login', options);
    }
	public function logout (_callback:Dynamic) {
      _logoutCallback = _callback;
      ExternalInterface.call('FBAS.logout');
    }
	
	function getAuthResponse():FacebookAuthResponse {
		
		var result:String = ExternalInterface.call('FBAS.getAuthResponse');
		var authResponseObj:Dynamic;
		try {
			authResponseObj = Json.parse(result);
		} catch (e:Dynamic) {
			return null;
		}
		trace(authResponseObj);
		var a = FacebookAuthResponse.fromJson( authResponseObj );
		this.authResponse = a;
		
		return authResponse;
	}
	
    /**
     * Shows a Facebook sharing dialog.
     *
     * @param method The related method for this dialog
     *	(ex. stream.publish).
     * @param data Data to pass to the dialog, date will be Json encoded.
	 * @param callback (Optional) Method to call when complete
     * @param display (Optional) The type of dialog to show (iframe or popup).
     * @see http://developers.facebook.com/docs/reference/javascript/FBAS.ui
     *
     */
	 public function ui (method:String, data:Dynamic, _callback:Dynamic, ?display:String) {

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
		trace("handle logout");
	  authResponse = null;
      if (_logoutCallback != null) {
        _logoutCallback(true);
        _logoutCallback = null;
      }
    }
	function handleJSEvent(event:String, result:String) {
		trace(event);trace(result);
/*	      if (jsCallbacks[event] != null) {
	        var decodedResult:Object;
	        try {
	          decodedResult = JSON.decode(result);
	        } catch (e:JSONParseError) { }

	        for (var func:Object in jsCallbacks[event]) {
	          (func as Function)(decodedResult);
	          delete jsCallbacks[event][func];
	        }
	      }*/
	}
	function handleAuthResponseChange(result:String) {
		trace(result);
		var resultObj :Dynamic = null;
		var success = true;
		
		if (result != null) {
			try {
				resultObj = Json.parse(result);
			} catch (e:JsonParseError) {
				success = false;
			}
		} else {
			success = false;
		}
		
		if (success) {
			if (authResponse == null) {
				authResponse = FacebookAuthResponse.fromJson( resultObj );
			} else {
				authResponse = FacebookAuthResponse.fromJson( resultObj );
			}
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
     * On success, result will be the object data returned from Facebook.
     * On fail, result will be null and fail will contain information about the error.
     *
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
	public function api (method:String, _callback:Dynamic, ?params:Dynamic, requestMethod:String = 'GET') {
  		
		trace(method);
		trace(_callback);
		trace(params);
		trace(requestMethod);
		trace(accessToken());
		
		method = (method.indexOf('/') != 0) ?  '/'+method : method;
		
		if (accessToken() != null) {
			if (params == null)
				params = {};
			if (params.access_token == null)
				params.access_token = accessToken();
		}
		trace(params.access_token);
		
		var req = new FacebookRequest();
			req.functionToCall = _callback;
		openRequests.push ( req );
		
		if (locale != null) { params.locale = locale; }
		
        req.call (GRAPH_URL+method, requestMethod, handleRequestLoad, params);
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
	public function uploadVideo (method:String, _callback:Dynamic, params:Dynamic) {
			
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
	}
		
    /**
    * @private
    * 
    */
	function pagingCall (url:String, _callback:Dynamic) :FacebookRequest {
		
		var req = new FacebookRequest();
			req.functionToCall = _callback;
		openRequests.push ( req );
		
		req.callURL (handleRequestLoad, url, locale);
		
		return req;
	}
		
	/**
     * Returns a reference to the entire raw object
	 * Facebook returns (including paging, etc.).
     *
     * @param data The result object.
     *
     * @see http://developers.facebook.com/docs/api#reading
     *
     */
	 public function getRawResult (data:Dynamic) :Dynamic {
		return resultHash[data];
	}
	
	/**
     * Retrieves the next page that is associated with result object passed in.
     *
     * @param data The result object.
	 * @param callback Method that will be called when this request is complete
     * The handler must have the signature of callback(result:Dynamic, fail:Dynamic);
     * On success, result will be the object data returned from Facebook.
     * On fail, result will be null and fail will contain information about the error.
	 * 
	 * @see com.facebook.graph.net.FacebookDesktop#request()
     * @see http://developers.facebook.com/docs/api#reading
     *
     */
	public function nextPage (data:Dynamic, _callback:Dynamic) :FacebookRequest {
		
		var req :FacebookRequest = null;
		var rawObj:Dynamic = getRawResult(data);
		
		if (rawObj && rawObj.paging && rawObj.paging.next) {
			req = pagingCall (rawObj.paging.next, _callback);
		}
		else if (_callback != null) {
			_callback (null, 'no page');
		}
		return req;
	}
	public function previousPage(data:Dynamic, _callback:Dynamic) :FacebookRequest {
		
		var req:FacebookRequest = null;
		var rawObj:Dynamic = getRawResult(data);
		
		if (rawObj && rawObj.paging && rawObj.paging.previous) {
			req = pagingCall (rawObj.paging.previous, _callback);
		} else if(_callback != null) {
			_callback (null, 'no page');
		}
		return req;
	}
	
    function handleRequestLoad (target:FacebookRequest) {
        var resultCallback:Dynamic = target.functionToCall;
        if (resultCallback == null) {
			openRequests.remove ( target );
        }

		if (target.success) {
			var data:Dynamic = Reflect.field(target.data, "data") != null ? target.data.data : target.data;
			resultHash.push ( data );// = target.data;
			
			if (data.hasOwnProperty("error_code")) {
				resultCallback (null, data);
			} else {
/*				if (Std.is (parserHash[target], IResultParser)) {
					var p:IResultParser = cast (parserHash[target], IResultParser);
					data = p.parse(data);
					parserHash.remove ( target );
					//delete parserHash[target];
				}*/
				resultCallback (data, null);
			}
		} else {
			resultCallback (null, target.data);
		}

        //delete openRequests[target];
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

        var req = new FacebookRequest();
			req.functionToCall = _callback;
		openRequests.push ( req );
        
			
		//keeping a reference to parser using the queries string as key, need to re-key to FacebookRequest so it can reference parser when call completes
		//if (Std.is (parserHash[values["queries"]], IResultParser)) {
/*			var p:IResultParser = parserHash[values["queries"]] as IResultParser;
			parserHash[values["queries"]] = null;
			delete parserHash[values["queries"]];
			parserHash[req] = p;*/
				//}

        req.call (API_URL + '/method/' + methodName, requestMethod, handleRequestLoad, values);
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
/*	public function fqlMultiQuery (queries:FQLMultiQuery, callback:Dynamic, parser:IResultParser) {
			
		//defaults to FQLMultiQueryParser
		parserHash[queries.toString()] = parser != null ? parser : new FQLMultiQueryParser();
			
		callRestAPI ('fql.multiquery', callback, {queries:queries.toString()});
	}*/
	//
    /**
     * Deletes an object from Facebook.
     * The current user must have granted extended permission
     * to delete the corresponding object,
     * or an error will be returned.
     *
     * @param method The ID and connection of the object to delete.
     * For example, /POST_ID/like to remove a like from a message.
     *
     * @see http://developers.facebook.com/docs/api#deleting
     * @see com.facebook.graph.net.FacebookDesktop#api()
     *
     */
    public function deleteObject(method:String, _callback:Dynamic) {
        var params = {method:'delete'};
        api (method, _callback, params, URLRequestMethod.POST);
    }
    /**
     * Utility method to format a picture URL, in order to load an image from Facebook.
     *
     * @param id The ID you wish to load an image from.
     * @param type The size of image to display from Facebook
     * (square, small, or large).
     *
     * @see http://developers.facebook.com/docs/api#pictures
     *
     */
    public function getImageUrl(id:String, type:String = null):String {
        return GRAPH_URL + '/' + id + '/picture' + (type != null?'?type=' + type:'');
    }
}
