package  {
	import flash.Boot;
	public class RCNotification {
		public function RCNotification(name : String = null,functionToCall : * = null,args : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this.name = name;
			this.functionToCall = functionToCall;
			this.args = args;
		}}
		
		public var name : String;
		public var functionToCall : *;
		public var args : Array;
		public function toString() : String {
			return "[RCNotification with name: '" + this.name + "', functionToCall: " + this.functionToCall + "]";
		}
		
	}
}
