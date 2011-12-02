package  {
	import flash.events.Event;
	import flash.Boot;
	public class GroupEvent extends flash.events.Event {
		public function GroupEvent(type : String = null,_label : String = null,index : int = 0,bubbles : Boolean = false,cancelable : Boolean = false) : void { if( !flash.Boot.skip_constructor ) {
			super(type,bubbles,cancelable);
			this._label = _label;
			this.index = index;
		}}
		
		public var _label : String;
		public var index : int;
		static public var UPDATED : String = "group_updated";
		static public var CLICK : String = "group_click";
		static public var PUSH : String = "group_push";
		static public var REMOVE : String = "group_remove";
	}
}
