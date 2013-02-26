#if nme
class NMEAlertView {
	
#if android
	
	var ralcr_show_alert_view :Dynamic;
	public function new (title:String, message:String) {
		if (ralcr_show_alert_view == null)
			ralcr_show_alert_view = nme.JNI.createStaticMethod("org/haxe/nme/GameActivity", "newAlertView", "(Ljava/lang/String;Ljava/lang/String;)V");
			ralcr_show_alert_view ( title, message );
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
