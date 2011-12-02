import flash.events.Event;
import flash.geom.Rectangle;


class DetectionEvent extends Event {
	
	public static var DETECT:String = "DetectionEvent.DETECT";
	
	public var rect :Rectangle;
	
	
	public function new (type:String, detectedRect:Rectangle) {
		super (type);
		rect = detectedRect;
	}
}
