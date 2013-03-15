//
//  RCActivityIndicator.hx
//
//  Created by Baluta Cristian on 2008-12-01.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//


#if nme
	
class RCActivityIndicator {
	
	var activityIndicator :NMEActivityIndicator;
	
	/**
	 *  For NME, stepX and skin are ignored
	 **/
	public function new (x, y, ?stepX:Int=0, ?skin:RCSkin) {
		activityIndicator = new NMEActivityIndicator (x, y);
	}
	public function destroy() :Void {
		activityIndicator.destroy();
		activityIndicator = null;
	}
}
	
#else
	
class RCActivityIndicator extends RCProgressIndicator {
	
	public var stepX :Int;// The distance after the symbol position is reseted to 0
	public var speedX :Int;
	var enterFrame :EVLoop;
	
	/**
	 *  @param x - the left corner of the activityIndicator
	 *  @param x - the top corner of the activityIndicator
	 *  @param stepX - the top corner of the activityIndicator
	 *  @param skin - the skin contains the objects from which the activityIndicator will be built
	 **/
	public function new (x, y, ?stepX:Int=0, ?skin:RCSkin) {
		
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
		if (enterFrame != null)
			enterFrame.destroy();
			enterFrame = null;
		super.destroy();
	}
}

#end