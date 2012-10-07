/**
 * SpecialPropertyModifier
 * A special property which actually acts on other properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 * @private
 */
package caurina.transitions;

class SpecialPropertyModifier {

	public var modifyValues : Dynamic;
	public var getValue : Dynamic;

	/**
	 * Builds a new special property modifier object.
	 * 
	 * @param		p_modifyFunction		Function		Function that returns the modifider parameters.
	 */
	public function new (p_modifyFunction:Dynamic, p_getFunction:Dynamic) {
		modifyValues = p_modifyFunction;
		getValue = p_getFunction;
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString () : String {
		
		return ("[SpecialPropertyModifier " +
				"modifyValues:" + Std.string (modifyValues) +
				", getValue:" + Std.string (getValue) + "]");
	}


}
