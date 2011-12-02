package  {
	import flash.external.ExternalInterface;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.Lib;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.system.Capabilities;
	import flash.display.StageDisplayState;
	public class RCStage {
		static public var target : flash.display.MovieClip = flash.Lib.current;
		static public var stage : flash.display.Stage = flash.Lib.current.stage;
		static public var SCREEN_W : Number = flash.system.Capabilities.screenResolutionX;
		static public var SCREEN_H : Number = flash.system.Capabilities.screenResolutionY;
		static public var URL : String = flash.Lib.current.loaderInfo.url;
		static public var ID : String = flash.Lib.current.loaderInfo.parameters.id;
		static public var width : int;
		static public var height : int;
		static public function init() : void {
			flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
			RCStage.width = flash.Lib.current.stage.stageWidth;
			RCStage.height = flash.Lib.current.stage.stageHeight;
			var url : Array = URL.split("/");
			url.pop();
			RCStage.URL = url.join("/") + "/";
			RCNotificationCenter.addObserver("resize",RCStage.resizeHandler);
		}
		
		static protected function resizeHandler(w : *,h : *) : void {
			RCStage.width = flash.Lib.current.stage.stageWidth;
			RCStage.height = flash.Lib.current.stage.stageHeight;
		}
		
		static public function getCenterX(w : Number) : int {
			return Math.round(RCStage.width / 2 - w / 2);
		}
		
		static public function getCenterY(h : Number) : int {
			return Math.round(RCStage.height / 2 - h / 2);
		}
		
		static public function fullscreen() : void {
			flash.Lib.current.stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
		}
		
		static public function normal() : void {
			flash.Lib.current.stage.displayState = flash.display.StageDisplayState.NORMAL;
		}
		
		static public function isFullScreen() : Boolean {
			return flash.Lib.current.stage.displayState == flash.display.StageDisplayState.FULL_SCREEN;
		}
		
		static public function setWidth(w : int) : void {
			if(flash.external.ExternalInterface.available) flash.external.ExternalInterface.call("swffit.configure",{ target : ID, maxWid : w});
		}
		
		static public function setHeight(h : int) : void {
			if(flash.external.ExternalInterface.available) flash.external.ExternalInterface.call("swffit.configure",{ target : ID, maxHei : h, maxWid : width, hCenter : false});
		}
		
		static public function addChild(child : flash.display.DisplayObjectContainer) : void {
			if(child != null) flash.Lib.current.addChild(child);
		}
		
		static public function removeChild(child : flash.display.DisplayObjectContainer) : void {
			if(child != null) if(flash.Lib.current.contains(child)) flash.Lib.current.removeChild(child);
		}
		
	}
}
