interface RCAudioInterface {
	
/*	dynamic public function onInit () :Void {}
	dynamic public function onError () :Void {}
	dynamic public function onLoadingProgress () :Void {}
	dynamic public function onPlayingProgress () :Void {}*/
	
	public function destroy () :Void;
	
	public function getVolume () :Float;
	public function setVolume (volume:Float) :Float;
}
