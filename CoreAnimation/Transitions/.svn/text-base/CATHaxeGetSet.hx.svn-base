//
//  Proxy
//
//  Created by Baluta Cristian on 2009-03-26.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
class CATHaxeGetSet extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		modifierFunction = Reflect.field (properties, "modifierFunction");
		Reflect.deleteField (properties, "modifierFunction");
		
		for (p in Reflect.fields (properties)) {
			if (Std.is (Reflect.field (properties, p), Int) ||
				Std.is (Reflect.field (properties, p), Float))
			{
				// We have clean properties: x=10, y=40, ...
				Reflect.setField (fromValues, p, Reflect.field (target, p));
				Reflect.setField (toValues, p, Reflect.field (properties, p));
			}
			else {
				try{//Prevents on adding to the object invalid properties
				// We have composed properties: x={fromValue:0, toValue:10}, ....
				Reflect.setField (fromValues, p, Reflect.field (Reflect.field (properties, p), "fromValue"));
				try{modifierFunction (Reflect.field (fromValues, p));}catch(e:Dynamic){trace(e);}
				Reflect.setField (toValues, p, Reflect.field (Reflect.field (properties, p), "toValue"));
				}
				catch (e:Dynamic) { trace(e); }
			}
		}
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues)) try {
			modifierFunction (calculate (time_diff, prop));
		} catch (e:Dynamic) { trace(e); }
	}
}
