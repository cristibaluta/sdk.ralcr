//
//  GKCharacter
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

import flash.display.MovieClip;


class GKCharacter extends GKSprite {
	
	var frames :Hash<MovieClip>;// Different states of the character
	
	
	public function new (x, y) {
		super(x, y);
		init();
	}
	
	override public function init () :Void {
		super.init();
		frames = new Hash<MovieClip>();
	}
	
	public function setState (key:String, sprite:Dynamic) :Void {
		try{
		var mc = new MovieClip();
		if (Std.is (sprite, MovieClip)) {
			mc = sprite;
		}
		else if (Std.is (sprite, RCView)) {
			mc.addChild ( sprite.layer );
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
				layer.addChild ( frames.get ( k ));
			}
			else if (layer.contains ( frames.get ( k ) ))
				layer.removeChild ( frames.get ( k ) );
		}
		// Keep the collisionArea in front
		if (collisionArea != null)
			this.layer.addChild ( collisionArea );
	}
	
	override public function destroy () :Void {
		super.destroy();
	}
}
