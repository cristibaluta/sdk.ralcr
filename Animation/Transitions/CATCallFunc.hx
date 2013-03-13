//
//  CATCallFunc.hx
//	Call repeatedly a function and pass as an argument the elapsed time
//
//  Created by Baluta Cristian on 2009-03-26.
//  Copyright (c) 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class CATCallFunc extends CAObject implements CATransitionInterface {
	
	override public function init () :Void {
		
		if (!Reflect.isFunction(target)) throw "Function must be of type: Float->Void";
		
		for (p in Reflect.fields (properties)) {
			if (Std.is (Reflect.field (properties, p), Int) ||
				Std.is (Reflect.field (properties, p), Float))
			{
				// We have clean properties: x=10, y=40, ...
				Reflect.setField (fromValues, p, 0);
				Reflect.setField (toValues, p, Reflect.field (properties, p));
			}
			else { try {
				//Prevents on adding to the object invalid properties
				// We have composed properties: x={fromValue:0, toValue:10}, ....
				Reflect.setField (fromValues, p, Reflect.field (Reflect.field (properties, p), "fromValue"));
				try{target (Reflect.field (fromValues, p));}catch(e:Dynamic){trace(e);}
				Reflect.setField (toValues, p, Reflect.field (Reflect.field (properties, p), "toValue"));
			}
			catch (e:Dynamic) { trace(e); }
			}
		}
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues)) try {
			target (calculate (time_diff, prop));
		}
		catch (e:Dynamic) { trace(e); }
	}
}
