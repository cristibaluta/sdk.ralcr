//
//  RCColor
//
//  Created by Cristi Baluta on 2010-10-08.
//  Copyright (c) 2010-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (js || cpp || neko)
	private typedef UInt = Int;
#end

class RCColor {
	
	inline public static var BLACK = 0x000000;
	inline public static var WHITE = 0xffffff;
	inline public static var RED = 0xff0000;
	inline public static var GREEN = 0x00ff00;
	inline public static var BLUE = 0x0000ff;
	inline public static var CYAN = 0x00ffff;
	inline public static var YELLOW = 0xffff00;
	
	// Some convenience methods to create colors.
	public static function blackColor ()		:RCColor { return colorWithWhite(0); }
	public static function darkGrayColor ()		:RCColor { return colorWithWhite(0.333); }
	public static function lightGrayColor ()	:RCColor { return colorWithWhite(0.667); }
	public static function whiteColor ()		:RCColor { return colorWithWhite(1); }
	public static function grayColor ()			:RCColor { return colorWithWhite(0.5); }
	public static function redColor ()			:RCColor { return colorWithRGBA(1, 0, 0); }
	public static function greenColor ()		:RCColor { return colorWithRGBA(0, 1, 0); }
	public static function blueColor ()			:RCColor { return colorWithRGBA(0, 0, 1); }
	public static function cyanColor ()			:RCColor { return colorWithRGBA(0, 1, 1); }
	public static function yellowColor ()		:RCColor { return colorWithRGBA(1, 1, 0); }
	public static function magentaColor ()		:RCColor { return colorWithRGBA(1, 0, 1); }
	public static function orangeColor ()		:RCColor { return colorWithRGBA(1, 0.5, 0); }
	public static function purpleColor ()		:RCColor { return colorWithRGBA(0.5, 0, 0.5); }
	public static function brownColor ()		:RCColor { return colorWithRGBA(0.6, 0.4, 0.2); }
	public static function clearColor ()		:RCColor { return colorWithWhite(0, 0); }
	
	public var fillColor :Null<UInt>;
	public var strokeColor :Null<UInt>;
	public var fillColorStyle :String;
	public var strokeColorStyle :String;
	
	public var redComponent :Float;
	public var greenComponent :Float;
	public var blueComponent :Float;
	public var alpha :Float;
	
	
	
	// Convenience methods for creating colors
	public static function colorWithWhite (white:Float, alpha:Float=1.0) :RCColor {
		return new RCColor ( RGBtoHEX (white, white, white), null, alpha);
	}
	public static function colorWithRGBA (red:Float, green:Float, blue:Float, alpha:Float=1.0) :RCColor {
		return new RCColor ( RGBtoHEX (red, green, blue), null, alpha);
	}
	public static function colorWithHSBA (hue:Float, saturation:Float, brightness:Float, alpha:Float=1.0) :RCColor {
		return new RCColor ( RGBtoHEX (hue, saturation, brightness), null, alpha);
	}
	public static function colorWithFillAndStroke (fillColor:Null<UInt>, ?strokeColor:Null<UInt>) {
		return new RCColor (fillColor, strokeColor);
	}
	
	
	
	
	public function new (fillColor:Null<UInt>, ?strokeColor:Null<UInt>, ?a:Null<Float>) {
		
		this.fillColor = fillColor;
		this.strokeColor = strokeColor;
		this.alpha = (a == null) ? 1.0 : a;
		
		redComponent = (fillColor >> 16 & 0xFF) / 0xFF;
		greenComponent = (fillColor >> 8 & 0xFF) / 0xFF;
		blueComponent = (fillColor & 0xFF) / 0xFF;
		
		// html colors
		fillColorStyle = HEXtoString ( fillColor );
		strokeColorStyle = HEXtoString ( strokeColor );
	}
	
	
	public static function HEXtoString (color:Null<UInt>) :String {
		if (color == null) return null;
		return "#" + StringTools.lpad(StringTools.hex(color), "0", 6);
	}
	public static function RGBtoHEX (r:Float, g:Float, b:Float) :Int {
		return Math.round(r*0xFF) << 16 | Math.round(g*0xFF) << 8 | Math.round(b*0xFF);
	}
}
