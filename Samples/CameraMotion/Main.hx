//
//  Main
//
//  Created by Cristi Baluta on 2010-06-24.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.display.Sprite;
import flash.media.Camera;
import DetectionEvent;
import MotionDetector;


class Main extends Sprite {
	
	var detector :MotionDetector;
	var drawer :Sprite;
	
	
	function new () {
		super();
		init();
	}
	
	function init():Void {
		
		detector = new MotionDetector (50, 50, 550, 400);
		detector.attachCamera ( Camera.getCamera() );
		detector.startDetection();
		detector.rectColor = 0x00ccff;
		detector.rectThickness = 1;
		detector.setEnableDrawing ( false );
		detector.addEventListener (DetectionEvent.DETECT, handleDetection);
		
		this.addChild ( detector );
		
		drawer = new Sprite();
		this.addChild ( drawer );
		
	}
	
	function handleDetection (e:DetectionEvent) :Void {
		drawer.graphics.clear();
		drawer.graphics.beginFill (0x00ccff, 0.5);
		drawer.graphics.drawRect (e.rect.x, e.rect.y, e.rect.width, e.rect.height);
		drawer.graphics.endFill();
		
	}
	
	static function main(){
		RCWindow.init();
		RCWindow.addChild ( new Main() );
	}
}