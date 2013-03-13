
class RCTabBarItem extends RCButtonRadio {
	
	public var badgeValue (default, set_badgeValue) :String;
	var _title :String;
	var _image :RCImage;
	var _selectedImage :RCImage;
	var _unselectedImage :RCImage;
	
	public function set_badgeValue (value:String) :String {
		badgeValue = value;
		return value;
	}
	override public function toString () :String {
		return "[RCTabBarItem ]";
	}
}
