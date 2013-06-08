## Overview

A collection of crossplatform user interface elements. 
The constructor for most of this components have the first 4 arguments the same:

	(x:Float, y:Float, ?width:Float, ?height:Float, ...)
	
This info is stored in the component like this:

	public var x :Float;
	public var y :Float;
	public var size :RCSize; // width and height

The base class is RCDisplayObject.
The superclass is RCView.
All other components extends the RCView.