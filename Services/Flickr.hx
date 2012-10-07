//
//  Flickr
//
//  Created by Baluta Cristian on 2008-05-08.
//  Copyright (c) 2008 www.lib.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.system.Security;
import flash.net.URLVariables;


class Flickr {
	
	inline static var ENDPOINT :String = "http://api.flickr.com/services/rest/";
	
	var _request :RCRequest;
	var _api_key :String;
	
	/**
	 * Result is an object with the following fields, depending on the operation that was made
	 * {id, primary, secret, server, farm, photos, videos, title, description}
	 */
	public static var user_id :String;
	public static var photosets :Array<Dynamic>;
	public static var photos :Array<Dynamic>;
	public var result :Dynamic;
	var wait :Dynamic;
	
	dynamic public function onComplete () :Void {}
	dynamic public function onError () :Void {}
	
	
	/**
	 * Constructor has the following parameters, wich you should get from flickr.com
	 *	api_key
	 *	user_id
	 */
	public function new (api_key:String, username:String) {
		// Allow to use the flickr api 
		Security.allowDomain ("static.flickr.com", "www.flickr.com", "api.flickr.com");
		
		_api_key = api_key;
		
		if (user_id == null)
			getUserId ( username );
	}
	
	
	/**
	 *	Return a user's NSID, given their username.
	
	api_key (Required)
		Your API application key. See here for more details.
	username (Required)
		The username of the user to lookup.
	 */
	public function getUserId (username:String) :Void {
		
		var variables = new URLVariables();
		variables.method = "flickr.people.findByUsername";
		variables.api_key = _api_key;
		variables.username = username;
		
		_request = new RCRequest();
		_request.load ( ENDPOINT, variables );
		_request.onComplete = onLoadUserId;
	}
	/**
	 *	<user nsid="12037949632@N01">
			<username>Stewart</username> 
		</user>
	 */
	function onLoadUserId () :Void {
		
		var xml = Xml.parse ( _request.result );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		// check if error occured on server
		if (fast.att.stat != "ok") {
			result = fast.node.err.att.msg;
			onError();
			return;
		}
		
		user_id = fast.node.user.att.nsid;
		
		if (wait != null) {
			wait();
			wait = null;
		}
	}
	
	
	
	/**
	 * Returns the photosets belonging to the specified user.
	
	api_key (Required)
	    Your API application key. See here for more details.
	user_id (Optional)
	    The RCID of the user to get a photoset list for. If none is specified,
		the calling user is assumed.
	 */
	public function getPhotosetsList () :Void {
		trace("getPhotosets "+wait+" / "+user_id);
		if (user_id == null) {
			wait = getPhotosetsList;
			return;
		}
		
		var variables = new URLVariables();
		variables.method = "flickr.photosets.getList";
		variables.api_key = _api_key;
		variables.user_id = user_id;
		
		_request = new RCRequest();
		_request.load ( ENDPOINT, variables );
		_request.onComplete = onLoadPhotosetsList;
	}
	/** Returns the photosets belonging to the specified user.
	
		<photosets cancreate="1">
			<photoset id="5" primary="2483" secret="abcdef" server="8" photos="4" farm="1">
				<title>Test</title>
				<description>foo</description>
			</photoset>
			...............................................
		</photosets>
	 */
	function onLoadPhotosetsList () :Void {
		
		var xml = Xml.parse ( _request.result );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		// check if error occured on server
		if (fast.att.stat != "ok") {
			result = fast.node.err.att.msg;
			onError();
			return;
		}
		
		// parse the xml and create an array
		result = new Array<Dynamic>();
		for (photoset in fast.node.photosets.nodes.photoset) {
			
			var title = try{ photoset.node.title.innerData; }catch(e:Dynamic){ ""; }
			var description = try{ photoset.node.description.innerHTML; }catch(e:Dynamic){ ""; }
			
			result.push ({	title		:title,
							description	:description,
							id			:photoset.att.id,
							primary		:photoset.att.primary,
							secret		:photoset.att.secret,
							server		:photoset.att.server,
							farm		:photoset.att.farm,
							photos		:photoset.att.photos,
							videos		:photoset.att.videos
						});
		}
		
		Flickr.photosets = result;
		onComplete();
	}
	
	
	/* Get the list of photos in a set.
	 *	Arguments
	api_key (Required)
	    Your API application key. See here for more details.
	photoset_id (Required)
	    The id of the photoset to return the photos for.
	extras (Optional)
	    A comma-delimited list of extra information to fetch for each returned record.
		Currently supported fields are: license, date_upload, date_taken, owner_name,
		icon_server, original_format, last_update.
	privacy_filter (Optional)
	    Return photos only matching a certain privacy level. This only applies when making
		an authenticated call to view a photoset you own. Valid values are:

	        * 1 public photos
	        * 2 private photos visible to friends
	        * 3 private photos visible to family
	        * 4 private photos visible to friends & family
	        * 5 completely private photos

	per_page (Optional)
	    Number of photos to return per page. If this argument is omitted, it defaults to 500.
		The maximum allowed value is 500.
	page (Optional)
	    The page of results to return. If this argument is omitted, it defaults to 1.
	media (Optional)
	    Filter results by media type. Possible values are all (default), photos or videos
	 */
	public function getPhotosList (photoset_id:String) :Void {
		
		var variables = new URLVariables();
		variables.method = "flickr.photosets.getPhotos";
		variables.api_key = _api_key;
		variables.photoset_id = photoset_id;
		
		_request = new RCRequest();
		_request.load ( ENDPOINT, variables );
		_request.onComplete = onLoadPhotosList;
	}
	/** Get the list of photos in a set.
	
		<photoset id="72157605457014006" primary="2553325956" owner="26428115@N08"
					ownername="cristi_tulcea" page="1" per_page="500" perpage="500"
					pages="1" total="13">
			<photo id="2553325956" secret="8497e21c96" server="3045" farm="4"
					title="_MG_6865" isprimary="1" />
			<photo id="2545386350" secret="d1b356f94e" server="3096" farm="4"
					title="_MG_6929" isprimary="0" />
		</photoset> 
	 */
	function onLoadPhotosList () :Void {
		
		var xml = Xml.parse ( _request.result );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		// check if error occured
		if (fast.att.stat != "ok") {
			result = fast.node.err.att.msg;
			onError();
			return;
		}
		
		// parse the xml and create an array
		result = new Array<Dynamic>();
		for (photo in fast.node.photoset.nodes.photo)
			result.push ({	title		:photo.att.title,
							id			:photo.att.id,
							secret		:photo.att.secret,
							server		:photo.att.server,
							farm		:photo.att.farm,
							isprimary	:photo.att.isprimary
						});
		
		Flickr.photos = result;
		onComplete();
	}
	
	
	
	/** Get information about a photo. The calling user must have permission to view the photo.
		
		api_key (Required)
		    Your API application key. See here for more details.
		photo_id (Required)
		    The id of the photo to get information for.
		secret (Optional)
		    The secret for the photo. If the correct secret is passed then permissions checking
			is skipped.
			This enables the 'sharing' of individual photos by passing around the id and secret.
	 */
	public function getInfo (photo_id:String) :Void {
		
		var variables = new URLVariables();
		variables.method = "flickr.photos.getInfo";
		variables.api_key = _api_key;
		variables.photo_id = photo_id;
		
		_request = new RCRequest();
		_request.load ( ENDPOINT, variables );
		_request.onComplete = onLoadInfo;
	}
	/**
		<photo id="2733" secret="123456" server="12" isfavorite="0" license="3" rotation="90" 
			originalsecret="1bc09ce34a" originalformat="png">
			
			<owner nsid="12037949754@N01" username="Bees"
				realname="Cal Henderson" location="Bedford, UK" />
			<title>orford_castle_taster</title>
			<description>hello!</description>
			<visibility ispublic="1" isfriend="0" isfamily="0" />
			<dates posted="1100897479" taken="2004-11-19 12:51:19"
				takengranularity="0" lastupdate="1093022469" />
			<permissions permcomment="3" permaddmeta="2" />
			<editability cancomment="1" canaddmeta="1" />
			<comments>1</comments>
			<notes>
				<note id="313" author="12037949754@N01"
					authorname="Bees" x="10" y="10"
					w="50" h="50">foo</note>
			</notes>
			<tags>
				<tag id="1234" author="12037949754@N01" raw="woo yay">wooyay</tag>
				<tag id="1235" author="12037949754@N01" raw="hoopla">hoopla</tag>
			</tags>
			<urls>
				<url type="photopage">http://www.flickr.com/photos/bees/2733/</url> 
			</urls>
		</photo>
	 */
	function onLoadInfo () :Void {
		
		var xml = Xml.parse ( _request.result );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		// check if error occured
		if (fast.att.stat != "ok") {
			result = fast.node.err.att.msg;
			onError();
			return;
		}
		
		var photo = fast.node.photo;
		// Make safer data. For some reason a tag like <title /> is not working with Fast
		//var title = try{ photo.node.title.innerData; }catch(e:Dynamic){ ""; }
		var description = try{ photo.node.description.innerHTML; }catch(e:Dynamic){ ""; }
		
		result = {
					description	:	description,
					city		:	photo.node.owner.att.location,
					location	:	photo.node.urls.node.url.innerData
				};
		
		onComplete();
	}
	
	
	
	/** Returns the available sizes for a photo. The calling user must have permission to view the photo.
		
		api_key (Required)
		    Your API application key. See here for more details.
		photo_id (Required)
		    The id of the photo to fetch size information for.
	 */
	public function getSizes (photo_id:String) :Void {
		
		var variables = new URLVariables();
		variables.method = "flickr.photos.getSizes";
		variables.api_key = _api_key;
		variables.photo_id = photo_id;
		
		_request = new RCRequest();
		_request.load ( ENDPOINT, variables );
		_request.onComplete = onLoadSizes;
	}
	/**
		<sizes>
		<size label="Square" width="75" height="75"
		      source="http://farm2.static.flickr.com/1103/567229075_2cf8456f01_s.jpg"
		      url="http://www.flickr.com/photos/stewart/567229075/sizes/sq/"/>
		<size label="Thumbnail" width="100" height="75"
		      source="http://farm2.static.flickr.com/1103/567229075_2cf8456f01_t.jpg"
		      url="http://www.flickr.com/photos/stewart/567229075/sizes/t/"/>
		</sizes>
	 */
	function onLoadSizes () :Void {
		trace(_request.result);
		var xml = Xml.parse ( _request.result );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		// check if error occured
		if (fast.att.stat != "ok") {
			result = fast.node.err.att.msg;
			onError();
			return;
		}
		
		var obj = {};
		for (photo in fast.node.sizes.nodes.size)
			Reflect.setField (obj, photo.att.label, photo.att.source);
		
		result = obj;
		
		onComplete();
	}
	
	

	/**
	 * Stop all activity and delete resources
	 */
	public function destroy () :Void {
		_request.destroy();
		_request = null;
	}
}
