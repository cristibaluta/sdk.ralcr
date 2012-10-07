//
//  Test
//
//  Created by Baluta Cristian on 2009-03-24.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class Test {
	
	public var duration (getDuration, setDuration):Float;
	var f :RCRectangle;
	
	public function new (){
		f = new RCRectangle (0, 10, 50, 50, 0xff4422, 1);
		RCWindow.addChild ( f );
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