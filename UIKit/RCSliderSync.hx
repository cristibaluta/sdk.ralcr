//
//  RCSliderSync
//	Keep in sync a slider with it's target
//
//  Created by Cristi Baluta on 2011-02-09.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme)
	import flash.display.DisplayObjectContainer;
#elseif js
	import js.Dom;
	private typedef DisplayObjectContainer = HtmlDom;
#end

private enum Direction {
	HORIZONTAL;
	VERTICAL;
}
private enum DecelerationRate {
	RCScrollViewDecelerationRateNormal;
	RCScrollViewDecelerationRateFast;
}

class RCSliderSync {
	
	var target :DisplayObjectContainer; // object to attach the mousewheel
	var contentView :RCView; // object to scroll
	var slider :RCScrollBar;
	var direction :Direction;
	var f :Int;
	var decelerationRate :DecelerationRate;
	var ticker :EVLoop;
	var mouseWheel :EVMouse;
	
	public var valueMax (default, setMaxValue) :Int;
	public var valueStart (default, setStartValue) :Int;
	public var valueFinal (default, setFinalValue) :Int;// the current value between start and max
	
	public var valueChanged :RCSignal<RCSliderSync->Void>;
	public var contentValueChanged :RCSignal<Void>;
	dynamic public function onScrollLeft() :Void {}
	dynamic public function onScrollRight() :Void {}
	
	
	public function new (	target:DisplayObjectContainer, contentView:RCView,
							slider:RCScrollBar, valueMax:Float, direction:String)
	{
		this.target = target;
		this.contentView = contentView;
		this.slider = slider;
		this.direction = direction == "horizontal" ? HORIZONTAL : VERTICAL;
		this.valueMax = Math.round ( valueMax );
		this.valueStart = Math.round ( getContentPosition() );
		this.valueFinal = valueStart;
		this.f = 1;
		
		valueChanged = new RCSignal<RCSliderSync->Void>();
		ticker = new EVLoop();
		mouseWheel = new EVMouse (EVMouse.WHEEL, target);
		resume();
	}
	
	
	/**
	 * Hold and resume actions
	 */
	public function hold () :Void {
		mouseWheel.remove ( wheelHandler );
		slider.valueChanged.remove ( sliderChangedHandler );
	}
	public function resume () :Void {
		mouseWheel.add ( wheelHandler );
		slider.valueChanged.add ( sliderChangedHandler );
	}
	
	
	/**
	 *	Handle scroll events
	 *	When wheel is scrolled move the content rather the scrollbar
	 */
	function wheelHandler (e:EVMouse) :Void {
		
		valueFinal += e.delta;
		startLoop();
		
		// Determine the correct position for the slider
		slider.value = Zeta.lineEquationInt (0, 100, valueFinal, valueStart, valueStart + valueMax - getContentSize());
		
		// dispatch an event with the direction the scroll is moving
		(e.delta < 0) ? onScrollRight() : onScrollLeft();
	}
	
	function sliderChangedHandler (e:RCScrollBar) :Void {
		
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
			
		ticker.run = loop;
	}
	
	
	/**
	 *	This moves the content with an easing equation
	 */
	function loop () {
		
		// Calculate the next position for target object
		var next_value = ( valueFinal - getContentPosition() ) / 3;
		
		// remove the enterframe listener
		if (Math.abs ( next_value ) < 1) {
			ticker.run = null;
			moveContentTo ( valueFinal );
		}
		else moveContentTo ( getContentPosition() + next_value );
		
		valueChanged.dispatch ( this );
	}
	
	function moveContentTo (next_value:Float) :Void {
		
		(direction == HORIZONTAL)
		? contentView.x = Math.round ( next_value )
		: contentView.y = Math.round ( next_value );
	}
	
	function getContentPosition () :Float {
		return (direction == HORIZONTAL) ? contentView.x : contentView.y;
	}
	
	function getContentSize () :Float {
		return (direction == HORIZONTAL) ? contentView.width : contentView.height;
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
		
		hold();
		valueChanged.destroy();
		ticker.destroy();
		mouseWheel.destroy();
	}
}
