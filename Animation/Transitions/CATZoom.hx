//
//  CATZoom.hx
//	Scales objects as to give a zoom effect
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class CATZoom extends CAObject implements CATransitionInterface {
	
	/**
	 *  Predefined zoom types that you can use: {zoom:zoomType}
	 *  zoominin - 
	 *  zoomoutin - From a big scale to normal scale
	 *  zoominout - 
	 *  zoomoutout - 
	 *  spinin - 
	 *  spinout - 
	 **/
	override public function init () :Void {
		
		var fromScale = 1.;
		var toScale = 1.;
		var fromAlpha = .0;
		var toAlpha = 1.;
		var fromRotation = .0;
		var toRotation = .0;
		
		var zoom :Dynamic = Reflect.field (properties, "zoom");
		
		if (zoom != null) {
			if (Std.is (zoom, Int) || Std.is (zoom, Float)) {
				
				fromScale = target.scaleX;
				toScale = fromScale * zoom;
			}
			else if (Std.is (zoom, String)) {
				switch ( zoom.toLowerCase() ) {
					case "zoominin":	fromScale = 0.7;
					case "zoomoutin":	fromScale = 1.3;
					case "zoominout":	fromScale = 1;	toScale = 1.3;	fromAlpha = 1;		toAlpha = 0;
					case "zoomoutout":	fromScale = 1;	toScale = .7;	fromAlpha = 1;		toAlpha = 0;
					case "spinin":		fromRotation -= 300;//rotation+scale
					case "spinout":		toRotation = 0;
				}
			}
			else {
				var _fromScale	:Null<Float> = Reflect.field (zoom, "fromScale");
				var _toScale	:Null<Float> = Reflect.field (zoom, "toScale");
				var _fromAlpha	:Null<Float> = Reflect.field (zoom, "fromAlpha");
				var _toAlpha	:Null<Float> = Reflect.field (zoom, "toAlpha");
				var _fromRot	:Null<Float> = Reflect.field (zoom, "fromRotation");
				var _toRot		:Null<Float> = Reflect.field (zoom, "toRotation");
				
				if (_fromScale != null) fromScale = _fromScale;
				if (_toScale != null)	toScale = _toScale;
				if (_fromAlpha != null) fromAlpha = _fromAlpha;
				if (_toAlpha != null)	toAlpha = _toAlpha;
				if (_fromRot != null)	fromRotation = _fromRot;
				if (_toRot != null)		toRotation = _toRot;
			}
		}
		
		// Set the properties that are used to zoom the object: x, y, width, height, alpha
		// >>
		// Get the original properties of the object
		var i_w = target.get_width();
		var i_h = target.get_height();
		var i_x = target.get_x();
		var i_y = target.get_x();
		
		// Final values we should zoom to
		var f_w = i_w * toScale;
		var f_h = i_h * toScale;
		var f_x = Math.round (i_x + (i_w - f_w) / 2);// center the object relative to his original position and size
		var f_y = Math.round (i_y + (i_h - f_h) / 2);
		
		// Set the object properties to their starting position
		target.set_width ( i_w * fromScale );
		target.set_height ( i_h * fromScale );
		target.set_x ( Math.round (i_x + (i_w - target.getWidth()) / 2));
		target.set_y ( Math.round (i_y + (i_h - target.getHeight())/ 2));
		target.set_alpha ( fromAlpha );
		
		// Set the starting and ending properties to the CAObject also
		fromValues = {	x		: target.get_x(),
						y		: target.get_y(),
						width	: target.get_width(),
						height	: target.get_height(),
						alpha	: fromAlpha
					};
		
		toValues = {	x		: f_x,
						y		: f_y,
						width	: f_w,
						height	: f_h,
						alpha	: toAlpha
					};
	}
	
	override public function animate (time_diff:Float) :Void {
		// Iterate over properties that should be tweened for this object
		for (prop in Reflect.fields (toValues)) {
			//Reflect.setField (target, prop, calculate (time_diff, prop));
			var setter = "set_"+prop;
			if (setter != null)
				Reflect.callMethod (target, Reflect.field(target,setter), [calculate (time_diff, prop)]);
			
		}
	}
}
