//
//  Fade - fades normal properties of a DisplayObject
//
//  Created by Baluta Cristian on 2009-03-21.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class CATween extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		for (p in Reflect.fields (properties)) {
			if (Std.is (Reflect.field (properties, p), Int) || Std.is (Reflect.field (properties, p), Float)) {
				
				// We have simple properties: x=10, y=40, ...
				Reflect.setField (fromValues, p, Reflect.field (target, p));
				Reflect.setField (toValues, p, Reflect.field (properties, p));
			}
			else try {
				//Prevents on adding to the object unknown properties
				// We have composed properties: x={fromValue:0, toValue:10}, ....
				Reflect.setField (fromValues, p, Reflect.field (Reflect.field (properties, p), "fromValue"));
				Reflect.setField (target, p, Reflect.field (fromValues, p));
				Reflect.setField (toValues, p, Reflect.field (Reflect.field (properties, p), "toValue"));
			}
			catch (e:Dynamic) { trace(e); }
		}
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues))
			try {
				Reflect.setField (target, prop, calculate (time_diff, prop));
			}
			catch (e:Dynamic) { trace(e); }
	}
}
