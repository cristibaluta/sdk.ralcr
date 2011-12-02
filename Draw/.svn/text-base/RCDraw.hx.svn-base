//
//  RCDraw
//
//  Created by Cristi Baluta on 2010-02-19.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
#if flash
import flash.geom.Matrix;
import flash.display.LineScaleMode;
#elseif js
typedef Matrix = Dynamic;
private class LineScaleMode { static public var NONE = null; }
private typedef UInt = Int;
#end

class RCDraw extends #if flash RCView #elseif js JSView #end {
	
	public var color :Dynamic;// UInt, RCColor, RCGradient
	public var borderThickness :Int;
	
	
	public function new (x:Float, y:Float, w:Float, h:Float, color:Dynamic, alpha:Float=1.0) {
		super (x, y);
		
		this.size.width = w;
		this.size.height = h;
		this.alpha = alpha;
		this.borderThickness = 1;
		
#if js
		try{this.graphics = untyped view;}catch(e:Dynamic){trace(e);}//untyped view.getContext('2d');
#end
		
		// Parse the color
		if (Std.is (color, RCColor) || Std.is (color, RCGradient)) {
			this.color = color;
		}
		else if (Std.is (color, Int) || Std.is (color, UInt)) {
			this.color = new RCColor ( color );
		}
		else if (Std.is (color, Array)) {
			this.color = new RCColor ( color[0], color[1] );
		}
		else
			this.color = new RCColor ( 0x000000 );
	}
	
	public function configure () :Void {
		
		if (Std.is (color, RCColor)) {
			
			if (color.fillColor != null)
				this.graphics.beginFill (color.fillColor, color.alpha);
			
			if (color.borderColor != null) {
				var pixelHinting = true;
				var scaleMode = LineScaleMode.NONE;
				var caps = null;
				var joints = null;
				var miterLimit = 3;
				
				this.graphics.lineStyle (	borderThickness,
											color.borderColor,
											color.alpha,
											pixelHinting,
											scaleMode,
											caps,
											joints,
											miterLimit);
			}
		}
#if flash
		else if (Std.is (color, RCGradient)) {
			
			var m = new Matrix();
				m.createGradientBox (size.width, size.height, color.matrixRotation, color.tx, color.ty);
				
			this.graphics.beginGradientFill (	color.gradientType,
												color.gradientColors,
												color.gradientAlphas,
												color.gradientRatios,
												m,
												color.spreadMethod,
												color.interpolationMethod,
												color.focalPointRatio);
			// this.graphics.lineGradientStyle
			// (GradientType.LINEAR, colors, [100, 100], [0, 255], m);
		}
#end
	}
	
	/**
	 *  Return the frame as a RCRect object
	 */
	public function frame () :RCRect {
		return new RCRect (x, y, size.width, size.height);
	}
}
