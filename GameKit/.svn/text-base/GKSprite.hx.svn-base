//
//  GKSprite
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;


class GKSprite extends Sprite {
	
	inline public static var GRAVITY = 0.98;
	
	public var w :Float;
	public var h :Float;
	public var mass :Float;
	public var vx :Float;// Velocity
	public var vy :Float;
	public var aX :Float;// Acceleration
	public var aY :Float;
	public var bounceX :Float;
	public var bounceY :Float;
	public var frictionX :Float;
	public var jumpForce :Float;
	public var isOnGround :Bool;
	public var collisionArea :MovieClip;
	
	public var view :Sprite;
	public var registrationPoint (default, setRegistrationPoint) :Point;
	
	
	public function new (x, y) {
		super();
		this.x = x;
		this.y = y;
		this.view = new Sprite();
		this.addChild ( view );
	}
	
/*	public function init () :Void {
		
	}
	*/
	
	public function setRegistrationPoint (point:Point) :Point {
		view.x = Math.round ( - point.x );
		view.y = Math.round ( - point.y );
		return point;
	}
	
	
	public function destroy () :Void {
		
	}
}
