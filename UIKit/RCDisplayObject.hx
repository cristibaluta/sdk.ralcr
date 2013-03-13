//
//  RCDisplayObject.hx
//	UIKit
//	A view interface, implement this for each target
//
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//


class RCDisplayObject {
	
	public var viewWillAppear :RCSignal<Void->Void>;
	public var viewWillDisappear :RCSignal<Void->Void>;
	public var viewDidAppear :RCSignal<Void->Void>;
	public var viewDidDisappear :RCSignal<Void->Void>;
	
	// Properties of a View
	public var bounds (get_bounds, set_bounds) :RCRect; // Real size of the view
	public var size :RCSize; // Visible area of the layer. Read only
	public var contentSize (get_contentSize, set_contentSize) :RCSize; // Real size of the layer.
	public var center (default, set_center) :RCPoint; // Position this view from the center
	public var clipsToBounds (default, set_clipsToBounds) :Bool;
	public var backgroundColor (default, set_backgroundColor) :Null<Int>;
	public var x (get_x, set_x) :Float; // Animatable property
	public var y (get_y, set_y) :Float; // Animatable property
	public var width (get_width, set_width) :Float; // Methods to get and set the size
	public var height (get_height, set_height) :Float; // Animatable property
	public var scaleX (get_scaleX, set_scaleX) :Float; // Animatable property
	public var scaleY (get_scaleY, set_scaleY) :Float; // Animatable property
	public var alpha (get_alpha, set_alpha) :Float; // Animatable property
	public var rotation (get_rotation, set_rotation) :Float; // Animatable property
	public var visible (default, set_visible) :Bool;
	public var mouseX (get_mouseX, null) :Float;
	public var mouseY (get_mouseY, null) :Float;
	public var parent :RCView;
	
	var size_ :RCSize;
	var originalSize_ :RCSize; // Used in scale methods
	var contentSize_ :RCSize;
	var center_ :RCPoint;
	var clipsToBounds_ :Bool;
	var backgroundColor_ :Null<Int>;
	var x_ :Float;// Getters and setters
	var y_ :Float;
	var scaleX_ :Float;
	var scaleY_ :Float;
	var alpha_ :Float;
	var rotation_ :Float;
	var visible_ :Bool;
	var mouseX_ :Float;
	var mouseY_ :Float;
	var caobj :CAObject;
	
	
	public function new () {
		
		viewWillAppear = new RCSignal<Void->Void>();
		viewWillDisappear = new RCSignal<Void->Void>();
		viewDidAppear = new RCSignal<Void->Void>();
		viewDidDisappear = new RCSignal<Void->Void>();
	}
	
	public function init () :Void {
		
	}
	
	
	// Getter / Setters methods
	//
	public function set_visible (v:Bool) :Bool {
		return visible_ = v;// Override it
	}
	public function get_alpha () :Float {
		return alpha_;
	}
	public function set_alpha (a:Float) :Float {
		return alpha_ = a;// Override it
	}
	public function get_x () :Float {
		return x_;
	}
	public function set_x (x:Float) :Float {
		return x_ = x;// Override it
	}
	public function get_y () :Float {
		return y_;
	}
	public function set_y (y:Float) :Float {
		return y_ = y;// Override it
	}
	public function get_width () :Float {
		return size_.width;
	}
	public function set_width (w:Float) :Float {
		return size_.width = w;// Override it
	}
	public function get_height () :Float {
		return size_.height;
	}
	public function set_height (h:Float) :Float {
		return size_.height = h;// Override it
	}
	public function get_contentSize () :RCSize {
		return size_;// Override it to return the real size of the layer
	}
	public function set_contentSize (s:RCSize) :RCSize {
		return contentSize_ = s;// Override it to return the real size of the layer
	}
	public function set_rotation (r:Float) :Float {
		return rotation_ = r;// Override it
	}
	public function get_rotation () :Float {
		return rotation_;
	}
	public function get_bounds () :RCRect {
		return new RCRect (x_, y_, size_.width, size_.height);
	}
	public function set_bounds (b:RCRect) :RCRect {
		set_x ( b.origin.x );
		set_y ( b.origin.y );
		set_width ( b.size.width );
		set_height ( b.size.height );
		return b;
	}
	public function get_scaleX () :Float {
		return scaleX_;
	}
	public function set_scaleX (sx:Float) :Float {
		scaleX_ = sx;
		scale (scaleX_, scaleY_);
		return scaleX_;
	}
	public function get_scaleY () :Float {
		return scaleY_;
	}
	public function set_scaleY (sy:Float) :Float {
		scaleY_ = sy;
		scale (scaleX_, scaleY_);
		return scaleY_;
	}
	
	
	public function set_clipsToBounds (clip:Bool) :Bool {
		return clip;// Override it
	}
	public function set_backgroundColor (color:Null<Int>) :Null<Int> {
		return color;// Override it
	}
	public function set_center (pos:RCPoint) :RCPoint {
		this.center_ = pos;
		set_x ( Std.int (pos.x - size_.width/2) );
		set_y ( Std.int (pos.y - size_.height/2) );
		return this.center_;
	}
	
	
	/**
	 *  Scale methods.
	 *  ScaleToFit - will fit the largest axis into the new bounds entirely.
	 *  ScaleToFill - will fill the new bounds entirely.
	 */
	public function scaleToFit (w:Float, h:Float) :Void {
		
		if (size.width/w > size.height/h && size.width > w) {
			set_width ( w );
			set_height ( w * originalSize_.height / originalSize_.width );
		}
		else if (size.height > h) {
			set_height ( h );
			set_width ( h * originalSize_.width / originalSize_.height );
		}
		else if (size.width > originalSize_.width && size.height > originalSize_.height) {
			set_width ( size.width );
			set_height ( size.height );
		}
		else {
			resetScale();
		}
	}
	
	public function scaleToFill (w:Float, h:Float) :Void {
		
		if (w/originalSize_.width > h/originalSize_.height) {
			set_width ( w );
			set_height ( w * originalSize_.height / originalSize_.width );
		}
		else {
			set_height ( h );
			set_width ( h * originalSize_.width / originalSize_.height );
		}
	}

	public function scale (sx:Float, sy:Float) {}
	
	public function resetScale () :Void {
		set_width ( originalSize_.width );
		set_height ( originalSize_.height );
	}
	
	// Get mouse position
	function get_mouseX () :Float {
		return 0;
	}
	function get_mouseY () :Float {
		return 0;
	}
	
	
	
	// Add subviews
	public function addChild (child:RCView) :Void {}
	public function addChildAt (child:RCView, index:Int) :Void {}
	public function removeChild (child:RCView) :Void {}
	
	
	/**
	 *  Test hit
	 *  x_ and _y are not changing
	 **/
	public function hitTest (otherObject:RCView) :Bool {
		return false;
	}
	
	/**
	 *  Start an animation
	 **/
	public function addAnimation (obj:CAObject) :Void {
		CoreAnimation.add ( this.caobj = obj );
	}
	
	
	/**
	 *  Removes running animation, if any.
	 */
	public function destroy () :Void {
		CoreAnimation.remove ( caobj );
		size_ = null;
	}
	
	public function toString () :String {
		return "[RCView bounds:"+x_+"x"+y_+","+size_.width+"x"+size_.height+"]";
	}
}
