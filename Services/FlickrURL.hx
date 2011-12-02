//
//  FlickrLink
//
//  Created by Baluta Cristian on 2008-10-22.
//  Copyright (c) 2008 http://imagin.ro. All rights reserved.
//
class FlickrURL {
	
	inline static var s = "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}_s.jpg";// square
	inline static var m = "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}_m.jpg";// medium
	inline static var t = "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}_t.jpg";// thumb
	// original photo is easier to obtain from getSizes method
	
	
	public static function getSmall (obj:Dynamic) :String {
		return replace (s, obj);
	}
	public static function getMedium (obj:Dynamic) :String {
		return replace (m, obj);
	}
	public static function getThumb (obj:Dynamic) :String {
		return replace (t, obj);
	}
	
	static function replace ( str:String, obj:Dynamic ) :String {
		
		for (field in Reflect.fields ( obj ))
			str = StringTools.replace (str, "{"+field+"}", Reflect.field (obj, field));
		
		return str;
	}
}
