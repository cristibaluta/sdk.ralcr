package  {
	import flash.Lib;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.Boot;
	public class HTween {
		public function HTween(object : * = null,finish : int = 0,properties : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.onComplete = properties.onComplete;
			this.onCompleteParams = ((properties.onCompleteParams != null)?properties.onCompleteParams:[]);
			this.onUpdate = properties.onUpdate;
			this.onUpdateParams = ((properties.onUpdateParams != null)?properties.onUpdateParams:[]);
			if(properties.ease != null) this._ease = properties.ease;
			else this._ease = HTween.easeOut;
			Reflect.deleteField(properties,"onComplete");
			Reflect.deleteField(properties,"onCompleteParams");
			Reflect.deleteField(properties,"onUpdate");
			Reflect.deleteField(properties,"onUpdateParams");
			Reflect.deleteField(properties,"ease");
			this._object = object;
			this._start = Math.round(flash.Lib._getTimer());
			this._finish = finish;
			this._properties = properties;
			this._initial = { }
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this._properties);
				while(_g < _g1.length) {
					var prop : String = _g1[_g];
					++_g;
					Reflect.setField(this._initial,prop,Reflect.field(this._object,prop));
					if(Std._is(Reflect.field(this._properties,prop),String)) Reflect.setField(this._properties,prop,Std._parseFloat(Reflect.field(this._properties,prop)));
					else Reflect.setField(this._properties,prop,Reflect.field(this._properties,prop) - Reflect.field(this._initial,prop));
				}
			}
		}}
		
		protected var _object : *;
		protected var _start : int;
		protected var _finish : int;
		protected var _properties : *;
		protected var _initial : *;
		protected var _ease : *;
		protected var prev : HTween;
		protected var next : HTween;
		protected var onComplete : *;
		protected var onCompleteParams : Array;
		protected var onUpdate : *;
		protected var onUpdateParams : Array;
		static public var version : Number = 0.2;
		static public function add(object : *,duration : Number,properties : *) : HTween {
			if(duration < 0.001) duration = 0.001;
			var _tween : HTween = new HTween(object,Math.floor(duration * 1000),properties);
			var _prev : HTween = _latest;
			if(_prev != null) _prev.next = _tween;
			_tween.prev = _prev;
			HTween._latest = _tween;
			if(!_initiated) {
				HTween._listener = new flash.display.Shape();
				_listener.addEventListener("enterFrame",HTween.update);
				HTween._initiated = true;
			}
			return _tween;
		}
		
		static public function removeTween(tween : HTween) : void {
			if(tween.prev != null) tween.prev.next = tween.next;
			if(tween.next != null) tween.next.prev = tween.prev;
			if(HTween._latest == tween) HTween._latest = tween.prev;
		}
		
		static public function easeOut(t : Number,b : Number,c : Number,d : Number) : Number {
			return c * t / d + b;
		}
		
		static protected function update(e : flash.events.Event) : void {
			var time : int = Math.round(flash.Lib._getTimer());
			var tween : HTween = _latest;
			while(tween != null) {
				var time_diff : int = time - tween._start;
				if(time_diff >= tween._finish) time_diff = tween._finish;
				{
					var _g : int = 0, _g1 : Array = Reflect.fields(tween._properties);
					while(_g < _g1.length) {
						var prop : String = _g1[_g];
						++_g;
						Reflect.setField(tween._object,prop,tween._ease(time_diff,Reflect.field(tween._initial,prop),Reflect.field(tween._properties,prop),tween._finish));
					}
				}
				if(tween.onUpdate != null) tween.onUpdate.apply(null,tween.onUpdateParams);
				if(time_diff == tween._finish) {
					if(tween.prev != null) tween.prev.next = tween.next;
					if(tween.next != null) tween.next.prev = tween.prev;
					if(HTween._latest == tween) {
						if(tween.prev != null) HTween._latest = tween.prev;
						else HTween._latest = null;
					}
					if(tween.onComplete != null) tween.onComplete.apply(null,tween.onCompleteParams);
				}
				tween = tween.prev;
			}
		}
		
		static protected var _latest : HTween;
		static protected var _listener : flash.display.Shape;
		static protected var _initiated : Boolean;
	}
}
