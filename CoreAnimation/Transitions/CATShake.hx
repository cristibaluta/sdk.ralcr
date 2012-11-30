//
//  CATShake.hx
//	Shake an object for a specified amount of time and a maximum magnitude
//
//  Created by Baluta Cristian on 2012-11-29.
//  Copyright (c) 2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class CATShake extends CAObject, implements CATransitionInterface {
	
	var magnitude :Null<Float>;
	var originalX :Float;
	var originalY :Float;
	var nextMove :Float;
	
	
	override public function init () :Void {
		
		magnitude = Reflect.field (properties, "magnitude");
		if (magnitude == null)
			magnitude = 10;
		
		originalX = target.getX();// target.x will return NaN, probably because of the new getter and setter of haxe
		originalY = target.getY();
		nextMove = 0;
	}
	
	override public function animate (time_diff:Float) :Void {
		
		if (time_diff > nextMove) {
			target.setX ( originalX + Math.random()*magnitude*2 - magnitude );
			target.setY ( originalY + Math.random()*magnitude*2 - magnitude );
			nextMove = Math.round ( time_diff + 15 + Math.random()*10 );
		}
		
		if (time_diff >= duration) {
			target.x = originalX;
			target.y = originalY;
		}
	}
}
