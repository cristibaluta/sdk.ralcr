import haxe.remoting.HttpAsyncConnection;


class RCRemoteDebugger {
	
	var connection :HttpAsyncConnection;
	
	
	public function new (url:String) {
		connection = HttpAsyncConnection.urlConnect ( url );
		connection.call (["blah blah", "blah blah blah"]);
	}
}
