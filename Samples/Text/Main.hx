//
//  Main
//
//  Created by Baluta Cristian on 2008-03-21.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

class Main {
	inline static var MC = flash.Lib.current.stage;
	
	/**
	 * Start the Application
	 */
	static function main () {
		haxe.Firebug.redirectTraces();
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		
		RCLib.onComplete = init;
		RCLib.loadFontWithKey ("font", 'lucida_r.swf');
		RCLib.loadFileWithKey ("css", 'styles.css?' + Math.random());
		// << \\
	}
	
	
	/**
	 * Init the application
	 */
	public static function init () {
		
		// register fonts, formats and stylesheets
		FontManager.init();
		FontManager.addSwf ( RCLib.getFileWithKey("font").event );
		FontManager.setCSS ( RCLib.getFileWithKey("css") );
		RegisterFonts.init();
		
		// Begin to use fonts, formats and stylesheets
		MC.addChild ( new RCTextView (18, 10, null, null, "<u>FontManager for AS3 (haXe and Flash)</u>", FontManager.getRCFont("title")));
		//
		var fontNames = new Array<String>();
		for (f in FontManager.enumerateFonts()) {
			fontNames.push (f.fontName);
		}
		var str = "Embeded fonts you can use in this application are: "+fontNames.join(", ");
		MC.addChild ( new RCTextView (20, 80, 200, null, str, FontManager.getRCFont("normal", {selectable: true}) ) );
		//
		var str = "But you can also use system fonts that are not embeded or loaded at runtime. This is a sample with <u>Arial</u> wich is also the default format when none specified and you don't need to register it. It's called 'system':<br>FontManager.getTextFormat()";
		MC.addChild ( new RCTextView (20, 200, 250, null, str, FontManager.getRCFont()) );
		//
		var str = "Or maybe you prefer <u><i>Times</i></u> wich is derived from previous format by applying some exceptions:<br>FontManager.getTextFormat('system', {font:'Times'})";
		MC.addChild ( new RCTextView (20, 350, 250, null, str, FontManager.getRCFont("system", {font:"Times", selectable: true, embedFonts: false})) );
		//
		
		// some stylesheet sample
		var str = "Stylesheet sample with <a href='self'>link to nowhere</a> and <h1>h1 style</h1>.<br>FontManager.getStyleSheet('normal') and i applyed also FontManager.getTextFormat('normal')";
		MC.addChild ( new RCTextView (20, 500, 250, null, str, FontManager.getRCFont("normal", {style: FontManager.getStyleSheet("normal"), selectable: true})) );
		
		//
		var usage:String = "<title>Usage:</title>
1. Init the FontManager and load fonts and/or styles:
<code>FontManager.onCSSLoaded = initTheApplicationNow;
FontManager.onFontLoaded = callback (FontManager.loadCSS, 'styles.css');
FontManager.onInit = callback (FontManager.loadFont, 'lucida_r.swf');
FontManager.init();</code>

2. Register loaded fonts(to register a font that you loaded from the swf you need a Class that extends Font Class in the same package with the one from the swf), textformats and stylesheets:
<code>FontManager.registerFont ('resources.fonts.CustomFontR');

FontManager.registerFormat ('normal',
	{font: new resources.fonts.CustomFontR().fontName,
	size: 12, color: 0xFFFFFF, letterSpacing: 0, leading: 4});

FontManager.registerStyle ('normal',
	{a_link :{color:'#999999', textDecoration:'underline'},
	a_hover :{color:'#33CCFF', textDecoration:'none'},
	h1		:{color:'#FFFFFF', fontSize:26},
	title	:{fontFamily:'FFF Urban_8pt_st', fontWeight:'bold'},
	code	:{color:'#65cbff', letterSpacing:0, selection:true}});</code>

3. Properties are stored as Objects. To get them ready to use, call:
<code>format = FontManager.getTextFormat ('normal');
style = FontManager.getStyleSheet ('normal');
style2 = FontManager.getStyleSheet ('css');</code>
And apply them to textfield, both or only one:
<code>tf = new TextField();
tf.defaultTextFormat = format;
tf.setTextFormat ( format );
tf.styleSheet = style;</code>
*'css' is the stylesheet loaded from css file and parsed";
		
		MC.addChild ( new RCTextView (300, 50, 400, null, usage, FontManager.getRCFont("pixel")) );
					
		// Download links
		var dld:String = "<title>Download:</title>
1. <a href='FontManager.hx' target='_blank'>View FontManager.hx source</a>		
2. <a href='styles.css' target='_blank'>View CSS applyed to this text</a>
3. <a href='FontManager.zip' target='_blank'>Download all files</a>";
		
		MC.addChild ( new RCTextView (750, 50, 260, null, dld, FontManager.getRCFont("pixel")) );
		
		readFile();
	}
	
	// Read an external txt file and display its content
	static function readFile () :Void {
		var loader = new URLLoader();
		loader.addEventListener (Event.COMPLETE, completeHandler);
		
		var request = new URLRequest ( "_info.txt?"+Math.random() );
		loader.load ( request );
	}
	// Add to stage the content from loaded txt file
	static function completeHandler (e:Event) :Void {
		var txt = new RCTextView (750, 186, 260, 100, e.target.data, FontManager.getRCFont("normal", {antiAliasType: flash.text.AntiAliasType.NORMAL}));
		MC.addChild ( txt );
		Fugu.safeDestroy ( txt );
	}
}
