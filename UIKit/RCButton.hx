//
//  RCButton.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-03-23.
//  Copyright (c) 2008-2012 www.ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCControl;// Imports RCControlState


class RCButton extends RCControl {
	
	public var skin :RCSkin;
	public var currentTitle :String;// normal/highlighted/selected/disabled. can return nil
	public var currentTitleColor :Int;// normal/highlighted/selected/disabled. always returns non-nil. default is white(1,1)
	public var currentImage :RCView;// normal/highlighted/selected/disabled. can return nil
	public var currentBackground :RCView;// normal/highlighted/selected/disabled. can return nil
	
	
	public function new (x, y, skin:RCSkin) {
		
		this.skin = skin;
		this.skin.hit.alpha = 0;
		fixSkin();
		
		super (x, y, currentBackground.width, currentBackground.height);
	}
	
	override public function setState (state:RCControlState) {
		//trace("setState "+state);
		if (state_ == state) return;
		
		// Remove current state from display list
		Fugu.safeRemove ( [currentBackground, currentImage] );
		
		switch (state) {
			case NORMAL :
				currentBackground = skin.normal.background;
				currentImage = skin.normal.label;
				
			case HIGHLIGHTED :
				currentBackground = skin.highlighted.background;
				currentImage = skin.highlighted.label;
				
			case DISABLED :
				currentBackground = skin.disabled.background;
				currentImage = skin.disabled.label;
				
			case SELECTED :
				currentBackground = skin.selected.background;
				currentImage = skin.selected.label;
		}
		addChild ( currentBackground );
		addChild ( currentImage );
		addChild ( skin.hit );
		
		// Set the width of the button
		// FF and Opera can't get it automatically
		size.width = currentBackground.width;
		size.height = currentBackground.height;
		
		super.setState ( state );
	}
	
	// Make sure that all the skin elements neccesary for a button exists
	function fixSkin () {
		
		// We need a label, if missing substitute it with the image or otherView
		if (skin.normal.label == null)
			skin.normal.label = skin.normal.image;
		if (skin.normal.label == null)
			skin.normal.label = skin.normal.otherView;
		
		// Iterate over all states of the button
		for (key in Reflect.fields(skin.normal)) {
			if (key == "colors") continue;
			
			// The properties of the HIGHLIGHTED state inherits from the NORMAL state
			if (Reflect.field (skin.highlighted, key) == null)
				Reflect.setField (skin.highlighted, key, Reflect.field (skin.normal, key));
			
			// The properties of the SELECTED state inherits from the HIGHLIGHTED state
			if (Reflect.field (skin.selected, key) == null)
				Reflect.setField (skin.selected, key, Reflect.field (skin.highlighted, key));
			
			// The properties of the DISABLED state inherits from the NORMAL state
			if (Reflect.field (skin.disabled, key) == null)
				Reflect.setField (skin.disabled, key, Reflect.field (skin.normal, key));
		}
		
		currentBackground = skin.normal.background;
		currentImage = skin.normal.label;
	}
	
	
	/**
	 *  Set title for state
	 **/
	public function setTitle (title:String, state:RCControlState) {
		
	}
	public function setTitleColor (color:Int, state:RCControlState) {
		
	}
	public function setBackgroundImage (image:RCImage, state:RCControlState) {
		
	}
	
	
	/**
	 *	Function to safely set color for objects in the button
	 */
/*	public function setObjectColor (obj:DisplayObjectContainer, color:Null<Int>) {
		if (obj == null || color == null) return;
		//Fugu.color (obj, color);
	}
	public function setObjectBrightness (obj:DisplayObjectContainer, brightness:Int) {
		if (obj == null || !autoBrightness) return;
		Fugu.brightness (obj, brightness);
	}*/
}
