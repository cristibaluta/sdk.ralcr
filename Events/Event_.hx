
class Event implements IEvent
{
	public var signal:IPrioritySignal<Dynamic>;
	public var target:Dynamic;
	public var currentTarget:Dynamic;
	public var bubbles:Bool;
	
	public function new(?bubbles:Bool=false)
	{
		this.bubbles = bubbles;
	}
	
	public function clone():IEvent
	{
		return new Event(bubbles);
	}
}