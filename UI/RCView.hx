//
//  RCView.hx
//	UIKit
//	Flash implementation of the RCDisplayObject
//
//  Created by Baluta Cristian on 2009-02-14.
//  Updated 2009-2012 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || (nme && (cpp || neko)))

typedef RCView = FlashView;

#elseif js

typedef RCView = JSView;

#elseif objc

typedef RCView = ObjcView;

#end

