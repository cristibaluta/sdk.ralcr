//
//  Main
//
//  Created by Cristi Baluta on 2010-05-28.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import js.Dom;
import RCView;
import RCStage;

class Main {
	
	static var lin :RCLine;
	static var ph :RCPhoto;
	
	// change the HTML content of a DIV based on its ID
	static function main() {
		haxe.Firebug.redirectTraces();
		RCStage.init();
		
		var rect = new RCRectangle(200,30, 300, 150, 0xff3300);
	 	RCStage.addChild ( rect );
		rect.clipsToBounds = true;
		
		var ell = new RCEllipse(100,100, 100, 100, 0xff3300);
	 	RCStage.addChild ( ell );
		
		lin = new RCLine(30,300, 400, 600, 0xff3300);
	 	RCStage.addChild ( lin );
		js.Lib.document.onmousemove = moveLine;
		
		ph = new RCPhoto(1, 1, "../CoreAnimation/3134265_large.jpg");
		ph.onComplete = resizePhoto;
	 	rect.addChild ( ph );
		
    }
	static function moveLine(e:Event){
		lin.size.width = e.clientX - lin.x;
		lin.size.height = e.clientY - lin.y;
		lin.redraw();
	}
	static function resizePhoto(){
		trace("onComplete");
		trace(ph.width);
		trace(ph.size.width);
		ph.scaleToFill (300-2, 150-2);
		//ph.scaleToFit (300-2, 150-2);
		
	}
/*	static function Hi(){
		trace("psst");
	}
	
	//
	static function setContent(id, content) {
        var d = js.Lib.document.getElementById(id);
        if( d == null )
            js.Lib.alert("Unknown element : "+id);
        d.innerHTML = content;
    }
	
    // create a javascript HTML link
    static function makeLink(title, code) {
        return '<a href="javascript:'+code+'">'+title+'</a>';
    }
	
    // function called when the user click on the link
    static function click() {
        //setContent("main","Congratulations !");
		setContent ("main", haxe.Http.requestUrl("data.xml"));
    }
	static function clickAsync(xml:String) {
		trace("click async");
	    var r = new haxe.Http(xml);
			//r.setParameter("param","value");
	    	r.onError = js.Lib.alert;
	    	r.onData = function(r) { setContent("main", r); }
	    	r.request(false);
	}*/
}
