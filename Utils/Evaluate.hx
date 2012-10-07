
class Evaluate {
	
	
	/**
	 *	Returns an Int from a string operation.
	 *	@param strOperation - The mathematical operation
	 *  @param rect - bounds of the photowidth, photoheight
	 */
	public static function operations (strOperation:String, ?rect:RCRect) :Int {
		
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
	
	static function makeOperation (result:Int, word:String, operator:String, rect:RCRect) :Int
	{
		return switch ( operator ) {
			case "+": result + parseInt ( word, rect );
			case "-": result - parseInt ( word, rect );
			case "*": Math.round ( result * parseInt ( word, rect ) );
			case "/": Math.round ( result / parseInt ( word, rect ) );
		}
	}
	
	
	
	public static function parseInt (str:String, ?rect:RCRect) :Int
	{
		return Math.round ( switch ( str ) {
			case "stagewidth":	RCWindow.sharedWindow().width;
			case "stageheight":	RCWindow.sharedWindow().height;
			case "photowidth":	rect == null ? 0.0 : rect.size.width;
			case "photoheight":	rect == null ? 0.0 : rect.size.height;
			case "content_max_width": RCWindow.sharedWindow().width;
			default :			Std.parseInt ( str );
		});
	}
	
}