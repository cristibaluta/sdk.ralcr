
class RCTabBarItem extends RCButtonRadio {
	
	public var badgeValue (default, setBadgeValue) :String;
	var _title :String;
	var _image :RCImage;
	var _selectedImage :RCImage;
	var _unselectedImage :RCImage;
	
	public function setBadgeValue (value:String) :String {
		badgeValue = value;
		return value;
	}
	override public function toString () :String {
		return "[RCTabBarItem ]";
	}
}
