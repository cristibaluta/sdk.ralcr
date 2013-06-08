
class RegisterFonts {
	
	inline public static var REGULAR = "regular";
	
	
	public static function init () :Void {
		
		try {
		
		#if openfl
			//var fnt1 = nme.Assets.getFont ("assets/HeadlinerNo.45.otf");
		#else
			//var fnt1 = new fonts.Headliner();
		#end
		
		var fr = new RCFont();
			//fr.font = fnt1.fontName;
			fr.size = 25;
			fr.color = 0xFFFFFF;
			fr.letterSpacing = 0;
			fr.leading = 1;
			
			
		RCFontManager.registerFont (REGULAR, fr);
		
		} catch (e:Dynamic) { trace(e); }
		
		// create styles
		RCFontManager.registerStyle ("default",
		{{	a_link	:{color : "#FFFFFF", textDecoration : "underline"/*, font : new fonts.FuturaBk().fontName*/},
			a_hover :{color : "#cccccc", textDecoration : "underline"}/*,
			h1		:{color : color_d, fontSize : size_h1}*/
		}});
	}
}
