//
//  RCScrollBar.hx
//	UIKit
//
//  Created by Baluta Cristian on 2008-06-25.
//  Copyright (c) 2008-2012 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

private enum Direction {
	HORIZONTAL;
	VERTICAL;
}
import RCControl;// imports States


class RCScrollBar extends RCControl {
	
	var skin :RCSkin;
	var background :RCView;
	var scrollbar :RCView;
	var indicatorSize :Float;
	var direction_ :Direction;
	var value_ :Float;
	var minValue_ :Int;// 0...100
	var maxValue_ :Int;
	var moving :Bool;
	var mouseUpOverStage_ :EVMouse;
	var mouseMoveOverStage_ :EVMouse;
	
	public var value (getValue, setValue) :Float;// default 0.0. this value will be pinned to min/max
	public var valueChanged :RCSignal<RCScrollBar->Void>;// sliders, etc.
	
	/**
	*  w and h are the bounds of the scrollbar
	*  indicatorSize is the width or height of the scrollbar indicator
	*/
	public function new (x, y, w:Float, h:Float, indicatorSize:Float, skin:RCSkin) {
		
		super (x, y, w, h);
		
		this.moving = false;
		this.minValue_ = 0;
		this.maxValue_ = 100;
		this.value_ = 0.0;
		this.skin = skin;
		this.indicatorSize = indicatorSize;
		this.viewDidAppear.add ( init );
	}
	
	override public function init () {
		
		super.init();
		
		
		// Decide the direction of movement
		direction_ = (size.width > size.height) ? HORIZONTAL : VERTICAL;
		
		// display skin (background, symbol, hit)
		background = skin.normal.background;
		background.setWidth ( size.width );
		background.setHeight ( size.height );
		this.addChild ( background );
		
		scrollbar = skin.normal.otherView;
		scrollbar.setWidth ( direction_ == HORIZONTAL ? indicatorSize : size.width );
		scrollbar.setHeight ( direction_ == VERTICAL ? indicatorSize : size.height );
		scrollbar.alpha = 0.4;
		this.addChild ( scrollbar );
		// end skin
	}
	override function configureDispatchers () {
		super.configureDispatchers();
		valueChanged = new RCSignal<RCScrollBar->Void>();
		mouseUpOverStage_ = new EVMouse (EVMouse.UP, RCWindow.sharedWindow().stage);
		mouseMoveOverStage_ = new EVMouse (EVMouse.MOVE, RCWindow.sharedWindow().stage);
	}
	override function mouseDownHandler (e:EVMouse) :Void {
		trace("mouseDownHandler");
		moving = true;
		mouseUpOverStage_.add ( mouseUpHandler );
		mouseMoveOverStage_.add ( mouseMoveHandler );
		mouseMoveHandler ( e );
		setState ( SELECTED );
		onPress();
	}
	override function mouseUpHandler (e:EVMouse) :Void {
		moving = false;
		mouseUpOverStage_.remove ( mouseUpHandler );
		mouseMoveOverStage_.remove ( mouseMoveHandler );
		setState ( HIGHLIGHTED );
		onRelease();
	}
	override function rollOverHandler (e:EVMouse) :Void {
		setState ( HIGHLIGHTED );
		scrollbar.alpha = 1;
		onOver();
	}
	override function rollOutHandler (e:EVMouse) :Void {
		setState ( NORMAL );
		scrollbar.alpha = 0.4;
		onOut();
	}
	override function clickHandler (e:EVMouse) :Void {
		setState ( SELECTED );
		onClick();
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
				y2 = size.width - scrollbar.width;
				y0 = Zeta.limitsInt (this.mouseX - scrollbar.width/2, 0, y2);
			case VERTICAL:
				//y0 = scrubber.y;
				y2 = size.height - scrollbar.height;
				y0 = Zeta.limitsInt (this.mouseY - scrollbar.height/2, 0, y2);
		}
		
		// Set the new value
		setValue ( Zeta.lineEquation (minValue_, maxValue_,  y0, y1, y2) );
		
		e.updateAfterEvent();
	}
	
	
	
	function getValue () :Float {
		return value_;
	}
	/**
	 * Set the scrubber position based on the new value
	 */
	public function setValue (v:Float) :Float {
		var x1=0.0, x2=0.0;
		value_ = v;
		switch (direction_) {
			case HORIZONTAL:
				x2 = size.width - scrollbar.width;
				scrollbar.x = Zeta.lineEquationInt (x1, x2,  v, minValue_, maxValue_);
			case VERTICAL:
				x2 = size.height - scrollbar.height;
				scrollbar.y = Zeta.lineEquationInt (x1, x2,  v, minValue_, maxValue_);
		}
		
		valueChanged.dispatch ( this );
		return value_;
	}
	
	
	
	// Clean mess
	override public function destroy () :Void {
		
		valueChanged.destroy();
		mouseUpOverStage_.destroy();
		mouseMoveOverStage_.destroy();
		skin.destroy();
		
		super.destroy();
	}
}
