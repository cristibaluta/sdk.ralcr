//
//  RCGroup
//
//  Created by Cristi Baluta on 2011-02-08.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
//
import flash.display.Sprite;


class RCGroup<T:Sprite> extends Sprite {
	
	var sprites :Array<Sprite>;
	var createSprite :Dynamic->Sprite;
	var gapX :Null<Int>;
	var gapY :Null<Int>;
	
	
	public function new (x, y, gapX:Null<Int>, gapY:Null<Int>, sprite:Dynamic->Sprite) {
		super();
		
		this.x = x;
		this.y = y;
		this.gapX = gapX;
		this.gapY = gapY;
		this.createSprite = sprite;
		
		sprites = new Array<Sprite>();
	}
	
	
	/**
	 *	Add and remove buttons
	 *	params = a list of parameters to pass to the function that returns our sprite
	 */
	public function add (params:Array<Dynamic>, ?sprite:Dynamic->Sprite) :Void {
		
		if (!Reflect.isFunction (this.createSprite) && !Reflect.isFunction (sprite)) return;
		if (sprite != null) this.createSprite = sprite;
		
		// push the new values into main array
		for (param in params) {
			// Create a new sprite with the passed function
			var s = this.createSprite ( param );
			this.addChild ( s );
			
			// keep the sprite into an array
			sprites.push ( s );
			
			// dispatch an event that the buttons structure has changed
			this.dispatchEvent ( new GroupEvent (GroupEvent.PUSH, null, -1) );
		}
		
		// Keep all sprites arranged
		align();
	}
	
	public function remove (i:Int) :Void {
		
		Fugu.safeDestroy ( sprites[i] );
		//sprites.remove ( sprites[i] );
		
		align();
		
		// dispatch an event that the buttons structure has changed
		this.dispatchEvent ( new GroupEvent (GroupEvent.REMOVE, null, i) );
	}
	
	
	/**
	 *	Keep all the sprites arranged after an update operation
	 */
	function align () :Void {
		
		// iterate over sprites
		for (i in 0...sprites.length) {
			var newX = 0.0, newY = 0.0;
			var new_s = sprites[i];
			var old_s = sprites[i-1];
			
			if (i != 0) {
				if (gapX != null) newX = old_s.x + old_s.width + gapX;
				if (gapY != null) newY = old_s.y + old_s.height + gapY;
			}
			
			new_s.x = newX;
			new_s.y = newY;
		}
		
		this.dispatchEvent ( new GroupEvent (GroupEvent.UPDATED, null, -1) );
	}
	
	
	/**
	 *	Returns a reference to a specified sprite
	 *	Usefull if you want to change it's properties
	 */
	public function get (i:Int) :Dynamic {
		return sprites[i];
	}
	
	
	/**
	 *	Returns an array with sprites but marked as Dynamic
	 *	because RCView will not contain the neccesary methods needed by the code
	 */
	public function iterator<T>() :Array<T> {
		var typedSprites = new Array<T>();
		for (s in sprites)
			typedSprites.push ( cast(s, T) );
			
		return typedSprites;
	}
	
	
	public function destroy() :Void {
		Fugu.safeDestroy ( sprites );
		sprites = null;
	}
}
