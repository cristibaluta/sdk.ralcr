//
//  RCSegmentedControl
//	A component that holds a group of radio buttons. Only one button can be selected at a given time
//	The buttons cannot have the same label
//
//  Created by Baluta Cristian
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCSegmentedControl extends RCView {
	
	var skin :Class<RCSkin>;
	var labels :Array<String>;
	var items :HashArray<RCButtonRadio>;
	var segmentsWidth :Array<Int>;
	var selectedIndex_ :Int;
	
	public var click :RCSignal<RCSegmentedControl->Void>;
	public var itemAdded :RCSignal<RCSegmentedControl->Void>;
	public var itemRemoved :RCSignal<RCSegmentedControl->Void>;
	public var selectedIndex (get_selectedIndex, set_selectedIndex) :Int;
	
	
	public function new (x, y, w:Int, h:Int, ?skin:Class<RCSkin>) {
		
		super (x, y, w, h);
		
		selectedIndex_ = -1;// Init this with -1
		items = new HashArray<RCButtonRadio>();
		click = new RCSignal<RCSegmentedControl->Void>();
		itemAdded = new RCSignal<RCSegmentedControl->Void>();
		itemRemoved = new RCSignal<RCSegmentedControl->Void>();
		
		if (skin == null)
			skin = ios.SKSegment;// If not otherwise specified use by default this Skin Class
		this.skin = skin;
	}
	
	/**
	 *  Init the SegmentedControl with labels
	 *  @param equalSizes - if the segments are split equaly on the provided width
	 **/
	public function initWithLabels (labels:Array<String>, ?equalSizes:Bool=true) :Void {
		
		this.labels = labels;
		this.segmentsWidth = new Array<Int>();
		
		if (equalSizes) {
			var segmentWidth = Math.round (size.width / labels.length);
			for (l in labels)
				segmentsWidth.push ( segmentWidth );
		}
		else {
			// Split the available width in equivalent widths for each label
			var labelLengths = new Array<Float>();
			var totalLabelsLength = 0;
			for (l in labels) {
				labelLengths.push ( l.length );
				totalLabelsLength += l.length;
			}
			
			// size.width ............. 100%
			// w ...................... p%
			
			// w1+w2+w3 ............... 100%
			// w1 ..................... w1 %
			// w2 ..................... w2 %
			// w3 ..................... w3 %
			for (ll in labelLengths) {
				var p = ll * 100 / totalLabelsLength;// The width of the segment in percents
				segmentsWidth.push ( Math.round ( p * size.width / 100));
			}
		}
		
		
		// Push the new values into main array
		var i = 0;
		for (label in labels) {
			if (items.exists( label )) continue;
			
			var b = constructButton ( i );
				b.onClick = clickHandler.bind (label);
				//b.click.add ( clickHandler );
			this.addChild ( b );
			b.init();
			
			// Keep the button into a hash table
			items.set( label, b);
			
			// dispatch an event that the buttons structure has changed
			itemAdded.dispatch ( this );
			
			i++;
		}
		
		// Finaly arrange all buttons one after another
		keepButtonsArranged();
		
/*		for (i in 0...values.length-1) {
			this.addChild ( new RCRectangle (segmentWidth+segmentWidth*i, 0, 1, h, 0x333333) );
		}
		*/
	}
	function constructButton (i:Int) :RCButtonRadio {
		
/*		var last :Int = labels.length - 1;
		var position = switch (i) {
			case 0:		"left"; // First
			case last:	"right"; // Last
			case _:	"middle"; // Middle
		}*/
		var position = "middle";
		if (i == 0) position = "left";
		if (i == labels.length - 1) position = "left";
		
		var segmentX = 0;
		for (j in 0...i) {
			segmentX += segmentsWidth[j];
		}
		var s = Type.createInstance (skin, [labels[i], segmentsWidth[i], size.height, position, null]);
		var b = new RCButtonRadio (segmentX, 0, s);

		return b;
	}
	
	// Setter for selectedIndex
	public function get_selectedIndex () :Int {
		return selectedIndex_;
	}
	public function set_selectedIndex (i:Int) :Int {
		trace("setIndex "+selectedIndex_ +" > "+i);
		if (selectedIndex_ == i) return i;
			selectedIndex_ = i;
			
		select ( labels[i] );// Select the label at index i
		
		return selectedIndex_;
	}

	/**
	 *	Remove button with label
	 */
	public function remove (label:String) :Void {
		//trace("REMOVE FROM HASH: "+label);
		if (items.exists( label )) {
			Fugu.safeDestroy ( items.get( label ) );
			items.remove( label );
		}
		
		// Arrange all buttons
		keepButtonsArranged();
		
		// Dispatch an event that the button has been removed
		itemRemoved.dispatch ( this );
	}
	
	
	/**
	 *	Keep all the buttons arranged after an update operation
	 */
	public function keepButtonsArranged () :Void {
		return;
		// iterate over buttons and arrange them on x axis
		for (i in 0...items.array.length) {
			var newX = 0.0, newY = 0.0;
			var new_b = items.get ( items.array[i] );
		}
	}
	
	
	/**
	 * Select the button for the new label
	 *  @param label - The label of the pressed button
	 *	@param can_unselect - Unselect the other buttons as soon as a new one is pressed
	 */
	public function select (label:String, ?can_unselect:Bool=true) :Void {
		trace("select "+label+", "+can_unselect);
		if (items.exists( label )) {
			// Select the current label
			items.get( label ).toggle();

			if (can_unselect)
				items.get( label ).enabled = false;
			else
				items.get( label ).enabled = true;
		}
		
		// Unselect other labels
		if (can_unselect)
			for (key in items.keys())
				if (key != label)
					//if (items.get( key ).enabled)
						unselect ( key );
	}
	
	public function unselect (label:String) :Void {
		items.get( label ).enabled = true;
		items.get( label ).untoggle();
	}
	
	public function toggled (label:String) :Bool {
		return items.get( label ).selected;
	}
	
	/**
	 *	Returns a reference to a specified button.
	 *	Usefull if you want to change it's properties
	 */
	public function get (label:String) :RCButtonRadio {
		return items.get( label );
	}
	
	/**
	 *	Checks if a specified label exists already
	 */
	public function exists (label:String) :Bool {
		return items.exists( label );
	}
	
	
	/**
	 *	Enable or disable a button
	 *  @param label - The label of the button to enable/disable
	 */
	public function enable (label:String) :Void {
		items.get( label ).enabled = true;
		items.get( label ).alpha = 1;
	}
	public function disable (label:String) :Void {
		items.get( label ).enabled = false;
		items.get( label ).alpha = 0.4;
	}
	
	
	// Dispatch events
	function clickHandler (label:String) :Void {
		set_selectedIndex ( items.indexForKey( label ));
		click.dispatch ( this );
	}
	
	
	override public function destroy () :Void {
		if (items != null)
		for (key in items.keys()) Fugu.safeDestroy ( items.get( key ) );
			items = null;
		click.destroy();
		itemAdded.destroy();
		itemRemoved.destroy();
		super.destroy();
	}
}
