import flash.display.Sprite;
import flash.events.MouseEvent;
import haxe.Json;

typedef FacebookUser = {
	var name : String;
	var id : String;
}
typedef FacebookUserInfo = {
	var name : String;
	var id : String;
}
	
class Main extends Sprite {
		
	static var APP_ID = "249854931808870"; //Place your application id here
	var fb :Facebook;
	
	public static function main () {
		flash.Lib.current.addChild ( new Main());
	}
	
	public function new () {
		haxe.Firebug.redirectTraces();
		trace("new");
		super();
		
		fb = Facebook.init (APP_ID, onInit);
		var s = new SKSimpleButtonWithText ("Logout", null);
		var b = new RCButton (20, 80, s);
			b.onClick = logoutHandler;
			b.init();
		addChild ( b.layer );
		var s = new SKSimpleButtonWithText ("Login", null);
		var b = new RCButton (20, 50, s);
			b.onClick = loginHandler;
			b.init();
		addChild ( b.layer );
		
		var s = new SKSimpleButtonWithText ("GetFriends", null);
		var b = new RCButton (120, 50, s);
			b.onClick = getFriendsHandler;
			b.init();
		addChild ( b.layer );
		
		var s = new SKSimpleButtonWithText ("GetFriendWithId", null);
		var b = new RCButton (120, 80, s);
			b.onClick = getFriendHandler;
			b.init();
		addChild ( b.layer );
	}
	
	function onInit (result:Dynamic, fail:Dynamic) {
		trace("onInit");
		trace(result);trace(fail);
	}
	
	function loginHandler(){
		trace("try login");
		var opts:Dynamic = {scope:"publish_stream, user_photos"};
		fb.login (onLogin, opts);
	}
	function logoutHandler(){
		trace("try logout");
		fb.logout (onLogout);
	}
	function onLogin (result:Dynamic, fail:Dynamic){
		trace(result);trace(fail);
	}
	function onLogout(success:Bool){			
		trace(success);			
	}
	
	function getFriendsHandler(){
		trace("getFriendsHandler");
		handleCallApiClick ("/me/friends", friendsHandler);
	}
	function getFriendHandler(){
		trace("getFriendHandler");
		handleCallApiClick ("245700020", friendHandler);// Emma
	}
	
	function handleReqTypeChange(event:MouseEvent){
/*		if (getRadio.selected) {			
			paramsLabel.visible = paramsInput.visible = false; 
		} else {
			paramsLabel.visible = paramsInput.visible = true; //only POST request types have params
		}*/
	}
	
	function handleCallApiClick(method:String, func:Dynamic){
		var requestType = "GET";//getRadio.selected ? "GET" : "POST";
		var params:Dynamic = null;	
		if (requestType == "POST") {
			try {
				params = Json.parse ( "" );
			} catch (e:Dynamic) {
				trace("\n\nERROR DECODING JSON: " + e.message);
			}
		}
		fb.api (method, func, params, requestType);
	}
	function friendsHandler (result:Dynamic, fail:Dynamic){
		trace(fail);
		if (result != null) {
			var users :Array<FacebookUser> = result;
			trace(users.length);
			for (user in users) trace(user);
		}
	}
	function friendHandler (result:Dynamic, fail:Dynamic){
		trace(result);trace(fail);return;
		if (result != null) {
			var users :Array<FacebookUser> = result;
			trace(users.length);
			for (user in users) trace(user);
		}
	}
	
	
	function handleUIClick (event:MouseEvent){			
		var method:String = "";
		if (method.length > 0) {
			var data:Dynamic = {};
			try {
				data = Json.parse ( "" );
			} catch (e:Dynamic) {
				trace("\n\nERROR DECODING JSON: " + e.message);
			}
			
			fb.ui (method, data, onUICallback);
		} else {
			trace("\n\nPlease specify dialog type");
		}
	}
	
	function onUICallback(result:Dynamic){
		trace(result);
	}
		
	
}
