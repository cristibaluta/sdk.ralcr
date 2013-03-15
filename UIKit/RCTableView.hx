//
//  RCTableView
//	A table is a list of items arranged verticaly, 
//
//  Created by Baluta Cristian on 2011-06-15.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (objc && ios)
	import ios.ui.UITableView;
#end
	
class RCTableView extends RCView {
	
	public var backgroundView :RCView;
	public var contentView :RCView;// Cells are added here
	public var scrollView :RCView;
	public var scrollIndicator :RCRectangle;
	public var indexPath :RCIndexPath;// indexPath of the last updated cell
	
	var anim :CATween;
	var cells :Array<RCTableViewCell>;
	var cellForRowAtIndexPath :RCIndexPath->RCTableViewCell->RCTableViewCell;
	var numberOfRowsInSection :Int->Int;
	
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
	var cell_min_h :Float;
	
	
	public function new (x, y, w, h, cellForRowAtIndexPath : RCIndexPath->RCTableViewCell->RCTableViewCell, numberOfRowsInSection : Int->Int) {
		
		super (x, y, w, h);
		
		this.cellForRowAtIndexPath = cellForRowAtIndexPath;
		this.numberOfRowsInSection = numberOfRowsInSection;
		this.indexPath = new RCIndexPath (0, 0);
		this.inertia = 0.95;
		this.dragging = false;
		this.vy = 0;
		this.oldY = 0;
		this.cell_min_h = Math.POSITIVE_INFINITY;
		
		backgroundView = new RCView (0,0,w,h);
		//RCRectangle (0, 0, size.width, size.height, 0x999999, 1, 32);
		this.addChild ( backgroundView );
		
		contentView = new RCView (1,1,w-2,h-2);
		//new RCRectangle (1, 1, size.width-2, size.height-2, 0xFFFFFF, 1, 30);
		this.addChild ( contentView );
		contentView.clipsToBounds = true;
		
		scrollView = new RCView (0,0);
		//scrollView.layer.cacheAsBitmap = true;
		contentView.addChild ( scrollView );
		
		scrollIndicator = new RCRectangle (w-10, 1, 6, 50, 0xffffff, .6, 6);
		scrollIndicator.alpha = 0;
		this.addChild ( scrollIndicator );
		
		cells = [];
		
		mousePress_ = new EVMouse (EVMouse.DOWN, scrollView);
		mouseMove_ = new EVMouse (EVMouse.MOVE, this);
		mouseUp_ = new EVMouse (EVMouse.UP, RCWindow.sharedWindow().stage);
	}
	
	override public function init () :Void {
		
		var max_h = 0.0, i = 0, rows = this.numberOfRowsInSection(0);
		
		while (max_h < size.height && i < rows) {
			// Ask the external function to provide a new cell
			var cell :RCTableViewCell = this.cellForRowAtIndexPath ( new RCIndexPath (0, i), null );
				cell.indexPath = new RCIndexPath (0, i);
				cell.y = max_h;
			cells.push ( cell );
			scrollView.addChild ( cell );
			max_h += cell.height;
			if (cell.height < cell_min_h)
				cell_min_h = cell.height;
			i ++;
		}
		
		mousePress_.add ( startDragCells );
		mouseMove_.add ( mouseMoveHandler );
		mouseUp_.add ( stopDragCells );
		mouseMove_.enabled = false;
		mouseUp_.enabled = false;
	}
	
	// Reload cells
	public function reloadData () :Void {
		
		for (cell in cells) {
			// This will cause the cell to be updated with new data
			this.cellForRowAtIndexPath ( cell.indexPath, cell );
		}
	}
	
	
	public function scrollToRowAtIndexPath (indexPath:RCIndexPath, cellPosition:Int=0) :Void {
	
	}
	
	
	// Dragging
	
	function startDragCells (e:EVMouse) {
		dragging = true;
		mouseMove_.enabled = true;
		mouseUp_.enabled = true;
		oldY = this.mouseY;
		vy = 0;
		startLoop();
	}
	
	function stopDragCells (e:EVMouse) {
		dragging = false;
		mouseMove_.enabled = false;
		mouseUp_.enabled = false;
		trace("stop scrollView "+scrollView.y);
		//RCAnimation.remove ( anim );
		if (scrollView.y > 0) {
			anim = new CATween (scrollView, {y:0}, 0.5, 0, eq.Cubic.OUT);
			RCAnimation.add ( anim );
			vy = 0;
			stopLoop();
		}
/*		else if (contentView.y < 260-contentView.height) {
			anim = new CATween (contentView, {y:260-contentView.height}, 0.5, 0, eq.Cubic.OUT);
			RCAnimation.add ( anim );
		}*/
	}
	
	function mouseMoveHandler (e:EVMouse) {
		if (dragging) {
			vy = this.mouseY - oldY;
			oldY = this.mouseY;
			if (vy > cell_min_h)
				vy = cell_min_h;
			if (vy < -cell_min_h)
				vy = -cell_min_h;
			if (scrollView.y > 0)
				vy = vy * 0.24;
			else if (scrollView.y < size.height-numberOfRowsInSection(0)*cell_min_h) {
				scrollView.y = size.height-numberOfRowsInSection(0)*cell_min_h;
				vy = 0;
			}
		}
		//e.updateAfterEvent();
	}
	
	
	
	public function mouseWheel (delta:Int) {
		vy = delta;
		if (vy > cell_min_h)
			vy = cell_min_h;
		if (vy < -cell_min_h)
			vy = -cell_min_h;
		startLoop();
	}
	function startLoop () {
		if (timer == null) {
			timer = new haxe.Timer(10);
			timer.run = loop;
		}
	}
	function stopLoop () {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}
	function loop () {
		//trace("loop "+vy);
		scrollIndicator.alpha = 1;
		scrollView.y = Math.round (scrollView.y + vy);
		
		// Reuse cells when out of view
		// Scrolling down
		if (cells[0].y + scrollView.y > 1) {
			if (cells[0].indexPath.row > 0) {
				// Take the last cell and add it on top
				var cell = cells.pop();
				cells.unshift ( cell );
				// Init the cell with new data
				cell.indexPath.row = cells[1].indexPath.row - 1;
				indexPath = cell.indexPath;
				cells[0].y = Math.round (cells[1].y - cells[0].height);
				cell = cellForRowAtIndexPath ( cell.indexPath, cell );
			}
			else if (!dragging) vy *= -0.5;
		}
		// Scrolling up
		else if (cells[0].y + scrollView.y  < -cells[0].height-1) {
			if (indexPath.row < numberOfRowsInSection(0)-1) {
				// Take the first cell and push it to the bottom
				var cell = cells.shift();
				cells.push ( cell );
				// Init the cell with new data
				cell.indexPath.row = cells[cells.length-2].indexPath.row + 1;
				cell = cellForRowAtIndexPath ( cell.indexPath, cell );
				cell.y = Math.round ( cells[cells.length-2].y + cells[cells.length-2].height );
				indexPath = cell.indexPath;
				loop();
			}
			else if (!dragging) vy *= -0.5;
		}
		
		vy *= inertia;
		if (!dragging && Math.abs (vy) < 1) {
			stopLoop();
			scrollIndicator.alpha = 0;
		}
		#if cpp
			//crashes
		//trace("Classes in uses: " + cpp.vm.Gc.trace( ScoreTableViewCell, false ) );
		#end
		scrollIndicator.y = Zeta.lineEquationInt (0, size.height-scrollIndicator.height, indexPath.row, 0, numberOfRowsInSection(0));
	}
	
	
	
/*	public function resize (w, h) :Void {
		size.width = w;
		size.height = h;
	}*/
	override public function destroy () {
		stopLoop();
		Fugu.safeDestroy ( cells );
		Fugu.safeDestroy ( [backgroundView, contentView, scrollIndicator, mousePress_, mouseMove_, mouseUp_] );
		cells = null;
		backgroundView = null;
		contentView = null;
		scrollIndicator = null;
		mousePress_ = null;
		mouseMove_ = null;
		mouseUp_ = null;
		
		super.destroy();
	}
}
