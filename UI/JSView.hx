//
//  JSView.hx
//	UIKit
//
//  Created by Baluta Cristian on 2011-11-12.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
//	Do not use directly this class, use RCView

import js.html.DivElement;
import js.html.CanvasRenderingContext2D;
import js.html.webgl.RenderingContext;
import RCDevice;


@:keep class JSView extends RCDisplayObject {
	
	@:keep public var layer :DivElement;
	public var layerScrollable :DivElement;// Clips to bounds will move all the subviews in this layer
	public var graphics :CanvasRenderingContext2D;
	public var gl :RenderingContext;
	
	
	public function new (x, y, ?w, ?h) {
		
		super();
		
		size = new RCSize (w, h);
		contentSize_ = size.copy();
		scaleX_ = 1;
		scaleY_ = 1;
		alpha_ = 1;
		
		#if canvas
			layer = js.Browser.document.createCanvasElement();
			graphics = layer.getContext2d();
			gl = layer.getContextWebGL();
		#else
			layer = js.Browser.document.createDivElement();
		#end
		
		// In JS, the div must be positioned absolute
		layer.style.position = "absolute";
		layer.style.margin = "0px 0px 0px 0px";
		layer.style.width = "auto";
		layer.style.height = "auto";
		untyped layer.style.webkitUserSelect = "none";
		untyped layer.style.mozUserSelect = "none";
		untyped layer.style.khtmlUserSelect = "none";
		untyped layer.style.oUserSelect = "none";
		
		set_x ( x );
		set_y ( y );
	}
	
	
	
	override public function addChild (child:JSView) :Void {
		
		if (child == null) return;
		child.viewWillAppear.dispatch();
		child.parent = this;
		layer.appendChild ( child.layer );
		child.viewDidAppear.dispatch();
	}
	override public function addChildAt (child:JSView, index:Int) :Void {
		
		if (layer.childNodes[index] != null) {
			layer.insertBefore (child.layer, layer.childNodes[index]);
		}
		else {
			layer.appendChild ( child.layer );
		}
	}
	override public function removeChild (child:JSView) :Void {
		
		if (child == null) return;
		child.viewWillDisappear.dispatch();
		child.parent = null;
		layer.removeChild ( child.layer );
		child.viewDidDisappear.dispatch();
	}
	public function removeFromSuperview () :Void {
		
		if (parent != null)
			parent.removeChild ( this );
	}
	
	
	
	/**
	 *  Change the color of the background
	 */
	override public function set_backgroundColor (color:Null<Int>) :Null<Int> {
		
		if (color == null) {
			layer.style.background = null;
			return color;
		}
		
		var red   = (color & 0xff0000) >> 16;
		var green = (color & 0xff00) >> 8;
		var blue  = color & 0xFF;
		// rgba is not available in IE
		layer.style.backgroundColor = "rgb("+red+","+green+","+blue+")";
		
		return color;
	}
	
	
	override public function set_clipsToBounds (clip:Bool) :Bool {
		// When we clip we move all subviews on a different div inside the current div
		if (clip) {
			layer.style.overflow = "hidden";
			layerScrollable = js.Browser.document.createDivElement();
			//layerScrollable.style.position = "absolute"; // Using position absolute will cause the div to not show at all
			layerScrollable.style.width = size.width + "px";
			layerScrollable.style.height = size.height + "px";
			
			// Move the views from layer to layerScrollable
			while (layer.hasChildNodes()) {
				layerScrollable.appendChild ( layer.removeChild ( layer.firstChild));
			}

			layer.appendChild ( layerScrollable );
		}
		// When we unclip we move the subviews back to the original div
		else {

			while (layerScrollable.hasChildNodes()) {
				layer.appendChild ( layerScrollable.removeChild ( layerScrollable.firstChild));
			}

			layer.style.overflow = null;
			layer.removeChild ( layerScrollable );
			layerScrollable = null;
		}
		return clip;
	}
	
	
	// Getters and setters
	//
	override public function set_visible (v:Bool) :Bool {
		layer.style.visibility = (v ? "visible" : "hidden");
		return super.set_visible ( v );
	}
	override public function set_alpha (a:Float) :Float {
		
		if (RCDevice.currentDevice().userAgent == MSIE) {
			untyped layer.style.msFilter = "progid:DXImageTransform.Microsoft.Alpha(Opacity="+Std.string(a*100)+")";
			untyped layer.style.filter = "alpha(opacity="+Std.string(a*100)+")";
			//if(a==0)layer.style.background = "url(pixel.png) repeat";
		}
		else {
			untyped layer.style.opacity = Std.string(a);
		}
		return super.set_alpha ( a );
	}
	override public function set_x (x:Float) :Float {
		layer.style.left = Std.string (x * RCDevice.currentDevice().dpiScale) + "px";
		return super.set_x ( x );
	}
	override public function set_y (y:Float) :Float {
		layer.style.top = Std.string (y * RCDevice.currentDevice().dpiScale) + "px";
		return super.set_y ( y );
	}
	override public function set_width (w:Float) :Float {
		layer.style.width = w + "px";
		return super.set_width ( w );
	}
	override public function set_height (h:Float) :Float {
		layer.style.height = h + "px";
		return super.set_height ( h );
	}
	override public function get_contentSize () :RCSize {
/*		trace("offset "+new RCSize (layer.offsetWidth, layer.offsetHeight));
		trace("scroll "+new RCSize (layer.scrollWidth, layer.scrollHeight));
		trace("client "+new RCSize (layer.clientWidth, layer.clientHeight));*/
		contentSize_.width = layer.scrollWidth;
		contentSize_.height = layer.scrollHeight;
		return contentSize_;
	}
	
	var transformProperty :String;
	override public function scale (sx:Float, sy:Float) :Void {
		untyped layer.style[getTransformProperty()+"Origin"] = "top left";
		untyped layer.style[getTransformProperty()] = "scale(" + sx + "," + sy + ")";
	}
	function getTransformProperty () :String {
	    // Note that in some versions of IE9 it is critical that
	    // msTransform appear in this list before MozTransform
		if (transformProperty != null)
			return transformProperty;
	    for (p in ['transform', 'WebkitTransform', 'msTransform', 'MozTransform', 'OTransform']) {
			if (untyped layer.style[p] != null) {
				transformProperty = p;
				return p;
	        }
	    }
	    return "transform";
	}
	
	
	override public function set_rotation (r:Float) :Float {
		untyped layer.style[getTransformProperty()] = "rotate(" + r + "deg)";
		return super.set_rotation ( r );
	}
	
	public function startDrag (?lockCenter:Bool, ?rect:RCRect) :Void {
		
	}
	public function stopDrag () :Void {
		
	}
	
	override function get_mouseX () :Float {
		trace(layer);trace(untyped layer.clientX);
		//return untyped layer.clientX;
		if (parent == null) return mouseX;
		return untyped parent.mouseX - x;
	}

	override function get_mouseY () :Float {
		if (parent == null) return mouseY;
		return untyped parent.mouseY - y;
	}
}
