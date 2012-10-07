//
//  JSView.hx
//	UIKit
//
//  Created by Baluta Cristian on 2011-11-12.
//  Copyright (c) 2011-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
//	Do not use directly this class, use RCView

import js.Lib;
import js.Dom;
import JSCanvas;
import RCDevice;


class JSView extends RCDisplayObject {
	
	public var layer :HtmlDom;
	public var layerScrollable :HtmlDom;// Clips to bounds will move all the subviews in this layer
	public var graphics :CanvasContext;
	var alpha_ :Float;
	
	
	@:keep public function new (x, y, ?w, ?h) {
		
		super();
		
		size = new RCSize (w, h);
		contentSize_ = size.copy();
		scaleX_ = 1;
		scaleY_ = 1;
		alpha_ = 1;
		//visible = true;
		
		#if canvas
			layer = Lib.document.createElement("canvas");
			graphics = untyped layer.getContext('2d');
		#else
			layer = Lib.document.createElement("div");
		#end
		
		// In JS, the div must be positioned absolute
		layer.style.position = "absolute";
		layer.style.margin = "0px 0px 0px 0px";
		layer.style.width = "auto";
		layer.style.height = "auto";
		
		setX ( x );
		setY ( y );
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
	public function removeFromSuperView () :Void {
		
		if (parent != null)
			parent.removeChild ( this );
	}
	
	
	
	/**
	 *  Change the color of the background
	 */
	override public function setBackgroundColor (color:Null<Int>) :Null<Int> {
		
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
	
	
	override public function setClipsToBounds (clip:Bool) :Bool {
		// When we clip we move all subviews on a different div inside the current div
		if (clip) {
			layer.style.overflow = "hidden";
			layerScrollable = Lib.document.createElement("div");
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
	override public function setVisible (v:Bool) :Bool {
		layer.style.visibility = (v ? "visible" : "hidden");
		return super.setVisible ( v );
	}
	override public function setAlpha (a:Float) :Float {
		
		if (RCDevice.currentDevice().userAgent == MSIE) {
			untyped layer.style.msFilter = "progid:DXImageTransform.Microsoft.Alpha(Opacity="+Std.string(a*100)+")";
			untyped layer.style.filter = "alpha(opacity="+Std.string(a*100)+")";
			//if(a==0)layer.style.background = "url(pixel.png) repeat";
		}
		else {
			untyped layer.style.opacity = Std.string(a);
		}
		return super.setAlpha ( a );
	}
	override public function setX (x:Float) :Float {
		layer.style.left = Std.string (x * RCDevice.currentDevice().dpiScale) + "px";
		return super.setX ( x );
	}
	override public function setY (y:Float) :Float {
		layer.style.top = Std.string (y * RCDevice.currentDevice().dpiScale) + "px";
		return super.setY ( y );
	}
	override public function setWidth (w:Float) :Float {
		layer.style.width = w + "px";
		return super.setWidth ( w );
	}
	override public function setHeight (h:Float) :Float {
		layer.style.height = h + "px";
		return super.setHeight ( h );
	}
	override public function getContentSize () :RCSize {
/*		trace("offset "+new RCSize (layer.offsetWidth, layer.offsetHeight));
		trace("scroll "+new RCSize (layer.scrollWidth, layer.scrollHeight));
		trace("client "+new RCSize (layer.clientWidth, layer.clientHeight));*/
		contentSize_.width = layer.scrollWidth;
		contentSize_.height = layer.scrollHeight;
		return contentSize_;
	}
	
/*	override public function setScaleX (sx:Float) :Float {
		scaleX_ = sx;
		scale (scaleX_, scaleY_);
		return scaleX_;
	}
	override public function setScaleY (sy:Float) :Float {
		scaleY_ = sy;
		scale (scaleX_, scaleY_);
		return scaleY_;
	}*/
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
	
	
	override public function setRotation (r:Float) :Float {
		untyped layer.style[getTransformProperty()] = "rotate(" + r + "deg)";
		return super.setRotation ( r );
	}
	
	public function startDrag (?lockCenter:Bool, ?rect:RCRect) :Void {
		
	}
	public function stopDrag () :Void {
		
	}
	
	override function getMouseX () :Float {
		return untyped layer.clientX;
		if (parent == null) return mouseX;
		return untyped parent.mouseX - x;
	}

	override function getMouseY () :Float {
		if (parent == null) return mouseY;
		return untyped parent.mouseY - y;
	}
}
