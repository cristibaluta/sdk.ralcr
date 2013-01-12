//
//  RCTableViewCell
//
//  Created by Baluta Cristian on 2011-06-30.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCTableViewCell extends RCControl {
	
	public var indexPath :RCIndexPath;
	public var backgroundView :RCRectangle;
	public var separatorView :RCRectangle;
	public var titleView :RCTextView;
	
	
	public function new (w, h) {
		super (0, 0, w, h);
		init();
		setup();
	}
	
	public function setup () {
		
		backgroundView = new RCRectangle (0, 0, size.width, size.height-1, 0xFFFFFF, 1);
		this.addChild ( backgroundView );
		
		separatorView = new RCRectangle (0, size.height-1, size.width, 1, 0x999999);
		this.addChild ( separatorView );
		
		titleView = new RCTextView (10, 6, null, null, " ", RCFont.systemFontOfSize(12));
		titleView.y = Math.round ((size.height - titleView.height) / 2);
		#if flash
		titleView.layer.mouseChildren = false;
		#end
		this.addChild ( titleView );
	}
	
	override function rollOverHandler (e:EVMouse) :Void {
		if (backgroundView != null) {
			backgroundView.color.fillColor = 0x578ccb;
			backgroundView.redraw();
		}
		super.rollOverHandler( e );
	}
	override function rollOutHandler (e:EVMouse) :Void {
		if (backgroundView != null) {
			backgroundView.color.fillColor = 0xffffff;
			backgroundView.redraw();
		}
		super.rollOutHandler( e );
	}
	
	override public function destroy () {
		Fugu.safeDestroy ([backgroundView, separatorView, titleView]);
		backgroundView = null;
		separatorView = null;
		titleView = null;
		
		super.destroy();
	}
	
	override public function toString () {
		return "[RCTableViewCell indexPath="+indexPath+"]";
	}
}

