//
//  The class of a standard button
//
//  Created by Baluta Cristian on 2008-03-23.
//  Copyright (c) 2008 www.ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;


class RCButton extends RCControl {
	
	public var background :DisplayObjectContainer;
	public var up :DisplayObjectContainer;
	public var over :DisplayObjectContainer;
	public var down :DisplayObjectContainer;
	public var hit :DisplayObjectContainer;
	
	public var autoBrightness :Bool;
	
	var backgroundColorUp :Null<Int>;
	var backgroundColorOver :Null<Int>;
	var symbolColorUp :Null<Int>;
	var symbolColorOver :Null<Int>;
	
	
	public function new (x, y, skin:RCSkin) {
		super (x, y);
		
		backgroundColorUp = skin.backgroundColorUp;
		backgroundColorOver = skin.backgroundColorOver;
		symbolColorUp = skin.symbolColorUp;
		symbolColorOver = skin.symbolColorOver;
		
		autoBrightness = true;
		
		// display skin (background, symbol, hit)
		background = skin.background;
		up = skin.up;
		over = skin.over == null ? skin.up : skin.over;
		down = skin.down == null ? skin.up : skin.down;
		hit = skin.hit;
		hit.alpha = 0;
		
		this.addChild ( background );
		this.addChild ( up );
		this.addChild ( hit );
		// end skin
		
		// go to out state
		rollOutHandler ( null );
	}
	
	
	
	/**
	 * Handlers
	 */
	override function rollOverHandler (e:MouseEvent) :Void {
		toggledState();
		onOver();
	}
	override function rollOutHandler (e:MouseEvent) :Void {
		untoggledState();
		onOut();
	}
	
	override function toggledState () {
		if (_toggled) return;
		
		// Change the color of the background
		//background.visible = _background_color_over != null ? true : false;
		if (backgroundColorOver == null)
			setObjectBrightness (background, 30);
		else
			setObjectColor (background, backgroundColorOver);
		
		// Change the color of the active symbol
		if (symbolColorOver == null) {
			if (up == over) setObjectBrightness (over, 30);
		}
		else
			setObjectColor (over, symbolColorOver);
		
		// Remove and add the coresponding objects for this state of the button
		Fugu.safeRemove ([up, down]);
		Fugu.safeAdd (this, [over, hit]);
	}
	
	override function untoggledState () {
		if (_toggled) return;
		
		// Change the color of the background
		//background.visible = _background_color_over != null ? true : false;
		if (backgroundColorUp == null)
			setObjectBrightness (background, 0);
		else
			setObjectColor (background, backgroundColorUp);
		
		// Change the color of the active symbol
		if (symbolColorOver == null)
			setObjectBrightness (up, 0);
		else
			setObjectColor (up, symbolColorUp);
		
		// Remove and add the coresponding objects for this state of the button
		Fugu.safeRemove ([over, down]);
		Fugu.safeAdd (this, [up, hit]);
	}
	
	
	/**
	 *	Function to safely set color for objects in the button
	 */
	public function setObjectColor (obj:DisplayObjectContainer, color:Null<Int>) {
		if (obj == null || color == null) return;
		Fugu.color (obj, color);
	}
	public function setObjectBrightness (obj:DisplayObjectContainer, brightness:Int) {
		if (obj == null || !autoBrightness) return;
		Fugu.brightness (obj, brightness);
	}
}
