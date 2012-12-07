
package;

import com.facebook.graph.core.AbstractFacebook;
import com.facebook.graph.data.Batch;
import com.facebook.graph.data.FQLMultiQuery;
import com.facebook.graph.data.FacebookSession;
import com.facebook.graph.net.FacebookRequest;
import com.facebook.graph.utils.FacebookDataUtils;
import com.facebook.graph.utils.IResultParser;
import com.facebook.graph.windows.MobileLoginWindow;
	
import flash.display.Stage;
import flash.geom.Rectangle;
import flash.media.StageWebView;
import flash.net.SharedDynamic;
import flash.net.URLRequestMethod;

public class FacebookMobile extends Facebook {
		
	inline public static var LOGIN_SUCCESS_URL = 'http://www.facebook.com/connect/login_success.html';
	inline public static var LOGIN_SUCCESS_SECUREURL = 'https://www.facebook.com/connect/login_success.html';
	inline public static var LOGIN_FAIL_URL = 'http://www.facebook.com/connect/login_success.html?error_reason';
	inline public static var LOGIN_FAIL_SECUREURL = 'https://www.facebook.com/connect/login_success.html?error_reason';
	inline public static var LOGIN_URL = 'https://login.facebook.com/login.php';
	inline public static var AUTHORIZE_CANCEL = 'https://graph.facebook.com/oauth/authorize_cancel';
		
	inline static var SO_NAME = 'com.facebook.graph.FacebookMobile';
		
	static var _instance:FacebookMobile;
	static var _canInit:Bool = false;
	var _manageSession:Bool = true;
	var loginWindow:MobileLoginWindow;
	var applicationId:String;
	var loginCallback:Dynamic;
	var logoutCallback:Dynamic;
	var initCallback:Dynamic;

	var webView :StageWebView;
	var stageRef :Stage;
		

	public static function init (applicationId:String, callback:Dynamic, accessToken:String = null) {

		Facebook.sharedFacebook().init(applicationId, callback, accessToken);
	}
		
	public static function set locale(value:String) {
		Facebook.sharedFacebook().locale = value;
	}
		
	/**
	 * Opens a new login window so the current user can log in to Facebook.
	 *
	 * @param callback The method to call when login is successful.
	 * The handler must have the signature of callback(success:Dynamic, fail:Dynamic);
	 * Success will be a FacebookSession if successful, or null if not.
	 * 
	 * @param stageRef A reference to the stage
	 *
	 * @param extendedPermissions (Optional) Array of extended permissions
	 * to ask the user for once they are logged in.
	 * 
	 * @param webView (Optional) The instance of StageWebView to use for the login window
	 * 
	 * @param display (Optional) The display type for the OAuth dialog. "wap" for older mobile browsers,
	 * "touch" for smartphones. The Default is "touch".
	 *
	 * For the most current list of extended permissions,
	 * visit http://developers.facebook.com/docs/authentication/permissions
	 *
	 * @see http://developers.facebook.com/docs/authentication
	 * @see http://developers.facebook.com/docs/authentication/permissions
	 * @see http://developers.facebook.com/docs/guides/mobile/
	 *
	 */
	public static function login (callback:Dynamic, stageRef:Stage, extendedPermissions:Array, webView:StageWebView = null, display:String = 'touch') {
		Facebook.sharedFacebook().login (callback, stageRef, extendedPermissions, webView, display);
	}

	/**
	 * Setting to true (default), this class will manage
	 * the session and access token internally.
	 * Setting to false, no session management will occur
	 * and the end developer must save the session manually.
	 *
	 */
	public static function set manageSession(value:Bool) {
		Facebook.sharedFacebook().manageSession = value;
	}

	/**
	 * Clears a user's local session.
	 * This method is synchronous, since
	 * its method does not log the user out of Facebook,
	 * only the current application.
	 * 
	 * @param callback (Optional) Method to call when logout is done.
	 * 
	 * @param appOrigin (Optional) The site url specified for your app. Required for clearing html window cookie.
	 *
	 */
	public static function logout(callBack:Dynamic=null, appOrigin:String=null) {
		Facebook.sharedFacebook().logout(callBack, appOrigin);
	}

	/**
	 * Opens a new window that asks the current user for
	 * extended permissions.
	 * 
	 * @param callback The method to call after request for permissions.
	 * 
	 * @param webView The instance of StageWebView to use.
	 * 
	 * @param extendedPermissions Array of extended permissions to ask the user for once they are logged in.
	 * 
	 *
	 * @see com.facebook.graph.net.FacebookMobile#login()
	 * @see http://developers.facebook.com/docs/authentication/permissions
	 *
	 */
	public static function requestExtendedPermissions (callback:Dynamic, webView:StageWebView, ...extendedPermissions:Array) {
		Facebook.sharedFacebook().requestExtendedPermissions(callback, webView, extendedPermissions);
	}

	/**
	 * Makes a new request on the Facebook Graph API.
	 *
	 * @param method The method to call on the Graph API.
	 * For example, to load the user's current friends, pass in /me/friends
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
	public static function api(method:String,
							   callback:Dynamic,
							   params:* = null,
							   requestMethod:String = 'GET'
	) {

		Facebook.sharedFacebook().api(method,
			callback,
			params,
			requestMethod
		);
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
	public static function getRawResult(data:Dynamic):Dynamic {			
		return Facebook.sharedFacebook().getRawResult(data);
	}
		
	/**
	 * Asks if another page exists
	 * after this result object.
	 *
	 * @param data The result object.
	 *
	 * @see http://developers.facebook.com/docs/api#reading
	 *
	 */
	public static function hasNext(data:Dynamic):Bool {
		var result:Dynamic = Facebook.sharedFacebook().getRawResult(data);
		if(!result.paging){ return false; }
		return (result.paging.next != null);
	}
		
	/**
	 * Asks if a page exists
	 * before this result object.
	 *
	 * @param data The result object.
	 *
	 * @see http://developers.facebook.com/docs/api#reading
	 *
	 */
	public static function hasPrevious(data:Dynamic):Bool {
		var result:Dynamic = Facebook.sharedFacebook().getRawResult(data);
		if(!result.paging){ return false; }
		return (result.paging.previous != null);
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
	public static function nextPage(data:Dynamic, callback:Dynamic):FacebookRequest {
		return Facebook.sharedFacebook().nextPage(data, callback);
	}
		
	/**
	 * Retrieves the previous page that is associated with result object passed in.
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
	public static function previousPage(data:Dynamic, callback:Dynamic):FacebookRequest {
		return Facebook.sharedFacebook().previousPage(data, callback);
	}

	/**
	 * Shortcut method to post data to Facebook.
	 * Alternatively, you can call FacebookMobile.request
	 * and use POST for requestMethod.
	 *
	 * @see com.facebook.graph.net.FacebookMobile#request()
	 */
	public static function postData(method:String,
									callback:Dynamic,
									params:* = null
	) {

		api(method, callback, params, URLRequestMethod.POST);
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
	public static function uploadVideo(method:String, callback:Dynamic = null, params:* = null) {
		Facebook.sharedFacebook().uploadVideo(method, callback, params);
	}

	/**
	 * Deletes an object from Facebook.
	 * The current user must have granted extended permission
	 * to delete the corresponding object,
	 * or an error will be returned.
	 *
	 * @param method The id and connection of the object to delete.
	 * For example, /POST_ID/like to remove a like from a message.
	 *
	 * @see http://developers.facebook.com/docs/api#deleting
	 * @see com.facebook.graph.net.FacebookMobile#request()
	 *
	 */
	public static function deleteDynamic(method:String, callback:Dynamic ) {

		Facebook.sharedFacebook().deleteDynamic(method, callback);
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
	public static function fqlQuery(query:String, callback:Dynamic=null, values:Dynamic=null) {
		Facebook.sharedFacebook().fqlQuery(query, callback, values);
	}
		
	/**
	 * Executes an FQL multiquery on api.facebook.com.
	 * 
	 * @param queries FQLMultiQuery The FQL queries to execute.
	 * @param parser IResultParser The parser used to parse result into object of name/value pairs. 
	 * @see http://developers.facebook.com/docs/reference/fql/
	 * @see com.facebook.graph.net.Facebook#callRestAPI()
	 * 
	 */	
	public static function fqlMultiQuery(queries:FQLMultiQuery, callback:Dynamic=null, parser:IResultParser=null) {
		Facebook.sharedFacebook().fqlMultiQuery(queries, callback, parser);
	}
		
	/**
	 * Executes a batch api operation on facebook.
	 * 
	 * @param batch The batch to send to facebook.
	 * @see com.facebook.graph.data.Batch
	 * @see callback The callback to execute when this operation is complete.
	 * 
	 */
	public static function batchRequest(batch:Batch, callback:Dynamic=null) {
		Facebook.sharedFacebook().batchRequest(batch, callback);
	}

	/**
	 * Used to make old style RESTful API calls on Facebook.
	 * Normally, you would use the Graph API to request data.
	 * This method is here in case you need to use an old method,
	 * such as FQL.
	 *
	 * @param methodName Name of the method to call on
	 * api.facebook.com (ex: fql.query).
	 * @param values Any values to pass to this request.
	 * @param requestMethod URLRequestMethod used to send data to Facebook.
	 *
	 * @see com.facebook.graph.net.FacebookMobile#request()
	 *
	 */
	public static function callRestAPI(methodName:String,
									   callback:Dynamic = null,
									   values:* = null,
									   requestMethod:String = 'GET'
	) {

		Facebook.sharedFacebook().callRestAPI(methodName, callback, values, requestMethod);
	}

	/**
	 * Utility method to format a picture URL,
	 * in order to load an image from Facebook.
	 *
	 * @param id The id you wish to load an image from.
	 * @param type The size of image to display from Facebook
	 * (square, small, or large).
	 *
	 * @see http://developers.facebook.com/docs/api#pictures
	 *
	 */
	public static function getImageUrl(id:String,
									   type:String = null
	):String {

		return Facebook.sharedFacebook().getImageUrl(id, type);
	}

	/**
	 * Synchronous call to return the current user's session.
	 *
	 */
	public static function getSession():FacebookSession {
		return Facebook.sharedFacebook().session;
	}

	function init(applicationId:String,
							callback:Dynamic,
							accessToken:String = null
	) {
			
		initCallback = callback;

		this.applicationId = applicationId;
		if (accessToken != null) {
			session = new FacebookSession();
			session.accessToken = accessToken;
		} else if (_manageSession) {
			session = new FacebookSession();
				
			var so:SharedDynamic = SharedDynamic.getLocal(SO_NAME);
			session.accessToken = so.data.accessToken;
			session.expireDate = so.data.expireDate;
		}
			
		verifyAccessToken();
	}
		
	/**
	 * @private
	 *
	 */
	function verifyAccessToken() {
		api('/me', handleUserLoad);
	}

	/**
	 * @private
	 *
	 */
	function handleUserLoad(result:Dynamic, error:Dynamic) {
		 if (result) {
			session.uid = result.id;
			session.user = result;
			if (loginCallback != null) {
			  loginCallback(session, null);
			}
			if (initCallback != null) {
				initCallback(session, null);
				initCallback = null;
			}
		  } else {
			if (loginCallback != null) {
			  loginCallback(null, error);
			}
			if (initCallback != null) {
				initCallback(null, error);
				initCallback = null;
			}
			session = null;
		  }
	}
		 
	public function login (callback:Dynamic, stageRef:Stage, extendedPermissions:Array, webView:StageWebView = null, display:String = 'touch') {
		this.loginCallback = callback;
		this.stageRef = stageRef;
		if (!webView) {
			this.webView = this.createWebView();
		} else {
			this.webView = webView;
			this.webView.stage = this.stageRef;
		}

		this.webView.assignFocus();

		if (applicationId == null) {
			throw new Error(
				'FacebookMobile.init() needs to be called first.'
			);
		}

		loginWindow = new MobileLoginWindow(handleLogin);
		loginWindow.open(this.applicationId,
			this.webView,
			FacebookDataUtils.flattenArray(extendedPermissions),
			display
		);
	}
		
	function set manageSession(value:Bool) {
		_manageSession = value;

	}
		
	function requestExtendedPermissions( callback:Dynamic, webView:StageWebView, extendedPermissions:Array<String>) {

		if (applicationId == null) {
			throw ( 'User must be logged in before asking for extended permissions.' );
		}
		login (callback, stageRef, extendedPermissions, webView);
	}
	
	function handleLogin (result:Dynamic, fail:Dynamic) {
		
		loginWindow.loginCallback = null;

		if (fail) {
			loginCallback(null, fail);
			return;
		}

		session = new FacebookSession();
		session.accessToken = result.access_token;
		session.expireDate = (result.expires_in == 0) ? null : FacebookDataUtils.stringToDate(result.expires_in) ;

		if (_manageSession) {
			var so:SharedDynamic = SharedDynamic.getLocal(SO_NAME);
			so.data.accessToken = session.accessToken;
			so.data.expireDate = session.expireDate;
			so.flush();
		}

		verifyAccessToken();
	}
	
	function logout(callback:Dynamic=null, appOrigin:String=null) {
		this.logoutCallback = callback;
			
		//clears cookie for mobile.
		var params:Dynamic = {};
		params.confirm = 1;
		params.next = appOrigin;
		params.access_token = accessToken;
		var req = new FacebookRequest();
			
		openRequests.push ( req );//] = handleLogout;
		req.call("https://m.facebook.com/logout.php", "GET" , handleRequestLoad, params);
			
		var so:SharedDynamic = SharedDynamic.getLocal(SO_NAME);
		so.clear();
		so.flush();

		session = null;
	}
	
	function handleLogout(result:Dynamic, fail:Dynamic) {
		//This is a specific case. Since we are hitting a different URL to 
		//logout, we do not get a normal result/fail
		if (logoutCallback != null) {
			logoutCallback(true);
			logoutCallback = null;
		}
	}
		
	
	function createWebView():StageWebView {
		if (this.webView) {
			try {
				this.webView.dispose();
			} catch (e:*) { }
		}
		this.webView = new StageWebView();
		this.webView.stage = this.stageRef;
		return webView;
	}
		
	public static function sharedFacebook() :FacebookMobile {
		if (_instance == null)
			_instance = new FacebookMobile();
		return _instance;
	}
}
