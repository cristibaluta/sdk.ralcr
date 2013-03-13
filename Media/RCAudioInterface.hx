interface RCAudioInterface {
	
/*	dynamic public function onInit () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function onLoadingProgress () :Void {}
	dynamic public function onPlayingProgress () :Void {}*/
	
	public function destroy () :Void;
	
	public function get_volume () :Float;
	public function set_volume (volume:Float) :Float;
}
