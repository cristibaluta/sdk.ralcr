//
//	CATween.hx
//  The most basic transition type, it fades properties of a RCView
//
//  Created by Baluta Cristian on 2009-03-21.
//  Copyright (c) 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class CATween extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		for (p in Reflect.fields (properties)) {
			if (Std.is (Reflect.field (properties, p), Int) || Std.is (Reflect.field (properties, p), Float)) {
				
				// We have simple properties: x=10, y=40, ...
				var getter = "get_"+p;//.substr(0,1).toUpperCase()+p.substr(1);
				if (getter == null)
				Reflect.setField (fromValues, p, Reflect.field (target, p));
				else
				Reflect.setField (fromValues, p, Reflect.callMethod (target, Reflect.field(target,getter), []));
				Reflect.setField (toValues, p, Reflect.field (properties, p));
			}
			else try {
				// Prevents on adding to the object unknown properties
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
/*			#if (flash || nme)
				Reflect.setField (target, prop, calculate (time_diff, prop));
			#elseif js*/
				
				//var val = calculate (time_diff, prop);
				var setter = "set_"+prop;//.substr(0,1).toUpperCase()+prop.substr(1);
				if (setter != null)
					//target.setter ( calculate (time_diff, prop) );
				Reflect.callMethod (target, Reflect.field(target,setter), [calculate (time_diff, prop)]);
			//#end
			}
			catch (e:Dynamic) { trace(e); }
	}
}
