#if openfl

class NMEAppPurchase extends NXObject{
	
	private static var instance:InAppPurchase;
	
	private function new(){
        super();
		system_in_app_purchase_init();
	}
	
	public static function getInstance():InAppPurchase{
		if(instance == null){
			instance = new NMEAppPurchase();
		}	
		return instance;
	}
	
	public function canPurchase():Bool{
		return system_in_app_purchase_can_purchase();
	}
	
	public function purchase(productID:String):Void{
		system_in_app_purchase_purchase(productID);
	}
	
	public function destroy():Void{
		system_in_app_purchase_release();
		instance = null;
	}
	
	static var system_in_app_purchase_init = flash.Lib.load("nme", "system_in_app_purchase_init",0);
	static var system_in_app_purchase_purchase = flash.Lib.load("nme", "system_in_app_purchase_purchase",1);
	static var system_in_app_purchase_can_purchase = flash.Lib.load("nme", "system_in_app_purchase_can_purchase",0);
	static var system_in_app_purchase_release = flash.Lib.load("nme", "system_in_app_purchase_release",0);
}
#end
