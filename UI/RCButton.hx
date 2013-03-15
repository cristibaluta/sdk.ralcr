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
		
		setup ( skin );
		super (x, y, currentBackground.width, currentBackground.height);
	}
	
	
	// Make sure that all the skin elements neccesary for the button exists
	function setup (skin:RCSkin) {
		
		this.skin = skin;
		
		if (skin.hit != null)
			skin.hit.alpha = 0;
		
		// We need a label, if it's missing replace with the image or otherView
		if (skin.normal.label == null)
			skin.normal.label = skin.normal.image;
		if (skin.normal.label == null)
			skin.normal.label = skin.normal.otherView;
		
		// Iterate over all states of the button
		for (key in Reflect.fields(skin.normal)) {
			if (key == "colors") continue;
			
			// When the HIGHLIGHTED state is missing, replace with the NORMAL state
			if (Reflect.field (skin.highlighted, key) == null)
				Reflect.setField (skin.highlighted, key, Reflect.field (skin.normal, key));
			
			// When the SELECTED state is missing, replace with the HIGHLIGHTED state
			if (Reflect.field (skin.selected, key) == null)
				Reflect.setField (skin.selected, key, Reflect.field (skin.highlighted, key));
			
			// When the DISABLED state is missing, replace with the NORMAL state
			if (Reflect.field (skin.disabled, key) == null)
				Reflect.setField (skin.disabled, key, Reflect.field (skin.normal, key));
		}
		
		currentBackground = skin.normal.background;
		currentImage = skin.normal.label;
	}
	
	
	/**
	*  Set the state of the button
	*/
	override public function setState (state:RCControlState) {
		//trace("setState "+state);
		if (state_ == state) return;
		try{
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
		
		if (currentBackground != null) addChild ( currentBackground );
		if (currentImage != null) addChild ( currentImage );
		if (skin.hit != null) addChild ( skin.hit );
		
		// Set the width of the button
		// FF and Opera can't get it automatically
		size.width = (currentBackground != null) ? currentBackground.width : currentImage.width;
		size.height = (currentBackground != null) ? currentBackground.height : currentImage.height;
		
		super.setState ( state );
		}catch(e:Dynamic){trace(e);}
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
	
	override public function toString () :String {
		return "[RCButton bounds:"+bounds.origin.x+"x"+bounds.origin.y+","+bounds.size.width+"x"+bounds.size.height+"]";
	}
}
