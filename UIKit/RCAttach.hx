// Attach something from the assets library

#if (flash || (nme && (cpp || neko)))
	import flash.display.MovieClip;
#elseif js
	import js.Dom;
	private typedef MovieClip = HtmlDom;
#end


class RCAttach extends RCView {
	
	public var target :MovieClip;
	public var id :String;
	
	
	public function new (x, y, id:String) {
		
		super (x, y);
		
		this.id = id;
		
		try {
		
		#if nme
			target = new MovieClip();
			target.addChild ( new nme.display.Bitmap (nme.Assets.getBitmapData ( id ), nme.display.PixelSnapping.AUTO, true));
			layer.addChild ( target );
		#elseif (flash && !nme)
			target = flash.Lib.attach ( id );
			layer.addChild ( target );
		#elseif (nme || js)
			target = RCAssets.getFileWithKey( id );
		#end
		
		}catch(e:Dynamic){ trace(e+" : id="+id); }
	}
	
	public function copy () :RCAttach {
		return new RCAttach (this.x, this.y, this.id);
	}
}
