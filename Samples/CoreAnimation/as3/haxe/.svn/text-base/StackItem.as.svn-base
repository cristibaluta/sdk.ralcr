package haxe {
	public class StackItem extends enum {
		public static const __isenum : Boolean = true;
		public function StackItem( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var CFunction : StackItem = new StackItem("CFunction",0);
		public static function FilePos(s : haxe.StackItem, file : String, line : int) : StackItem { return new StackItem("FilePos",2,[s,file,line]); }
		public static function Lambda(v : int) : StackItem { return new StackItem("Lambda",4,[v]); }
		public static function Method(classname : String, method : String) : StackItem { return new StackItem("Method",3,[classname,method]); }
		public static function Module(m : String) : StackItem { return new StackItem("Module",1,[m]); }
		public static var __constructs__ : Array = ["CFunction","Module","FilePos","Method","Lambda"];;
	}
}
