//
//  RCView.hx
//	UIKit
//	Flash implementation of the RCDisplayObject
//
//  Created by Baluta Cristian on 2009-02-14.
//  Updated 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if ios
	typedef Sprite = ios.ui.UIView;
#elseif osx
	typedef Sprite = osx.appkit.NSView;
#end
import objc.graphics.CGGeometry;
import objc.graphics.CGAffineTransform;


class ObjcView extends RCDisplayObject {

	public var layer :Sprite;
	public var graphics :Graphics;
	var rect :CGRect;
	
	public function new (x, y, ?w, ?h) {
		
		super();
		
		layer = new Sprite();
		rect = new CGRect (x, y, w, h);
		layer.frame = rect;
		graphics = layer.graphics;
		size = new RCSize (w, h);
		contentSize_ = size.copy();
		
		set_x ( x );
		set_y ( y );
	}
	
	/**
	 *  Change the color of the Sprite
	 */
	override public function set_backgroundColor (color:Null<Int>) :Null<Int> {
		
		var red   = (color & 0xff0000) >> 16;
		var green = (color & 0xff00) >> 8;
		var blue  = color & 0xFF;
		var mpl = 0;
		
		if (color != null) {
			layer.backgroundColor = UIColor.colorWith (red, green, blue);
		} else {
			layer.backgroundColor = UIColor.clearColor();
		}
		return backgroundColor = color;
	}
	
	
	override public function set_clipsToBounds (clip:Bool) :Bool {
		
		layer.clipsToBounds = clip;
		return clip;
	}
	
	// Position and size
	override public function set_x (x:Float) :Float {
		rect.origin.x = x;
		layer.frame = rect;
		return super.set_x ( x );
	}
	override public function set_y (y:Float) :Float {
		rect.origin.y = y;
		layer.frame = rect;
		return super.set_y ( y );
	}
	override public function set_width (w:Float) :Float {
		rect.size.width = w;
		layer.frame = rect;
		return super.set_width ( w );
	}
	override public function set_height (h:Float) :Float {
		rect.size.height = h;
		layer.frame = rect;
		return super.set_height ( h );
	}
	override public function get_contentSize () :RCSize {
		return new RCSize (rect.size.width, rect.size.height);
	}
	override public function set_rotation (r:Float) :Float {
		layer.transform = untyped CGAffineTransformMakeRotation(DegreesToRadians(r));
		return super.set_rotation ( r );
	}
	override public function scale (sx:Float, sy:Float) :Void {
		
	}
	
	override public function set_visible (v:Bool) :Bool {
		layer.hidden = !v;
		return super.set_visible ( v );
	}
	override public function set_alpha (a:Float) :Float {
		layer.alpha = a;
		return super.set_alpha ( a );
	}
	
	override function get_mouseX () :Float {
		return 0;
	}
	override function get_mouseY () :Float {
		return 0;
	}
	
	
	override public function hitTest (otherObject:RCView) :Bool {
		
		if (otherObject.layer.frame.origin.x >= x_ && otherObject.layer.frame.origin.y >= y_) {
			if (otherObject.layer.frame.origin.x <= x_ + rect.size.width && otherObject.layer.frame.origin.y <= y_ + rect.size.height) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 *  This method is usually overriten by the super class.
	 */
	override public function destroy () :Void {
		layer.graphics.clear();
		super.destroy();
	}
	
	
	override public function addChild (child:RCView) :Void {
		if (child == null) return;
		child.viewWillAppear.dispatch();
		child.parent = this;
		layer.addSubview ( child.layer );
		child.viewDidAppear.dispatch();
	}
	override public function addChildAt (child:RCView, index:Int) :Void {
		layer.addChildAt (child.layer, index);
	}
	override public function removeChild (child:RCView) :Void {
		if (child == null) return;
		child.viewWillDisappear.dispatch();
		layer.removeSubview ( child.layer );
		child.parent = null;
		child.viewDidDisappear.dispatch();
	}
	public function removeFromSuperview () :Void {
		var parent = null;
		try{parent = layer.parent; } catch (e:Dynamic) { null; }
		if (parent != null)
		if (parent.contains ( layer ))
			parent.removeChild ( layer );
	}
}
