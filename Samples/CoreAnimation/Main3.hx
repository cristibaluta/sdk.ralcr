//
//  Main3
//
//  Created by Cristi Baluta on 2010-05-28.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class Main3 extends RCView {
	
	static var txt :RCTextView;
	static var bg :RCRectangle;
	
	static function main () :Void {
		haxe.Firebug.redirectTraces();
		RCWindow.sharedWindow().addChild ( new RCStats (5, 5) );
		RCWindow.sharedWindow().addChild ( new Main3() );
	}
	
	function new () {
		super(0,0);
		txt = new RCTextView (50, 50, 500, 20, "", RCFont.systemFontOfSize(20));
		this.addChild ( txt );
		
		var obj = new CATText (txt, {text:"What's this fuss about true randomness? Perhaps you have wondered...", html:false}, 2, 0, caequations.Cubic.IN_OUT);
		CoreAnimation.add (obj);
		
		
		var el = new RCEllipse (100, 180, 100, 100, 0xff3300);
		this.addChild ( el );
		
		//var o2 = new CATBezier (rect, {points:[new Point(500,400), new Point(200,500), new Point(350,50)]}, 3.6, 0, caequations.Cubic.IN_OUT);
		
		var o1 = new CATween (el, {x:200}, 3, 0, caequations.Cubic.IN_OUT);
		trace(o1);
		var o3 = new CATFilters (el, {blur:120, alpha:0}, .6, 0, caequations.Cubic.IN_OUT);
			o3.autoreverses = true;
			o3.repeatCount = 20;
		CoreAnimation.add (o3);
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
