package  {
	import flash.Lib;
	import caequations.Linear;
	import flash.events.Event;
	import flash.display.Sprite;
	public class CoreAnimation {
		static protected var latest : CAObject;
		static protected var sprite : flash.display.Sprite;
		static public var defaultTimingFunction : Function = caequations.Linear.NONE;
		static public var defaultDuration : Number = 0.8;
		static public function add(obj : CAObject) : void {
			if(obj == null) return;
			if(obj.target == null) return;
			var a : CAObject = latest;
			var prev : CAObject = latest;
			if(prev != null) prev.next = obj;
			obj.prev = prev;
			CoreAnimation.latest = obj;
			obj.init();
			obj.initTime();
			if(CoreAnimation.sprite == null) {
				CoreAnimation.sprite = new flash.display.Sprite();
				sprite.addEventListener(flash.events.Event.ENTER_FRAME,CoreAnimation.updateAnimations);
			}
		}
		
		static public function remove(obj : *) : void {
			if(obj == null) return;
			var a : CAObject = latest;
			while(a != null) {
				if(a.target == obj) removeCAObject(a);
				a = a.prev;
			}
		}
		
		static public function removeCAObject(a : CAObject) : void {
			if(a.prev != null) a.prev.next = a.next;
			if(a.next != null) a.next.prev = a.prev;
			if(CoreAnimation.latest == a) CoreAnimation.latest = ((a.prev != null)?a.prev:null);
			removeTimer();
			a = null;
		}
		
		static protected function removeTimer() : void {
			if(CoreAnimation.latest == null && CoreAnimation.sprite != null) {
				sprite.removeEventListener(flash.events.Event.ENTER_FRAME,CoreAnimation.updateAnimations);
				CoreAnimation.sprite = null;
			}
		}
		
		static public function destroy() : void {
			CoreAnimation.latest = null;
			removeTimer();
		}
		
		static protected function updateAnimations(_ : *) : void {
			var current_time : int = flash.Lib._getTimer();
			var time_diff : Number = 0.0;
			var a : CAObject = latest;
			while(a != null) {
				if(a.target == null) {
					a = a.prev;
					removeCAObject(a);
					break;
				}
				time_diff = current_time - a.fromTime - a.delay;
				if(time_diff >= a.duration) time_diff = a.duration;
				if(time_diff >= 0) {
					a.animate(time_diff);
					if(time_diff > 0 && !a.delegate.startPointPassed) a.delegate.start();
					if(time_diff >= a.duration) {
						if(a.repeatCount > 0) {
							a.repeat();
							a.delegate.repeat();
						}
						else {
							removeCAObject(a);
							a.delegate.stop();
						}
					}
					if(a.delegate.kenBurnsPointIn != null) {
						if(time_diff > a.delegate.kenBurnsPointIn && !a.delegate.kenBurnsPointInPassed) a.delegate.kbIn();
						if(time_diff > a.delegate.kenBurnsPointOut && !a.delegate.kenBurnsPointOutPassed) a.delegate.kbOut();
					}
				}
				a = a.prev;
			}
		}
		
	}
}
