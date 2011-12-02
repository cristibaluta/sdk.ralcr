//
//  GKCharacter
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.MovieClip;


class GKCharacter extends GKSprite {
	
	var frames :Hash<MovieClip>;// Different states of the character
	
	
	public function new (x, y) {
		super(x, y);
		init();
	}
	
	public function init () :Void {
		frames = new Hash<MovieClip>();
	}
	
	public function setState (key:String, sprite:Dynamic) :Void {
		try{
		var mc = new MovieClip();
		if (Std.is (sprite, MovieClip)) {
			mc = sprite;trace(mc);
		}
		else
			mc.addChild ( sprite );
		
		frames.set (key, mc);
		}
		catch(e:Dynamic){ trace(e);Fugu.stack(); }
	}
	
	public function showState (key:String) {
		//trace("show "+key);
		for (k in frames.keys()) {
			if (k == key) {
				view.addChild ( frames.get ( k ));
			}
			else if (view.contains ( frames.get ( k ) ))
				view.removeChild ( frames.get ( k ) );
		}
		// Keep the collisionArea in front
		if (collisionArea != null)
			this.addChild ( collisionArea );
	}
	
	override public function destroy () :Void {
		
	}
}
