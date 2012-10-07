//
//  Animation
//
//  Created by Baluta Cristian on 2008-09-28.
//  Copyright (c) 2008 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

/**
*  Tween engine
*/

class CoreAnimation {
	
	static var latest :CAObject;
	static var ticker :EVLoop;
	
	public static var defaultTimingFunction :Dynamic = caequations.Linear.NONE;
	public static var defaultDuration = 0.8;
	
	/**
	 *	Add a new CAObject to the tween list
	 */
	public static function add (obj:CAObject) :Void {
		
		if (obj == null) return;
		if (obj.target == null) return;
		
		// Do not add twice the same target
		var a :CAObject = latest;
		
		// Do not add twice the same object
/*		while (a != null) {
			if (a == obj)
				return;
			a = a.prev;
		}*/
		
		var prev = latest;
		if (prev != null)
			prev.next = obj;
		obj.prev = prev;
		latest = obj;
		
		// Init the parameters of the object
		obj.init();
		obj.initTime();
		
		if (ticker == null) {
			ticker = new EVLoop();
			ticker.run = updateAnimations;
		}
	}
	
	
	/**
	 *	Removes an animation.
	 *	Iterate over all active animations and removes the one that coresponds to the object
	 */
	public static function remove (obj:Dynamic) :Void {
		if (obj == null) return;
		var a :CAObject = latest;
		while (a != null) {
			if (a.target == obj)
				removeCAObject ( a );
			a = a.prev;
		}
	}
	
	/**
	 *	Removes an animation by passing the CAObject that is being animated.
	 *  @param a - Can be Ani Transition object: CATween, CATZoom, CATSound, CATText.....
	 */
	public static function removeCAObject (a:CAObject) :Void {
		
		if (a.prev != null) a.prev.next = a.next;
		if (a.next != null) a.next.prev = a.prev;
		if (latest == a) latest = a.prev != null ? a.prev : null;
		
		removeTimer();
		a = null;
	}
	
	static function removeTimer () :Void {
		if (latest == null && ticker != null) {
			ticker.destroy();
			ticker = null;
		}
	}
	
	/**
	 *  Removes all animations.
	 */
	public static function destroy () :Void {
		latest = null;
		removeTimer();
	}
	
	
	/**
	 *	Update the animations state
	 */
	static function updateAnimations () :Void {
		
		var current_time = timestamp();
		var time_diff = 0.0;
		
		// Iterate over existing animations list from the newest to older
		var a :CAObject = latest;
		while (a != null) {
			
			// Auto destroy the CAObject if the target object becames null for some reason
			if (a.target == null) {
				a = a.prev;
				removeCAObject ( a );
				break;
			}
			
				time_diff = current_time - a.fromTime - a.delay;
			if (time_diff >= a.duration)
				time_diff = a.duration;
			if (time_diff > 0) {
				
				// Animate the object by calling "animate" method in "a.transition" class
				a.animate ( time_diff );
				
				// DISPATCHING
				// Dispatch the start of the animation
				if (time_diff > 0 && !a.delegate.startPointPassed)
					a.delegate.start();
				
				// Dispatch the end of the animation or the repeat event
				if (time_diff >= a.duration)
				if (a.repeatCount > 0) {
					a.repeat();
					a.delegate.repeat();
				}
				else {
					removeCAObject ( a );
					a.delegate.stop();
				}
				
				// Dispatch the KenBurns points
				if (a.delegate.kenBurnsPointIn != null) {
					if (time_diff > a.delegate.kenBurnsPointIn && !a.delegate.kenBurnsPointInPassed)
						a.delegate.kbIn();
					if (time_diff > a.delegate.kenBurnsPointOut && !a.delegate.kenBurnsPointOutPassed)
						a.delegate.kbOut();
				}
			}
			
			// Animate the next CAObject
			a = a.prev;
		}
	}
	
	/**
	 *  Returns the timestamp depending on the platform.
	 **/
	inline public static function timestamp () :Float {
		#if cpp
			return cpp.Sys.time() * 1000;
		#elseif neko
			return neko.Sys.time() * 1000;
		#elseif js
			return Date.now().getTime();
		#elseif flash
			return flash.Lib.getTimer();
		#end
	}
}
