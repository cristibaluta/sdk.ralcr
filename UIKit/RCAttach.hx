import flash.display.Sprite;
import flash.display.MovieClip;


class RCAttach extends Sprite {
	
	public var target :MovieClip;
	public var key :String;
	
	
	public function new (x, y, key:String) {
		super();
		this.x = x;
		this.y = y;
		this.key = key;
		
		try {
			target = flash.Lib.attach ( key );
			this.addChild ( target );
		}
		catch(e:Dynamic){trace(e);}
	}
	
	public function clone () :RCAttach {
		return new RCAttach (this.x, this.y, this.key);
	}
}
