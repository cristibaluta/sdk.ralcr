#if nme
class NMEAlertView {
	
#if android
	
	public function new (title:String, msg:String) {
		var _showAlert_func = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V", true);
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
    function delayAlert() {
		ralcr_show_alert_view (alertTitle, alertMSG);
	}
    
	static var ralcr_show_alert_view = nme.Loader.load("ralcr_show_alert_view", 2);
#end
}
#end
