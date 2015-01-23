import flash.events.Event;
//import flash.events.DataEvent;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
//import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import haxe.Json;
typedef PostRequest = Dynamic;


class FacebookRequest {
		
	//var fileReference :FileReference;
	var urlLoader :URLLoader;
	var urlRequest :URLRequest;
	var _url :String;
	var _requestMethod :String;
	var __callback :Dynamic;

	public var result :String;// Raw result from FB
	public var data :Dynamic;
	public var success :Bool;
	public var functionToCall :Dynamic;
	
	
	public function new() { }
		
	public function call (requestUrl:String, requestMethod:String = 'GET', _callback:Dynamic, values:Dynamic=null) {
		//trace(requestUrl);
		//trace(_requestMethod);
		_url = requestUrl;
		_requestMethod = requestMethod;
		__callback = _callback;
		
		urlRequest = new URLRequest(requestUrl);
		urlRequest.method = _requestMethod;
/*			https://graph.facebook.com/me/friends?access_token=AAAAAAITEghMBABqJHZB1ZC9JhRMyjdkvkCsgsx16X8aqZBZAUFAbBcvX6ZA7o8E7S4LY8BVlkFt7O2g3unc9r8quZAaJTMDrVoByRqWGHcVnl8iPkRYEJMaccess%5Ftoken=function%20Function%28%29%20%7B%7D*/
		//If there are no user defined values, just send the request as is.
		if (values == null) {
			loadURLLoader();
			return;
		}
			
		var fileData:Dynamic = extractFileData(values);
		//trace(fileData);
		//There is no fileData, so just send it off.
		if (fileData == null) {
			urlRequest.data = objectToURLVariables(values);
			loadURLLoader();
			return;
		}
			
		//If the fileData is a FileReference, let it handle this request.
/*		if (Std.is (fileData, FileReference)) {
			urlRequest.data = objectToURLVariables(values);
			urlRequest.method = URLRequestMethod.POST;
				
			fileReference = cast (fileData, FileReference);
			//fileReference.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceData, false, 0, true );
			fileReference.addEventListener( IOErrorEvent.IO_ERROR, handelFileReferenceError, false, 0, false );
			fileReference.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handelFileReferenceError, false, 0, false);
			fileReference.upload(urlRequest);
			return;
		}*/
		
		urlRequest.data = createUploadFileRequest(fileData, values).getPostData();
		urlRequest.method = URLRequestMethod.POST;
			
		loadURLLoader();
	}
		
		
	function handleFileReferenceData(event:/*DataEvent*/Dynamic) {
		handleDataLoad(event.data);
	}
		
	function handelFileReferenceError(event:ErrorEvent) {
		this.success = false;
		this.data = event;
			
		dispatchComplete();
	}
	
	
		
	public function callURL (_callback:Dynamic, url:String = "", locale:String = null) {			
		__callback = _callback;
		urlRequest = new URLRequest (url.length > 0 ? url : _url);
			
		if (locale != null) {
			var data = new URLVariables();
			data.locale = locale;
			urlRequest.data = data;
		}
		loadURLLoader();
	}
		
	public function setSuccessCallback (value:Dynamic) {
		__callback = value;
	}
		
	function isValueFile(value:Dynamic):Bool {
		return false;
		//return (Std.is (value, FileReference) || Std.is (value, Bitmap) || Std.is (value, BitmapData) || Std.is (value, ByteArray));
	}
		
	function objectToURLVariables (values:Dynamic) :URLVariables {
		
		var urlVars = new URLVariables();
		
		if (values == null) {
			return urlVars;
		}
		
		for (n in Reflect.fields(values)) {
			Reflect.setField (urlVars, n, Reflect.field ( values, n));
		}
			
		return urlVars;
	}
		
	/**
	 * Cancels the current request.
	 *
	 */
	public function close() {
		if (urlLoader != null) {
			urlLoader.removeEventListener( Event.COMPLETE, handleURLLoaderComplete );
			urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, handleURLLoaderIOError );
			urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderSecurityError );
				
			try {
				urlLoader.close();
			} catch (e:Dynamic) { }
				
			urlLoader = null;
		}
/*		if (fileReference != null) {
			//fileReference.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceData );
			fileReference.removeEventListener( IOErrorEvent.IO_ERROR, handelFileReferenceError );
			fileReference.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, handelFileReferenceError );
				
			try {
				fileReference.cancel();
			} catch (e:Dynamic) { }
				
			fileReference = null;
		}*/
	}
	
	function loadURLLoader() {
		urlLoader = new URLLoader();
		urlLoader.addEventListener (Event.COMPLETE, handleURLLoaderComplete, false, 0, false );
		urlLoader.addEventListener (IOErrorEvent.IO_ERROR, handleURLLoaderIOError, false, 0, true);
		urlLoader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderSecurityError, false, 0, true);
		urlLoader.load ( urlRequest );
	}
	function handleURLLoaderComplete(event:Event) {
		handleDataLoad ( urlLoader.data );
	}
	function handleDataLoad (result:Dynamic, dispatchCompleteEvent:Bool = true) {
		
		this.result = result;
		this.success = true;
		
		try {
			this.data = Json.parse ( this.result );
		} catch (e:Dynamic) {
			this.data = this.result;
			this.success = false;
		}
		
		handleDataReady();
		
		if (dispatchCompleteEvent) {
			dispatchComplete();
		}
	}
		
	/**
	 * Called after the loaded data is parsed but before complete is dispatched
	 */
	function handleDataReady() {
			
	}
	function dispatchComplete() {
		if (__callback != null) { __callback(this); }
		close();
	}
		
	/**
	 * Facebook will return a 500 Internal ServerError
	 * when a Graph request fails,
	 * with JSON data attached explaining the error.
	 *
	 */
	function handleURLLoaderIOError(event:IOErrorEvent) {
		this.success = false;
		this.result = cast (event.target, URLLoader).data;
			
		if (this.result != '') {
			try {
				this.data = Json.parse(this.result);
			} catch (e:Dynamic) {
				this.data = {type:'Exception', message:this.result};
			}
		} else {
			this.data = event;
		}
			
		dispatchComplete();
	}
	function handleURLLoaderSecurityError(event:SecurityErrorEvent) {
		this.success = false;
		this.result = cast (event.target, URLLoader).data;
			
		try {
			this.data = Json.parse ( cast (event.target, URLLoader).data);
		} catch (e:Dynamic) {
			this.data = event;
		}
			
		dispatchComplete();
	}
	
	function extractFileData (values:Dynamic) :Dynamic {
		
		if (values == null) return null;
		
		var fileData:Dynamic = null;
		
		if (isValueFile(values)) {
			fileData = values;
		}
/*		else if (values != null) {
			for (n in Reflect.fields ( values)) {
				if (isValueFile(values[n])) {
					fileData = values[n];
					//delete values[n];
					break;
				}
			}
		}*/
		
		return fileData;
	}
		
	function createUploadFileRequest(fileData:Dynamic, values:Dynamic) :PostRequest {
		return null;
/*		var post = new PostRequest();
			
		//Write the primitive values first, if they exist
		if (values) {
			for (n in values) {
				post.writePostData (n, values[n]);
			}
		}
			
		//If we have a Bitmap, extract its BitmapData for upload.
		if (Std.is (fileData, Bitmap)) {
			fileData = fileData.bitmapData;
		}
			
		if (Std.is (fileData, ByteArray)) {
			//If we have a ByteArray, upload as is.
			post.writeFileData (values.fileName, cast (fileData, ByteArray), values.contentType );
				
		} else if (Std.is (fileData, BitmapData)) {
			//If we have a BitmapData, create a ByteArray, then upload.
			var ba:ByteArray = PNGEncoder.encode (cast (fileData, BitmapData));
			post.writeFileData(values.fileName, ba, 'image/png');
		}
			
		post.close();
		urlRequest.contentType = 'multipart/form-data; boundary=' + post.boundary;
			
		return post;*/
	}
		
	/**
	 * @return Returns the current request URL
	 * and any parameters being used.
	 *
	 */
	public function toString():String {
		return urlRequest.url + (urlRequest.data == null ? '':'?' + StringTools.htmlUnescape (urlRequest.data.toString()));
	}

}



class FacebookSession {

   public var uid :String;
   public var user :Dynamic;
   public var sessionKey :String;
   public var expireDate :Date;
   public var accessToken :String;
   public var secret :String;
   public var sig :String;
   public var availablePermissions :Array<String>;
	
   public function new() { }

   
   public function fromJSON (result:Dynamic) {
	   trace(Std.string(result));
       if (result != null) {
            sessionKey = result.session_key;
            expireDate = Date.fromString (result.expires);
            accessToken = result.access_token;
            secret = result.secret;
			sig = result.sig;
			uid = result.uid;
       }
    }
    public function toString():String {
        return '[FacebookSession userId:' + uid + ']';
    }
}


class FacebookAuthResponse {
	
	public var uid :String;
	public var expireDate :Date;
	public var accessToken :String;
	public var signedRequest :String;

	public function new() { }

    public static function fromJson (result:Dynamic) :FacebookAuthResponse {
		var r = new FacebookAuthResponse();
        if (result != null) {
			r.expireDate = Date.fromTime (Date.now().getTime() + result.expiresIn * 1000);
			//r.expireDate.setTime(expireDate.time + result.expiresIn * 1000);
            r.accessToken = result.access_token != null ? result.access_token : result.accessToken;
			r.signedRequest = result.signedRequest;
            r.uid = result.userID;
			trace(r.accessToken);
        }
		return r;
    }
    public function toString():String {
        return '[FacebookAuthResponse userId:' + uid + ']';
    }
}
