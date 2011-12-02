//
//  SKScroll
//
//  Created by Baluta Cristian on 2011-03-07.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//

class SKSlider extends RCSkin {
	
	public function new (w, h, max_w, max_h, roundness:Int, colors:Array<Null<Int>>) {
		super ( colors );
		
		background = new RCRectangle (0, 0, max_w, max_h, colors[2], .2, roundness);
		up = new RCRectangle (0, 0, w, h, colors[2], 1, roundness);
		hit = new flash.display.Sprite();
	}
}
