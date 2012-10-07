
#if (flash || nme)
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
#elseif js
	import js.Dom;
	private typedef MouseEvent = Event;
	private typedef DisplayObjectContainer = HtmlDom;
	typedef EVMouseRelationship = {target:DisplayObjectContainer, type:String, instance:EVMouse};
#end


class EVMouse extends RCSignal<EVMouse->Void> {
	
	inline public static var UP = "mouseup";
	inline public static var DOWN = "mousedown";
	inline public static var OVER = "mouseover";
	inline public static var OUT = "mouseout";
	inline public static var MOVE = "mousemove";
	inline public static var CLICK = "mouseclick";
	inline public static var DOUBLE_CLICK = "mousedoubleclick";
	inline public static var WHEEL = "mousewheel";
	
	public var target :Dynamic;// The original object
	public var type :String;
	public var e :MouseEvent;
	public var delta :Int;
	var layer :DisplayObjectContainer;// Object that gets the events
	
	#if js
		// JS events do not permit to attach more than one listeners to a target
		// What we do is keep a list of events and their targets
		// And when we add a listener to an already used target we return the old EVMouse
		var targets :List<EVMouseRelationship>;
	#end
	
	/**
	 *  @param type: the type of MouseEvent you want to listen to.
	 *  @param target: RCView you want to listen for events. Can be also directy a DisplayObjectContainer
	 **/
	public function new (type:String, target:Dynamic, ?pos:haxe.PosInfos) {
		
		if (target == null) throw "Can't use a null target. " + pos;
		
		super();
		
		this.type = type;
		this.target = target;
		this.delta = 0;
		
		#if js
			targets = new List<EVMouseRelationship>();
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
		
		#if (flash || nme)
			switch (type) {
				case UP:			layer.addEventListener (MouseEvent.MOUSE_UP, mouseHandler);
				case DOWN: 			layer.addEventListener (MouseEvent.MOUSE_DOWN, mouseHandler);
				case OVER: 			layer.addEventListener (MouseEvent.MOUSE_OVER, mouseHandler);
				case OUT: 			layer.addEventListener (MouseEvent.MOUSE_OUT, mouseHandler);
				case MOVE: 			layer.addEventListener (MouseEvent.MOUSE_MOVE, mouseHandler);
				case CLICK: 		layer.addEventListener (MouseEvent.CLICK, mouseHandler);
				case DOUBLE_CLICK:	layer.addEventListener (MouseEvent.DOUBLE_CLICK, mouseHandler);
				case WHEEL:			layer.addEventListener (MouseEvent.MOUSE_WHEEL, mouseHandler);
				default: trace("The mouse event you're trying to add does not exist. "+pos);
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
			//targets.add ({target:target, type:type, instance:this});
			switch (type) {
				case UP:			layer.onmouseup = mouseHandler;
				case DOWN:			layer.onmousedown = mouseHandler;
				case OVER:			layer.onmouseover = mouseHandler;
				case OUT:			layer.onmouseout = mouseHandler;
				case MOVE:			layer.onmousemove = mouseHandler;
				case CLICK:			layer.onclick = mouseHandler;
				case DOUBLE_CLICK:	layer.ondblclick = mouseHandler;
				case WHEEL:			addWheelListener();
				default: trace("The mouse event you're trying to add does not exist. "+pos);
			}
		#end
	}
	
	function removeEventListener () {
		#if (flash || nme)
			switch (type) {
				case UP:			layer.removeEventListener (MouseEvent.MOUSE_UP, mouseHandler);
				case DOWN:			layer.removeEventListener (MouseEvent.MOUSE_DOWN, mouseHandler);
				case OVER:			layer.removeEventListener (MouseEvent.MOUSE_OVER, mouseHandler);
				case OUT:			layer.removeEventListener (MouseEvent.MOUSE_OUT, mouseHandler);
				case MOVE:			layer.removeEventListener (MouseEvent.MOUSE_MOVE, mouseHandler);
				case CLICK:			layer.removeEventListener (MouseEvent.CLICK, mouseHandler);
				case DOUBLE_CLICK:	layer.removeEventListener (MouseEvent.DOUBLE_CLICK, mouseHandler);
				case WHEEL:			layer.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseHandler);
			}
		#elseif js
			switch (type) {
				case UP:			layer.onmouseup = null;
				case DOWN:			layer.onmousedown = null;
				case OVER:			layer.onmouseover = null;
				case OUT:			layer.onmouseout = null;
				case MOVE:			layer.onmousemove = null;
				case CLICK:			layer.onclick = null;
				case DOUBLE_CLICK:	layer.ondblclick = null;
				case WHEEL:			removeWheelListener();
			}
		#end
	}
	
	function mouseHandler (e:MouseEvent) {
		#if js
			// IE is retarded and doesn't pass the event object 
			if (e == null)
				e = untyped js.Lib.window.event;
/*			if (js.Lib.isIE)
				untyped e.returnValue = false;
			else
				untyped e.preventDefault();*/
		#end
		this.e = e;
		dispatch ( this );
	}
	
	public function updateAfterEvent () :Void {
		#if flash
			e.updateAfterEvent();
		#end
	}
	
	
	
	// Wheel support
#if js
	
	function addWheelListener () {
		
		mouseScrollHandler = MouseScroll;
		
        if (untyped layer.addEventListener) {
			// Internet Explorer 9, Opera, Google Chrome and Safari
			untyped layer.addEventListener ("mousewheel", mouseScrollHandler, false);
			// Firefox
			untyped layer.addEventListener ("DOMMouseScroll", mouseScrollHandler, false);
		}
		else if (untyped layer.attachEvent) {
			// IE < 9
			untyped layer.attachEvent ("onmousewheel", mouseScrollHandler);
		}
	}
	
	function removeWheelListener () {
		
        if (untyped layer.removeEventListener) {
			// Internet Explorer 9, Opera, Google Chrome and Safari
			untyped layer.removeEventListener ("mousewheel", mouseScrollHandler, false);
			// Firefox
			untyped layer.removeEventListener ("DOMMouseScroll", mouseScrollHandler, false);
		}
		else if (untyped layer.detachEvent) {
			// IE < 9
			untyped layer.detachEvent ("onmousewheel", mouseScrollHandler);
		}
	}
	
	var mouseScrollHandler :Dynamic;// Haxe bug, need to store here the reference
    function MouseScroll (e) {
		
		if (Reflect.field(e, 'wheelDelta') != null) {
			delta = e.wheelDelta;
		}
		else if (Reflect.field(e, 'detail') != null) {
			/** Mozilla case. MouseScrollEvent */
			/** In Mozilla, sign of delta is different than in IE.
			* Also, delta is multiple of 3. */
			delta = - Math.round ( e.detail*5 );
		}
		this.e = e;
		dispatch ( this );
    }
	
#end
	
	
	override public function destroy (?pos:haxe.PosInfos) :Void {
		removeEventListener();
		super.destroy();
	}
	
}
