import flash.display.MovieClip;
import flash.events.*;
import com.electrotank.water.Wave;


class GKDot extends MovieClip {
	
	var waves :Array;
	
	
	public function Dot() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		waves = new Array<GKWave>();
	}
	public function addWave(w:Wave):void {
		waves.push(w);
	}
	public function addedToStage(ev:Event):Void {
	}
	override public function toString():String {
		return "x: "+Math.round(x).toString()+" , "+Math.round(y).toString();
	}
	public function getWaves():Array {
		return waves;
	}
}
