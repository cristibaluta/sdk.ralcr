//
//  Tooltip
//
//  Created by Baluta Cristian on 2008-09-05.
//  Copyright (c) 2008 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCToolTip extends RCView {
	
	var skin :RCSkin;
	var target :Dynamic;
	var targetMoveSignal :EVMouse;
	
	
	public function new (skin:RCSkin) {
		super(0,0);
		this.skin = skin;
	}
	
	public function followMouse (parent:Dynamic) :Void {
		if (parent == null) return;
		target = parent;
		targetMoveSignal = new EVMouse (EVMouse.MOVE, target);
		targetMoveSignal.add ( dragHandler );
		//dragHandler ( null );
	}
	public function stopFollow () :Void {
		targetMoveSignal.destroy();
	}
	
	
	function dragHandler (e:EVMouse) :Void {
		if (target == null) return;
		this.x = target.mouseX;
		this.y = target.mouseY;
		//e.updateAfterEvent();
	}
	
	
	override public function destroy () :Void {
		stopFollow();
		super.destroy();
	}
}
