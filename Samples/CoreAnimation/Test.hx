//
//  Test
//
//  Created by Baluta Cristian on 2009-03-24.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class Test {
	
	public var duration (getDuration, setDuration):Float;
	var f :RCRectangle;
	
	public function new (){
		f = new RCRectangle (0, 10, 50, 50, 0xff4422, 1);
		RCStage.addChild ( f );
	}
	
	
	function getDuration () :Float {
		return duration;
	}
	
	function setDuration (i:Float) :Float {
		duration = i;//trace("duration: "+duration);
		f.x = i;
		return duration;
	}
}