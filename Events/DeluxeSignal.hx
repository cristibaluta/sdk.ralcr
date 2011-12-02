package massive.signal;

class DeluxeSignal<T> extends Signal<T>, implements IPrioritySignal<T>
{
	var target(default, set_target):Dynamic;
	
	public function new(?target:Dynamic=null)
	{
		super();
		this.target = target;
	}
	
	function set_target(value:Dynamic):Dynamic
	{
		if (value == target) return target;
		removeAll();
		return target = value;
	}
	
	public function addWithPriority(listener:T, ?priority:Int=0):T
	{
		return listener;
	}
	
	public function addOnceWithPriority(listener:T, ?priority:Int=0):T
	{
		return listener;
	}
}