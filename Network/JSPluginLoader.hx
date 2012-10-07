import js.Dom;

class JSPluginLoader {
	
	public var percentLoaded :Int;
	
	dynamic public function onProgress() :Void {}
	dynamic public function onComplete() :Void {}
	dynamic public function onError() :Void {}
	
	
	public function new (path:String)
	{
		trace("load new Plugin "+path);
		var fileref = null;
		
		if (path.indexOf(".js") != -1) { //if filename is a external JavaScript file
			fileref = js.Lib.document.createElement('script');
			fileref.setAttribute("type","text/javascript");
			fileref.setAttribute("src", path);
		}
		else if (path.indexOf(".css") != -1) { //if filename is an external CSS file
			fileref = js.Lib.document.createElement("link");
			fileref.setAttribute("rel", "stylesheet");
			fileref.setAttribute("type", "text/css");
			fileref.setAttribute("href", path);
		}
		
		// After loading the external file add it to the DOM
		if (fileref != null) {
			untyped fileref.onload = completeHandler;
			js.Lib.document.getElementsByTagName("head")[0].appendChild ( fileref );
		}
	}
	
	function completeHandler (e:Event) {
		trace("plugin loaded asyncronously");
		onComplete();
	}
	function remove (path:String) :Bool
	{
		//determine element type to create nodelist using
/*		var targetelement=(filetype=="js")? "script" : (filetype=="css") ? "link" : "none";
		//determine corresponding attribute to test for
		var targetattr = (filetype == "js")? "src" : (filetype == "css") ? "href" : "none";
		var allsuspects = js.Lib.document.getElementsByTagName(targetelement);
		//search backwards within nodelist for matching elements to remove
		for (i in 0...allsuspects.length) {
			if (allsuspects[i] && 
				allsuspects[i].getAttribute(targetattr) != null && 
				allsuspects[i].getAttribute(targetattr).indexOf(oldfilename) != -1)
			{
				var newelement = createjscssfile(newfilename, filetype)
					allsuspects[i].parentNode.replaceChild (newelement, allsuspects[i])
			}
		}*/
		return true;
	}
	
	public function destroy () :Void {
		
	}
	
	
	/**
	 *  Check if a class name exists in the current application domain, meaning the current swf or the loaded swf's.
	 **/
	public static function exists (filename:String) :Bool
	{
		var element = (filename.indexOf(".js") != -1) ? "script" : (filename.indexOf(".css") != -1) ? "link" : "none";
		var attr = (filename.indexOf(".js") != -1)? "src" : (filename.indexOf(".css") != -1) ? "href" : "none";
		var collection :HtmlCollection<HtmlDom> = js.Lib.document.getElementsByTagName( element );
		for (i in 0...collection.length) {
			if (collection[i].getAttribute(attr) != null && collection[i].getAttribute(attr).indexOf(filename) != -1)
				return true;
		}
		return false;
	}
}