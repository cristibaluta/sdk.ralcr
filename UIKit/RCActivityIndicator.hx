//
//  RCActivityIndicator.hx
//
//  Created by Baluta Cristian on 2008-12-01.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCActivityIndicator extends RCProgressIndicator {
	
	public var stepX :Int;// The distance after the symbol position is reseted to 0
	public var speedX :Int;
	var enterFrame :EVLoop;
	
	public function new (x, y, stepX:Int, skin:RCSkin) {
		
		super (x, y, skin);
		
		this.stepX = stepX;
		this.speedX = 1;
		enterFrame = new EVLoop();
		enterFrame.run = loop;
	}
	
	function loop () :Void {
		skin.normal.otherView.x -= speedX;
		if (Math.abs(skin.normal.otherView.x) >= Math.abs(stepX))
			skin.normal.otherView.x = 0;
	}
	
	// CLEAN MESS
	override public function destroy() :Void {
		enterFrame.destroy();
		super.destroy();
	}
}
