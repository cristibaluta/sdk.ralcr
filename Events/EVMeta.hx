class MetaEvent extends flash.events.Event {
	
	public var duration :Int;
	public var width :Int;
	public var height :Int;
	
	inline public static var META :String = "on_meta_data";
	
	public function new (type:String, meta:Dynamic, ?bubbles:Bool=false, ?cancelable:Bool=false) {
		super ( type, bubbles, cancelable );
		//for (f in Reflect.fields(meta)) trace(f+" >>> "+Std.string (Reflect.field(meta, f)));
	}
}
