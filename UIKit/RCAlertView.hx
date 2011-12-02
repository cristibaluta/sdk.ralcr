//
//  Dialog window
//
//  Created by Baluta Cristian on 2009-03-02.
//  Copyright (c) 2009 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;


class RCAlertView extends Sprite {
	
	var COLORS :Array<Null<Int>>;
	var background :DisplayObjectContainer;
	var text :DisplayObjectContainer;
	var buttons :RCGroupButtons<RCButton>;
	
	public var label :String;
	dynamic public function onClick () :Void {}
	
	
	public function new (skin:RCSkin) {
		super();
		
		this.background = skin.background;
		this.text = skin.up; // all graphical elements are here
		this.addChild ( this.background );
		this.addChild ( this.text );
	}
	
	public function init (arr:Array<String>, constructButton:String->RCButton) :Void {
		
		buttons = new RCGroupButtons<RCButton>(0, 0, 10, null, constructButton);
		buttons.add ( arr );
		buttons.x = Math.round ( (background.width - buttons.width) / 2 );
		buttons.y = Math.round ( background.height - buttons.height - 10 );
		buttons.addEventListener (GroupEvent.CLICK, onClickHandler);
		
		this.addChild ( buttons );
	}
	
	function onClickHandler (e:GroupEvent) :Void {
		label = e.label;
		onClick();
		this.dispatchEvent ( e );
	}
	
	
	public function destroy () :Void {
		if (buttons != null)
			buttons.destroy();
			buttons = null;
	}
}
