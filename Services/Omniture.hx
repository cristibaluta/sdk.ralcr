//
//  Omniture
//
//  Created by Cristi Baluta on 2010-09-01.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.external.ExternalInterface;
import flash.net.URLRequest;


class Omniture {
	
	static var INSTANCE :Omniture;
	
	public var country :String;
	public var unit :String;
	public var campaign :String;
	public var debug :Bool;
		
	
	public function new () {
		country = "uk|en";
		unit = "";
		campaign = "";
		debug = true;
	}
	public static function instance () :Omniture {
		if (INSTANCE == null)
			INSTANCE = new Omniture();
		return INSTANCE;
	}
	
	
	public function trackMainPage (?pos:haxe.PosInfos) {
		var message = "Gw: " + country + "|" + unit + ": " + campaign;
		//ExternalInterface.call ("s_sendAnalyticsEvent", "", message);
		flash.Lib.getURL (new URLRequest("javascript:s_sendAnalyticsEvent('','"+message+"')"), "_self");
		
		if (debug) trace(message+", "+Std.string(pos));
	}
	
	public function trackEvent (movieName:String, ?action:String, ?pos:haxe.PosInfos) {
		if (movieName != null) movieName = movieName.toLowerCase();
		if (action != null) action = action.toLowerCase();
		var message = country + "|" + unit + ": " + campaign + "|" + movieName + (action == null ? "" : ("|" + action));
		
		//ExternalInterface.call ("s_sendAnalyticsEvent", "", message);
		flash.Lib.getURL (new URLRequest("javascript:s_sendAnalyticsEvent('','"+message+"')"), "_self");
		
		if (debug) trace(message+", "+Std.string(pos));
	}
	
	
	public function trackClick (where:String, ?pos:haxe.PosInfos) {
		var message = country + "|"+ unit + ": " + campaign +"|"+ where + "|click";
		//ExternalInterface.call ("s_sendAnalyticsEvent", "", message);
		flash.Lib.getURL (new URLRequest("javascript:s_sendAnalyticsEvent('','"+message+"')"), "_self");
		
		if (debug) trace(message+", "+Std.string(pos));
	}
	
	public function trackLink (link:String, ?pos:haxe.PosInfos) :Void {
		//ExternalInterface.call ("s_sendCustomLinkEvent", "", link);
		flash.Lib.getURL (new URLRequest("javascript:s_sendCustomLinkEvent('','"+link+"')"), "_self");
		
		if (debug) trace(link+", "+Std.string(pos));
	}
	
	public function trackDownloadLink (link:String, ?pos:haxe.PosInfos) :Void {
		//ExternalInterface.call ("s_sendDownloadLinkEvent", "", link);
		flash.Lib.getURL (new URLRequest("javascript:s_sendDownloadLinkEvent('','"+link+"')"), "_self");
		
		if (debug) trace(link+", "+Std.string(pos));
	}
	
	public function trackExitLink (link:String, ?pos:haxe.PosInfos) :Void {
		//ExternalInterface.call ("s_sendExitLinkEvent", "", link);
		flash.Lib.getURL (new URLRequest("javascript:s_sendExitLinkEvent('','"+link+"')"), "_self");
		
		if (debug) trace(link+", "+Std.string(pos));
	}
}
