#if nme
class NMEAlertView {
	
#if android
	
	var ralcr_show_alert_view :Dynamic;
	public function new (title:String, message:String) {
		trace(1);
		if (ralcr_show_alert_view == null)
			ralcr_show_alert_view = nme.JNI.createStaticMethod("org/haxe/nme/GameActivity", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V");
		trace(2);trace(ralcr_show_alert_view);
			ralcr_show_alert_view ( title, message );
			trace(3);
	}
/*	native_new = nme.JNI.createStaticMethod("mloader/nme/extension/android/HttpLoader", "<init>", "(Ljava/lang/String;)V");
	native_addHeader = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "addHeader", "(Ljava/lang/String;Ljava/lang/String;)V");
	native_setUserAgent = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "setUserAgent", "(Ljava/lang/String;)V");
	native_get = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "get", "(Lorg/haxe/nme/HaxeObject;)V");
	native_post = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "post", "(Ljava/lang/String;Lorg/haxe/nme/HaxeObject;)V");
	native_cancel = nme.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "cancel", "()V");*/
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
