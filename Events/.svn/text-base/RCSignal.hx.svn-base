
class Signal<T> implements ISignal<T>
{
	static var NIL = massive.signal.SignalBindingList.NIL;
	
	var bindings:SignalBindingList;
	var existing:ListenerSet;
	
	public function new()
	{
		bindings = NIL;
		existing = null;
	}
	
	public var numListeners(get_numListeners, null):Int;
	function get_numListeners():Int { return bindings.length; }
	
	public function add(listener:T):T
	{
		registerListener(listener);
		return listener;
	}
	
	public function addOnce(listener:T):T
	{
		registerListener(listener, true);
		return listener;
	}
	
	public function remove(listener:T):T
	{
		bindings = bindings.filterNot(listener);
		
		if (bindings.isEmpty) existing = null;
		else existing.remove(listener);
		
		return listener;
	}
	
	public function removeAll():Void
	{
		bindings = SignalBindingList.NIL;
		existing = null;
	}
	
	public function dispatch(?arg1:Dynamic, ?arg2:Dynamic):Void
	{
		var numArgs = 0;
		if (arg2 != null) numArgs = 2;
		else if (arg1 != null) numArgs = 1;
		
		var bindingsToProcess = bindings;

		if (bindingsToProcess.notEmpty)
		{
			if (numArgs == 0)
			{
				while (bindingsToProcess.notEmpty)
				{
					bindingsToProcess.head.execute0();
					bindingsToProcess = bindingsToProcess.tail;
				}
			}
			else if (numArgs == 1)
			{
				while (bindingsToProcess.notEmpty)
				{
					bindingsToProcess.head.execute1(arg1);
					bindingsToProcess = bindingsToProcess.tail;
				}
			}
			else if (numArgs == 2)
			{
				while (bindingsToProcess.notEmpty)
				{
					bindingsToProcess.head.execute2(arg1, arg2);
					bindingsToProcess = bindingsToProcess.tail;
				}
			}
		}
	}
	
	function registerListener(listener:T, once:Bool=false):Void
	{
		if (bindings.isEmpty || verifyRegistrationOf(listener, once))
		{
			bindings = new SignalBindingList(new SignalBinding(listener, once, this), bindings);
			
			if (existing == null) existing = new ListenerSet();
			existing.add(listener);
		}
	}
	
	function verifyRegistrationOf(listener:T,  once:Bool):Bool
	{
		if (existing == null || !existing.has(listener)) return true;
		
		var existingBinding:ISignalBinding = bindings.find(listener);

		if (existingBinding != null)
		{
			if (existingBinding.once != once)
			{
				// If the listener was previously added, definitely don't add it again.
				// But throw an exception if their once value differs.
				throw new IllegalOperationException('You cannot addOnce() then add() the same listener without removing the relationship first.');
			}
			
			// Listener was already added.
			return false;
		}
		
		// This listener has not been added before.
		return true;
	}
}

class ListenerSet
{
	var listeners:Array<Dynamic>;
	
	public function new()
	{
		listeners = [];
	}
	
	public function has(listener:Dynamic):Bool
	{
		for (i in 0...listeners.length)
		{
			if (Reflect.compareMethods(listeners[i], listener))
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function add(listener:Dynamic):Void
	{
		if (has(listener)) return;
		listeners.push(listener);
	}
	
	public function remove(listener:Dynamic):Void
	{
		for (i in 0...listeners.length)
		{
			if (Reflect.compareMethods(listeners[i], listener))
			{
				listeners.splice(i, 1);
				return;
			}
		}
	}
}