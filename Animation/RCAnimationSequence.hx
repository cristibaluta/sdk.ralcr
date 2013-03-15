//
//  CASequence.hx
//	Create a sequence of animations
//
//  Created by Baluta Cristian on 2011-03-06.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCAnimationSequence {
	
	var objs :Array<CAObject>;
	
	
	public function new (objs:Array<CAObject>) {
		this.objs = objs;
	}
	
	public function start () :Void {
		var obj = objs.shift();
		if (objs.length > 0) {
			var arguments :Dynamic = obj.animationDidStop;
			obj.animationDidStop = animationDidStopHandler;
			obj.arguments = [arguments];
		}
		RCAnimation.add ( obj );
	}
	
	function animationDidStopHandler (func:Dynamic) {
		// Call the original method
		// .apply is not working in cpp
		if (func != null) {
			if (Reflect.isFunction( func ))
				Reflect.callMethod (null, func, []);
				//try{ func/*.apply (null,*/ (/*[]*/); }catch(e:Dynamic){ trace(e); Fugu.stack(); }
		}
		
		// Start the next animation
		if (objs.length > 0)
			start();
	}
}
