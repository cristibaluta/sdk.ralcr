//
//  ThreeD
//
//  Created by Baluta Cristian on 2009-03-26.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.geom.Point;
import flash.display.DisplayObjectContainer;


class CATDistort extends CAObject, implements CATransitionInterface {
	
	var distort :DistortImage;
	
	
	override public function init () :Void {
		
		var fromPoints :Array<Point> = new Array<Point>();
		var toPoints :Array<Point> = new Array<Point>();
		
		var points :Dynamic = Reflect.field (properties, "brightness");
		if (points != null)
		if (Std.is (points, Array)) {
			toPoints = points;
		}
		else if (Std.is (points, String)) {
			switch ( points.toLowerCase() ) {
				case "flip":	fromPoints = [];
				case "revolvingdoor":	fromPoints = [];
			}
		}
		else {
			// Custom brightnesses
			fromPoints = Reflect.field (points, "fromValue");
			toPoints = Reflect.field (points, "toValue");
		}
		
		// Set the starting and ending properties to the CAObject
		fromValues = {points	: fromPoints};
		toValues = {points	: toPoints};
		
		// Apply the starting brightness and alpha
		setDistortion (target, fromPoints);
	}
	
	override public function animate (time_diff:Float) :Void {
		
		var toPoints :Array<Point> = [];//calculate (time_diff, "points");
		setDistortion (target, toPoints);
	}
	
	// Flip - flip + flip
	// RevolvingDoor - flip verticaly + flip horizontaly
	
	function setDistortion (o:DisplayObjectContainer, points:Array<Point>) :Void {
		
	}
	
}