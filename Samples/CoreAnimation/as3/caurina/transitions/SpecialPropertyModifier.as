package caurina.transitions {
	import flash.Boot;
	public class SpecialPropertyModifier {
		public function SpecialPropertyModifier(p_modifyFunction : * = null,p_getFunction : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.modifyValues = p_modifyFunction;
			this.getValue = p_getFunction;
		}}
		
		public var modifyValues : *;
		public var getValue : *;
		public function toString() : String {
			return "[SpecialPropertyModifier " + "modifyValues:" + Std.string(this.modifyValues) + ", getValue:" + Std.string(this.getValue) + "]";
		}
		
	}
}
