package com.gskinner.motion {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.Shape;
	import flash.events.Event;
	import haxe.Timer;
	import flash.Boot;
	public class GTween extends flash.events.EventDispatcher {
		public function GTween(target : * = null,duration : Number = 1,values : * = null,props : * = null,pluginData : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super();
			this._delay = 0;
			this._paused = true;
			this.autoPlay = true;
			this.repeatCount = 1;
			this.timeScale = 1;
			this._hashKey = uniqueKey();
			if(!_sInited) staticInit();
			this.ease = defaultEase;
			this.dispatchEvents = defaultDispatchEvents;
			this.target = target;
			this.duration = duration;
			this.pluginData = this.copy(pluginData,{ });
			var swap : Boolean = false;
			if(props) {
				swap = props.swapValues;
				Reflect.deleteField(props,"swapValues");
			}
			this.copy(props,this);
			this.resetValues(values);
			if(swap) {
				this.swapValues();
			}
			if(this.duration == 0 && this.getDelay() == 0 && this.autoPlay) {
				this.setPosition(0);
			}
		}}
		
		protected var _values : Hash;
		protected var _paused : Boolean;
		public function get paused() : Boolean { return getPaused(); }
		public function set paused( __v : Boolean ) : void { setPaused(__v); }
		protected var $paused : Boolean;
		protected var _position : Number;
		public function get position() : Number { return getPosition(); }
		public function set position( __v : Number ) : void { setPosition(__v); }
		protected var $position : Number;
		protected var _delay : Number;
		public function get delay() : Number { return getDelay(); }
		public function set delay( __v : Number ) : void { setDelay(__v); }
		protected var $delay : Number;
		protected var _inited : Boolean;
		protected var _initValues : Hash;
		protected var _rangeValues : Hash;
		protected var _hashKey : int;
		public var autoPlay : Boolean;
		public var data : *;
		public var duration : Number;
		public var ease : Function;
		public var nextTween : com.gskinner.motion.GTween;
		public var pluginData : *;
		public var reflect : Boolean;
		public var repeatCount : int;
		public var target : *;
		public var useFrames : Boolean;
		public var timeScale : Number;
		public var positionOld : Number;
		public var ratio : Number;
		public var ratioOld : Number;
		public var calculatedPosition : Number;
		public var calculatedPositionOld : Number;
		public var suppressEvents : Boolean;
		public var dispatchEvents : Boolean;
		public var onComplete : Function;
		public var onChange : Function;
		public var onInit : Function;
		public function getPaused() : Boolean {
			return this._paused;
		}
		
		public function setPaused(value : Boolean) : Boolean {
			if(value == this._paused) {
				return this._paused;
			}
			this._paused = value;
			if(this._paused) {
				tickList.remove(this._hashKey);
				if(this.target != null && Std._is(this.target,flash.events.IEventDispatcher)) {
					this.target.removeEventListener("_",this.invalidate);
				}
			}
			else {
				if(Math["isNaN"](this._position) || this.repeatCount != 0 && this._position >= this.repeatCount * this.duration) {
					this._inited = false;
					this.calculatedPosition = this.calculatedPositionOld = this.ratio = this.ratioOld = this.positionOld = 0;
					this._position = -this.getDelay();
				}
				tickList.set(this._hashKey,this);
				if(this.target != null && Std._is(this.target,flash.events.IEventDispatcher)) {
					this.target.addEventListener("_",this.invalidate);
				}
			}
			return this._paused;
		}
		
		public function getPosition() : Number {
			return this._position;
		}
		
		public function setPosition(value : Number) : Number {
			this.positionOld = this._position;
			this.ratioOld = this.ratio;
			this.calculatedPositionOld = this.calculatedPosition;
			var maxPosition : Number = this.repeatCount * this.duration;
			var end : Boolean = value >= maxPosition && this.repeatCount > 0;
			var pluginArr : Array;
			var l : int;
			if(end) {
				if(this.calculatedPositionOld == maxPosition) {
					return maxPosition;
				}
				this._position = maxPosition;
				this.calculatedPosition = ((this.reflect && (this.repeatCount & 1) != 1)?0:this.duration);
			}
			else {
				this._position = value;
				this.calculatedPosition = ((this._position < 0)?0:this._position % this.duration);
				if(this.reflect && this._position / this.duration % 2 >= 1) {
					this.calculatedPosition = this.duration - this.calculatedPosition;
				}
			}
			this.ratio = ((this.duration == 0 && this._position >= 0)?1:this.ease(this.calculatedPosition / this.duration,0,1,1));
			if(this.target != null && (this._position >= 0 || this.positionOld >= 0) && this.calculatedPosition != this.calculatedPositionOld) {
				if(!this._inited) {
					this.init();
				}
				{ var $it : * = this._values.keys();
				while( $it.hasNext() ) { var nm : String = $it.next();
				{
					var initVal : Number = this._initValues.get(nm);
					var rangeVal : Number = this._rangeValues.get(nm);
					var val : Number = initVal + rangeVal * this.ratio;
					pluginArr = plugins.get(nm);
					if(pluginArr != null) {
						l = pluginArr.length;
						{
							var _g : int = 0;
							while(_g < l) {
								var i : int = _g++;
								val = pluginArr[i].tween(this,nm,val,initVal,rangeVal,this.ratio,end);
							}
						}
						if(!Math["isNaN"](val)) {
							Reflect.setField(this.target,nm,val);
						}
					}
					else {
						Reflect.setField(this.target,nm,val);
					}
				}
				}}
			}
			if(hasStarPlugins) {
				pluginArr = plugins.get("*");
				l = pluginArr.length;
				{
					var _g2 : int = 0;
					while(_g2 < l) {
						var i2 : int = _g2++;
						pluginArr[i2].tween(this,"*",Math["NaN"],Math["NaN"],Math["NaN"],this.ratio,end);
					}
				}
			}
			if(!this.suppressEvents) {
				if(this.dispatchEvents) {
					this.dispatchEvt("change");
				}
				if(this.onChange != null) {
					this.onChange(this);
				}
			}
			if(end) {
				this.setPaused(true);
				if(this.nextTween != null) {
					this.nextTween.setPaused(false);
				}
				if(!this.suppressEvents) {
					if(this.dispatchEvents) {
						this.dispatchEvt("complete");
					}
					if(this.onComplete != null) {
						this.onComplete(this);
					}
				}
			}
			return this._position;
		}
		
		public function getDelay() : Number {
			return this._delay;
		}
		
		public function setDelay(value : Number) : Number {
			if(this._position <= 0) {
				this._position = -value;
			}
			this._delay = value;
			return this._delay;
		}
		
		public function setValue(name : String,value : Number) : void {
			this._values.set(name,value);
			this.invalidate();
		}
		
		public function getValue(name : String) : Number {
			return this._values.get(name);
		}
		
		public function deleteValue(name : String) : Boolean {
			this._rangeValues.remove(name);
			this._initValues.remove(name);
			return this._rangeValues.remove(name);
		}
		
		public function setValues(values : *) : void {
			this.copyToHash(values,this._values,true);
			this.invalidate();
		}
		
		public function resetValues(values : * = null) : void {
			this._values = new Hash();
			this.setValues(values);
		}
		
		public function getValues() : * {
			return this.copyFromHash(this._values,{ });
		}
		
		public function getInitValue(name : String) : Number {
			return this._initValues.get(name);
		}
		
		public function swapValues() : void {
			if(!this._inited) {
				this.init();
			}
			var o : * = this._values;
			this._values = this._initValues;
			this._initValues = o;
			{ var $it : * = this._rangeValues.keys();
			while( $it.hasNext() ) { var n : String = $it.next();
			{
				this._rangeValues.set(n,this._rangeValues.get(n) * -1);
			}
			}}
			if(this._position < 0) {
				var pos : Number = this.positionOld;
				this.setPosition(0);
				this._position = this.positionOld;
				this.positionOld = pos;
			}
			else {
				this.setPosition(this._position);
			}
		}
		
		public function init() : void {
			this._inited = true;
			this._initValues = new Hash();
			this._rangeValues = new Hash();
			var pluginArr : Array;
			{ var $it : * = this._values.keys();
			while( $it.hasNext() ) { var n : String = $it.next();
			{
				if(plugins.exists(n)) {
					pluginArr = plugins.get(n);
					var value : Number;
					value = ((Reflect.hasField(this.target,n))?Reflect.field(this.target,n):Math["NaN"]);
					{
						var _g1 : int = 0, _g : int = pluginArr.length;
						while(_g1 < _g) {
							var i : int = _g1++;
							value = pluginArr[i].init(this,n,value);
						}
					}
					if(!Math["isNaN"](value)) {
						this._initValues.set(n,value);
						this._rangeValues.set(n,this._values.get(n) - this._initValues.get(n));
					}
				}
				else {
					this._initValues.set(n,Reflect.field(this.target,n));
					this._rangeValues.set(n,this._values.get(n) - this._initValues.get(n));
				}
			}
			}}
			if(hasStarPlugins) {
				pluginArr = plugins.get("*");
				{
					var _g12 : int = 0, _g2 : int = pluginArr.length;
					while(_g12 < _g2) {
						var i2 : int = _g12++;
						pluginArr[i2].init(this,"*",Math["NaN"]);
					}
				}
			}
			if(!this.suppressEvents) {
				if(this.dispatchEvents) {
					this.dispatchEvt("init");
				}
				if(this.onInit != null) {
					this.onInit(this);
				}
			}
		}
		
		public function beginning() : void {
			this.setPosition(0);
			this.setPaused(true);
		}
		
		public function end() : void {
			this.setPosition(((this.repeatCount > 0)?this.repeatCount * this.duration:this.duration));
		}
		
		protected function invalidate() : void {
			this._inited = false;
			if(this._position > 0) {
				this._position = 0;
			}
			if(this.autoPlay) {
				this.setPaused(false);
			}
		}
		
		protected function copyToHash(o1 : *,o2 : Hash,smart : Boolean = false) : Hash {
			var props : Array = Reflect.fields(o1);
			{ var $it : * = props.iterator();
			while( $it.hasNext() ) { var n : String = $it.next();
			{
				if(smart && Reflect.field(o1,n) == null) {
					o2.remove(n);
				}
				else {
					o2.set(n,Reflect.field(o1,n));
				}
			}
			}}
			return o2;
		}
		
		protected function copyFromHash(o1 : Hash,o2 : *,smart : Boolean = false) : * {
			{ var $it : * = o1.keys();
			while( $it.hasNext() ) { var n : String = $it.next();
			{
				if(smart && o1.get(n) == null) {
					o2.remove(n);
				}
				else {
					Reflect.setField(o2,n,o1.get(n));
				}
			}
			}}
			return o2;
		}
		
		protected function copy(o1 : *,o2 : *,smart : Boolean = false) : * {
			var props : Array = Reflect.fields(o1);
			{ var $it : * = props.iterator();
			while( $it.hasNext() ) { var n : String = $it.next();
			{
				if(smart && Reflect.field(o1,n) == null) {
					Reflect.deleteField(o2,n);
				}
				else {
					Reflect.setField(o2,n,Reflect.field(o1,n));
				}
			}
			}}
			return o2;
		}
		
		protected function dispatchEvt(name : String) : void {
			if(this.hasEventListener(name)) {
				this.dispatchEvent(new flash.events.Event(name));
			}
		}
		
		static protected var INT_MX : int = 2147483647;
		static protected var INT_MN : int = -2147483647;
		static public var version : Number;
		static public var defaultDispatchEvents : Boolean;
		static public var defaultEase : Function;
		static public var pauseAll : Boolean;
		static public var timeScaleAll : Number;
		static protected var hasStarPlugins : Boolean;
		static protected var plugins : Hash;
		static protected var ticker : flash.events.IEventDispatcher;
		static protected var time : Number;
		static protected var tickList : IntHash;
		static protected var keyMarker : int;
		static protected var _sInited : Boolean;
		static public function installPlugin(plugin : *,propertyNames : Array,highPriority : Boolean = false) : void {
			var a : Array;
			{
				var _g1 : int = 0, _g : int = propertyNames.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var propertyName : String = propertyNames[i];
					if(propertyName == "*") {
						com.gskinner.motion.GTween.hasStarPlugins = true;
					}
					if(!plugins.exists(propertyName)) {
						a = [];
						plugins.set(propertyName,a);
					}
					else {
						a = plugins.get(propertyName);
					}
					if(highPriority) {
						a.unshift(plugin);
					}
					else {
						a[a.length] = plugin;
					}
				}
			}
		}
		
		static public function linearEase(a : Number,b : Number,c : Number,d : Number) : Number {
			return a;
		}
		
		static protected function staticInit() : void {
			if(!_sInited) {
				(com.gskinner.motion.GTween.ticker = new flash.display.Shape()).addEventListener(flash.events.Event.ENTER_FRAME,com.gskinner.motion.GTween.staticTick);
				com.gskinner.motion.GTween.time = haxe.Timer.stamp();
				com.gskinner.motion.GTween._sInited = true;
			}
		}
		
		static public function patchTick(s : flash.events.IEventDispatcher) : void {
			null;
		}
		
		static protected function staticTick(evt : flash.events.Event) : void {
			var t : Number = time;
			com.gskinner.motion.GTween.time = haxe.Timer.stamp();
			if(pauseAll) {
				return;
			}
			var dt : Number = (com.gskinner.motion.GTween.time - t) * timeScaleAll;
			{ var $it : * = tickList.iterator();
			while( $it.hasNext() ) { var tween : com.gskinner.motion.GTween = $it.next();
			{
				tween.setPosition(tween._position + (((tween.useFrames)?timeScaleAll:dt)) * tween.timeScale);
			}
			}}
		}
		
		static protected function uniqueKey() : int {
			while(com.gskinner.motion.GTween.keyMarker < 2147483647) {
				keyMarker++;
				if(!tickList.exists(keyMarker)) {
					return keyMarker;
				}
			}
			com.gskinner.motion.GTween.keyMarker = -2147483647;
			return uniqueKey();
		}
		
	}
}
