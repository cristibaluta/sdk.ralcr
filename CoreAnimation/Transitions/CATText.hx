//
//  CATText.hx
//	Typewriter effect
//
//  Created by Baluta Cristian on 2010-05-28.
//  Copyright (c) 2010 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class CATText extends CAObject, implements CATransitionInterface {
	
	var direction :Int;
	var html :Null<Bool>;
	
	
	override public function init () :Void {
		
		direction = -1;
		var fromText = "";
		var toText = "";
		var text :Dynamic = Reflect.field (properties, "text");
		
		if (text != null) {
			if (Std.is (text, String)) {
				
				fromText = target.text;
				toText = text;
			}
			else {
				var _fromText :String = Reflect.field (text, "fromValue");
				var _toText	:String = Reflect.field (text, "toValue");
				
				if (_fromText != null)	fromText = _fromText;
				if (_toText != null)	toText = _toText;
			}
		}
		
		fromValues = { text : fromText, nrOfLetters : 0/*fromText.length*/ };
		toValues = { text : toText, nrOfLetters : toText.length };
	}
	
	override public function animate (time_diff:Float) :Void {
		var nrOfLetters = Math.round (calculate (time_diff, "nrOfLetters"));
		target.setText ( Reflect.field (toValues, "text").substr (0, nrOfLetters));
	}
}
