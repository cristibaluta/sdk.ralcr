
public class GKTextureAtlas {
	
    private var _texture :RCImage;
    private var _regions :Hash<RCRect>;
    private var _frames :Hash<RCRect>;
        
    /** Create a texture atlas from a RCImage by parsing the regions from an PLIST file. */
	
    public function new (texture:RCImage, atlasXml:XML) {
		
        _regions = new Hash<RCRect>();
        _frames = new Hash<RCRect>();
        _texture = texture;
            
        parseAtlasXml ( atlasXml );
    }
	protected function parsePlist (xml:Xml) :Void {
		var xml = Xml.parse ( str );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		
		players = new Array<Player>();
		
		for (p in fast.nodes.player) {
			var player = new Player();
				player.id = p.att.id;
				player.message = p.att.message;
				player.points = Std.parseInt ( p.att.points );
				
			players.push ( player );
		}
	}
	protected function parseXml (atlasXml:XML) :Void {
		
        var scale:Number = mAtlasTexture.scale;
            
        for each (var subTexture:XML in atlasXml.SubTexture)
        {
            var name:String        = subTexture.attribute("name");
            var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
            var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
            var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
            var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
            var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
            var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
            var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
            var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
                
            var region:Rectangle = new Rectangle(x, y, width, height);
            var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
                    new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
                
	        _regions.set (name, region);
	        _frames.set (name, frame);
        }
    }
    
    public function imageNamed (name:String) :RCImage {
		
        var region = _regions.get ( name );
        if (region != null) {
			return RCImage.imageWithRegionOfImage (region, _texture /*_frames.get ( name )*/);
		}
		return null;
    }
        
    /** Returns all textures that start with a certain string, sorted alphabetically
     *  (especially useful for "MovieClip"). */
    public function imagesWithPrefix (prefix:String="") :Array<RCImage> {
		
		var textures = new Array<RCImage>();
		var names = new Array<String>();
		
		for (name in _regions)
			if (name.indexOf(prefix) == 0)                
				names.push ( name );                
		
		names.sort ( Array.CASEINSENSITIVE );
		
		for (name in names) 
			textures.push ( imageNamed ( name)); 
		
		return textures;
	}
	
	public function destroy () {
		_texture.destroy();
		_texture = null;
		_regions = null;
		_frames = null;
	}
}
