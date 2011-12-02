//
//  Main3
//
//  Created by Cristi Baluta on 2010-05-28.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.text.TextField;
import flash.display.Sprite;
import flash.geom.Point;


class Main3 extends Sprite {
	
	static var txt :TextField;
	static var bg :RCRectangle;
	
	static function main () :Void {
		haxe.Firebug.redirectTraces();
		RCStage.init();
		RCStage.addChild ( new RCStats (5, 5) );
		RCStage.addChild ( new Main3() );
	}
	
	function new () {
		super();
		txt = new TextField();
		txt.x = 50;
		txt.y = 50;
		txt.width = 500;
		txt.height = 20;
		txt.text = "";
		this.addChild ( txt );
		
		var obj = new CATText (txt, {text:"What's this fuss about true randomness? Perhaps you have wondered..."}, 1, 0, caequations.Cubic.IN_OUT);
		//CoreAnimation.add (obj);
		
		
		var rect = new RCEllipse (100, 180, 100, 100, 0xff3300);
		this.addChild ( rect );
			
		//var o2 = new CATBezier (rect, {points:[new Point(500,400), new Point(200,500), new Point(350,50)]}, 3.6, 0, caequations.Cubic.IN_OUT);
		
		var o1 = new CATween (rect, {x:200}, 0, 0, caequations.Cubic.IN_OUT);
		trace(o1);
		var o3 = new CATFilters (rect, {blur:120, alpha:0}, .6, 0, caequations.Cubic.IN_OUT);
			o3.autoreverses = true;
			o3.repeatCount = 20;
		//CoreAnimation.add (o3);
		CoreAnimation.add ( o1 );
	}
	
	static function fadePhoto(){
		
		//Fugu.brightness (photo, 50);
		//new catransitions.Brightness().setBrightness (photo, 50);
		
		//return;
/*		var obj = new CAObject (photo, {brightness:{fromValue:-50, toValue:150}}, 1, caequations.Cubic.OUT);
			obj.transition = new catransitions.Brightness();
			obj.autoreverses = true;
			obj.repeatCount = 13;
		CoreAnimation.add (obj);*/
		
	}
}
