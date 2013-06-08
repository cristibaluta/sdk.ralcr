
#if (flash || (openfl && flash))
	import flash.events.FullScreenEvent;
	import flash.display.StageDisplayState;
#end


class EVFullScreen extends RCSignal<Bool->Void> {

	public function new () {
		super();
		#if (flash || (openfl && flash))
			flash.Lib.current.stage.addEventListener (FullScreenEvent.FULL_SCREEN, fullScreenHandler);
		#end
	}
#if (flash || (openfl && flash))
	function fullScreenHandler (e:FullScreenEvent) {
		dispatch ( flash.Lib.current.stage.displayState == StageDisplayState.FULL_SCREEN );
	}
#end
}
