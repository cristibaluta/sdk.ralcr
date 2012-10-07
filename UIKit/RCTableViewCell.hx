//
//  RCTableViewCell
//
//  Created by Baluta Cristian on 2011-06-30.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCTableViewCell extends RCControl {
	
	public var identifier :String;
	public var indexPath :RCIndexPath;
	
	var backgroundView :RCRectangle;
	var separatorView :RCRectangle;
	public var titleView :RCTextView;
	
	
	public function new (w, h) {
		super (0, 0, w, h);
		init();
	}
	
	override public function init () {
		
		super.init();
		
		backgroundView = new RCRectangle (0, 0, size.width, size.height-1, 0xFFFFFF, 1);
		this.addChild ( backgroundView );
		
		separatorView = new RCRectangle (0, size.height-1, size.width, 1, 0x999999);
		this.addChild ( separatorView );
		
		titleView = new RCTextView (10, 6, null, null, " ", RCFont.systemFontOfSize(12));
		titleView.y = Math.round ((size.height - titleView.height) / 2);
		titleView.layer.mouseChildren = false;
		this.addChild ( titleView );
	}
	
	override function rollOverHandler (e:EVMouse) :Void {
		backgroundView.color.fillColor = 0x578ccb;
		backgroundView.redraw();
		super.rollOverHandler( e );
	}
	override function rollOutHandler (e:EVMouse) :Void {
		backgroundView.color.fillColor = 0xffffff;
		backgroundView.redraw();
		super.rollOutHandler( e );
	}
}
