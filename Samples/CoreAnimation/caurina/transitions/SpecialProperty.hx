/**
 * SpecialProperty
 * A kind of a getter/setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */
package caurina.transitions;

class SpecialProperty {

	public var getValue : Dynamic; // (p_obj:Object, p_parameters:Array): Number
	public var setValue : Dynamic; // (p_obj:Object, p_value:Float, p_parameters:Array): Void
	public var parameters : Array<Dynamic>;
	public var preProcess : Dynamic; // (p_obj:Object, p_parameters:Array, p_originalValueComplete:Object, p_extra:Object): Number

	/**
	 * Builds a new special property object.
	 *
	 * @param		p_getFunction		Function	Reference to the function used to get the special property value
	 * @param		p_setFunction		Function	Reference to the function used to set the special property value
	 * @param		p_parameters		Array		Additional parameters that should be passed to the function when executing
													(so the same function can apply to different special properties)
	 */
	public function new (	p_getFunction:Dynamic,
							p_setFunction:Dynamic,
							?p_parameters:Array<Dynamic>,
							?p_preProcessFunction:Dynamic) {
								
		getValue = p_getFunction;
		setValue = p_setFunction;
		parameters = p_parameters;
		preProcess = p_preProcessFunction;
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString () : String {
		
		return ("[SpecialProperty " +
				"getValue:" + Std.string (getValue) +
				", setValue:" + Std.string (setValue) +
				", parameters:" + Std.string (parameters) +
				", preProcess:" + Std.string (preProcess) + "]");
	}
}
