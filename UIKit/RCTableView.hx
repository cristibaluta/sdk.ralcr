//
//  TableView
//
//  Created by Baluta Cristian on 2011-06-15.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;


class RCTableView<T:RCControl> extends RCView {
	
	
	public var backgroundView :RCRectangle;
	var contentView :Sprite;
	var contentMask :RCRectangle;
	var scrollIndicator :RCRectangle;
	
	var cells :Array<RCTableViewCell>;
	public var indexes :Array<String>;
	public var delegate :Dynamic;
	var anim :CATween;
	public var indexPath :RCIndexPath;
	var maxCells :Int;
	
	// Dragging and Throwing variables
	var vy :Float;
	var oldY :Float;
	var dragging :Bool;
	var inertia :Float;
	var changeOrder :Bool;
	
	
	public function new (x, y, w, h) {
		super(x, y);
		size.width = w;
		size.height = h;
		this.indexPath = new RCIndexPath (0, 0);
		this.inertia = 0.95;
		this.dragging = false;
		this.vy = 0;
		this.oldY = 0;
		
		backgroundView = new RCRectangle (0, 0, size.width, size.height, 0x999999, 1, 32);
		backgroundView.addChild ( new RCRectangle (1, 1, size.width-2, size.height-2, 0xFFFFFF, 1, 30) );
		this.addChild ( backgroundView );
		
		contentView = new Sprite();
		this.addChild ( contentView );
		
		contentMask = new RCRectangle (1, 1, size.width-2, size.height-2, 0xFFFFFF, 1, 30);
		contentView.mask = contentMask;
		this.addChild ( contentMask );
		
		scrollIndicator = new RCRectangle (size.width-10, 1, 6, 50, 0xffffff, .6, 6);
		scrollIndicator.alpha = 0;
		this.addChild ( scrollIndicator );
		
		cells = new Array<RCTableViewCell>();
		
		
		contentView.addEventListener (MouseEvent.MOUSE_DOWN, startDragCells);
	}
	
	public function init () :Void {
		
		maxCells = Math.ceil (size.height/44+1);
		
		for (i in 0...maxCells) {
			var cell :RCTableViewCell = delegate.cellForRowAtIndexPath ( new RCIndexPath (0, i) );
			cells.push ( cell );
			contentView.addChild ( cell );
		}
		
		reloadData();
	}
	
	public function reloadData () {
		for (i in indexPath.row...(indexPath.row + maxCells)) {
			cells[i].indexPath.row = i;
			Reflect.callMethod (delegate, Reflect.field (delegate, "claimDataForCell"), [cells[i]] );
		}
	}
	
	// Table view delegate
	function clickHandler (e:GroupEvent) :Void {
		this.dispatchEvent ( e.duplicate() );
	}
	
	
	function startDragCells(_){
		dragging = true;
		oldY = this.mouseY;
		vy = 0;
		
		this.addEventListener (Event.ENTER_FRAME, loop);
		this.addEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
		RCStage.stage.addEventListener (MouseEvent.MOUSE_UP, stopDragCells);
	}
	function stopDragCells(_){
		dragging = false;
		//CoreAnimation.remove ( anim );
		
		RCStage.stage.removeEventListener (MouseEvent.MOUSE_UP, stopDragCells);
		this.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
		
/*		if (contentView.y > 0) {
			anim = new CATween (contentView, {y:0}, 0.5, 0, caequations.Cubic.OUT);
			CoreAnimation.add ( anim );
		}
		else if (contentView.y < 260-contentView.height) {
			anim = new CATween (contentView, {y:260-contentView.height}, 0.5, 0, caequations.Cubic.OUT);
			CoreAnimation.add ( anim );
		}*/
	}
	
	function mouseMove (e:MouseEvent) {
		if (dragging) {
			vy = this.mouseY - oldY;
			oldY = this.mouseY;
			if (vy > 44)
				vy = 44;
			if (vy < -44)
				vy = -44;
		}
		e.updateAfterEvent();
	}
	public function mouseWheel (delta:Int) {
		vy = delta;
		if (vy > 44)
			vy = 44;
		if (vy < -44)
			vy = -44;
		this.addEventListener (Event.ENTER_FRAME, loop);
	}
	function loop (e:Event) {
		scrollIndicator.alpha = 1;
		
		for (i in 0...cells.length) {
			cells[i].y = i==0 ? Math.round (cells[i].y + vy) : Math.round (cells[i-1].y + cells[i-1].height);
			
			// Decide direction
			// From up to down
			if (cells[0].y > 1) {
				if (cells[0].indexPath.row == 0) {
					vy = 0;//-Math.abs(vy);
					cells[0].y = 0;
				}
				else {
					var cell = cells.pop();
						cell.indexPath.row = (cells[0].indexPath.row - 1);
					indexPath = cell.indexPath;
					//cells[maxCells - 1].indexPath.row = cells[maxCells - 1].indexPath.row - maxCells + 1;
					cells.unshift ( cell );
					cells[0].y = Math.round (cells[1].y - cells[0].height);
					Reflect.callMethod (delegate, Reflect.field (delegate, "claimDataForCell"), [cells[0]] );
				}
			}
			
			// From down to up
			else if (cells[0].y < -cells[0].height-1) {
				if (indexPath.row >= delegate.numberOfRowsInSection(0)) {
					cells[0].y -= vy;
					vy = 0;//-Math.abs(vy);
					//cells[0].y = 0;
				}
				else {
					var cell = cells.shift();
						cell.indexPath.row += maxCells;
					cells.push ( cell );
					indexPath = cell.indexPath;
					//cells[maxCells - 1].y = Math.round (cells[maxCells - 2].y + cells[maxCells - 2].height);
					Reflect.callMethod (delegate, Reflect.field (delegate, "claimDataForCell"), [cells[maxCells - 1]] );
					loop(null);
					break;
				}
			}
		}
		if (!dragging) {
			vy *= inertia;
			if (Math.abs (vy) < 1) {
				this.removeEventListener (Event.ENTER_FRAME, loop);
				scrollIndicator.alpha = 0;
			}
		}
		else {
			vy *= inertia;
		}
		
		scrollIndicator.y = Zeta.lineEquationInt (0, size.height-scrollIndicator.height, indexPath.row, 0, delegate.numberOfRowsInSection(0));
	}
	
	
	
	public function resize (w, h) :Void {
		size.width = w;
		size.height = h;
	}
}
