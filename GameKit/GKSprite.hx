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
	
	// GLES
#if (nme && (ios || android))
	public var children :Array<GKSprite>;
#end
	
	
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
class TileGroup extends TileBase
{
	
	#if flash
	var container:Sprite;
	#end

	public function new()
	{
		super();
		children = new Array<TileBase>();
		#if flash
		container = new Sprite();
		#end
	}

	override public function init(layer:TileLayer):Void
	{
		this.layer = layer;
		initChildren();
	}

	#if flash
	override public function getView():DisplayObject { return container; }
	#end

	function initChild(item:TileBase)
	{
		item.parent = this;
		if (layer != null && item.layer == null) 
			item.init(layer);
	}

	function initChildren()
	{
		for(child in children)
			initChild(child);
	}

	public inline function indexOf(item:TileBase)
	{
		return Lambda.indexOf(children, item);
	}

	public function addChild(item:TileBase)
	{
		removeChild(item);
		#if flash
		container.addChild(item.getView());
		#end
		initChild(item);
		return children.push(item);
	}

	public function addChildAt(item:TileBase, index:Int)
	{
		removeChild(item);
		#if flash
		container.addChildAt(item.getView(), index);
		#end
		initChild(item);
		children.insert(index, item);
		return index;
	}

	public function removeChild(item:TileBase)
	{
		if (item.parent == null) return item;
		if (item.parent != this) {
			trace("Invalid parent");
			return item;
		}
		var index = indexOf(item);
		if (index >= 0) 
		{
			#if flash
			container.removeChild(item.getView());
			#end
			children.splice(index, 1);
			item.parent = null;
		}
		return item;
	}

	public function removeChildAt(index:Int)
	{
		#if flash
		container.removeChildAt(index);
		#end
		var child = children.splice(index, 1)[0];
		if (child != null) child.parent = null;
		return child;
	}

	public function removeAllChildren()
	{
		#if flash
		while (container.numChildren > 0) container.removeChildAt(0);
		#end
		for (child in children)
			child.parent = null;
		return children.splice(0, children.length);
	}

	public function getChildIndex(item:TileBase)
	{
		return indexOf(item);
	}

	public inline function iterator() { return children.iterator(); }

	public var numChildren(get_numChildren, null):Int;
	inline function get_numChildren() { return children != null ? children.length : 0; }

	public var height(get_height, null):Float; // TOFIX incorrect with sub groups
	function get_height():Float 
	{
		if (numChildren == 0) return 0;
		var ymin = 9999.0, ymax = -9999.0;
		for(child in children)
			if (Std.is(child, TileSprite)) {
				var sprite:TileSprite = cast child;
				var h = sprite.height;
				var top = sprite.y - h/2;
				var bottom = top + h;
				if (top < ymin) ymin = top;
				if (bottom > ymax) ymax = bottom;
			}
		return ymax - ymin;
	}

	public var width(get_width, null):Float; // TOFIX incorrect with sub groups
	function get_width():Float 
	{
		if (numChildren == 0) return 0;
		var xmin = 9999.0, xmax = -9999.0;
		for(child in children)
			if (Std.is(child, TileSprite)) {
				var sprite:TileSprite = cast child;
				var w = sprite.width;
				var left = sprite.x - w/2;
				var right = left + w;
				if (left < xmin) xmin = left;
				if (right > xmax) xmax = right;
			}
		return xmax - xmin;
	}
}