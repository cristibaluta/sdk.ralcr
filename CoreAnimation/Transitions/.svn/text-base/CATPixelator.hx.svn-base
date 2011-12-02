//
//  Zoom
//
//  Created by Baluta Cristian on 2009-03-20.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
/*
 * com.vj.fx.Pixelator
 * 
 * @author: Erik Hallander
 * @build: 1.1 (21-08-08)
 * @purpose: "Pixelating" transition between two displayobjects.
 * @collaborators: None.
 *
 * @destructs: Nothing. Source objects gets hidden.
 * @modifies: Nothing.
 * 
 */
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.events.Event;
import flash.geom.Matrix;


class CATPixelator extends CAObject, implements CATransitionInterface {
	
	var extra :Array<Dynamic>;// used by pixelator to store helpful information
	
	
	override public function init () :Void {
		
		// Default values
		var fromPixelSize :Float = 1;
		var toPixelSize :Float = 200;
		
		var pixelSize :Dynamic = Reflect.field (properties, "pixelSize");
		
		if (pixelSize != null) {
			if (Std.is (pixelSize, Int) || Std.is (pixelSize, Float)) {
				// We have clear properties: pixelSize=200;
				toPixelSize = pixelSize;
			}
			else if (Std.is (pixelSize, String)) {
				// We have some predefined strings
				switch ( pixelSize.toLowerCase() ) {
					case "pixelatein":	toPixelSize = 200;
					case "pixelateout":	fromPixelSize = 200; toPixelSize = 1;
				}
			}
			else {
				// We have composed properties: x={fromValue:0, toValue:10}, ....
				var _fromPixelSize	:Null<Float> = Reflect.field (pixelSize, "fromValue");
				var _toPixelSize	:Null<Float> = Reflect.field (pixelSize, "toValue");
				
				if (_fromPixelSize != null) fromPixelSize = _fromPixelSize;
				if (_toPixelSize != null)	toPixelSize = _toPixelSize;
			}
		}
		
		// Set the starting and ending pixel size to the CAObject
		fromValues = { pixelSize : fromPixelSize	};
		toValues   = { pixelSize : toPixelSize	};
		
		// Create the extra array used to store the original and modified  objects
		extra = new Array<Dynamic>();
		
		// Take a snapshot of the original display object
		var copyData = new BitmapData (	Math.round ( target.width / target.scaleX ),
										Math.round ( target.height / target.scaleY ),
										true, 0);
			copyData.draw ( target );

		// Keep a snapshot in a Sprite at index 0
		extra[0] = new Sprite();
		extra[0].addChild ( new Bitmap (copyData, PixelSnapping.AUTO, true) );
		
		// bmp [1]
		extra[1] = new Bitmap (copyData.clone(), PixelSnapping.AUTO, true);
		target.addChild ( extra[1] );
										
		setPixelationLevel ( fromPixelSize );
	}
	
	override public function animate (time_diff:Float) :Void {
		
		var pixelSize = calculate (time_diff, "pixelSize");
		setPixelationLevel ( pixelSize );
	}
	
	public function setPixelationLevel (pixelSize:Float) {
		
		// bitmapProcess [2]
		extra[2] = new BitmapData (	Math.round (extra[0].width/pixelSize),
									Math.round (extra[0].height/pixelSize),
									true, 0);
		
		var scaleMatrix = new Matrix();
			scaleMatrix.scale (1 / pixelSize, 1 / pixelSize);
			
		extra[2].draw (extra[0], scaleMatrix);
		extra[1].bitmapData = extra[2];
		extra[1].width = extra[0].width;
		extra[1].height = extra[0].height;
	}
	
	public function resetPixels () :Void {
		if (target != null) {
			
			extra[0] = null;
			target.removeChild ( extra[1] );
			extra[1] = null;
			extra[2].dispose();
			extra[2] = null;
		}
	}
}
