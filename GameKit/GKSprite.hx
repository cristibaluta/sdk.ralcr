//
//  GKSprite
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || nme || cpp)
	import flash.display.MovieClip;
	import flash.display.Sprite;
#elseif js
	private typedef MovieClip = Dynamic;
#end


class GKSprite extends RCView {
	
	inline public static var GRAVITY = 0.98;
	
	public var mass :Float;
	public var gravity :Float;
	public var vx :Float;// Velocity
	public var vy :Float;
	public var ax :Float;// Acceleration
	public var ay :Float;
	public var bounceX :Float;
	public var bounceY :Float;
	public var frictionX :Float;
	public var jumpForce :Float;
	public var isOnGround :Bool;
	public var collisionArea :MovieClip;
	
	public var layer2 :RCView;
	public var registrationPoint (default, set_registrationPoint) :RCPoint;
	
	
	public function new (x, y) {
		super(x, y);
		this.layer2 = new RCView(0, 0);
		this.addChild ( layer2 );
	}

	public function set_registrationPoint (point:RCPoint) :RCPoint {
		layer2.x = Math.round ( - point.x );
		layer2.y = Math.round ( - point.y );
		return point;
	}
	
	override public function destroy () :Void {
		super.destroy();
	}
}
