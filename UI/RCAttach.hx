// Attach something from the assets library

#if (flash || (openfl && (cpp || neko)))
	import flash.display.MovieClip;
#elseif js
	//import js.Dom;
	private typedef MovieClip = js.html.DivElement;
#end


class RCAttach extends RCView {
	
	public var target :MovieClip;
	public var id :String;
	
	
	public function new (x, y, id:String) {
		
		super (x, y);
		
		this.id = id;
		
		try {
		
		#if openfl
			target = new MovieClip();
			target.addChild ( new nme.display.Bitmap (openfl.Assets.getBitmapData ( id ), nme.display.PixelSnapping.AUTO, true));
			layer.addChild ( target );
		#elseif (flash && !nme)
			target = flash.Lib.attach ( id );
			layer.addChild ( target );
		#elseif (openfl || js)
			target = RCAssets.getFileWithKey( id );
		#end
		
		}catch(e:Dynamic){ trace(e+" : id="+id); }
	}
	
	public function copy () :RCAttach {
		return new RCAttach (this.x, this.y, this.id);
	}
}
