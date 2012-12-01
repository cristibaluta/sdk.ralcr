
private typedef FrameData = {
	var frame :RCRect;
	var offset :RCPoint;
	var rotated :Bool;
	var sourceColorRect :RCRect;
	var sourceSize :RCSize;
}

class RCTextureAtlas {
	
	private var _texture :RCImage;
	private var _textures :Hash<FrameData>;
	
	/** Create a texture atlas from a RCImage by parsing the regions from a PLIST file. */
	
    public function new (texture:RCImage, atlas:String) {
		
		_textures = new Hash<FrameData>();
		_texture = texture;
		
		parse ( Xml.parse ( atlas ) );
    }
	function parse (xml:Xml) :Void {
		
		var type = xml.firstElement().nodeName;//trace(type);
		
		if (type == "plist")
			parsePlist ( xml.firstElement() );
	}
	function parsePlist (xmlPlist:Xml) :Void {
		
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
/*	function parseDictionary( xmlDict:Xml ) :Hash<Dynamic> {
		
			var h = new Hash<Dynamic>();
			var key :String = null;
		
			for (element in xmlDict.elements()) {
				if (key == null && element.nodeName == "key" ) {						
					key = element.firstChild().toString();
				}
				else {
					switch ( element.nodeName ) {
						case "dict": h.set (key, parseDictionary (element));
						case "array": h.set (key, parseArray (element));
						case "string": h.set (key, element.firstChild().toString());
						case "integer": h.set (key, Std.parseInt(element.firstChild().toString()));
						case "real": h.set (key, Std.parseFloat(element.firstChild().toString()));
						case "data": h.set (key, element.firstChild());
						case "date": 
							var d = element.firstChild().toString();
								d = StringTools.replace(d, "T", " ");
								d = StringTools.replace(d, "Z", "");
							h.set (key, Date.fromString(d));
					}
					key = null;
				}
			}
			//trace(h);
			return h;
		}*/
/*	function parseXml (atlasXml:XML) :Void {
		
        var scale:Number = mAtlasTexture.scale;
            
        for (var subTexture:XML in atlasXml.SubTexture)
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
    }*/
    
    public function imageNamed (name:String) :RCImage {
		
        var texture_data = _textures.get ( name );
		
        if (texture_data != null) {
			return RCImage.imageWithRegionOfImage (_texture, texture_data.sourceSize, texture_data.frame, texture_data.sourceColorRect);
		}
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
		
		//names.sort ( untyped Array.CASEINSENSITIVE );
		
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
