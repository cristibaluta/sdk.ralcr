class RCSwitch extends RCControl {
	
	public var on (default, null) :Bool;
	
	public function setOn (on:Bool, ?animated:Bool=true) {
		this.on = on;
		
	}
}
