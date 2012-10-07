//
//  RegisterFonts
//
//  Created by Baluta Cristian on 2008-12-02.
//  Copyright (c) 2008 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RegisterFonts {
	
	public static function init () :Void {
		
		// register external loaded font
		trace( RCFontManager.registerFont ("resources.fonts.CustomFontR") );
		
		
		// create styles
		FontManager.registerStyle ("normal", {	a_link	:{color:"#999999", textDecoration:"underline"},
												a_hover :{color:"#33CCFF", textDecoration:"none"},
												h1		:{/*fontFamily:"ArcherBook", */color:"#FFFFFF", fontSize:26},
												title	:{fontFamily:'FFF Urban_8pt_st', fontWeight:'bold'},
												code	:{color:"#65cbff", letterSpacing:0, selection:true}}
									);
		
		
		var fontNormal = new RCFont();
			fontNormal.font = new resources.fonts.CustomFontR().fontName;
			fontNormal.size = 12;
			fontNormal.color = 0xFFFFFF;
			fontNormal.leading = 4;
			fontNormal.letterSpacing = 0;
			fontNormal.align = flash.text.TextFormatAlign.LEFT;
			fontNormal.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			fontNormal.html = true;
			fontNormal.selectable = true;
			fontNormal.style = RCFontManager.getStyleSheet("css");
			//trace(new CustomFontR());
			trace(fontNormal.font);
		FontManager.registerRCFont ("normal", fontNormal);
		
		//
		var fontNormal = new RCFont();
			fontNormal.font = new resources.fonts.CustomFontR().fontName;
			fontNormal.size = 22;
			fontNormal.color = 0xFFFFFF;
			fontNormal.leading = 4;
			fontNormal.letterSpacing = 0;
			fontNormal.align = flash.text.TextFormatAlign.LEFT;
			fontNormal.antiAliasType = flash.text.AntiAliasType.NORMAL;
			fontNormal.html = true;
			fontNormal.selectable = true;
			
		FontManager.registerRCFont ("title", fontNormal);
		
		//
		var fontNormal = new RCFont();
			fontNormal.font = new resources.fonts.UrbanR().fontName;
			fontNormal.size = 8;
			fontNormal.color = 0xFFFFFF;
			fontNormal.leading = 4;
			fontNormal.letterSpacing = 1;
			fontNormal.align = flash.text.TextFormatAlign.LEFT;
			fontNormal.antiAliasType = flash.text.AntiAliasType.NORMAL;
			fontNormal.html = true;
			fontNormal.selectable = true;
			fontNormal.style = RCFontManager.getStyleSheet("normal");
			
		FontManager.registerRCFont ("pixel", fontNormal);
	}
	
}
