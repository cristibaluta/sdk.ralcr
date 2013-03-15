import flash.filters.ColorMatrixFilter;

class Main2 {
	static var photo :RCImage;
	static var bg :RCRectangle;
	
	static function main () :Void {
		haxe.Firebug.redirectTraces();
		RCWindow.sharedWindow().addChild ( new RCStats (5, 5) );
		
		photo = new RCImage (200, 0, "3134265_large.jpg");
		photo.onComplete = fadePhoto;
		RCWindow.sharedWindow().addChild ( photo );
		
		bg = new RCRectangle (0, 100, 200, 300, 0x999999);
		//bg.setColor (0xffffff);
		RCWindow.sharedWindow().addChild ( bg );
		trace (bg.layer.transform.colorTransform);
		
		var obj = new CATColors (bg, {color:0x000000}, 4, 0, eq.Cubic.IN_OUT);
		RCAnimation.add (obj);
	}
	static function fadePhoto(){
		
		var cm = new ColorMatrix();
			cm.adjustBrightness (100);
			//cm.adjustContrast (20);
			//cm.adjustSaturation (-20);
			//cm.adjustHue (70);
		
		photo.layer.filters = [new ColorMatrixFilter(cm.toArray())];
			
		//Fugu.brightness (photo, 50);
		//new catransitions.Brightness().setBrightness (photo, 50);
		
		return;
		var obj = new CATBrightness (photo, {brightness:{fromValue:-50, toValue:150}}, 1, 0, eq.Cubic.OUT);
			obj.autoreverses = true;
			obj.repeatCount = 13;
		RCAnimation.add (obj);
		
	}
}
