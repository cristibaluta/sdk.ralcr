//
//  RCSkin.hx - A collection of organized views that will get displayed in a RCControl
//
//  Created by Baluta Cristian on 2008-07-03.
//  Copyright (c) 2008-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

typedef RCSkinElements = {
	var background :RCView;
	var label :RCView;
	var image :RCView;
	var otherView :RCView;
	var colors :RCSkinColors;
	var scale :Float;
}
typedef RCSkinColors = {
	var background :Null<Int>;
	var label :Null<Int>;
	var image :Null<Int>;
	var otherView :Null<Int>;
}

class RCSkin {
	
	// NORMAL / HIGHLIGHTED / DISABLED / SELECTED / HIT_AREA
	public var normal :RCSkinElements;
	public var highlighted :RCSkinElements;
	public var disabled :RCSkinElements;
	public var selected :RCSkinElements;
	public var hit :RCView;
	
	
	/**
	*  Extend this class and create views for each state
	* @param colors - an array of colours for:
	*  colors[0] is for NORMAL background
	*  colors[1] is for NORMAL label
	*  colors[2] is for HIGHLIGHTED background
	*  colors[3] is for HIGHLIGHTED label
	*/
	public function new (?colors : Array<Null<Int>>)
	{
		normal		= {background:null, label:null, image:null, otherView:null, colors:{background:null, label:null, image:null, otherView:null}, scale:1};
		highlighted	= {background:null, label:null, image:null, otherView:null, colors:{background:null, label:null, image:null, otherView:null}, scale:1};
		disabled	= {background:null, label:null, image:null, otherView:null, colors:{background:null, label:null, image:null, otherView:null}, scale:1};
		selected	= {background:null, label:null, image:null, otherView:null, colors:{background:null, label:null, image:null, otherView:null}, scale:1};
		
		if (colors != null) {
			normal.colors.background = colors[0];
			normal.colors.label = colors[1];
			highlighted.colors.background = colors[2];
			highlighted.colors.label = colors[3];
			disabled.colors.background = colors[2];
			disabled.colors.label = colors[3];
		}
	}
	public function destroy(){
		// Override this method
	}
}
