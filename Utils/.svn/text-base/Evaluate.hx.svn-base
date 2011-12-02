import flash.geom.Rectangle;


class Evaluate {
	
	
	/**
	 *	Returns an int from a string operation
	 *	obj - pass an object to get width and height instead the stage width and height
	 */
	public static function operations (strOperation:String, ?rect:Rectangle) :Int {
		
		var result :Int = 0;
		var operators = ["+", "-", "*", "/"];
		var lastOperator = "+";
		var letters = strOperation.toLowerCase().split("");
		var word = "";
		
		for (letter in letters) {
			// If operator found
			if (Zeta.isIn (letter, operators)) {
				result = makeOperation (result, word, lastOperator, rect);
				word = "";
				lastOperator = letter;
			}
			// Ignore spaces
			else if (letter == " ")
				continue;
			// If a letter or number is found add it to the word
			else
				word += letter;
		}
		return makeOperation (result, word, lastOperator, rect);
	}
	
	static function makeOperation (result:Int, word:String, operator:String, rect:Rectangle) :Int {
		return switch ( operator ) {
			case "+": result + parseInt ( word, rect );
			case "-": result - parseInt ( word, rect );
			case "*": Math.round ( result * parseInt ( word, rect ) );
			case "/": Math.round ( result / parseInt ( word, rect ) );
		}
	}
	
	
	
	public static function parseInt (str:String, ?rect:Rectangle) :Int {
		return Math.round ( switch ( str ) {
			case "stagewidth":	RCStage.width;
			case "stageheight":	RCStage.height;
			case "photowidth":	rect == null ? 0.0 : rect.width;
			case "photoheight":	rect == null ? 0.0 : rect.height;
			default :			Std.parseInt ( str );
		});
	}
	
}