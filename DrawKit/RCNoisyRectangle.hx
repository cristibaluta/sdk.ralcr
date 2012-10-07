//
//  RCNoiseRectangle
//
//  Created by Cristi Baluta on 2010-05-11.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import flash.display.Bitmap;
import flash.display.BitmapData;


class RCNoisyRectangle extends RCDraw, implements RCDrawInterface {
	
	public var roundness :Null<Int>;// Rounded corners radius
	
	
	public function new (x, y, w, h, ?color:Int, ?alpha:Float=1.0, ?r:Null<Int>) {
		super (x, y, w, h, color, alpha);
		
		this.roundness = r;
		this.redraw();
	}
	
	public function redraw () {
		var line = new BitmapData (Math.round(size.width), Math.round(size.height), true, color);
			line.perlinNoise (	Math.random() /*baseX*/,
								Math.random()*5 /*baseY*/, 
								6 /*numOctaves :Int*/, 
								10 /*randomSeed :Int*/, 
								true /*stitch*/, 
								true /*fractalNoise*/, 
								0 /*channelOptions :Int*/, 
								true /*grayscale*/,
								null /*offsets :Array*/);
		var bitmapRectangle = new Bitmap ( line );
			bitmapRectangle.blendMode = flash.display.BlendMode.SCREEN;
		
		layer.addChild ( bitmapRectangle );
	}
}
