package massive.signal;

interface ISignalBinding
{
	var listener(default, set_listener):Dynamic;
	var once(default, null):Bool;
	var priority(default, null):Int;
	
	function pause():Void;
	function resume():Void;
	function remove():Void;
	
	function execute0():Void;
	function execute1(arg1:Dynamic):Void;
	function execute2(arg1:Dynamic, arg2:Dynamic):Void;
}