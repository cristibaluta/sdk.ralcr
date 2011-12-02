//
//  CASequence
//
//  Created by Baluta Cristian on 2011-03-06.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//

class CASequence {
	
	var objs :Array<CAObject>;
	
	
	public function new (objs:Array<CAObject>) {
		this.objs = objs;
	}
	
	public function start () :Void {
		var obj = objs.shift();
		if (objs.length > 0) {
			var arguments :Dynamic = obj.delegate.animationDidStop;
			obj.delegate.animationDidStop = animationDidStop;
			obj.delegate.arguments = [arguments];
		}
		CoreAnimation.add ( obj );
	}
	
	function animationDidStop (func:Dynamic) {
		// Call the original method
		if (func != null) {
			if (Reflect.isFunction( func ))
				try{ func.apply (null, []); }catch(e:Dynamic){trace(e);}
		}
		
		// Start the next animation
		if (objs.length > 0)
			start();
	}
}
