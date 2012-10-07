class RCResponder {
	
	public var viewWillAppear :RCSignal<Void->Void>;
	public var viewWillDisappear :RCSignal<Void->Void>;
	public var viewDidAppear :RCSignal<Void->Void>;
	public var viewDidDisappear :RCSignal<Void->Void>;
	
	public function viewWillAppearHandler () :Void { viewWillAppear.dispatch(); }
	public function viewWillDisappearHandler () :Void { viewWillDisappear.dispatch(); }
	public function viewDidAppearHandler () :Void { viewDidAppear.dispatch(); }
	public function viewDidDisappearHandler () :Void { viewDidDisappear.dispatch(); }
	
	
	// Properties of a View
	public var bounds :RCRect; // Real size of the view
	public var size :RCSize; // Visible size of the layer. You can get the real size with width and height
	public var center (default, setCenter) :RCPoint;
	public var clipsToBounds (default, setClipsToBounds) :Bool;
	public var backgroundColor (default, setBackgroundColor) :Null<Int>;
	public var x (default, setX) :Float;
	public var y (default, setY) :Float;
	public var scaleX (default, setScaleX) :Float;
	public var scaleY (default, setScaleY) :Float;
	public var width (getWidth, setWidth) :Float;
	public var height (getHeight, setHeight) :Float;
	public var alpha (default, setAlpha) :Float;
	public var visible (default, setVisible) :Bool;
	public var mouseX (getMouseX, null) :Float;
	public var mouseY (getMouseY, null) :Float;
	
	var lastW :Float;
	var lastH :Float;
	var scaleX_ :Float;
	var scaleY_ :Float;
	var alpha_ :Float;
	var caobj :CAObject;
	
	
	public function new () {
		
		viewWillAppear = new RCSignal<Void->Void>();
		viewWillDisappear = new RCSignal<Void->Void>();
		viewDidAppear = new RCSignal<Void->Void>();
		viewDidDisappear = new RCSignal<Void->Void>();
	}
	
	/**
	 *  Scale methods
	 */
	public function scaleToFit (w:Int, h:Int) :Void {
		
		if (size.width/w > size.height/h && size.width > w) {
			setWidth ( w );
			setHeight ( this.width * size.height / size.width );
		}
		else if (size.height > h) {
			setHeight ( h );
			setWidth ( this.height * size.width / size.height );
		}
		else if (size.width > lastW && size.height > lastH) {
			setWidth ( size.width );
			setHeight ( size.height );
		}
		else
			resetScale();
		
		lastW = this.width;
		lastH = this.height;
	}
	
	public function scaleToFill (w:Int, h:Int) :Void {
		
		if (w/size.width > h/size.height) {
			setWidth ( w );
			setHeight ( this.width * size.height / size.width );
		}
		else {
			setHeight ( h );
			setWidth ( this.height * size.width / size.height );
		}
	}
	public function resetScale () :Void {
		setWidth ( lastW );
		setHeight ( lastH );
	}
	
	public function animate (obj:CAObject) :Void {
		CoreAnimation.add ( this.caobj = obj );
	}
	
	/**
	 *  Removes running animation, if any.
	 */
	public function destroy () :Void {
		CoreAnimation.remove ( caobj );
	}
	
	
}
