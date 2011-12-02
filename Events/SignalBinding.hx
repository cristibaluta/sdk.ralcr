package massive.signal;

import massive.exception.Exception;
import massive.exception.ArgumentException;

class SignalBinding implements ISignalBinding
{
	public var listener(default, set_listener):Dynamic;
	public var once(default, null):Bool;
	public var priority(default, null):Int;
	
	var signal:ISignal<Dynamic>;
	var active:Bool;
	
	public function new(listener:Dynamic, ?once:Bool=false, ?signal:ISignal<Dynamic>=null, ?priority:Int=0)
	{
		this.once = once;
		this.signal = signal;
		this.priority = priority;
		this.active = true;
		
		this.listener = listener;
	}
	
	public function pause():Void
	{
		active = false;
	}
	
	public function resume():Void
	{
		active = true;
	}
	
	public function remove():Void
	{
		signal.remove(listener);
	}
	
	public function execute0():Void
	{
		if (active)
		{
			if (once) remove();
			listener();
		}
	}
	
	public function execute1(arg1:Dynamic):Void
	{
		if (active)
		{
			if (once) remove();
			listener(arg1);
		}
	}
	
	public function execute2(arg1:Dynamic, arg2:Dynamic):Void
	{
		if (active)
		{
			if (once) remove();
			listener(arg1, arg2);
		}
	}
	
	function set_listener(value:Dynamic):Dynamic
	{
		verifyListener(value);
		listener = value;
	}
	
	function verifyListener(listener:Dynamic):Void
	{
		if (listener == null)
		{
			throw new ArgumentException("Listener is null.");
		}
		
		if (signal == null)
		{
			throw new Exception("Internal signal reference has not been set yet.");
		}
	}
}