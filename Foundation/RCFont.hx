//
//  RCFont
//
//  Created by Cristi Baluta on 2010-10-15.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatDisplay;
import flash.text.StyleSheet;
import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;


class RCFont {
	
	public var html :Bool;
	public var format :TextFormat;
	public var style :StyleSheet;
	
	// TextField properties (only some of them that are more important)
	public var embedFonts :Bool;
	public var type :TextFieldType;
	public var antiAliasType :AntiAliasType;
	public var autoSize :TextFieldAutoSize;
	public var displayAsPassword :Bool;
	public var selectable :Bool;
	public var sharpness :Int;// -400 ... 400
	public var thickness :Float;
	
	// TextFormat properties
	public var align : TextFormatAlign;
	public var blockIndent : Null<Float>;
	public var bold : Null<Bool>;
	public var bullet : Null<Bool>;
	public var color : Null<UInt>;
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
	public var tabStops : Array<UInt>;
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
	
	
	public function new () {
		
		html = true;
		embedFonts = true;
		type = TextFieldType.DYNAMIC;
		antiAliasType = AntiAliasType.ADVANCED;// ADVANCED-normal fonts(<40px), NORMAL-pixel fonts
		autoSize = TextFieldAutoSize.LEFT;
		selectable = false;
		
		format = new TextFormat();
		style = new StyleSheet();
	}
		
	public function copy (?exceptions:Dynamic) :RCFont {
		
		var rcfont = new RCFont();
		var fields = Type.getInstanceFields ( RCFont );
		
		// Copy all RCFont properties to the new object
		for (field in fields) {
			if (field == "copy") continue;
			//trace(field+", "+Reflect.field (this, field));
			Reflect.setField (rcfont, field, Reflect.field (this, field));
		}
		
		if (exceptions != null) {
			for (excp in Reflect.fields ( exceptions )) {
				if (Reflect.hasField (rcfont, excp)) {
					Reflect.setField (rcfont, excp, Reflect.field (exceptions, excp));
				}
			}
		}
		
		rcfont.format = new TextFormat();
		rcfont.format.align = rcfont.align;
		rcfont.format.blockIndent = rcfont.blockIndent;
		rcfont.format.bold = rcfont.bold;
		rcfont.format.bullet = rcfont.bullet;
		rcfont.format.color = rcfont.color;
		//rcfont.format.display = rcfont.display;
		rcfont.format.font = rcfont.font;
		rcfont.format.italic = rcfont.italic;
		rcfont.format.indent = rcfont.indent;
		rcfont.format.kerning = rcfont.kerning;
		rcfont.format.leading = rcfont.leading;
		rcfont.format.leftMargin = rcfont.leftMargin;
		rcfont.format.letterSpacing = rcfont.letterSpacing;
		rcfont.format.rightMargin = rcfont.rightMargin;
		rcfont.format.size = rcfont.size;
		rcfont.format.tabStops = rcfont.tabStops;
		rcfont.format.target = rcfont.target;
		rcfont.format.underline = rcfont.underline;
		rcfont.format.url = rcfont.url;
		
		return rcfont;
	}
}
