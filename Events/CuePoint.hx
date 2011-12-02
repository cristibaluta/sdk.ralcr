//
//  CuePoint
//
//  Created by Baluta Cristian on 2009-03-01.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class CuePoint extends flash.events.Event {
	
	inline public static var CUE_POINT :String = "cue_point_found";
	
	public function new (type:String, cue:Dynamic, ?bubbles:Bool=false, ?cancelable:Bool=false) {
		super ( type, bubbles, cancelable );
		for (f in Reflect.fields(cue)) trace(f+" >>> "+Std.string (Reflect.field(cue, f)));
	}
}
