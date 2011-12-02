//
//  iSkin
//
//  Created by Baluta Cristian on 2009-01-03.
//  Copyright (c) 2009 http://ralcr.com. All rights reserved.
//
import flash.display.DisplayObjectContainer;

interface RCSkinInterface {
	// Basic objects that should have a Skin
	public var background :DisplayObjectContainer;
	public var up :DisplayObjectContainer;
	public var over :DisplayObjectContainer;
	public var down :DisplayObjectContainer;
	public var hit :DisplayObjectContainer;
	
	public var colors :Array<Null<Int>>;
}
