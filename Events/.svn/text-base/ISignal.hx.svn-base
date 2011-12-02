package massive.signal;

interface ISignal<T>
{
	var numListeners(get_numListeners, never):Int;
	
	function add(listener:T):T;
	function addOnce(listener:T):T;
	function dispatch(?arg1:Dynamic, ?arg2:Dynamic):Void;
	function remove(listener:T):T;
	function removeAll():Void;
}