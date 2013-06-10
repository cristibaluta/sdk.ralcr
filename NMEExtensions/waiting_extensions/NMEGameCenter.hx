#if openfl
class NMEGameCenter {
	
#if android
	
	public function new (title:String, msg:String) {
		var _showAlert_func = openfl.utils.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
		_showAlert_func ( [title, msg] );
	}
    
#else
	
	var alertTitle :String;
	var alertMSG :String;
	
	public function new (title:String, message:String) {
		alertTitle = title;
		alertMSG = message;
		haxe.Timer.delay (delayAlert, 30);
	}
    
	static function delayAlert() {
		system_ui_show_alert (alertTitle, alertMSG);
	}
    
	static var system_ui_show_alert = flash.Lib.load("nme", "system_ui_show_alert", 2);
#end
}
#end