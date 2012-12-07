import flash.display.Sprite;
import flash.events.MouseEvent;
import haxe.Json;
import FacebookTools;


class Main extends Sprite {
		
	static var APP_ID = "249854931808870"; //Place your application id here
	var fb :Facebook;
	
	public static function main () {
		flash.Lib.current.addChild ( new Main());
	}
	
	public function new () {
		
		haxe.Firebug.redirectTraces();
		super();
		
		//var textureAtlas = new RCTextureAtlas (RCAssets.sharedAssets().get("players_png"), RCAssets.sharedAssets().get("players_plist"));
/*		var textureAtlas = new RCTextureAtlas (RCAssets.sharedAssets().get("t_png"), RCAssets.sharedAssets().get("t_xml"));
		addChild ( textureAtlas.imageNamed("Asset_Door_Front_008_D_frame0-20_008_.RGB_color.0000.tga") );
		
		var i = 0;
		var arr = textureAtlas.imagesWithPrefix ( "Asset_Door_Front_008_D" );
		var aim = RCImageAnimated.animatedImageWithImages (300, 0, arr);
		aim.play(10);
		addChild ( aim );*/
		
/*		for (im in arr) {
			addChild ( im );
			im.x = 200+i*100;
			i++;
		}*/
		
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
		//trace(result);trace(fail);
		//if (result != null) 
	}
	function onLogout(success:Bool){			
		trace(success);			
	}
	
	function getFriendsHandler(){
		FacebookTools.requestFriends( friendsHandler );
	}
	function getFriendHandler(){
		FacebookTools.requestProfilePictureForUserId ("245700020", friendHandler);// Emma
	}
	
	function handleReqTypeChange(event:MouseEvent){
/*		if (getRadio.selected) {			
			paramsLabel.visible = paramsInput.visible = false; 
		} else {
			paramsLabel.visible = paramsInput.visible = true; //only POST request types have params
		}*/
	}
	function friendsHandler (result:Dynamic, fail:Dynamic) {
		if (result != null) {
			var friends :Array<FacebookFriend> = result;
			trace(friends.length);
			var self = this;
			var i = 0;
			for (fr in friends) {
				trace(i+", "+fr);
				//continue;
				if (i<10) {
					
				FacebookTools.requestProfilePictureForUserId (fr.id, function(result:Dynamic, fail:Dynamic) {
					trace("ready"+result.url+i);
					addChild ( new RCImage(Math.random()*600, 0, result.url).layer );
				});
				}
				else break;
				i++;
			}
		}
	}
	function friendHandler (result:Dynamic, fail:Dynamic) {
		trace(result);trace(fail);
		addChild ( new RCImage(350, 100, result.url).layer );
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
