//
//  RCCell
//
//  Created by Baluta Cristian on 2011-06-30.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.geom.Point;
import flash.events.MouseEvent;


class RCTableViewCell extends RCControl {
	
	public var identifier :String;
	public var indexPath :RCIndexPath;
	
	var backgroundView :RCRectangle;
	var separatorView :RCRectangle;
	public var titleView :RCTextView;
	
	
	public function new (w, h) {
		super (x, y);
		this.size = new RCSize (w, h);
		init();
	}
	
	public function init () {
		
		backgroundView = new RCRectangle (0, 0, size.width, size.height-1, 0xFFFFFF, 1);
		this.addChild ( backgroundView );
		
		separatorView = new RCRectangle (0, size.height-1, size.width, 1, 0x999999);
		this.addChild ( separatorView );
		
		titleView = new RCTextView (10, 6, null, null, " ", FontManager.getRCFont("system", {color:0x000000, selectable:false}));
		titleView.y = Math.round ((size.height - titleView.height) / 2);
		titleView.mouseChildren = false;
		this.addChild ( titleView );
	}
	
	override function rollOverHandler (e:MouseEvent) :Void {
		backgroundView.color.fillColor = 0x578ccb;
		backgroundView.redraw();
		super.rollOverHandler( e );
	}
	override function rollOutHandler (e:MouseEvent) :Void {
		backgroundView.color.fillColor = 0xffffff;
		backgroundView.redraw();
		super.rollOutHandler( e );
	}
}
