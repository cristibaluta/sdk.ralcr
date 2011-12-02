/**
 * HTween
 *  http://hesselboom.com/blog/2009/01/htween-the-light-weight-tween-engine/
 * @author Viktor Hesselbom
 */

import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.Lib;

class HTween 
{
	
	public static var version : Float = 0.2;
	
	public function new (object : Dynamic, finish : Int, properties : Dynamic)
	{
		onComplete = properties.onComplete;
		onCompleteParams = (properties.onCompleteParams != null ? properties.onCompleteParams : []);
		onUpdate = properties.onUpdate;
		onUpdateParams = (properties.onUpdateParams != null ? properties.onUpdateParams : []);
		if (properties.ease != null) _ease = properties.ease; else _ease = easeOut;
		Reflect.deleteField (properties, "onComplete");
		Reflect.deleteField (properties, "onCompleteParams");
		Reflect.deleteField (properties, "onUpdate");
		Reflect.deleteField (properties, "onUpdateParams");
		Reflect.deleteField (properties, "ease");
		
		_object = object;
		_start = Math.round (Lib.getTimer ());
		_finish = finish;
		_properties = properties;
		_initial = {};
		for (prop in Reflect.fields (_properties))
		{
			Reflect.setField (_initial, prop, Reflect.field (_object, prop));
			if (Std.is (Reflect.field (_properties, prop), String))
				Reflect.setField (_properties, prop, Std.parseFloat (Reflect.field (_properties, prop)));
			else
				Reflect.setField (_properties, prop, Reflect.field (_properties, prop) - Reflect.field (_initial, prop));
		}
	}
	
	/**
	 * Add a new tween
	 * @param	object	Object whose properties will be tweened
	 * @param	duration	Duration of tween, in seconds
	 * @param	properties	Properties to be tweened and to what value
	 * @return	Newly created HTween object
	 */
	public static function add (object : Dynamic, duration : Float, properties : Dynamic) : HTween
	{
		if (duration < 0.001) duration = 0.001;
		var _tween : HTween = new HTween (object, Math.floor (duration * 1000), properties);
		var _prev : HTween = _latest;
		
		if (_prev != null) _prev.next = _tween;
		_tween.prev = _prev;
		_latest = _tween;
		
		if (!_initiated)
		{
			_listener = new Shape ();
			_listener.addEventListener ("enterFrame", update);
			_initiated = true;
		}
		
		return _tween;
	}
	
	public static function removeTween (tween : HTween)
	{
		if (tween.prev != null) tween.prev.next = tween.next;
		if (tween.next != null) tween.next.prev = tween.prev;
		if (_latest == tween) _latest = tween.prev;
	}
	
	public static function easeOut (t : Float, b : Float, c : Float, d : Float) : Float
	{
		//return -c * (t /= d) * (t - 2) + b;
		//if ((t/=d/2) < 1) return c/2*t*t*t + b;
		//return c/2*((t-=2)*t*t + 2) + b;
		
		return c*t/d + b;
	}
	
	static function update (e : Event)
	{
		var time : Int = Math.round(Lib.getTimer ());
		var tween : HTween = _latest;
		while (tween != null)
		{
			var time_diff : Int = time - tween._start;
			if (time_diff >= tween._finish)
				time_diff = tween._finish;
			for (prop in Reflect.fields (tween._properties))
				Reflect.setField (tween._object, prop, tween._ease (time_diff, Reflect.field (tween._initial, prop), Reflect.field (tween._properties, prop), tween._finish));
			if (tween.onUpdate != null)
				tween.onUpdate.apply (null, tween.onUpdateParams);
			if (time_diff == tween._finish)
			{
				if (tween.prev != null) tween.prev.next = tween.next;
				if (tween.next != null) tween.next.prev = tween.prev;
				if (_latest == tween)
					if (tween.prev != null) _latest = tween.prev;
					else _latest = null;
				if (tween.onComplete != null)
					tween.onComplete.apply (null, tween.onCompleteParams);
			}
			tween = tween.prev;
		}
	}
	
	var _object : Dynamic;
	var _start : Int;
	var _finish : Int;
	var _properties : Dynamic;
	var _initial : Dynamic;
	var _ease : Dynamic;
	var prev : HTween;
	var next : HTween;
	var onComplete : Dynamic;
	var onCompleteParams : Array<Dynamic>;
	var onUpdate : Dynamic;
	var onUpdateParams : Array<Dynamic>;
	static var _latest : HTween;
	static var _listener : Shape;
	static var _initiated : Bool;
	
}