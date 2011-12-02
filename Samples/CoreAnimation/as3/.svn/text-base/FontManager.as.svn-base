package  {
	import flash.events.ErrorEvent;
	import flash.text.Font;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.events.IEventDispatcher;
	import haxe.Log;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.text.TextFormatAlign;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.text.StyleSheet;
	public class FontManager {
		public function FontManager() : void {
			null;
		}
		
		protected var fontsDomain : flash.system.ApplicationDomain;
		protected var fontsEvent : flash.events.Event;
		protected var _defaultStyleSheetData : *;
		protected var _defaultRCFont : RCFont;
		protected var hash_style : Hash;
		protected var hash_rcfont : Hash;
		protected function initDefaults() : void {
			this.hash_style = new Hash();
			this.hash_rcfont = new Hash();
			this._defaultRCFont = new RCFont();
			this._defaultRCFont.font = "Arial";
			this._defaultRCFont.size = 12;
			this._defaultRCFont.color = 14540253;
			this._defaultRCFont.leading = 4;
			this._defaultRCFont.letterSpacing = 1;
			this._defaultRCFont.align = flash.text.TextFormatAlign.LEFT;
			this._defaultRCFont.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			this._defaultRCFont.html = true;
			this._defaultRCFont.selectable = true;
			this._defaultRCFont.embedFonts = false;
			this._defaultStyleSheetData = { a_link : { color : "#999999", textDecoration : "underline"}, a_hover : { color : "#33CCFF"}, h1 : { size : 16}}
			registerRCFont("system",this._defaultRCFont);
			registerStyle("default",this._defaultStyleSheetData);
			onInit();
		}
		
		protected function loadFontSwf(URL : String) : void {
			var loader : flash.display.Loader = new flash.display.Loader();
			this.configureListeners(loader.contentLoaderInfo,this.onFontFileLoaded);
			loader.load(new flash.net.URLRequest(URL));
		}
		
		protected function loadCSSFile(URL : String) : void {
			var loader : flash.net.URLLoader = new flash.net.URLLoader();
			this.configureListeners(loader,this.onCSSFileLoaded);
			loader.load(new flash.net.URLRequest(URL));
		}
		
		protected function configureListeners(dispatcher : flash.events.IEventDispatcher,func : *) : void {
			dispatcher.addEventListener(flash.events.Event.COMPLETE,func);
			dispatcher.addEventListener(flash.events.ProgressEvent.PROGRESS,this.progressHandler);
			dispatcher.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
			dispatcher.addEventListener(flash.events.IOErrorEvent.IO_ERROR,this.errorHandler);
		}
		
		protected function onFontFileLoaded(e : flash.events.Event) : void {
			this.fontsEvent = e;
			onFontLoaded();
		}
		
		protected function onCSSFileLoaded(e : flash.events.Event) : void {
			var cssStyleSheet : flash.text.StyleSheet = new flash.text.StyleSheet();
			cssStyleSheet.parseCSS(e.target.data);
			this.hash_style.set("css",cssStyleSheet);
			onCSSLoaded();
		}
		
		protected function progressHandler(e : flash.events.ProgressEvent) : void {
			FontManager.percentLoaded = Math.round(e.target.bytesLoaded * 100 / e.target.bytesTotal);
			onProgress();
		}
		
		protected function errorHandler(e : flash.events.ErrorEvent) : void {
			FontManager.errorMessage = "Error loading font or css! " + e;
			onError();
		}
		
		protected function createStyle(properties : *,exceptions : * = null) : flash.text.StyleSheet {
			var style : flash.text.StyleSheet = new flash.text.StyleSheet();
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(properties);
				while(_g < _g1.length) {
					var field : String = _g1[_g];
					++_g;
					style.setStyle(StringTools.replace(field,"_",":"),Reflect.field(properties,field));
					if(exceptions != null) style.setStyle(StringTools.replace(field,"_",":"),Reflect.field(exceptions,field));
				}
			}
			return style;
		}
		
		static protected var INSTANCE : FontManager;
		static public var errorMessage : String;
		static public var percentLoaded : int;
		static public var onInit : Function = function() : void {
			null;
		}
		static public var onFontLoaded : Function = function() : void {
			null;
		}
		static public var onCSSLoaded : Function = function() : void {
			null;
		}
		static public var onProgress : Function = function() : void {
			null;
		}
		static public var onError : Function = function() : void {
			null;
		}
		static public function init() : void {
			if(FontManager.INSTANCE == null) {
				FontManager.INSTANCE = new FontManager();
				INSTANCE.initDefaults();
			}
		}
		
		static public function instance() : FontManager {
			if(FontManager.INSTANCE == null) init();
			return INSTANCE;
		}
		
		static public function registerRCFont(key : String,data : RCFont) : void {
			instance().hash_rcfont.set(key,data);
		}
		
		static public function registerStyle(key : String,data : *) : void {
			instance().hash_style.set(key,data);
		}
		
		static public function remove(key : String) : void {
			instance().hash_style.remove(key);
			instance().hash_rcfont.remove(key);
		}
		
		static public function getRCFont(key : String = "system",exceptions : * = null) : RCFont {
			return instance().hash_rcfont.get(key).copy(exceptions);
		}
		
		static public function getStyleSheet(key : String = "default",exception : * = null) : flash.text.StyleSheet {
			if(key == "css" && instance().hash_style.exists("css")) return instance().hash_style.get("css");
			return instance().createStyle(INSTANCE.hash_style.get(key),exception);
		}
		
		static public function loadFont(URL : String) : void {
			instance().loadFontSwf(URL);
		}
		
		static public function loadCSS(URL : String) : void {
			instance().loadCSSFile(URL);
		}
		
		static public function enumerateFonts() : Array {
			init();
			return flash.text.Font.enumerateFonts();
		}
		
		static public function registerFont(str : String) : Boolean {
			if(instance().fontsEvent == null) return false;
			var e : * = instance().fontsEvent.target;
			if(e.applicationDomain.hasDefinition(str)) {
				var def : * = e.applicationDomain.getDefinition(str);
				var LoadedFont : Class = function() : Class {
					var $r : Class;
					var $t : * = def;
					if(Std._is($t,Class)) (($t) as Class);
					else throw "Class cast error";
					$r = $t;
					return $r;
				}();
				try {
					flash.text.Font.registerFont(LoadedFont);
				}
				catch( e1 : * ){
					haxe.Log.trace(e1,{ fileName : "FontManager.hx", lineNumber : 172, className : "FontManager", methodName : "registerFont"});
					return false;
				}
				return true;
			}
			return false;
		}
		
	}
}
