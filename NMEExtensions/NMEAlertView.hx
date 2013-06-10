#if openfl
class NMEAlertView {
	
#if android
	
	var ralcr_show_alert_view :Dynamic;

	public function new (title:String, message:String) {
		
		ralcr_show_alert_view = openfl.utils.JNI.createStaticMethod("org/haxe/nme/GameActivity", "newAlertView", "(Ljava/lang/String;Ljava/lang/String;)V");
		nme.Lib.postUICallback ( function() { ralcr_show_alert_view ( title, message ); });
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
    
	static var ralcr_show_alert_view = flash.Lib.load("nme", "ralcr_show_alert_view", 2);
#end
}
#end
