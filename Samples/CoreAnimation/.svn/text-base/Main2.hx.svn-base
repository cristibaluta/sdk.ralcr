import flash.filters.ColorMatrixFilter;

class Main2 {
	static var photo :RCPhoto;
	static var bg :RCRectangle;
	
	static function main () :Void {
		haxe.Firebug.redirectTraces();
		RCStage.init();
		RCStage.addChild ( new RCStats (5, 5) );
		
		photo = new RCPhoto (200, 0, "3134265_large.jpg");
		photo.onComplete = fadePhoto;
		RCStage.addChild ( photo );
		
		bg = new RCRectangle (0, 100, 200, 300, 0x999999);
		bg.setColor (0xffffff);
		RCStage.addChild ( bg );
		trace (bg.transform.colorTransform);
		
		var obj = new CATColors (bg, {color:0x000000}, 4, 0, caequations.Cubic.IN_OUT);
		CoreAnimation.add (obj);
	}
	static function fadePhoto(){
		
		var cm = new ColorMatrix();
			cm.adjustBrightness (100);
			//cm.adjustContrast (20);
			//cm.adjustSaturation (-20);
			//cm.adjustHue (70);
		
		photo.filters = [new ColorMatrixFilter(cm.toArray())];
			
		//Fugu.brightness (photo, 50);
		//new catransitions.Brightness().setBrightness (photo, 50);
		
		return;
		var obj = new CATBrightness (photo, {brightness:{fromValue:-50, toValue:150}}, 1, 0, caequations.Cubic.OUT);
			obj.autoreverses = true;
			obj.repeatCount = 13;
		CoreAnimation.add (obj);
		
	}
}
