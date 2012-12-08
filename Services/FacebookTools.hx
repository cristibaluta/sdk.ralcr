
typedef FacebookFriend = {
	var name : String;
	var id : String;
}
typedef FacebookFriendPhoto = {
	var url : String;
	var is_silhouette : Bool;
}


class FacebookTools {
	
	public static function requestInfoForUserId (userId:String, func:Dynamic) {
		Facebook.sharedFacebook().api (userId, func, null, "GET");
	}
	public static function requestFriends (func:Dynamic) {
		Facebook.sharedFacebook().api ("me/friends", func, null, "GET");
	}
	public static function requestProfilePictureForUserId (userId:String, func:Dynamic) {
		Facebook.sharedFacebook().api (userId + "/picture?type=square&redirect=0&", func, null, "GET");
	}
    public static function postData (method:String, _callback:Dynamic, params:Dynamic) {
		Facebook.sharedFacebook().api (method, _callback, params, "POST");
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
    public function requestImageWithId (id:String, ?type:String) :String {
        return Facebook.GRAPH_URL + '/' + id + '/picture' + (type != null ? ('?type=' + type) : '');
    }
}
