import js.html.Event;
import js.html.HTMLCollection;
import js.html.NodeList;
import js.html.Element;

class JSPluginLoader {
	
	public var percentLoaded :Int;
	
	dynamic public function onProgress() :Void {}
	dynamic public function onComplete() :Void {}
	dynamic public function onError() :Void {}
	
	
	/**
	 *  Loads into the DOM the file at path @path
	 *  Can load javascript files or css files
	 **/
	public function new (path:String)
	{
		trace("load new Plugin "+path);
		var fileref :Element = null;
		
		if (path.indexOf(".js") != -1) {
			fileref = js.Browser.document.createElement('script');
			fileref.setAttribute("type","text/javascript");
			fileref.setAttribute("src", path);
		}
		else if (path.indexOf(".css") != -1) {
			fileref = js.Browser.document.createElement("link");
			fileref.setAttribute("rel", "stylesheet");
			fileref.setAttribute("type", "text/css");
			fileref.setAttribute("href", path);
		}
		
		// After loading the external file add it to the DOM
		if (fileref != null) {
			untyped fileref.onload = completeHandler;
			js.Browser.document.getElementsByTagName("head")[0].appendChild ( fileref );
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
		var allsuspects = js.Browser.document.getElementsByTagName(targetelement);
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
		// Nothing to destroy, for compatibility reason
	}
	
	
	/**
	 *  Checks if a class name exists in the Dom
	 **/
	public static function exists (filename:String) :Bool
	{
		trace("exists "+filename);
		var element = (filename.indexOf(".js") != -1) ? "script" : (filename.indexOf(".css") != -1) ? "link" : "none";
		var attr = (filename.indexOf(".js") != -1)? "src" : (filename.indexOf(".css") != -1) ? "href" : "none";
		var collection :NodeList = js.Browser.document.getElementsByTagName( element );
		
		for (i in 0...collection.length) {
			var e :HTMLScriptElement = untyped collection.item(i);// Node
			trace(e.src);
			trace(e.getAttribute(attr));
			if (e.getAttribute(attr) != null && 
				e.getAttribute(attr).indexOf(filename) != -1)
				return true;
		}
		return false;
	}
}
extern class HTMLScriptElement extends js.html.HtmlElement {
	public var src :String;
}