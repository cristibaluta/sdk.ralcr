//
//  RCSliderSync
//
//  Created by Cristi Baluta on 2011-02-09.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.DisplayObjectContainer;


private enum Direction {
	Horizontal;
	Vertical;
}
private enum DecelerationRate {
	RCScrollViewDecelerationRateNormal;
	RCScrollViewDecelerationRateFast;
}

class RCSliderSync {
	
	var target :DisplayObjectContainer; // object to attach the mousewheel
	var contentView :DisplayObjectContainer; // object to scroll
	var slider :RCSlider;
	var direction :Direction;
	var f :Int;
	var decelerationRate :DecelerationRate;
	
	public var valueMax (default, setMaxValue) :Int;
	public var valueStart (default, setStartValue) :Int;
	public var valueFinal (default, setFinalValue) :Int;// the current value between start and max
	
	dynamic public function onUpdate() :Void {}
	dynamic public function onScrollLeft() :Void {}
	dynamic public function onScrollRight() :Void {}
	
	
	public function new (	target:DisplayObjectContainer, contentView:DisplayObjectContainer,
							slider:RCSlider, valueMax:Int, direction:String)
	{
		this.target = target;
		this.contentView = contentView;
		this.slider = slider;
		this.direction = direction == "horizontal" ? Horizontal : Vertical;
		this.valueMax = valueMax;
		this.valueStart = Math.round ( getContentPosition() );
		this.valueFinal = valueStart;
		this.f = 1;
		
		resume();
	}
	
	
	/**
	 * Hold and resume actions
	 */
	public function hold () :Void {
		target.removeEventListener (MouseEvent.MOUSE_WHEEL, wheelHandler);
		slider.removeEventListener (SliderEvent.ON_MOVE, sliderChangedHandler);
	}
	
	public function resume () :Void {
		target.addEventListener (MouseEvent.MOUSE_WHEEL, wheelHandler);
		slider.addEventListener (SliderEvent.ON_MOVE, sliderChangedHandler);
	}
	
	
	/**
	 *	Handle scrol events
	 *	When wheel is scrolled move the content rather the scrollbar
	 */
	function wheelHandler (e:MouseEvent) :Void {
		//trace(e);
		// Calculate different values for mac and pc
/*		(flash.system.Capabilities.os.toLowerCase().indexOf("mac") != -1)
		? valueFinal += e.delta*50
		: valueFinal += e.delta*50;*/
	//	var delta = e.delta;
		valueFinal += e.delta * 2;
		
		startLoop();
		
		// Determine the correct position for the slider
		slider.value = Zeta.lineEquationInt (0, 100, valueFinal, valueStart, valueStart + valueMax - getContentSize());
		
		// dispatch an event with the direction the scroll is moving
		(e.delta < 0) ? onScrollRight() : onScrollLeft();
	}
	
	function sliderChangedHandler (e:SliderEvent) :Void {
		valueFinal = Zeta.lineEquationInt (valueStart, valueStart + valueMax - getContentSize(), e.value, 0, 100);
		startLoop();
	}
	
	
	/**
	 *	Start the enterFrame loop
	 */
	function startLoop () :Void {
		//try{valueFinal = Zeta.limitsInt ( valueFinal, valueStart + valueMax - getContentSize(), 
			//valueStart );}catch(e:Dynamic){trace(e);}
		if (valueFinal > valueStart)
			valueFinal = valueStart;
		if (valueFinal < valueStart + valueMax - getContentSize())
			valueFinal = Math.round ( valueStart + valueMax - getContentSize() );
			
		contentView.addEventListener (Event.ENTER_FRAME, loop);
	}
	
	
	/**
	 *	This moves the content with an easing equation
	 */
	function loop (e:Event) {
		// Calculate the next position for target object
		var next_value = ( valueFinal - getContentPosition() ) / 3;
		
		// remove the enterframe listener
		if (Math.abs ( next_value ) < 1) {
			contentView.removeEventListener (Event.ENTER_FRAME, loop);
			moveContentTo ( valueFinal );
		}
		else moveContentTo ( getContentPosition() + next_value );
		
		onUpdate();
	}
	
	function moveContentTo (next_value:Float) :Void {
		(direction == Horizontal)
		? contentView.x = Math.round ( next_value )
		: contentView.y = Math.round ( next_value );
	}
	
	function getContentPosition () :Float {
		return (direction == Horizontal) ? contentView.x : contentView.y;
	}
	
	function getContentSize () :Float {
		return (direction == Horizontal) ? contentView.width : contentView.height;
	}
	
	
	function setMaxValue (value:Int) :Int {
		return valueMax = value;
	}
	
	function setFinalValue (value:Int) :Int {
		return valueFinal = value;
	}
	
	function setStartValue (value:Int) :Int {
		return valueStart = value;
	}
	
	
	// Clean mess
	public function destroy () :Void {
		contentView.removeEventListener (Event.ENTER_FRAME, loop);
		hold();
	}
}
