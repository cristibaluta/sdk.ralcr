
typedef FacebookFriend = {
	var name : String;
	var id : String;
}
typedef FacebookFriendPhoto = {
	var url : String;
	var is_silhouette : Bool;
}


class FacebookTools {
	
	public static function requestFriends (func:Dynamic) {
		Facebook.sharedFacebook().api ("/me/friends", func, null, "GET");
	}
	public static function requestProfilePictureForUserId (userId:String, func:Dynamic) {
		Facebook.sharedFacebook().api (userId + "/picture?type=large&redirect=0&", func, null, "GET");
	}
	
}
