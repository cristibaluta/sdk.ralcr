#if nme
class NMEActivityIndicator {
	
#if android
	
	public function new (x:Float, y:Float, ?white:Bool=false, ?large:Bool=false) {
		
	}
	public function destroy() :Void {
		
	}
    
#else
	
	public function new (x:Float, y:Float, ?white:Bool=false, ?large:Bool=false) {
		ralcr_new_activity_indicator (x, y, white, large);
	}
	public function destroy() :Void {
		ralcr_destroy_activity_indicator();
	}
    
	static var ralcr_new_activity_indicator = nme.Loader.load("ralcr_new_activity_indicator", 4);
	static var ralcr_destroy_activity_indicator = nme.Loader.load("ralcr_destroy_activity_indicator", 0);
#end
}
#end