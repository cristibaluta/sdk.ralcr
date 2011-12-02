//
//  FontManager
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
/*

- init the FontManager
- load external fonts from swf
- load CSS file
- set TextFormat properties (all fonts except external ones)
- register external fonts that you know for shure exists in the swf
- set TextFormat properties (with external fonts also)
- set StyleSheet properties

*/
import flash.system.ApplicationDomain;
import flash.events.Event;
import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.StyleSheet;


class FontManager {
	
	static var INSTANCE :FontManager;
	var fontsDomain :ApplicationDomain;
	var fontsSwfList :Array<Event>;// Keep a reference to the loaded font event
	var event :Event;
	var _defaultStyleSheetData :Dynamic;//StyleSheet
	var _defaultRCFont :RCFont;//TextFormat;
	
	// Store the name of the format and the object with properties
	// that should later be converted to TextFormat or StyleSheet
	var hash_style :Hash<Dynamic>;
	var hash_rcfont :Hash<RCFont>;
	
	
	public function new () {}
	
	function initDefaults () {
		
		hash_style = new Hash<Dynamic>();
		hash_rcfont = new Hash<RCFont>();
		fontsSwfList = new Array<Event>();
		
		// Init the default values
		_defaultRCFont = new RCFont();
		_defaultRCFont.font = "Arial";
		_defaultRCFont.size = 12;
		_defaultRCFont.color = 0xDDDDDD;
		_defaultRCFont.leading = 4;
		_defaultRCFont.letterSpacing = 1;
		_defaultRCFont.align = flash.text.TextFormatAlign.LEFT;
		_defaultRCFont.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		_defaultRCFont.html = true;
		_defaultRCFont.selectable = true;
		_defaultRCFont.embedFonts = false;
		
		_defaultStyleSheetData = {	a_link	:{color:"#999999", textDecoration:"underline"},
									a_hover :{color:"#33CCFF"},
									h1		:{size:16}
		};
		
		registerRCFont ("system", _defaultRCFont); // use with embedFonts = false
		registerStyle ("default", _defaultStyleSheetData);
	}
	
	
	public static function init () {
		if (INSTANCE == null) {
			INSTANCE = new FontManager();
			INSTANCE.initDefaults();
		}
	}
	
	public static function instance () :FontManager {
		if (INSTANCE == null) init();
		return INSTANCE;
	}
	
	
	
	/**
	 * Register formats and stylesheets
	 * Data is stored as Objects
	 */
	public static function registerRCFont (key:String, data:RCFont) :Void {
		instance().hash_rcfont.set (key, data);
	}
	
	public static function registerStyle (key:String, data:Dynamic) :Void {
		instance().hash_style.set (key, data);
	}
	
	public static function remove (key:String) :Void {
		instance().hash_style.remove (key);
		instance().hash_rcfont.remove (key);
	}
	
	
	/**
	 * Return TextFormat and StyleSheets ready to apply them to TextField
	 * key = a give name for the format or stylesheet
	 * exception = object with properties that should override the original
	 */
	static public function getRCFont (?key:String="system", ?exceptions:Dynamic) :RCFont {
		return instance().hash_rcfont.get( key ).copy( exceptions );
	}
	
	static public function getStyleSheet (?key:String="default", ?exception:Dynamic) :StyleSheet {
		if (key == "css" && instance().hash_style.exists("css"))
		return instance().hash_style.get ("css");
		return instance().createStyle (INSTANCE.hash_style.get( key ), exception);
	}
	
	
	
	
	
	/**
	 * Load a font embeded in swf, or a css file
	 */
	public static function addSwf (swf:Event) :Void {
		instance().push ( swf );
	}
	
	public static function setCSS (css:String) :Void {
		instance().setCSSFile ( css );
	}
	
	public static function enumerateFonts () :Array<Dynamic> {
		init();
		return Font.enumerateFonts();
	}
	
	
	/**
	 * Register a font that you know for shure exits in the loaded swf
	 */
	public static function registerFont (str:String) :Bool {
		
		if (instance().fontsSwfList.length == 0) return false;
		
		// Iterate over each swf registered that has fonts inside
		for (swf in instance().fontsSwfList) {
			var e = swf.target;
			if (e.applicationDomain.hasDefinition ( str )) {
				var def = e.applicationDomain.getDefinition ( str );
				var LoadedFont :Class<Dynamic> = cast (def, Class<Dynamic>);
				try {
					 Font.registerFont ( LoadedFont );
				}
				catch (e:Dynamic) { trace(e); return false; }

				return true;
			}
		}
		return false;
	}
	
	
	/**
	 * Handle events when loading files
	 */
	function push (e:Event) {
		fontsSwfList.push ( e );
	}
	function setCSSFile (css:String) {
	    var cssStyleSheet = new StyleSheet();
	    cssStyleSheet.parseCSS ( css );
		
		// Store the css stylesheet
		hash_style.set ("css", cssStyleSheet);
	}
	
	
	// When the style is created from an object some replacements are necessary:
	// 1. a:link should be a_link
	// 2. .heading should be .... (not implemented yet)
	function createStyle (properties:Dynamic, ?exceptions:Dynamic) :StyleSheet {
		// Create new styleSheet 
		var style = new StyleSheet();
		
		for (field in Reflect.fields(properties)) {
			style.setStyle (StringTools.replace (field, "_", ":"), Reflect.field (properties, field));
			if (exceptions != null)
			style.setStyle (StringTools.replace (field, "_", ":"), Reflect.field (exceptions, field));
		}
		
		return style;
	}
}
	