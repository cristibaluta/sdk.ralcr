
typedef FacebookFriend = {
	var name : String;
	var id : String;
}
typedef FacebookFriendPhoto = {
	var url : String;
	var is_silhouette : Bool;
}

// http://developers.facebook.com/docs/reference/login/#permissions
enum FacebookPermissions {
	email;
	publish_stream;
	publish_actions;
	// Extended permissions
	read_friendlists;
	read_insights;
	read_mailbox;
	read_requests;
	read_stream;
	xmpp_login;
	ads_management;
	create_event;
	manage_friendlists;
	manage_notifications;
	user_online_presence;
	friends_online_presence;
	publish_checkins;
	rsvp_event;
}

class FacebookTools {
	
	/**
	*  @param func - should be of type Dynamic->Dynamic->Void
	*/
	public static function requestInfoForUserId (userId:String, func:Dynamic->Dynamic->Void) {
		Facebook.sharedFacebook().api (userId, func, null, "GET");
	}
	
	/**
	*  Returns in func an Array<FacebookFriend>
	*  all = If there are too many items facebook will return you only a part of it and a link to the next part
	*  If 'all' is true i'll request the other parts for you and func will get all the friends
	*/
	public static function requestFriends (func:Dynamic->Dynamic->Void, all:Bool=true) {
		Facebook.sharedFacebook().api ("me/friends", func, null, "GET");
	}
	
	/**
	*  Returns in func a FacebookFriendPhoto
	*/
	public static function requestProfilePictureForUserId (userId:String, func:Dynamic->Dynamic->Void) {
		Facebook.sharedFacebook().api (userId + "/picture?type=large&redirect=0&", func, null, "GET");
	}
	
	/**
	*  Returns an Object containing an 'id'
	*/
    public static function postData (method:String, func:Dynamic->Dynamic->Void, params:Dynamic) {
		Facebook.sharedFacebook().api (method, func, params, "POST");
    }
	
    /**
     * Utility method to format a picture URL, in order to load an image from Facebook.
     *
     * @param id The ID you wish to load an image from.
     * @param type The size of image to display from Facebook
     * (square, small, or large).
     *
     * @see http://developers.facebook.com/docs/reference/api/using-pictures/
     *
     */
    public function buildImageURLWithId (id:String, ?type:String) :String {
        return Facebook.GRAPH_URL + '/' + id + '/picture' + (type != null ? ('?type=' + type) : '');
    }
}
