//
//  RCFont.hx
//
//  Created by Cristi Baluta on 2010-10-15.
//  Copyright (c) 2010-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	#if (cpp || neko)
		private typedef TextFormatDisplay = Dynamic;
		private typedef StyleSheet = Dynamic;
		private typedef AntiAliasType = Dynamic;
	#else
		import flash.text.TextFormatDisplay;
		import flash.text.StyleSheet;
		import flash.text.AntiAliasType;
	#end
#elseif js
	private typedef TextFieldType = Dynamic;
	private typedef TextFormat = Dynamic;
	private typedef TextFormatAlign = Dynamic;
	//typedef TextFieldAutoSize = Dynamic;
	private typedef TextFormatDisplay = Dynamic;
	private typedef StyleSheet = Dynamic;
	private typedef AntiAliasType = Dynamic;
#end


class RCFont {
	
	public var html :Bool;
	public var format (getFormat, null) :TextFormat;
	public var style (getStyleSheet, null) :StyleSheet;
	
	// TextField properties (only some of them that are more important)
	public var embedFonts :Bool;
	public var type :TextFieldType;
	public var antiAliasType :AntiAliasType;
	public var autoSize :Bool;//TextFieldAutoSize;
	public var displayAsPassword :Bool;
	public var selectable :Bool;
	public var sharpness :Int;// -400 ... 400
	public var thickness :Float;
	
	// TextFormat properties
	public var align : String;// TextFormatAlign; center, left, right
	public var blockIndent : Null<Float>;
	public var bold : Null<Bool>;
	public var bullet : Null<Bool>;
	public var color : Null<Int>;
	public var display : TextFormatDisplay;
	public var font : String;
	public var indent : Null<Float>;
	public var italic : Null<Bool>;
	public var kerning : Null<Bool>;
	public var leading : Null<Float>;
	public var leftMargin : Null<Float>;
	public var letterSpacing : Null<Float>;
	public var rightMargin : Null<Float>;
	public var size : Null<Float>;
	public var tabStops : Array<Int>;
	public var target : String;
	public var underline : Null<Bool>;
	public var url :String;
	
	// Stylesheet properties
/*	public var color :String;
	public var display :String;
	public var fontFamily :String;
	public var fontSize :String;
	public var fontStyle :String;
	public var fontWeight :String;
	public var kerning :String;
	public var leading :String;
	public var letterSpacing :String;
	public var marginLeft :String;
	public var marginRight :String;
	public var textAlign :String;
	public var textDecoration :String;
	public var textIndent :String;*/
	
	
	// Some convenience methods to create fast a rcfont
	
	/**
	 *  This will create an embedded font.
	 *  @param fontName - the name of the font
	 *  @param size - the size of the font
	 **/
	public static function fontWithName (fontName:String, size:Int) :RCFont {
		var fnt = new RCFont();
			fnt.font = fontName;
			fnt.size = size;
		return fnt;
	}

	/**
	* Returns an array of font family names for all installed fonts
	*/
	public static function familyNames () :Array<Dynamic> {
		#if flash
			return flash.text.Font.enumerateFonts();
		#else
			return [];
		#end
	}
	
	
	// Some convenience methods to create system fonts
	
	/**
	 *  This will create an Arial font, non embedded.
	 *  @param size - the size of the font
	 **/
	public static function systemFontOfSize (size:Int) :RCFont {
		var fnt = new RCFont();
			fnt.size = size;
			fnt.embedFonts = false;
		return fnt;
	}
	
	/**
	 *  This will create an Arial font, non embedded, and bold.
	 *  @param size - the size of the font
	 **/
	public static function boldSystemFontOfSize (size:Int) :RCFont {
		var fnt = systemFontOfSize(size);
			fnt.bold = true;
		return fnt;
	}
	
	/**
	 *  This will create an Arial font, non embedded, and italic.
	 *  @param size - the size of the font
	 **/
	public static function italicSystemFontOfSize (size:Int) :RCFont {
		var fnt = systemFontOfSize(size);
			fnt.italic = true;
		return fnt;
	}
	
	
	
	/**
	 *  This will create a RCFont with the following settings
	 *  @param font = Arial
	 *  @param html = true
	 *  @param embedFonts = true
	 *  @param autoSize = true
	 *  @param selectable = true
	 *  @param color = 0xDDDDDD
	 *  @param size = 12
	 **/
	
	public function new () {
		
		font = "Arial";
		html = true;
		embedFonts = true;
		autoSize = true;
		selectable = false;
		color = 0xDDDDDD;
		size = 12;
		leading = 4;
		leftMargin = 0;
		rightMargin = 0;
		letterSpacing = 0;
		
#if (flash || nme)
	#if flash
		antiAliasType = AntiAliasType.ADVANCED;// ADVANCED-normal fonts(<40px), NORMAL-pixel fonts
		style = new StyleSheet();
	#end
		format = new TextFormat();
		type = TextFieldType.DYNAMIC;
#elseif js
		format = {};
		style = {};
#end
	}
	
	/**
	 *  Make a copy of the RCFont
	 **/
	public function copy (?exceptions:Dynamic) :RCFont {
		
		var rcfont = new RCFont();
		var fields = Type.getInstanceFields ( RCFont );
		
		// Copy all RCFont properties to the new object
		for (field in fields) {
			// Restricted fields
			if (field == "copy" || field == "getFormat" || field == "getStyleSheet" || field == "get_format" || field == "get_style") continue;
			Reflect.setField (rcfont, field, Reflect.field (this, field));
		}
		
		// Apply exceptions to the valid properties of an RCFont
		if (exceptions != null) {
			for (excp in Reflect.fields ( exceptions )) {
				#if cpp
					// cpp fix where hasField is not working on class members. Issue 148 on hxcpp
					Reflect.setField (rcfont, excp, Reflect.field (exceptions, excp));
				#else
				if (Reflect.hasField (rcfont, excp)) {
					Reflect.setField (rcfont, excp, Reflect.field (exceptions, excp));
				}
				#end
			}
		}
		
		return rcfont;
	}
	
	
	/**
	 *  Create a TextFormat from the properties of the RCFont
	 **/
	public function getFormat () :TextFormat {
		// Copy the right properties from rcfont to the format
		format.align = null;// This property is replaced in the textfield
		format.blockIndent = blockIndent;
		format.bold = bold;
		format.bullet = bullet;
		format.color = color;
		//format.display = display;
		format.font = font;
		format.italic = italic;
		format.indent = indent;
		format.kerning = kerning;
		format.leading = leading * RCDevice.currentDevice().dpiScale;
		format.leftMargin = leftMargin * RCDevice.currentDevice().dpiScale;
		format.letterSpacing = letterSpacing;
		format.rightMargin = rightMargin * RCDevice.currentDevice().dpiScale;
		format.size = size * RCDevice.currentDevice().dpiScale;
		format.tabStops = tabStops;
		format.target = target;
		format.underline = underline;
		format.url = url;
		
		return format;
	}
	public function getStyleSheet () :StyleSheet {
		return style;
	}
}
