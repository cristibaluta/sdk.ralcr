//
//  RCTextView.hx
//
//  Created by Cristi Baluta on 2011-02-01.
//  Updated 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	#if flash
		import flash.text.AntiAliasType;
	#end
#elseif js
	import js.Dom;
	import RCView;
	private typedef MouseEvent = Event;
	private typedef TextField = RCView;
#end


class RCTextView extends RCView {
	
	public var target :TextField;
	public var rcfont :RCFont;
	public var text (getText, setText) :String;
	
	
	public function new (x:Float, y:Float, w:Null<Float>, h:Null<Float>, str:String, rcfont:RCFont) {
		
		super (Math.round(x), Math.round(y), w, h);
		// This step is very important, otherwise the TextFormat will not be created
		this.rcfont = rcfont.copy();
#if js
		setWidth ( size.width );
		setHeight ( size.height );
		viewDidAppear.add ( viewDidAppear_ );
#end
		init();
		setText ( str );
	}
	override public function init () :Void {
		
		super.init();
		redraw();
	}
	
#if (flash || nme)
	
	public function redraw () :Void {
		
		// Remove the previous textfield
		if (target != null)
		if (this.layer.contains ( target ))
			this.layer.removeChild ( target );
		
		// Create a new textfield
		target = new TextField();
		target.embedFonts = rcfont.embedFonts;
		target.type = rcfont.type;
		
		#if flash
			// AutoSize does not work on NME cpp and neko targets
			target.autoSize = switch (rcfont.align) {
				case "center": flash.text.TextFieldAutoSize.CENTER;
				case "right": flash.text.TextFieldAutoSize.RIGHT;
				default : flash.text.TextFieldAutoSize.LEFT;
			};
			// antiAliasType and sharpness does not exist in NME
			target.antiAliasType = rcfont.antiAliasType;
			target.sharpness = rcfont.sharpness;
			//if (rcfont.style != null) target.styleSheet = rcfont.style;
		#else
			// If NME, autoSize the textfield to left, will align it later
			target.autoSize = flash.text.TextFieldAutoSize.LEFT;
		#end
		
		target.wordWrap = (size.width == 0) ? false : true;
		target.multiline = (size.height == 0) ? false : true;
		target.selectable = rcfont.selectable;
		target.border = false;
		
		if (size.width != 0)	target.width = size.width * RCDevice.currentDevice().dpiScale;
		if (size.height != 0)	target.height = size.height * RCDevice.currentDevice().dpiScale;
		
		var format = rcfont.getFormat();
		format.align = switch (rcfont.align) {
						case "center": TextFormatAlign.CENTER;
						case "right": TextFormatAlign.RIGHT;
						default: TextFormatAlign.LEFT;
					};
		target.defaultTextFormat = format;// This approach doesn't work on NME
		target.setTextFormat ( format );
		
		layer.addChild ( target );
	}
	
#elseif js
	
	public function redraw () :Void {
		
		var wrap = size.width != 0;
		var multiline = size.height != 0;
		
		layer.style.whiteSpace = (wrap ? "normal" : "nowrap");
		layer.style.wordWrap = (wrap ? "break-word" : "normal");
		
		var style = (rcfont.selectable ? "text" : "none");
		untyped layer.style.WebkitUserSelect = style;
		untyped layer.style.MozUserSelect = style;
		
		layer.style.lineHeight = (rcfont.leading + rcfont.size) + "px";
		layer.style.fontFamily = rcfont.font;
		layer.style.fontSize = rcfont.size + "px";
		layer.style.fontWeight = (rcfont.bold ? "bold" : "normal");
		layer.style.fontStyle = (rcfont.italic ? "italic" : "normal");
		layer.style.letterSpacing = rcfont.letterSpacing + "px";
		layer.style.textAlign = rcfont.align;// "center", "left", "right"
		layer.style.color = RCColor.HEXtoString ( rcfont.color );
		untyped layer.style.contentEditable = "true";
		if (rcfont.autoSize) {
			layer.style.width = multiline ? size.width + "px" : "auto";
			layer.style.height = "auto";
		}
		else {
			layer.style.width = size.width + "px";
			layer.style.height = size.height + "px";
		}
		
		if (size.width != 0) setWidth ( size.width );
		//layer.style.textAlign = rcfont.align;
	}
	function viewDidAppear_ () :Void {
		size.width = contentSize.width;
	}
	
#end
	
	public function getText() :String {
		return #if (flash || nme) target.text #elseif js layer.innerHTML #end;
	}
	
	public function setText (str:String) :String {
		#if (flash || nme)
			
			if (rcfont.html)
				target.htmlText = str;
			else
				target.text = str;
			
		#elseif js
			
			if (rcfont.html) {
				layer.innerHTML = str;
			}
			else {
/*				var content:String = Std.string(str);
				content = content.split("\n").join("~~~NEWLINE~~~");
				content = content.split("\t").join("~~~TAB~~~");
				content = StringTools.htmlEscape(content);
				content = content.split("~~~NEWLINE~~~").join("<br/>");
				content = content.split("~~~TAB~~~").join("<span style='letter-spacing:1.3em'>&nbsp;</span>");*/
				layer.innerHTML = str;
			}
			size.width = contentSize.width;
			//setWidth ( size.width );
		#end
		
		#if nme
			// Align the text by doing some math for NME 
			// because align is not supported in combination with autoSize
			if (size.width != 0)
				target.x = switch (rcfont.align) {
					case "center": Math.round ((size.width - target.width) / 2);
					case "right": Math.round (size.width - target.width);
					default: 0;
				}; 
		#end
		
		return str;
	}
	
	override public function destroy () :Void {
		target = null;
		super.destroy();
	}
}
