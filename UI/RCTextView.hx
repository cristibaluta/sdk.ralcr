//
//  RCTextView.hx
//
//  Created by Cristi Baluta on 2011-02-01.
//  Updated 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || (openfl && (cpp || neko)))
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
	import js.html.DivElement;
	import RCView;
	private typedef MouseEvent = js.html.Event;
	private typedef TextField = RCView;
#elseif objc
	import ios.ui.UITextView;
	private typedef TextField = UITextView;
#end


class RCTextView extends RCView {
	
	public var target :TextField;
	public var rcfont :RCFont;
	public var text (get, set) :String;
	public var editable (null, set) :Bool;
	
	
	public function new (x:Float, y:Float, w:Null<Float>, h:Null<Float>, str:String, rcfont:RCFont) {
		
		super (Math.round(x), Math.round(y), w, h);
		// This step is very important, otherwise the TextFormat will not be created
		this.rcfont = rcfont.copy();
#if js
		set_width ( size.width );
		set_height ( size.height );
		viewDidAppear.add ( viewDidAppear_ );
#end
		init();
		set_text ( str );
	}
	
	override public function init () :Void {
		
		super.init();
		redraw();
	}
	
#if (flash || (openfl && (cpp || neko)))
	
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
		
		var format = rcfont.get_format();
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
		
		var div;
		
		var wrap = size.width != 0;
		var multiline = size.height != 0;
		
		if (editable) {
			div = js.Browser.document.createElement("textarea");
	/*        untyped div.type = "text";*/
			untyped div.readonly = "true";
	        untyped div.name = "member";
			untyped div.value = "abc";
	        layer.appendChild ( div );
		}
		else {
			div = layer;
		}
		
		div.style.whiteSpace = (wrap ? "normal" : "nowrap");
		div.style.wordWrap = (wrap ? "break-word" : "normal");
		
		var style = (rcfont.selectable ? "text" : "none");
		untyped div.style.WebkitUserSelect = style;
		untyped div.style.MozUserSelect = style;
		
		div.style.lineHeight = (rcfont.leading + rcfont.size) + "px";
		div.style.fontFamily = rcfont.font;
		div.style.fontSize = rcfont.size + "px";
		div.style.fontWeight = (rcfont.bold ? "bold" : "normal");
		div.style.fontStyle = (rcfont.italic ? "italic" : "normal");
		div.style.letterSpacing = rcfont.letterSpacing + "px";
		div.style.textAlign = rcfont.align;// "center", "left", "right"
		div.style.color = RCColor.HEXtoString ( rcfont.color );
		
		if (rcfont.autoSize) {
			div.style.width = multiline ? size.width + "px" : "auto";
			div.style.height = "auto";
		}
		else {
			div.style.width = size.width + "px";
			div.style.height = size.height + "px";
		}
		
		if (size.width != 0) set_width ( size.width );
		//layer.style.textAlign = rcfont.align;
	}
	
	function viewDidAppear_ () :Void {
		size.width = contentSize_.width;
	}
	
#elseif objc
	
	public function redraw () :Void {
		
		// Remove the previous textfield
		if (target != null)
		if (this.layer.contains ( target ))
			this.layer.removeChild ( target );
		
		// Create a new textfield
		target = new TextField();
		target.frame = new CGRect (0, 0, size.width, size.height);
		target.font = UIFont.systemFontOfSize ( rcfont.size );
		target.textColor = rcfont.color;
		target.textAlignment = switch (rcfont.align) {
			case "center": NSTextAlignmentCenter;
			case "right": NSTextAlignmentRight;
			default : NSTextAlignmentLeft;
		};
		target.wordWrap = (size.width == 0) ? false : true;
		target.multiline = (size.height == 0) ? false : true;
		target.selectable = rcfont.selectable;
		target.border = false;
		
		if (size.width != 0)	target.width = size.width * RCDevice.currentDevice().dpiScale;
		if (size.height != 0)	target.height = size.height * RCDevice.currentDevice().dpiScale;
		
		
		layer.addSubview ( target );
	}
	
#end
	
	public function get_text() :String {
		return #if (flash || (openfl && (cpp || neko))) target.text #elseif js layer.innerHTML #end;
	}
	
	public function set_text (str:String) :String {
		
		#if (flash || (openfl && (cpp || neko)))
			
			if (rcfont.html)
				target.htmlText = str;
			else
				target.text = str;
			
		#elseif js
			
			if (editable) {
				
			}
			else if (rcfont.html) {
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
			size.width = contentSize_.width;
			//set_width ( size.width );
		#end
		
		#if openfl
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
	
	public function set_editable (e:Bool) :Bool {
		trace('set editable $e');
		editable = e;
		
		#if (flash || (openfl && (cpp || neko)))
			
			target.type = TextFieldType.INPUT;
/*			textView.target.type = TextFieldType.INPUT;
			textView.target.autoSize = TextFieldAutoSize.NONE;
			textView.target.antiAliasType = rcfont.antiAliasType;
			textView.target.sharpness = rcfont.sharpness;
			textView.target.wordWrap = (size.width == null) ? false : true;
			textView.target.multiline = (size.height == 0) ? false : true;
			textView.target.selectable = true;*/
			
		#elseif js
			
			redraw();
			
		#end
		return e;
	}
	
	override public function destroy () {
		#if (flash || (openfl && (cpp || neko)))
			layer.removeChild ( target );
		#end
		target = null;
		rcfont = null;
		super.destroy();
	}
}