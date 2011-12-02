package  {
	public class ValueType extends enum {
		public static const __isenum : Boolean = true;
		public function ValueType( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var TBool : ValueType = new ValueType("TBool",3);
		public static function TClass(c : Class) : ValueType { return new ValueType("TClass",6,[c]); }
		public static function TEnum(e : Class) : ValueType { return new ValueType("TEnum",7,[e]); }
		public static var TFloat : ValueType = new ValueType("TFloat",2);
		public static var TFunction : ValueType = new ValueType("TFunction",5);
		public static var TInt : ValueType = new ValueType("TInt",1);
		public static var TNull : ValueType = new ValueType("TNull",0);
		public static var TObject : ValueType = new ValueType("TObject",4);
		public static var TUnknown : ValueType = new ValueType("TUnknown",8);
		public static var __constructs__ : Array = ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"];;
	}
}
