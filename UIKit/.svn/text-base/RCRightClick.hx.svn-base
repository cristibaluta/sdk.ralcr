//
//  RightClick
//
//  Created by Baluta Cristian on 2007-08-15.
//  Copyright (c) 2007 http://ralcr.com. All rights reserved.
//
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.events.ContextMenuEvent;


class RCRightClick {
	
	var cm_hash :Hash<ContextMenuItem>;
	var cm :ContextMenu;
	
	
	public function new () {
		
		cm = new ContextMenu();
		cm.hideBuiltInItems();
		cm_hash = new Hash<ContextMenuItem>();
	}
	
	
	public function add (key:String, ?func:Dynamic, separatorBefore:Bool=true, ?enabled:Bool=true) :Void {
		
		if (cm_hash.exists( key ))
			remove ( key );
		
		var cmi = new ContextMenuItem ( key, separatorBefore, enabled );
		if (func != null)
			cmi.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, func);
			cm.customItems.push ( cmi );
			
		cm_hash.set ( key, cmi );
	}
	
	public function remove (key:String) :Void {
		if (cm_hash.exists( key )) {
			cm.customItems.remove ( cm_hash.get( key ) );
			cm_hash.remove( key );
		}
	}
	
	
	public function enable (key:String) :Void {
		if (cm_hash.exists( key )) {
			cm_hash.get( key ).enabled = true;
		}
	}
	public function disable (key:String) :Void {
		if (cm_hash.exists( key )) {
			cm_hash.get( key ).enabled = false;
		}
	}
	
	/**
	 *	Apply the newly created custom menu
	 */
	public function apply (target:Dynamic) :Void {
		if (target != flash.Lib.current.stage)
			target.contextMenu = cm;
		else trace("Contextual menu cannot be added to stage!");
	}
}
