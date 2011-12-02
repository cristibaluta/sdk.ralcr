class SliderEvent extends flash.events.Event {
	
	public var value :Float;
	
	inline public static var ON_MOVE :String = "on_slider_value_changed";
	inline public static var PRESS :String = "on_slider_pressed";
	inline public static var RELEASE :String = "on_slider_released";
	
	public function new (type:String, value:Float, ?bubbles:Bool=false, ?cancelable:Bool=false) {
		this.value = value;
		super ( type, bubbles, cancelable );
	}
}
