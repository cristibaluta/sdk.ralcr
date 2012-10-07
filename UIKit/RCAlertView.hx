//
//  RCAlertView
//
//  Created by Baluta Cristian on 2009-03-02.
//  Copyright (c) 2009 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCAlertView extends RCView {
	
	var COLORS :Array<Null<Int>>;
	var background :RCView;
	var text :RCView;
	var buttons :RCGroup<RCButton>;
	
	public var label :String;
	dynamic public function onClick () :Void {}
	
	
	public function new (skin:RCSkin) {
		
		super(0,0);
		
		this.background = skin.normal.background;
		this.text = skin.normal.label; // all graphical elements are here
		this.addChild ( this.background );
		this.addChild ( this.text );
	}
	
	public function initWithLabels (arr:Array<String>, constructButton:RCIndexPath->RCButton) :Void {
		
		buttons = new RCGroup<RCButton>(0, 0, 10, null, constructButton);
		buttons.add ( arr );
		buttons.x = Math.round ( (background.width - buttons.width) / 2 );
		buttons.y = Math.round ( background.height - buttons.height - 10 );
		//buttons.addEventListener (GroupEvent.CLICK, onClickHandler);
		
		this.addChild ( buttons );
	}
	
	function onClickHandler (e:EVMouse) :Void {
		//label = e.label;
		//onClick();
		//this.dispatchEvent ( e );
	}
	
	
	override public function destroy () :Void {
		
		if (buttons != null)
			buttons.destroy();
			buttons = null;
		
		super.destroy();
	}
}
