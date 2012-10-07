
#if (flash || (nme && flash))
	import flash.events.FullScreenEvent;
	import flash.display.StageDisplayState;
#end


class EVFullScreen extends RCSignal<Bool->Void> {

	public function new () {
		super();
		#if (flash || (nme && flash))
			flash.Lib.current.stage.addEventListener (FullScreenEvent.FULL_SCREEN, fullScreenHandler);
		#end
	}
#if (flash || (nme && flash))
	function fullScreenHandler (e:FullScreenEvent) {
		dispatch ( flash.Lib.current.stage.displayState == StageDisplayState.FULL_SCREEN );
	}
#end
}
