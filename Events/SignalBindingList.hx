package massive.signal;

import massive.exception.Exception;
import massive.exception.ArgumentException;

class SignalBindingList
{
	public static var NIL = new SignalBindingList(null, null);
	
	public var head(default, null):ISignalBinding;
	public var tail(default, null):SignalBindingList;
	public var notEmpty(default, null):Bool;
	public var isEmpty(default, null):Bool;
	public var length(get_length, null):Int;
	
	public function new(head:ISignalBinding, tail:SignalBindingList)
	{
		if (head == null && tail == null)
		{
			if (NIL != null)
			{
				throw new ArgumentException("Parameters head and tail are null. Use the NIL element instead.");
			}
			
			isEmpty = true;
			notEmpty = false;
		}
		else
		{
			if (tail == null)
			{
				throw new ArgumentException("Tail must not be null.");
			}
			
			this.head = head;
			this.tail = tail;
			
			isEmpty = false;
			notEmpty = true;
		}
	}
	
	function get_length():Int
	{
		if (isEmpty)
		{
			return 0;
		}
		
		var result = 0;
		var p = this;
		
		while (p.notEmpty)
		{
			++result;
			p = p.tail;
		}
		
		return result;
	}

	public function prepend(value:SignalBinding):SignalBindingList
	{
		return new SignalBindingList(value, this);
	}

	public function insertWithPriority(value:ISignalBinding):SignalBindingList
	{
		if (isEmpty)
		{
			return new SignalBindingList(value, this);
		}
		
		var priority = value.priority;
		
		if (priority > this.head.priority)
		{
			return new SignalBindingList(value, this);
		}
		
		var p:SignalBindingList = this;
		var q:SignalBindingList = null;
		
		var first:SignalBindingList = null;
		var last:SignalBindingList = null;
		
		while (p.notEmpty)
		{
			if (priority > p.head.priority)
			{
				q = new SignalBindingList(value, p);
				
				if (last != null)
				{
					last.tail = q;
				}
				
				return q;
			}
			else
			{
				q = new SignalBindingList(p.head, NIL);
				
				if (last != null)
				{
					last.tail = q;
				}
				
				if (first == null)
				{
					first = q;
				}
				
				last = q;
			}
			
			p = p.tail;
		}

		if (first == null || last == null)
		{
			throw new Exception("Internal error.");
		}
		
		last.tail = new SignalBindingList(value, NIL);
		
		return first;
	}

	public function filterNot(listener:Dynamic):SignalBindingList
	{
		if (isEmpty)
		{
			return this;
		}
		
		if (Reflect.compareMethods(listener, head.listener))
		{
			return tail;
		}
		
		var p:SignalBindingList = this;
		var q:SignalBindingList = null;
		
		var first:SignalBindingList = null;
		var last:SignalBindingList = null;
		
		while (p.notEmpty)
		{
			if (!Reflect.compareMethods(p.head.listener, listener))
			{
				q = new SignalBindingList(p.head, NIL);
				
				if (last != null)
				{
					last.tail = q;
				}
				
				if (first == null)
				{
					first = q;
				}
				
				last = q;
			}
			else
			{
				last.tail = p.tail;
				return first;
			}
			
			p = p.tail;
		}
		
		return this;
	}

	public function contains(listener:Dynamic):Bool
	{
		if (isEmpty)
		{
			return false;
		}
		
		var p:SignalBindingList = this;
		
		while (p.notEmpty)
		{
			if (Reflect.compareMethods(p.head.listener, listener))
			{
				return true;
			}
			
			p = p.tail;
		}

		return false;
	}

	public function find(listener:Dynamic):ISignalBinding
	{
		if (isEmpty)
		{
			return null;
		}
		
		var p:SignalBindingList = this;
		
		while (p.notEmpty)
		{
			if (Reflect.compareMethods(p.head.listener, listener))
			{
				return p.head;
			}
			
			p = p.tail;
		}
		
		return null;
	}
}