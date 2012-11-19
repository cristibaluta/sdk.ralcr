//
//  Main
//
//  Created by Cristi Baluta on 2010-05-28.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCView;
import RCWindow;

class Main {
	
	static var lin :RCLine;
	static var ph :RCImage;
	static var circ :RCEllipse;
	static var req :RCHttp;
	static var win :RCWindow;
	
	// change the HTML content of a DIV based on its ID
	static function main() {
		haxe.Firebug.redirectTraces();
		
		var mousew = new EVMouse ( EVMouse.WHEEL, RCWindow.sharedWindow().target );
			//mousew.add ( function(e:EVMouse){ } );
			//mousew.remove ( wheelHandler );
			//mousew.destroy();
		
			try {
			}
		try{
			
		trace("step1 - RCFont, RCTextView");
		var f = new RCFont();
			f.color = 0xFFFFFF;
			f.font = "Arial";
			f.size = 30;
			f.embedFonts = false;
		var t = new RCTextView (50, 30, null, null, #if flash "FLASH" #else "HTML5" #end, f);
		RCWindow.sharedWindow().addChild ( t );
		trace("t.width "+t.width);
		
		trace("step1 - backgroundColor");
		win = RCWindow.sharedWindow();
		//RCWindow.setTarget ("js");
		win.backgroundColor = 0xefefef;
		
/*		var swf = new RCSwf (200,0,"../HeartEquation/heart.swf");
		RCWindow.addChild(swf);*/
		
/*			var f = new RCFont();
				f.color = 0x000000;
				f.font = "Arial";
				f.size = 30;
				f.embedFonts = false;
			var t = new RCTextView (50, 30, null, null, #if flash "FLASH" #else "HTML5" #end, f);
			RCWindow.sharedWindow().addChild ( t );
			*/
			
		trace("step2 - RCFontManager");
		RCFontManager.init();
		trace("step2 - RCAssets");
		RCAssets.loadFileWithKey("photo", "../assets/900x600.jpg");
		RCAssets.loadFileWithKey("some_text", "../assets/data.txt");
		RCAssets.loadFileWithKey("Urban", "../assets/FFF Urban.ttf");
		RCAssets.loadFontWithKey("Futu", "../assets/FUTUNEBI.TTF");
		RCAssets.onComplete = testJsFont;
		//function(){trace("RCAssets did finish loading assets"); trace(RCAssets.getFileWithKey("some_text"));}
		
		trace("step2 - RCRectangle");
		// Draw a colored rectangle
		var rect = new RCRectangle(0,0, 300, 150, RCColor.redColor());
	 	RCWindow.sharedWindow().addChild ( rect );
		rect.clipsToBounds = true;
		rect.center = new RCPoint (RCWindow.sharedWindow().width/2, RCWindow.sharedWindow().height/2);
		
		trace("step2 - RCImage");
		ph = new RCImage(1, 1, "../assets/900x600.jpg");
		ph.onComplete = resizePhoto;
		rect.addChild ( ph );
		
		trace("step3 - ellipse");
		circ = new RCEllipse(0,0, 100, 100, RCColor.darkGrayColor());
	 	RCWindow.sharedWindow().addChild ( circ );
		//circ.center = new RCPoint(120,120);
		
/*		trace("step4 - CASequence");
		trace(RCWindow.sharedWindow().target.scrollWidth);
		trace(RCWindow.sharedWindow().target.offsetWidth);
		trace(RCWindow.sharedWindow().target.clientWidth);
		trace(RCWindow.sharedWindow().target.scrollHeight);
		trace(RCWindow.sharedWindow().target.offsetHeight);
		trace(RCWindow.sharedWindow().target.clientHeight);*/
		
		
		// Test the animation engine
		var size = RCWindow.sharedWindow().size;trace(size);
		var a1=new CATween (circ, {x:size.width-100, y:0}, 2, 0, caequations.Cubic.IN_OUT);
		var a2=new CATween (circ, {x:size.width-100, y:size.height-100}, 2, 0, caequations.Cubic.IN_OUT);
		var a3=new CATween (circ, {x:0, y:size.height-100}, 2, 0, caequations.Cubic.IN_OUT);
		var a4=new CATween (circ, {x:0, y:0}, 2, 0, caequations.Cubic.IN_OUT);
		var seq = new CASequence ([cast a1, cast a2, cast a3, cast a4]);
		seq.start();
		
		trace("step5 - line");
		lin = new RCLine(30,300, 400, 600, 0xff3300);
		RCWindow.sharedWindow().addChild ( lin );
		
		
		trace("step6 - Keys");
		var k = new RCKeyboardController();
			k.onLeft = moveLeft;
			k.onRight = moveRight;
		
		trace("step7 - Mouse");
		var m = new EVMouse( EVMouse.OVER, rect.layer );
			m.add ( function(_){ trace("onOver"); } );
		
		trace("step8 - text");
		testTexts();
		trace("step8 - signals");
		testSignals();
		trace("step8 - buttons");
		testButtons();
		
		// Shared objects
/*		RCUserDefaults.init("com.ralcr.html5.");
		trace(RCUserDefaults.stringForKey("key1"));
		RCUserDefaults.set ("key1", "blah blah");
		trace(RCUserDefaults.stringForKey("key1"));*/
		
		// Add slider
		trace("step9 - SKSlider");
		var s = new haxe.SKSlider();
		trace("step9 - RCSlider");
		var sl = new RCSlider(50, 250, 160, 10, s);
		//sl.valueChanged.add ( function(e:RCSlider){trace(e.value);} );
		RCWindow.sharedWindow().addChild ( sl );
		sl.maxValue = 500;
		sl.value = 30;
		
		
		
		trace("step10 - Http");
		req = new RCHttp();
		req.onComplete = function (){ trace("http result "+req.result); }
		req.onError = function (){ trace("http error "+req.result); }
		req.onStatus = function (){ trace("http status "+req.status); }
		req.readFile("../assets/data.txt");
		
		trace("step11 - CATCallFunc");
		var anim = new CATCallFunc (setAlpha_, {alpha:{fromValue:0, toValue:1}}, 2.8, 0, caequations.Cubic.IN_OUT);
		CoreAnimation.add ( anim );
		
		
		}catch(e:Dynamic){Fugu.stack(); trace(e); }
    }
	static function setAlpha_ (a:Float){lin.alpha=a;}
	
	static function testJsFont () {
		var f = new RCFont();
			f.color = 0x000000;
			f.font = "Futu";
			f.size = 34;
			f.embedFonts = false;
		var t = new RCTextView (50, 120, null, null, "blah blah blah", f);
		RCWindow.sharedWindow().addChild ( t );
		trace("t.width "+t.width);
	}
	
	
	
/*	static function moveLine(e:Event){
		lin.size.width = e.clientX - lin.x;
		lin.size.height = e.clientY - lin.y;
		lin.redraw();
	}*/
	static function resizePhoto(){
		//ph.scaleToFill (300-2, 150-2);
		//ph.scaleToFit (300-2, 150-2);
		trace("startResizing");
		//ph.height = 50;
		#if js
/*			ph.layer.style.height = "50px";
			ph.layer.style.margin = "50px 50px 50px 50px";
			
			var r = js.Lib.document.getElementById("flash");
			r.style.height = 20+"px";*/
		#end
		
/*		trace(ph.width+", "+ph.height);
		trace(ph.size.width+", "+ph.size.height);*/
		
		var ph2 = ph.copy();
		RCWindow.sharedWindow().addChild ( ph2 );
		trace(ph.contentSize);
		//trace(ph2.contentSize);
		
		var scrollview = new RCScrollView (780, 10, 300, 300);
		RCWindow.sharedWindow().addChild( scrollview );
		scrollview.setContentView ( ph2 );
		
		var anim = new CATween (ph, {x:{fromValue:-ph.width, toValue:ph.width}}, 2, 0, caequations.Cubic.IN_OUT);
			anim.repeatCount = 5;
			anim.autoreverses = true;
		CoreAnimation.add ( anim );
	}
	
	
	static function moveLeft(){
		circ.x -= 10;
	}
	static function moveRight(){
		circ.x += 10;
	}


	static var signal :RCSignal<Int->Void>;
	static function testSignals(){
		signal = new RCSignal<Int->Void>();
		signal.add ( printNr );
		signal.addOnce ( printNr2 );
		signal.remove ( printNr );
		signal.removeAll();
		for (i in 0...5)
		signal.dispatch ( Math.random() );
	}
	static function printNr(nr:Int){
		//trace("printNr "+nr);
	}
	static function printNr2(nr:Int){
		//trace("printNr2 "+nr);
	}
	
	
	
	static function testButtons(){try{
		// Add some buttons
		var s = new haxe.SKButton("Switch");
		var b = new RCButton(50, 200, s);

		RCWindow.sharedWindow().addChild ( b );
		//trace("b.width "+b.width);
		
		b.onRelease = function(){ HXAddress.href(#if flash "js.html" #else "flash.html" #end); }
		b.onOver = function(){trace("over");}
		b.onOut = function(){trace("out");}
		b.onPress = function(){trace("press");}
		
		var s = new haxe.SKButtonRadio();
		var b = new RCButtonRadio(50, 230, s);
		RCWindow.sharedWindow().addChild ( b );
		
		var group = new RCGroup<RCButtonRadio> (50,200,0,null,createRadioButton);
		RCWindow.sharedWindow().addChild ( group );
		group.add([1,2,3,4,5,5]);
		
		var seg = new RCSegmentedControl (100,400, 640,50, ios.SKSegment);
		RCWindow.sharedWindow().addChild ( seg );
		seg.initWithLabels (["Masculin","Feminin","123","Label 12345"], false);
		//seg.backgroundColor = 0x000000;
		seg.click.add(segClick);
		
		}catch(e:Dynamic){Fugu.stack();}
	}
	static function createRadioButton (indexPath:RCIndexPath) :RCButtonRadio {
		var s = new haxe.SKButtonRadio();
		//var s = new SkinButtonWithText ("blah blah", null);
		var b = new RCButtonRadio(0,0,s);
		return b;
	}
	static function segClick (s:RCSegmentedControl) {
		trace(s.selectedIndex);
	}
	
	
	static function testTexts(){try{
		var f = new RCFont();
			f.color = 0xFFFFFF;
			f.font = "Arial";
			f.size = 30;
			f.embedFonts = false;
		var t = new RCTextView (50, 30, null, null, #if flash "FLASH" #else "HTML5" #end, f);
		RCWindow.sharedWindow().addChild ( t );
		trace("t.width "+t.width);
		
		var f2 = f.copy();
			f2.color = 0xffffff;
			f2.size = 16;
		var r = new RCTextRoll (50, 60, 200, null, "What's this fuss about true randomness?", f2);
		RCWindow.sharedWindow().addChild ( r );
		r.start();
		r.backgroundColor = 0xff3300;
		}catch(e:Dynamic){Fugu.stack();}
	}
	
	function x__ (){
		//div.innerHTML = "   <link/><table></table><a href='/a' style='top:1px;float:left;opacity:.55;'>a</a><input type='checkbox'/>";
	}
}
//#end