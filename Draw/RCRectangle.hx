//
//  RCRectangle.hx
//	DrawKit
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008-2012 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class RCRectangle extends RCDraw implements RCDrawInterface {
	
	public var roundness :Null<Int>;// Rounded corners radius
	
	
	public function new (x, y, w, h, ?color:Dynamic, ?alpha:Float=1.0, ?r:Null<Int>) {
		
		super (x, y, w, h, color, alpha);
		
		this.roundness = r;
		this.redraw();
	}
	
	public function redraw() :Void {
		
		var dpi :Float = RCDevice.currentDevice().dpiScale;
		
#if (flash || (nme && (cpp || neko)))
		
		layer.graphics.clear();
		configure();
		
		(roundness != null)
		? layer.graphics.drawRoundRect (0, 0, size.width * dpi, size.height * dpi, roundness * dpi)
		: layer.graphics.drawRect (0, 0, size.width * dpi, size.height * dpi);
		
		layer.graphics.endFill();
		
#elseif js
		
		var fillColorStyle :Null<Int> = color.fillColorStyle;
		var strokeColorStyle :Null<Int> = color.strokeColorStyle;
		
		layer.style.margin = "0px 0px 0px 0px";
		layer.style.width = size.width * dpi + "px";
		layer.style.height = size.height * dpi + "px";
		layer.style.backgroundColor = fillColorStyle;
		
		if (strokeColorStyle != null) {
			layer.style.borderStyle = "solid";
			layer.style.borderWidth = borderThickness + "px";
			layer.style.borderColor = strokeColorStyle;
		}
		if (roundness != null) {
			untyped layer.style.MozBorderRadius = roundness * dpi / 2 + "px";
			untyped layer.style.borderRadius = roundness * dpi / 2 + "px";
		}
		
#end
	}
	
	override public function set_width (w:Float) :Float {
		size.width = w;
		redraw();
		return w;
	}
	override public function set_height (h:Float) :Float {
		size.height = h;
		redraw();
		return h;
	}
}
