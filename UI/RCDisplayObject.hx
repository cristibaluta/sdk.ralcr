//
//  RCDisplayObject.hx
//	UIKit
//	A view interface, implement this for each target
//
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//


@:keep class RCDisplayObject {
	
	public var viewWillAppear :RCSignal<Void->Void>;
	public var viewWillDisappear :RCSignal<Void->Void>;
	public var viewDidAppear :RCSignal<Void->Void>;
	public var viewDidDisappear :RCSignal<Void->Void>;
	
	// Properties of a View
	public var bounds (get, set) :RCRect; // Real size of the view
	public var size :RCSize; // Visible area of the layer. Read only
	public var contentSize (get, set) :RCSize; // Real size of the layer.
	public var center (default, set) :RCPoint; // Position this view from the center
	public var clipsToBounds (default, set) :Bool;
	public var backgroundColor (default, set) :Null<Int>;
	public var x (get, set) :Float; // Animatable property
	public var y (get, set) :Float; // Animatable property
	public var width (get, set) :Float; // Methods to get and set the size
	public var height (get, set) :Float; // Animatable property
	public var scaleX (get, set) :Float; // Animatable property
	public var scaleY (get, set) :Float; // Animatable property
	public var alpha (get, set) :Float; // Animatable property
	public var rotation (get, set) :Float; // Animatable property
	public var visible (default, set) :Bool;
	public var mouseX (get, null) :Float;
	public var mouseY (get, null) :Float;
	public var parent :RCView;
	
	var x_ :Float;
	var y_ :Float;
	var alpha_ :Float;
	var scaleX_ :Float;
	var scaleY_ :Float;
	var rotation_ :Float;
	var contentSize_ :RCSize;
	var originalSize :RCSize; // Used in scale methods
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
		return visible = v;// Override it
	}
	@:keep public function get_alpha () :Float {
		return alpha_;
	}
	public function set_alpha (a:Float) :Float {
		return alpha_ = a;// Override it
	}
	@:keep public function get_x () :Float {
		return x_;
	}
	public function set_x (x:Float) :Float {
		return x_ = x;// Override it
	}
	@:keep public function get_y () :Float {
		return y_;
	}
	public function set_y (y:Float) :Float {
		return y_ = y;// Override it
	}
	@:keep public function get_width () :Float {
		return size.width;
	}
	public function set_width (w:Float) :Float {
		return size.width = w;// Override it
	}
	@:keep public function get_height () :Float {
		return size.height;
	}
	public function set_height (h:Float) :Float {
		return size.height = h;// Override it
	}
	@:keep public function get_contentSize () :RCSize {
		return size;// Override it to return the real size of the layer
	}
	public function set_contentSize (s:RCSize) :RCSize {
		return contentSize_ = s;// Override it to return the real size of the layer
	}
	@:keep public function get_rotation () :Float {
		return rotation_;
	}
	public function set_rotation (r:Float) :Float {
		return rotation_ = r;// Override it
	}
	@:keep public function get_bounds () :RCRect {
		return new RCRect (x_, y_, size.width, size.height);
	}
	public function set_bounds (b:RCRect) :RCRect {
		set_x ( b.origin.x );
		set_y ( b.origin.y );
		set_width ( b.size.width );
		set_height ( b.size.height );
		return b;
	}
	@:keep public function get_scaleX () :Float {
		return scaleX_;
	}
	public function set_scaleX (sx:Float) :Float {
		scaleX_ = sx;
		scale (scaleX_, scaleY_);
		return scaleX_;
	}
	@:keep public function get_scaleY () :Float {
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
		this.center = pos;
		set_x ( Std.int (pos.x - size.width/2) );
		set_y ( Std.int (pos.y - size.height/2) );
		return this.center;
	}
	
	
	/**
	 *  Scale methods.
	 *  ScaleToFit - will fit the largest axis into the new bounds entirely.
	 *  ScaleToFill - will fill the new bounds entirely.
	 */
	public function scaleToFit (w:Float, h:Float) :Void {
		
		if (size.width/w > size.height/h && size.width > w) {
			set_width ( w );
			set_height ( w * originalSize.height / originalSize.width );
		}
		else if (size.height > h) {
			set_height ( h );
			set_width ( h * originalSize.width / originalSize.height );
		}
		else if (size.width > originalSize.width && size.height > originalSize.height) {
			set_width ( size.width );
			set_height ( size.height );
		}
		else {
			resetScale();
		}
	}
	
	public function scaleToFill (w:Float, h:Float) :Void {
		
		if (w/originalSize.width > h/originalSize.height) {
			set_width ( w );
			set_height ( w * originalSize.height / originalSize.width );
		}
		else {
			set_height ( h );
			set_width ( h * originalSize.width / originalSize.height );
		}
	}

	public function scale (sx:Float, sy:Float) {}
	
	public function resetScale () :Void {
		set_width ( originalSize.width );
		set_height ( originalSize.height );
	}
	
	// Get mouse position
	@:keep function get_mouseX () :Float {
		return 0;
	}
	@:keep function get_mouseY () :Float {
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
		RCAnimation.add ( this.caobj = obj );
	}
	
	
	/**
	 *  Removes running animation, if any.
	 */
	public function destroy () :Void {
		RCAnimation.remove ( caobj );
		size = null;
	}
	
	public function toString () :String {
		return "[RCView bounds:"+bounds.origin.x+"x"+bounds.origin.y+","+bounds.size.width+"x"+bounds.size.height+"]";
	}
}
