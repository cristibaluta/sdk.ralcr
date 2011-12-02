package caurina.transitions {
	import flash.Boot;
	public class SpecialProperty {
		public function SpecialProperty(p_getFunction : * = null,p_setFunction : * = null,p_parameters : Array = null,p_preProcessFunction : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.getValue = p_getFunction;
			this.setValue = p_setFunction;
			this.parameters = p_parameters;
			this.preProcess = p_preProcessFunction;
		}}
		
		public var getValue : *;
		public var setValue : *;
		public var parameters : Array;
		public var preProcess : *;
		public function toString() : String {
			return "[SpecialProperty " + "getValue:" + Std.string(this.getValue) + ", setValue:" + Std.string(this.setValue) + ", parameters:" + Std.string(this.parameters) + ", preProcess:" + Std.string(this.preProcess) + "]";
		}
		
	}
}
