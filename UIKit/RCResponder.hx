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
	public var center (default, set_center) :RCPoint;
	public var clipsToBounds (default, set_clipsToBounds) :Bool;
	public var backgroundColor (default, set_backgroundColor) :Null<Int>;
	public var x (default, set_x) :Float;
	public var y (default, set_y) :Float;
	public var scaleX (default, set_scaleX) :Float;
	public var scaleY (default, set_scaleY) :Float;
	public var width (get_width, set_width) :Float;
	public var height (get_height, set_height) :Float;
	public var alpha (default, set_alpha) :Float;
	public var visible (default, set_visible) :Bool;
	public var mouseX (get_mouseX, null) :Float;
	public var mouseY (get_mouseY, null) :Float;
	
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
			set_width ( w );
			set_height ( this.width * size.height / size.width );
		}
		else if (size.height > h) {
			set_height ( h );
			set_width ( this.height * size.width / size.height );
		}
		else if (size.width > lastW && size.height > lastH) {
			set_width ( size.width );
			set_height ( size.height );
		}
		else
			resetScale();
		
		lastW = this.width;
		lastH = this.height;
	}
	
	public function scaleToFill (w:Int, h:Int) :Void {
		
		if (w/size.width > h/size.height) {
			set_width ( w );
			set_height ( this.width * size.height / size.width );
		}
		else {
			set_height ( h );
			set_width ( this.height * size.width / size.height );
		}
	}
	public function resetScale () :Void {
		set_width ( lastW );
		set_height ( lastH );
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
