
#if (flash10_1 || nme)
	import flash.events.TouchEvent;
	import flash.display.DisplayObjectContainer;
#elseif js
	import js.Dom;
	private typedef TouchEvent = Event;
	private typedef DisplayObjectContainer = HtmlDom;
	typedef EVTouchRelationship = {target:DisplayObjectContainer, type:String, instance:EVTouch};
#else
	private typedef TouchEvent = Dynamic;
	private typedef DisplayObjectContainer = Dynamic;
	typedef EVTouchRelationship = {target:DisplayObjectContainer, type:String, instance:EVTouch};
#end


class EVTouch extends RCSignal<EVMouse->Void> {
	
	inline public static var DOWN = "touchstart"; // When a finger is placed on the touch surface/screen.
	inline public static var UP = "touchend"; // When a finger is removed from the touch surface/screen.
	inline public static var MOVE = "touchmove"; // When a finger already placed on the screen is moved across the screen.
	inline public static var OVER = "touchenter"; // When a touch point moves onto the interactive area defined by a DOM element.
	inline public static var OUT = "touchleave"; // When a touch point moves off the interactive area defined by a DOM element.
	inline public static var CANCEL = "touchcancel";
	inline public static var TAP = "touchtap";
	
	public var target :Dynamic;// The original object
	public var type :String;
	public var e :TouchEvent;
	var layer :DisplayObjectContainer;// Object that gets the events
	
	#if js
		// JS events do not permit to attach more than one listeners to a target
		// What we do is keep a list of events and their targets
		// And when we add a listener to an already used target we return the old EVMouse
		var targets :List<EVTouchRelationship>;
	#end
	
	/**
	 *  @param type: the type of TouchEvent you want to listen to.
	 *  @param target: RCView you want to listen for events. Can be also directy a DisplayObjectContainer
	 **/
	public function new (type:String, target:Dynamic, ?pos:haxe.PosInfos)
	{
		if (target == null) throw "Can't use a null target. " + pos;
		
		super();
		
		this.type = type;
		this.target = target;
		
		#if js
			targets = new List<EVTouchRelationship>();
			if (Std.is(target, JSView))
				layer = cast(target, JSView).layer;
		#else
			if (Std.is(target, RCView))
				layer = cast(target, RCView).layer;
		#end
		
		if (layer == null)
			layer = target;
		
		addEventListener( pos );
	}
	function addEventListener (?pos:haxe.PosInfos) :Void {
		#if (flash10_1 || nme)
			switch (type) {
				case DOWN:		layer.addEventListener (TouchEvent.TOUCH_BEGIN, touchHandler);
				case UP: 		layer.addEventListener (TouchEvent.TOUCH_END, touchHandler);
				case MOVE: 		layer.addEventListener (TouchEvent.TOUCH_MOVE, touchHandler);
				case OUT: 		layer.addEventListener (TouchEvent.TOUCH_OUT, touchHandler);
				case OVER: 		layer.addEventListener (TouchEvent.TOUCH_OVER, touchHandler);
				case TAP: 		layer.addEventListener (TouchEvent.TOUCH_TAP, touchHandler);
				default: trace ("The touch event you're trying to add does not exist. "+pos);
			}
		#elseif js
			for (t in targets) {
				if (t.target == target && t.type == type) {
					// Target is already used for this mouse event
					trace("Target already in use by this event type. Called from "+pos);
					//return t.instance;
					return;
				}
			}
			targets.add ({target:target, type:type, instance:this});
			switch (type) {
				case DOWN:		untyped layer.touchstart = touchHandler;
				case UP:		untyped layer.touchend = touchHandler;
				case OVER:		untyped layer.touchenter = touchHandler;
				case OUT:		untyped layer.touchleave = touchHandler;
				case MOVE:		untyped layer.touchmove = touchHandler;
				case TAP:		untyped layer.touchtap = touchHandler;
				case CANCEL:	untyped layer.touchcancel = touchHandler;
				default: trace("The mouse event you're trying to add does not exist. "+pos);
			}
		#else
			trace ("Your target does not support touch. Probably you run flash player lower than 10.1");
		#end
	}
	function removeEventListener () {
		#if (flash10_1 || nme)
			switch (type) {
				case DOWN:		layer.removeEventListener (TouchEvent.TOUCH_BEGIN, touchHandler);
				case UP: 		layer.removeEventListener (TouchEvent.TOUCH_END, touchHandler);
				case MOVE: 		layer.removeEventListener (TouchEvent.TOUCH_MOVE, touchHandler);
				case OUT: 		layer.removeEventListener (TouchEvent.TOUCH_OUT, touchHandler);
				case OVER: 		layer.removeEventListener (TouchEvent.TOUCH_OVER, touchHandler);
				case TAP: 		layer.removeEventListener (TouchEvent.TOUCH_TAP, touchHandler);
			}
		#elseif js
			switch (type) {
				case DOWN:		untyped layer.touchstart = null;
				case UP:		untyped layer.touchend = null;
				case OVER:		untyped layer.touchenter = null;
				case OUT:		untyped layer.touchleave = null;
				case MOVE:		untyped layer.touchmove = null;
				case TAP:		untyped layer.touchtap = null;
				case CANCEL:	untyped layer.touchcancel = null;
			}
		#end
	}
	function touchHandler (e:TouchEvent) {
		this.e = e;
		dispatch ( this );
	}
	public function updateAfterEvent () :Void {
		#if flash10_1
			e.updateAfterEvent();
		#end
	}
	override public function destroy (?pos:haxe.PosInfos) :Void {
		removeEventListener();
		super.destroy();
	}
}
