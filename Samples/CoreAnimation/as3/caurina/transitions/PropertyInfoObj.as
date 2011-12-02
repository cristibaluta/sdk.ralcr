package caurina.transitions {
	import flash.Boot;
	public class PropertyInfoObj {
		public function PropertyInfoObj(p_valueStart : * = null,p_valueComplete : * = null,p_originalValueComplete : * = null,p_arrayIndex : * = null,p_extra : * = null,p_isSpecialProperty : Boolean = false,p_modifierFunction : * = null,p_modifierParameters : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this.valueStart = p_valueStart;
			this.valueComplete = p_valueComplete;
			this.originalValueComplete = p_originalValueComplete;
			this.arrayIndex = p_arrayIndex;
			this.extra = p_extra;
			this.isSpecialProperty = p_isSpecialProperty;
			this.hasModifier = p_modifierFunction != null;
			this.modifierFunction = p_modifierFunction;
			this.modifierParameters = p_modifierParameters;
		}}
		
		public var valueStart : *;
		public var valueComplete : *;
		public var originalValueComplete : *;
		public var arrayIndex : *;
		public var extra : *;
		public var isSpecialProperty : Boolean;
		public var hasModifier : Boolean;
		public var modifierFunction : *;
		public var modifierParameters : Array;
		public function clone() : caurina.transitions.PropertyInfoObj {
			return new caurina.transitions.PropertyInfoObj(this.valueStart,this.valueComplete,this.originalValueComplete,this.arrayIndex,this.extra,this.isSpecialProperty,this.modifierFunction,this.modifierParameters);
		}
		
		public function toString() : String {
			return "\n[PropertyInfoObj " + "valueStart:" + Std.string(this.valueStart) + ", valueComplete:" + Std.string(this.valueComplete) + ", originalValueComplete:" + Std.string(this.originalValueComplete) + ", arrayIndex:" + Std.string(this.arrayIndex) + ", extra:" + Std.string(this.extra) + ", isSpecialProperty:" + Std.string(this.isSpecialProperty) + ", hasModifier:" + Std.string(this.hasModifier) + ", modifierFunction:" + Std.string(this.modifierFunction) + ", modifierParameters:" + Std.string(this.modifierParameters) + "]\n";
		}
		
	}
}
