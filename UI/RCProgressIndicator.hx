//
//  RCProgressIndicator
//
//  Created by Baluta Cristian on 2009-01-18.
//  Copyright (c) 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCProgressIndicator extends RCView {
	
	public var skin :RCSkin;
/*	var background :DisplayObjectContainer;
	var symbol :DisplayObjectContainer;*/
	
	public function new (x, y, skin:RCSkin) {
		super (x, y);
		this.skin = skin;
		
		// display skin (background, symbol, hit)
		this.addChild ( skin.normal.background );
		this.addChild ( skin.normal.otherView );
/*		symbolMask = skin.hit;
		this.addChild ( symbolMask );
		symbol.mask = symbolMask;*/
		this.clipsToBounds = true;
		// end skin
	}
	
	public function updateProgressBarWithPercent (percent:Int) {
		skin.normal.otherView.width = Zeta.lineEquationInt (0, size.width, percent, 0, 100);
	}
	
	// CLEAN MESS
	override public function destroy() :Void {
		skin.destroy();
		super.destroy();
	}
}
