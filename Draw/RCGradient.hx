//
//  RCGradient
//
//  Created by Cristi Baluta on 2010-10-13.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
#if (flash || (openfl && (cpp || neko)))
import flash.geom.Matrix;
import flash.display.LineScaleMode;
import flash.display.GradientType;
import flash.display.CapsStyle;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;
#elseif js
//typedef Matrix = Dynamic;
typedef SpreadMethod = Dynamic;
typedef InterpolationMethod = Dynamic;
typedef GradientType = Dynamic;
#end

	// DCE bug at this moment if the RCGradient is not referenced anywhere, and it is not.
@:keep class RCGradient {
	
	public var strokeColor :Null<Int>;
	public var gradientColors :Array<Int>;// This 3 arrays should have the same number of elements
	public var gradientAlphas :Array<Float>;
	public var gradientRatios :Array<Int>;
	public var spreadMethod :SpreadMethod;
	public var interpolationMethod :InterpolationMethod;
	public var gradientType :GradientType;
	public var focalPointRatio :Float;
	public var tx :Int;
	public var ty :Int;
	public var matrixRotation :Float;
	
	
	public function new (colors:Array<Int>, ?alphas:Array<Float>, linear:Bool=true) {
		
		this.gradientColors = colors;
		this.gradientAlphas = alphas == null ? [1.0, 1.0] : alphas;
		this.gradientRatios = [0, 255];
		
#if (flash || (openfl && (cpp || neko)))
	
		this.spreadMethod = SpreadMethod.PAD;// REPEAT, REFLECT, PAD
		this.interpolationMethod = InterpolationMethod.RGB;// RGB, LINEAR_RGB
		this.gradientType = linear ? GradientType.LINEAR : GradientType.RADIAL;
		
#elseif canvas
	
	var canvas = document.getElementById('myCanvas');
	      var context = canvas.getContext('2d');
	      context.rect(0, 0, canvas.width, canvas.height);

	      // add linear gradient
	      var grd = context.createLinearGradient(0, 0, canvas.width, canvas.height);
	      // light blue
	      grd.addColorStop(0, '#8ED6FF');   
	      // dark blue
	      grd.addColorStop(1, '#004CB3');
	      context.fillStyle = grd;
	      context.fill();
		  
		  
		  var canvas = document.getElementById('myCanvas');
		        var context = canvas.getContext('2d');
		        context.rect(0, 0, canvas.width, canvas.height);

		        // create radial gradient
		        var grd = context.createRadialGradient(238, 50, 10, 238, 50, 300);
		        // light blue
		        grd.addColorStop(0, '#8ED6FF');
		        // dark blue
		        grd.addColorStop(1, '#004CB3');

		        context.fillStyle = grd;
		        context.fill();
#end
		this.focalPointRatio = 0;
		this.tx = 0;
		this.ty = 0;
		this.matrixRotation = Math.PI * 0.5;
		
		//if (colors.length == alphas.length == gradientRatios.length) trace("RCGradient arrays have different lengths!");
	}
}
