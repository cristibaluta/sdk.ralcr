/**
 * SpecialPropertySplitter
 * A proxy setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */
package caurina.transitions;

class SpecialPropertySplitter {

	public var parameters : Array<Dynamic>;
	public var splitValues : Dynamic;

	/**
	 * Builds a new splitter special propery object.
	 * 
	 * @param		p_splitFunction		Function	Reference to the function used to split a value 
	 */
	public function new (p_splitFunction:Dynamic, p_parameters:Array<Dynamic>) {
		splitValues = p_splitFunction;
		parameters = p_parameters;
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString () : String {
		
		return ("[SpecialPropertySplitter " +
				"splitValues:" + Std.string (splitValues) +
				", parameters:" + Std.string (parameters) + "]");
	}


}
