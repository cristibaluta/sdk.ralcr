//
//  RCTableView
//	A table is a list of items arranged verticaly, 
//
//  Created by Baluta Cristian on 2011-06-15.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCTableView extends RCView {
	
	public var backgroundView :RCRectangle;
	var contentView :RCView;
	var scrollIndicator :RCRectangle;
	
	var cells :Array<RCTableViewCell>;
	public var indexes :Array<String>;
	public var delegate :Dynamic;
	public var indexPath :RCIndexPath;
	var anim :CATween;
	var maxCells :Int;
	
	// Dragging and Throwing
	var vy :Float;
	var oldY :Float;
	var dragging :Bool;
	var inertia :Float;
	var changeOrder :Bool;
	var timer :haxe.Timer;
	var mousePress_ :EVMouse;
	var mouseMove_ :EVMouse;
	var mouseUp_ :EVMouse;
	
	
	public function new (x, y, w, h) {
		
		super (x, y);
		
		size.width = w;
		size.height = h;
		this.indexPath = new RCIndexPath (0, 0);
		this.inertia = 0.95;
		this.dragging = false;
		this.vy = 0;
		this.oldY = 0;
		
		backgroundView = new RCRectangle (0, 0, size.width, size.height, 0x999999, 1, 32);
		this.addChild ( backgroundView );
		
		contentView = new RCRectangle (1, 1, size.width-2, size.height-2, 0xFFFFFF, 1, 30);
		this.addChild ( contentView );
		contentView.clipsToBounds = true;
		
		scrollIndicator = new RCRectangle (size.width-10, 1, 6, 50, 0xffffff, .6, 6);
		scrollIndicator.alpha = 0;
		this.addChild ( scrollIndicator );
		
		cells = [];
		
		mousePress_ = new EVMouse (EVMouse.DOWN, contentView);
		mouseMove_ = new EVMouse (EVMouse.MOVE, this);
		mouseUp_ = new EVMouse (EVMouse.UP, RCWindow.sharedWindow().stage);
	}
	
	override public function init () :Void {
		
		maxCells = Math.ceil (size.height/44+1);
		
		for (i in 0...maxCells) {
			var cell :RCTableViewCell = delegate.cellForRowAtIndexPath ( new RCIndexPath (0, i) );
			cells.push ( cell );
			contentView.addChild ( cell );
		}
		
		reloadData();
		mousePress_.add ( startDragCells );
	}
	
	public function reloadData () {
		for (i in indexPath.row...(indexPath.row + maxCells)) {
			cells[i].indexPath.row = i;
			dataForCell ( i );
		}
	}
	function dataForCell (i:Int) :Void {
		try {
			delegate.dataForCell ( cells[i] );
		}
		catch(e:Dynamic){ trace("There's no method called 'dataForCell(cell:RCTableViewCell)' in the delegate class"); }
	}
	
	function startDragCells (e:EVMouse) {
		dragging = true;
		oldY = this.mouseY;
		vy = 0;
		mouseMove_.add ( mouseMoveHandler );
		mouseUp_.add ( stopDragCells );
		startLoop();
	}
	function stopDragCells (e:EVMouse) {
		dragging = false;
		//CoreAnimation.remove ( anim );
		
		mouseMove_.remove ( mouseMoveHandler );
		mouseUp_.remove ( stopDragCells );
		
/*		if (contentView.y > 0) {
			anim = new CATween (contentView, {y:0}, 0.5, 0, caequations.Cubic.OUT);
			CoreAnimation.add ( anim );
		}
		else if (contentView.y < 260-contentView.height) {
			anim = new CATween (contentView, {y:260-contentView.height}, 0.5, 0, caequations.Cubic.OUT);
			CoreAnimation.add ( anim );
		}*/
	}
	
	function mouseMoveHandler (e:EVMouse) {
		if (dragging) {
			vy = this.mouseY - oldY;
			oldY = this.mouseY;
			if (vy > 44)
				vy = 44;
			if (vy < -44)
				vy = -44;
		}
		//e.updateAfterEvent();
	}
	public function mouseWheel (delta:Int) {
		vy = delta;
		if (vy > 44)
			vy = 44;
		if (vy < -44)
			vy = -44;
		startLoop();
	}
	function startLoop () {
		stopLoop();
		timer = new haxe.Timer(10);
		timer.run = loop;
	}
	function stopLoop () {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}
	function loop () {
		scrollIndicator.alpha = 1;
		
		for (i in 0...cells.length) {
			cells[i].y = (i==0) ? Math.round (cells[i].y + vy) : Math.round (cells[i-1].y + cells[i-1].height);
			
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
					dataForCell ( 0 );
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
					dataForCell ( maxCells - 1 );
					loop();
					break;
				}
			}
		}
		if (!dragging) {
			vy *= inertia;
			if (Math.abs (vy) < 1) {
				stopLoop();
				scrollIndicator.alpha = 0;
			}
		}
		else {
			vy *= inertia;
		}
		
		scrollIndicator.y = Zeta.lineEquationInt (0, size.height-scrollIndicator.height, indexPath.row, 0, delegate.numberOfRowsInSection(0));
	}
	
	
	
/*	public function resize (w, h) :Void {
		size.width = w;
		size.height = h;
	}*/
	override public function destroy () {
		stopLoop();
		super.destroy();
	}
}
