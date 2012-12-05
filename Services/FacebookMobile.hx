
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
	import flash.net.SharedObject;
	import flash.net.URLRequestMethod;

	/**
	 * For use in Mobile, to access the Facebook Graph API from the Mobile phone.
	 *
	 */
	public class FacebookMobile extends AbstractFacebook {
		
		inline public static var LOGIN_SUCCESS_URL = 'http://www.facebook.com/connect/login_success.html';
		inline public static var LOGIN_SUCCESS_SECUREURL = 'https://www.facebook.com/connect/login_success.html';
		inline public static var LOGIN_FAIL_URL = 'http://www.facebook.com/connect/login_success.html?error_reason';
		inline public static var LOGIN_FAIL_SECUREURL = 'https://www.facebook.com/connect/login_success.html?error_reason';
		inline public static var LOGIN_URL = 'https://login.facebook.com/login.php';
		inline public static var AUTHORIZE_CANCEL = 'https://graph.facebook.com/oauth/authorize_cancel';
		
		inline static var SO_NAME = 'com.facebook.graph.FacebookMobile';
		
		static var _instance:FacebookMobile;
		static var _canInit:Boolean = false;
		var _manageSession:Boolean = true;
		var loginWindow:MobileLoginWindow;
		var applicationId:String;
		var loginCallback:Function;
		var logoutCallback:Function;
		var initCallback:Function;

		var webView:StageWebView;
		var stageRef:Stage;
		

		/**
		 * Creates a new FacebookMobile instance
		 *
		 */
		public function new() {
			super();

			if (_canInit == false) {
				throw new Error(
					'FacebookMobile is an singleton and cannot be instantiated.'
				);
			}
		}

		/**
		 * Initializes this Facebook singleton with your application ID.
		 * You must call this method first.
		 *
		 * @param applicationId The application ID you created at
		 * http://www.facebook.com/developers/apps.php
		 *
		 * @param callback Method to call when initialization is complete.
		 * The handler must have the signature of callback(success:Object, fail:Object);
		 * Success will be a FacebookSession if successful, or null if not.
		 *
		 * @param accessToken If you have a previously saved access_token, you can pass it in here.
		 *
		 */
		public static function init(applicationId:String, callback:Function, accessToken:String = null):void {

			getInstance().init(applicationId, callback, accessToken);
		}
		
		public static function set locale(value:String):void {
			getInstance().locale = value;
		}
		
		/**
		 * Opens a new login window so the current user can log in to Facebook.
		 *
		 * @param callback The method to call when login is successful.
		 * The handler must have the signature of callback(success:Object, fail:Object);
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
		public static function login (callback:Function, stageRef:Stage, extendedPermissions:Array, webView:StageWebView = null, display:String = 'touch'):void {
			getInstance().login (callback, stageRef, extendedPermissions, webView, display);
		}

		/**
		 * Setting to true (default), this class will manage
		 * the session and access token internally.
		 * Setting to false, no session management will occur
		 * and the end developer must save the session manually.
		 *
		 */
		public static function set manageSession(value:Boolean):void {
			getInstance().manageSession = value;
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
		public static function logout(callBack:Function=null, appOrigin:String=null):void {
			getInstance().logout(callBack, appOrigin);
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
		public static function requestExtendedPermissions (callback:Function, webView:StageWebView, ...extendedPermissions:Array):void {
			getInstance().requestExtendedPermissions(callback, webView, extendedPermissions);
		}

		/**
		 * Makes a new request on the Facebook Graph API.
		 *
		 * @param method The method to call on the Graph API.
		 * For example, to load the user's current friends, pass in /me/friends
		 * @param calllback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
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
								   callback:Function,
								   params:* = null,
								   requestMethod:String = 'GET'
		):void {

			getInstance().api(method,
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
		public static function getRawResult(data:Object):Object {			
			return getInstance().getRawResult(data);
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
		public static function hasNext(data:Object):Boolean {
			var result:Object = getInstance().getRawResult(data);
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
		public static function hasPrevious(data:Object):Boolean {
			var result:Object = getInstance().getRawResult(data);
			if(!result.paging){ return false; }
			return (result.paging.previous != null);
		}
		
		/**
		 * Retrieves the next page that is associated with result object passed in.
		 *
		 * @param data The result object.
		 * @param callback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
		 * On success, result will be the object data returned from Facebook.
		 * On fail, result will be null and fail will contain information about the error.
		 * 
		 * @see com.facebook.graph.net.FacebookDesktop#request()
		 * @see http://developers.facebook.com/docs/api#reading
		 *
		 */
		public static function nextPage(data:Object, callback:Function):FacebookRequest {
			return getInstance().nextPage(data, callback);
		}
		
		/**
		 * Retrieves the previous page that is associated with result object passed in.
		 *
		 * @param data The result object.
		 * @param callback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
		 * On success, result will be the object data returned from Facebook.
		 * On fail, result will be null and fail will contain information about the error.
		 *
		 * @see com.facebook.graph.net.FacebookDesktop#request()
		 * @see http://developers.facebook.com/docs/api#reading
		 *
		 */
		public static function previousPage(data:Object, callback:Function):FacebookRequest {
			return getInstance().previousPage(data, callback);
		}

		/**
		 * Shortcut method to post data to Facebook.
		 * Alternatively, you can call FacebookMobile.request
		 * and use POST for requestMethod.
		 *
		 * @see com.facebook.graph.net.FacebookMobile#request()
		 */
		public static function postData(method:String,
										callback:Function,
										params:* = null
		):void {

			api(method, callback, params, URLRequestMethod.POST);
		}
		
		/**
		 * Shortcut method to upload video to Facebook.
		 * 
		 * @param method The method to call on the Graph API.
		 * For example, to upload a video, pass in /me/videos. To upload to an friend's wall, pass in /USER_ID/videos.
		 * @param callback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
		 * On success, result will be the object data returned from Facebook.
		 * On fail, result will be null and fail will contain information about the error.
		 * @param params An object containing the title, description, fileName (including extension), and video (FileReference or ByteArray) 
		 * 
		 * @see http://developers.facebook.com/docs/reference/api/video/
		 * 
		 */
		public static function uploadVideo(method:String, callback:Function = null, params:* = null):void {
			getInstance().uploadVideo(method, callback, params);
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
		public static function deleteObject(method:String, callback:Function ):void {

			getInstance().deleteObject(method, callback);
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
		public static function fqlQuery(query:String, callback:Function=null, values:Object=null):void {
			getInstance().fqlQuery(query, callback, values);
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
		public static function fqlMultiQuery(queries:FQLMultiQuery, callback:Function=null, parser:IResultParser=null):void {
			getInstance().fqlMultiQuery(queries, callback, parser);
		}
		
		/**
		 * Executes a batch api operation on facebook.
		 * 
		 * @param batch The batch to send to facebook.
		 * @see com.facebook.graph.data.Batch
		 * @see callback The callback to execute when this operation is complete.
		 * 
		 */
		public static function batchRequest(batch:Batch, callback:Function=null):void {
			getInstance().batchRequest(batch, callback);
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
										   callback:Function = null,
										   values:* = null,
										   requestMethod:String = 'GET'
		):void {

			getInstance().callRestAPI(methodName, callback, values, requestMethod);
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

			return getInstance().getImageUrl(id, type);
		}

		/**
		 * Synchronous call to return the current user's session.
		 *
		 */
		public static function getSession():FacebookSession {
			return getInstance().session;
		}

		function init(applicationId:String,
								callback:Function,
								accessToken:String = null
		):void {
			
			initCallback = callback;

			this.applicationId = applicationId;
			if (accessToken != null) {
				session = new FacebookSession();
				session.accessToken = accessToken;
			} else if (_manageSession) {
				session = new FacebookSession();
				
				var so:SharedObject = SharedObject.getLocal(SO_NAME);
				session.accessToken = so.data.accessToken;
				session.expireDate = so.data.expireDate;
			}
			
			verifyAccessToken();
		}
		
		/**
		 * @private
		 *
		 */
		function verifyAccessToken():void {
			api('/me', handleUserLoad);
		}

		/**
		 * @private
		 *
		 */
		function handleUserLoad(result:Object, error:Object):void {
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
		 
		 /**
     	  * @private
          *
     	  */
		function login (callback:Function, stageRef:Stage, extendedPermissions:Array, webView:StageWebView = null, display:String = 'touch'):void {
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
		
		function set manageSession(value:Boolean):void {
			_manageSession = value;

		}
		
		function requestExtendedPermissions( callback:Function, webView:StageWebView,
			...extendedPermissions:Array
		):void {

			if (applicationId == null) {
				throw new Error(
					'User must be logged in before asking for extended permissions.'
				);
			}
			login (callback, stageRef, extendedPermissions, webView);
		}
		
		function handleLogin(result:Object, fail:Object):void {
			loginWindow.loginCallback = null;

			if (fail) {
				loginCallback(null, fail);
				return;
			}

			session = new FacebookSession();
			session.accessToken = result.access_token;
			session.expireDate = (result.expires_in == 0) ? null : FacebookDataUtils.stringToDate(result.expires_in) ;

			if (_manageSession) {
				var so:SharedObject = SharedObject.getLocal(SO_NAME);
				so.data.accessToken = session.accessToken;
				so.data.expireDate = session.expireDate;
				so.flush();
			}

			verifyAccessToken();
		}
		
		/**
		 * @private
		 *
		 */
		function logout(callback:Function=null, appOrigin:String=null):void {
			this.logoutCallback = callback;
			
			//clears cookie for mobile.
			var params:Object = {};
			params.confirm = 1;
			params.next = appOrigin;
			params.access_token = accessToken;
			var req = new FacebookRequest();
			
			openRequests[req] = handleLogout;
			req.call("https://m.facebook.com/logout.php", "GET" , handleRequestLoad, params);
			
			var so:SharedObject = SharedObject.getLocal(SO_NAME);
			so.clear();
			so.flush();

			session = null;
		}
		
		/**
		 * @private
		 *
		 */
		function handleLogout(result:Object, fail:Object):void {
			//This is a specific case. Since we are hitting a different URL to 
			//logout, we do not get a normal result/fail
			if (logoutCallback != null) {
				logoutCallback(true);
				logoutCallback = null;
			}
		}
		
		 /**
		 * @private
		 *
		 */
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
		
 		/**
		 * @private
		 *
		 */
		static function getInstance():FacebookMobile {
			if (_instance == null) {
				_canInit = true;
				_instance = new FacebookMobile();
				_canInit = false;
			}
			return _instance;
		}
	}
}