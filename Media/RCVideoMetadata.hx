//
//  CustomClient
//
//  Created by Baluta Cristian on 2008-08-18.
//  Copyright (c) 2008 milc.ro. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class CustomClient {
	
	public var width : Int;
	public var height : Int;
	
	public function new () {}
	
	public function onMetaData (info:Dynamic) : Void {
		width = Math.round (Reflect.field (info, "width"));
		height = Math.round (Reflect.field (info, "height"));
		//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
	}
	public function onCuePoint (info:Dynamic) : Void {
		trace (Reflect.fields (info));
		//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	}
}
