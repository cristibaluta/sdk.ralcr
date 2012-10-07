// The properties a display object must have

class RCDisplayObject {
	
	public var viewWillAppear :RCSignal<Void->Void>;
	public var viewWillDisappear :RCSignal<Void->Void>;
	public var viewDidAppear :RCSignal<Void->Void>;
	public var viewDidDisappear :RCSignal<Void->Void>;
	
	// Properties of a View
	public var bounds (getBounds, setBounds) :RCRect; // Real size of the view
	public var size :RCSize; // Visible area of the layer. Read only
	public var contentSize (getContentSize, setContentSize) :RCSize; // Real size of the layer. Used in rcscrollview mostly
	public var center (default, setCenter) :RCPoint; // Position this view with the center
	public var clipsToBounds (default, setClipsToBounds) :Bool;
	public var backgroundColor (default, setBackgroundColor) :Null<Int>;
	public var x (getX, setX) :Float; // Animatable property
	public var y (getY, setY) :Float; // Animatable property
	public var width (getWidth, setWidth) :Float; // Methods to get and set the size
	public var height (getHeight, setHeight) :Float; // Animatable property
	public var scaleX (getScaleX, setScaleX) :Float; // Animatable property
	public var scaleY (getScaleY, setScaleY) :Float; // Animatable property
	public var alpha (getAlpha, setAlpha) :Float; // Animatable property
	public var rotation (getRotation, setRotation) :Float; // Animatable property
	public var visible (default, setVisible) :Bool;
	public var mouseX (getMouseX, null) :Float;
	public var mouseY (getMouseY, null) :Float;
	public var parent :RCView;
	
	var x_ :Float;// Getters and setters
	var y_ :Float;
	var scaleX_ :Float;
	var scaleY_ :Float;
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
	public function setVisible (v:Bool) :Bool {
		return visible = v;// Override it
	}
	public function getAlpha () :Float {
		return alpha;
	}
	public function setAlpha (a:Float) :Float {
		return alpha = a;// Override it
	}
	public function getX () :Float {
		return x_;
	}
	public function setX (x:Float) :Float {
		return x_ = x;// Override it
	}
	public function getY () :Float {
		return y_;
	}
	public function setY (y:Float) :Float {
		return y_ = y;// Override it
	}
	public function getWidth () :Float {
		return size.width;
	}
	public function setWidth (w:Float) :Float {
		return size.width = w;// Override it
	}
	public function getHeight () :Float {
		return size.height;
	}
	public function setHeight (h:Float) :Float {
		return size.height = h;// Override it
	}
	public function getContentSize () :RCSize {
		return size;// Override it to return the real size of the layer
	}
	public function setContentSize (s:RCSize) :RCSize {
		return contentSize = s;// Override it to return the real size of the layer
	}
	public function setRotation (r:Float) :Float {
		return rotation = r;// Override it
	}
	public function getRotation () :Float {
		return rotation;
	}
	public function getBounds () :RCRect {
		return new RCRect (x_, y_, size.width, size.height);
	}
	public function setBounds (b:RCRect) :RCRect {
		setX ( b.origin.x );
		setY ( b.origin.y );
		setWidth ( b.size.width );
		setHeight ( b.size.height );
		return b;
	}
	public function getScaleX () :Float {
		return scaleX_;
	}
	public function setScaleX (sx:Float) :Float {
		scaleX_ = sx;
		scale (scaleX_, scaleY_);
		return scaleX_;
	}
	public function getScaleY () :Float {
		return scaleY_;
	}
	public function setScaleY (sy:Float) :Float {
		scaleY_ = sy;
		scale (scaleX_, scaleY_);
		return scaleY_;
	}
	
	
	public function setClipsToBounds (clip:Bool) :Bool {
		return clip;// Override it
	}
	public function setBackgroundColor (color:Null<Int>) :Null<Int> {
		return color;// Override it
	}
	public function setCenter (pos:RCPoint) :RCPoint {
		this.center = pos;
		setX ( Std.int (pos.x - size.width/2) );
		setY ( Std.int (pos.y - size.height/2) );
		return this.center;
	}
	
	
	/**
	 *  Scale methods.
	 *  ScaleToFit - will fit the largest axis into the new bounds entirely.
	 *  ScaleToFill - will fill the new bounds entirely.
	 */
	public function scaleToFit (w:Float, h:Float) :Void {
		
		if (size.width/w > size.height/h && size.width > w) {
			setWidth ( w );
			setHeight ( w * originalSize.height / originalSize.width );
		}
		else if (size.height > h) {
			setHeight ( h );
			setWidth ( h * originalSize.width / originalSize.height );
		}
		else if (size.width > originalSize.width && size.height > originalSize.height) {
			setWidth ( size.width );
			setHeight ( size.height );
		}
		else {
			resetScale();
		}
	}
	
	public function scaleToFill (w:Float, h:Float) :Void {
		
		if (w/originalSize.width > h/originalSize.height) {
			setWidth ( w );
			setHeight ( w * originalSize.height / originalSize.width );
		}
		else {
			setHeight ( h );
			setWidth ( h * originalSize.width / originalSize.height );
		}
	}

	public function scale (sx:Float, sy:Float) {}
	
	public function resetScale () :Void {
		setWidth ( originalSize.width );
		setHeight ( originalSize.height );
	}
	
	// Get mouse position
	function getMouseX () :Float {
		return 0;
	}
	function getMouseY () :Float {
		return 0;
	}
	
	
	
	// Add subviews
	public function addChild (child:RCView) :Void {}
	public function addChildAt (child:RCView, index:Int) :Void {}
	public function removeChild (child:RCView) :Void {}
	
	
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
		size = null;
	}
	
	public function toString () :String {
		return "[RCView bounds:"+bounds.origin.x+"x"+bounds.origin.x+","+bounds.size.width+"x"+bounds.size.height+"]";
	}
}
