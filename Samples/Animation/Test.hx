//
//  Test
//
//  Created by Baluta Cristian on 2009-03-24.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class Test {
	
	public var duration (get_duration, set_duration):Float;
	var f :RCRectangle;
	
	public function new (){
		f = new RCRectangle (0, 10, 50, 50, 0xff4422, 1);
		RCWindow.addChild ( f );
	}
	
	
	function get_duration () :Float {
		return duration;
	}
	
	function set_duration (i:Float) :Float {
		duration = i;//trace("duration: "+duration);
		f.x = i;
		return duration;
	}
}