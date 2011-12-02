//
//  RCSegmentControl
//
//  Created by Baluta Cristian on 2011-08-18.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//

class SegmentControl extends RCView {
	
	var values :Array<String>;
	var buttons :RCGroupButtons<RCButton>;
	var segmentWidth :Int;
	public var selectedIndex (getIndex, setIndex) :Int;
	
	
	public function new (x, y, w, h) {
		super(x, y);
		this.w = w;
		this.h = h;
	}
	public function init (values:Array<String>) :Void {
		this.segmentWidth = Math.round (w / values.length);
		this.values = values;
		
		buttons = new RCGroupButtons<RCButton> (0, 0, 0, null, constructButton);
		buttons.add ( this.values );
		buttons.addEventListener (GroupEvent.CLICK, clickHandler);
		this.addChild ( buttons );
		
		for (i in 0...values.length-1) {
			this.addChild ( new RCRectangle (segmentWidth+segmentWidth*i, 0, 1, h, 0x333333) );
		}
	}
	function constructButton (label:String) :RCButton {
		
		var segmentLeft :String;
		var segmentMiddle :String;
		var segmentRight :String;
		
		switch (label) {
			case values[0]: segmentLeft = "L"; segmentMiddle = "M"; segmentRight = "MR"; // First
			case values[values.length-1]: segmentLeft = "ML"; segmentMiddle = "M"; segmentRight = "R"; // Last
			default: segmentLeft = "ML"; segmentMiddle = "M"; segmentRight = "MR"; // Middle
		}
		
		var s = new SkinButtonSegment (label, segmentWidth, h, segmentLeft, segmentMiddle, segmentRight, null);
		var b = new RCButton (0, 0, s);
			b.toggable = true;
		return b;
	}
	function clickHandler (e:GroupEvent) :Void {
		this.dispatchEvent ( e.duplicate() );
	}
	
	
	public function getIndex () :Int {
		return selectedIndex;
	}
	public function setIndex (i:Int) :Int {
		buttons.select ( values[i] );
		selectedIndex = i;
		return getIndex();
	}
}
