//
//  Main
//
//  Created by Cristi Baluta on 2010-05-20.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.MovieClip;


class Main extends MovieClip {
	
		
	public static function main () {
		haxe.Firebug.redirectTraces();
		RCStage.init();
		RCStage.addChild ( new Main() );
	}
	
	
	public function new () {
		super();
		
		this.addChild ( new RCRectangle (10, 10, 100, 100) );
		this.addChild ( new RCRectangle (114, 10, 100, 100, new RCColor(null, 0x222222), 0.41, 27) );
		this.addChild ( new RCRectangle (224, 10, 100, 100, new RCGradient([0xf33333, 0x000000], [1., 1.])) );
		this.addChild ( new RCEllipse (334, 10, 100, 100, new RCGradient([0xf33333, 0x000000], [1., 1.], false)) );
		this.addChild ( new RCEllipse (450, 10, 100, 100, 0xff3300) );
		this.addChild ( new RCBurst (200, 200, 100, 100, new RCGradient([0xf33333, 0xff0000], [0.3, .3]), 1,   10, 50, 100, 100) );
		//this.addChild ( new RCArc (300, 80, 100, 100, 0x333333, 1,   100, 0) );
		this.addChild ( new RCDashedLine (10, 200, 300, 1, 0x333333, 1,  10, 2) );
		this.addChild ( new RCDashedLine (10, 200, 3, 300, 0x333333, 1,  10, null) );
		this.addChild ( new RCLine(10, 200, 300, 500, 0x333333, .6, 1) );
		
	}
}
