package caurina.transitions {
	public class AuxFunctions {
		static public function numberToR(p_num : int) : int {
			return (p_num & 16711680) >> 16;
		}
		
		static public function numberToG(p_num : int) : int {
			return (p_num & 65280) >> 8;
		}
		
		static public function numberToB(p_num : int) : int {
			return p_num & 255;
		}
		
		static public function isInArray(p_string : String,p_array : Array) : Boolean {
			{
				var _g : int = 0;
				while(_g < p_array.length) {
					var p_elem : String = p_array[_g];
					++_g;
					if(p_elem == p_string) return true;
				}
			}
			return false;
		}
		
		static public function getObjectLength(p_object : *) : int {
			var totalProperties : int = 0;
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(p_object);
				while(_g < _g1.length) {
					var pName : String = _g1[_g];
					++_g;
					totalProperties++;
				}
			}
			return totalProperties;
		}
		
		static public function concatObjects(args : Array) : * {
			var finalObject : * = { }
			{
				var _g : int = 0;
				while(_g < args.length) {
					var currentObject : * = args[_g];
					++_g;
					{
						var _g1 : int = 0, _g2 : Array = Reflect.fields(currentObject);
						while(_g1 < _g2.length) {
							var prop : String = _g2[_g1];
							++_g1;
							if(Reflect.field(currentObject,prop) != null) {
								Reflect.setField(finalObject,prop,Reflect.field(currentObject,prop));
							}
						}
					}
				}
			}
			return finalObject;
		}
		
	}
}
