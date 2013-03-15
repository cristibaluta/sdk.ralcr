//
//  RCSlider.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-06-25.
//  Updated 2008-2012 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import RCControl;

private enum Direction {
	HORIZONTAL;
	VERTICAL;
}

class RCSlider extends RCControl {
	
	var init_ :Bool;
	var value_ :Float;
	var minValue_ :Float;
	var maxValue_ :Float;
	var moving_ :Bool;
	var direction_ :Direction;
	var mouseUpOverStage_ :EVMouse;
	var mouseMoveOverStage_ :EVMouse;
	
	var skin :RCSkin;
	var sliderNormal :RCView;
	var sliderHighlighted :RCView;
	var scrubber :RCView;
	
	public var minValue (default, set_minValue) :Float;
	public var maxValue (default, set_maxValue) :Float;
	public var value (get_value, set_value) :Float;// default 0.0. this value will be pinned to min/max
	public var minimumValueImage (default, set_minimumValueImage) :RCImage;// default is nil
	public var maximumValueImage (default, set_maximumValueImage) :RCImage;
	
	public var valueChanged :RCSignal<RCSlider->Void>;// sliders, etc.
	
	
	public function new (x, y, w, h, ?skin:RCSkin) {
		
		this.init_ = false;
		this.moving_ = false;
		this.minValue_ = 0.0;
		this.maxValue_ = 100.0;
		this.value_ = 0.0;
		this.direction_ = (w > h) ? HORIZONTAL : VERTICAL;// Decide the direction of movement
		if (skin == null)
			skin = new haxe.SKSlider();// If not otherwise specified use by default this Skin
		this.skin = skin;
		
		// This is the right moment to call super
		super (x, y, w, h);
		
		viewDidAppear.add ( viewDidAppear_ );
	}
	
	function viewDidAppear_(){
		
		// Resize skin elements based on the width and height
		sliderNormal = skin.normal.background;
		if (sliderNormal == null)
			sliderNormal = new RCView(0,0);
		sliderNormal.set_width ( size.width );
		
		sliderHighlighted = skin.highlighted.background;
		if (sliderHighlighted == null)
			sliderHighlighted = new RCView(0,0);
		sliderHighlighted.set_width ( size.width );
		
		scrubber = skin.normal.otherView;
		if (scrubber == null)
			scrubber = new RCView(0,0);
		scrubber.y = Math.round ((size.height - scrubber.height)/2);
		
		addChild ( sliderNormal );
		addChild ( sliderHighlighted );
		addChild ( scrubber );
		
		// When the symbol is pressed start to move the slider
		press.add ( mouseDownHandler );
		over.add ( rollOverHandler );
		out.add ( rollOutHandler );
		
		init_ = true;
		
		set_value ( value_ );
	}
	
	override function configureDispatchers () {
		super.configureDispatchers();
		valueChanged = new RCSignal<RCSlider->Void>();
		mouseUpOverStage_ = new EVMouse (EVMouse.UP, RCWindow.sharedWindow().stage);
		mouseMoveOverStage_ = new EVMouse (EVMouse.MOVE, RCWindow.sharedWindow().stage);
	}
	override function set_enabled (c:Bool) :Bool {
		return enabled_ = false;// The slider does not listen for the events on the entire object, but for the scrubber
	}
	
	
	/**
	 *	Functions to move the slider
	 */
	override function mouseDownHandler (e:EVMouse) :Void {
		moving_ = true;
		mouseUpOverStage_.add ( mouseUpHandler );
		mouseMoveOverStage_.add ( mouseMoveHandler );
		mouseMoveHandler ( e );
	}
	override function mouseUpHandler (e:EVMouse) :Void {
		moving_ = false;
		mouseUpOverStage_.remove ( mouseUpHandler );
		mouseMoveOverStage_.remove ( mouseMoveHandler );
	}
	
	
	/**
	 * Set new value when the slider is moving, and dispatch an event
	 */
	function mouseMoveHandler (e:EVMouse) {
		//trace("mouseMoveHandler");
		var y0=0.0, y1=0.0, y2=0.0;
		//#if js trace(e.clientX); #end
		switch (direction_) {
			case HORIZONTAL:
				//y0 = scrubber.x;
				y2 = size.width - scrubber.width;
				y0 = Zeta.limitsInt (this.mouseX - scrubber.width/2, 0, y2);
			case VERTICAL:
				//y0 = scrubber.y;
				y2 = size.height - scrubber.height;
				y0 = Zeta.limitsInt (this.mouseY - scrubber.height/2, 0, y2);
		}
		
		// set the new value
		set_value ( Zeta.lineEquation (minValue_, maxValue_,  y0, y1, y2) );
		
		#if flash
			e.updateAfterEvent();
		#end
	}
	
	
	
	function get_value () :Float {
		return value_;
	}
	/**
	 * Set the scrubber position based on the new value
	 */
	public function set_value (v:Float) :Float {
		
		value_ = v;
		
		if (!init_) return v;
		
		var x1=0.0, x2=0.0;
		
		switch (direction_) {
			case HORIZONTAL:
				x2 = size.width - scrubber.width;
				scrubber.x = Zeta.lineEquationInt (x1, x2,  v, minValue_, maxValue_);
				scrubber.y = Math.round ((size.height - scrubber.height)/2);
				sliderHighlighted.set_width ( scrubber.x + scrubber.width/2 );
			case VERTICAL:
				x2 = size.height - scrubber.height;
				scrubber.y = Zeta.lineEquationInt (x1, x2,  v, minValue_, maxValue_);
				sliderHighlighted.set_height ( scrubber.y + scrubber.height/2 );
		}
		
		valueChanged.dispatch ( this );
		return value_;
	}
	public function set_minValue (v:Float) :Float {
		minValue_ = v;
		set_value ( value_ );// Refresh the slider elements position
		return v;
	}
	public function set_maxValue (v:Float) :Float {
		maxValue_ = v;
		set_value ( value_ );
		return v;
	}
	public function set_minimumValueImage (v:RCImage) :RCImage {
		return v;
	}
	public function set_maximumValueImage (v:RCImage) :RCImage {
		return v;
	}
	
	
	/**
	 *	Scale the background and the symbol
	 *	
	 */
/*	function set_width (w:Int) :Int {
		if (size.width == null) return w;
		size.width = w;
		//TO DO
		
		return w;
	}
	function set_height (h:Int) :Int {
		if (size.height == null) return h;
		size.height = h;
		//TO DO
		
		return h;
	}*/
	
	
	
	// Clean mess
	override public function destroy () :Void {
		mouseUpOverStage_.destroy();
		mouseMoveOverStage_.destroy();
		valueChanged.destroy();
		skin.destroy();
		super.destroy();
	}
}
