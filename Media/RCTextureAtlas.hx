
private typedef FrameData = {
	var frame :RCRect;
	var offset :RCPoint;
	var rotated :Bool;
	var sourceColorRect :RCRect;
	var sourceSize :RCSize;
}

class RCTextureAtlas {
	
	static var textures :Hash<RCTextureAtlas>;
	public static function set (key:String, texture:RCTextureAtlas) :Void {
		if (textures == null)
			textures = new Hash<RCTextureAtlas>();
		textures.set (key, texture);
	}
	public static function get (key:String) :RCTextureAtlas {
		if (textures == null) return null;
		return textures.get ( key );
	}
	
	
	private var _texture :RCImage;
	private var _textures :Hash<FrameData>;
	
	/** Create a texture atlas from a RCImage by parsing the regions from a PLIST file. */
	
    public function new (texture:RCImage, atlas:String) {
		
		_textures = new Hash<FrameData>();
		_texture = texture;
		
		if (atlas.indexOf ("{\"frames\":") == 0)
			parseJSON ( atlas );
		else
			parse ( Xml.parse ( atlas ) );
    }
	
	function parse (xml:Xml) {
		
		switch ( xml.firstElement().nodeName ) {
			 case "plist" : parsePlist ( xml.firstElement() );
			 case "TextureAtlas" : parseXml ( xml.firstElement() );
		}
	}
	
	
	// Parse PLIST - for Cocos2D
	
	function parsePlist (xmlPlist:Xml) {
		
		var key_type :String = null;
		
		for (element in xmlPlist.firstElement().elements()) {
			
			if (element.nodeName == "key") {
				key_type = element.firstChild().nodeValue;
			}
			else if (element.nodeName == "dict") {
				switch (key_type) {
					case "frames":
						
						var frame_name :String = null;
						var frame_data :FrameData = null;
						
						for (element2 in element.elements()) {
							switch ( element2.nodeName ) {
								case "key":
									frame_name = element2.firstChild().nodeValue;
									frame_data = { frame:null, offset:null, rotated:false, sourceColorRect:null, sourceSize:null };
								case "dict":
									var current_key :String = null;
									for (element3 in element2.elements()) {
										switch ( element3.nodeName ) {
											case "key": current_key = element3.firstChild().nodeValue;
											case "string": 
												var current_value :Dynamic = null;
												var arr = element3.firstChild().nodeValue.split("{").join("").split("}").join("").split(",");
												switch ( current_key ) {
													case "frame", "sourceColorRect" :
														current_value = new RCRect (Std.parseFloat(arr[0]), Std.parseFloat(arr[1]), Std.parseFloat(arr[2]), Std.parseFloat(arr[3]));
													case "offset":
														current_value = new RCPoint (Std.parseFloat(arr[0]), Std.parseFloat(arr[1]));
													case "sourceSize":
														current_value = new RCSize (Std.parseFloat(arr[0]), Std.parseFloat(arr[1]));
												}
												Reflect.setField (frame_data, current_key, current_value);
											case "false": Reflect.setField (frame_data, current_key, "false");
											case "true": Reflect.setField (frame_data, current_key, "true");
											default : trace("Unmatched value type");
										}
									}
									_textures.set (frame_name, frame_data);
							}
						}
						
					case "metadata":
					
					
				}
			}
		}
	}


	// Parse XML - Sparrow
	
	function parseXml (xml:Xml) {
		
        var scale :Float = 1;
		var frame_data :FrameData = null;
		var x :Float;
		var y :Float;
		var width :Float;
		var height :Float;
		var frameX :Float;
		var frameY :Float;
		var frameWidth :Float;
		var frameHeight :Float;
		
		for (element in xml.elements()) {
			
			x = Std.parseFloat ( element.get("x")) / scale;
			y = Std.parseFloat ( element.get("y")) / scale;
			width = Std.parseFloat ( element.get("width")) / scale;
			height = Std.parseFloat ( element.get("height")) / scale;
			frameX = Std.parseFloat ( element.get("frameX")) / scale;
			frameY = Std.parseFloat ( element.get("frameY")) / scale;
			frameWidth = Std.parseFloat ( element.get("frameWidth")) / scale;
			frameHeight = Std.parseFloat ( element.get("frameHeight")) / scale;
			
			frame_data = {
				frame : new RCRect (x, y, width, height),
				offset : null,
				rotated : false,
				sourceColorRect : new RCRect (-frameX, -frameY, width, height),
				sourceSize : new RCSize (frameWidth, frameHeight)
			};
			
	        _textures.set (element.get("name"), frame_data);
		}
	}
    
	
	
	// Parse JSON - 
	
	function parseJSON (json:String) {
		
	}
	
	
    public function imageNamed (name:String, ?pos:haxe.PosInfos) :RCImage {
		
		if (!_textures.exists ( name ))
			name = name + ".png";
        
		var texture_data = _textures.get ( name );
		
        if (texture_data != null) {
			return RCImage.imageWithRegionOfImage (_texture, texture_data.sourceSize, texture_data.frame, texture_data.sourceColorRect);
		}
		trace( "err: imageNamed '"+name+"' does not exist in the texture. Called from "+pos);
		return null;
    }
    
    /** Returns all textures that start with a certain string, sorted alphabetically
     *  (especially useful for "MovieClip"). */
    public function imagesWithPrefix (prefix:String="") :Array<RCImage> {
		
		var textures = new Array<RCImage>();
		var names = new Array<String>();
		
		for (name in _textures.keys())
			if (name.indexOf(prefix) == 0)                
				names.push ( name );           
		Zeta.sort (names, "ascending");
			
		for (name in names)
			textures.push ( imageNamed ( name));
		
		return textures;
	}
	
	public function destroy () {
		_texture.destroy();
		_texture = null;
		_textures = null;
	}
}
