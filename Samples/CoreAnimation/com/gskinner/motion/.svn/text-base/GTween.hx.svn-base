/**                                                               *                                                               *
* Initial haXe port by Brett Johnson, http://now.periscopic.com   *
* Project site: code.google.com/p/gtweenhx/                       *
* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . *
*
* GTween v1 by Grant Skinner. Aug 15, 2008
* GTween v2 by Grant Skinner. Oct 02, 2009
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
*
* Copyright (c) 2009 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package com.gskinner.motion;
	
	#if flash
	import flash.utils.Dictionary;
	import flash.display.Shape;
	#end
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import Std;
	import Reflect;
	import haxe.Timer;
	
	import com.gskinner.motion.plugins.IGTweenPlugin;
	
	/**
	* <b>GTween Â©2008 Grant Skinner, gskinner.com. Visit www.gskinner.com/libraries/gtween/ for documentation, updates and more free code. Licensed under the MIT license - see the source file header for more information.</b>
	* <hr>
	* GTween is a light-weight instance oriented tween engine. This means that you instantiate tweens for specific purposes, and then reuse, update or discard them.
	* This is different than centralized tween engines where you "register" tweens with a global object. This provides a more familiar and useful interface
	* for object oriented programmers.
	* <br/><br/>
	* In addition to a more traditional setValue/setValues tweening interface, GTween also provides a unique proxy interface to tween and access properties of target objects
	* in a more dynamic fashion. This allows you to work with properties directly, and mostly ignore the details of the tween. The proxy "stands in"
	* for your object when working with tweened properties. For example, you can modify end values (the value you are tweening to), in the middle of a tween.
	* You can also access them dynamically, like so:
	* <br/><br/>
	* <code>mySpriteTween.proxy.rotation += 50;</code>
	* <br/><br/>
	* Assuming no end value has been set for rotation previously, the above example will get the current rotation from the target, add 50 to it, set it as the end
	* value for rotation, and start the tween. If the tween has already started, it will adjust for the new values. This is a hugely powerful feature that
	* requires a bit of exploring to completely understand. See the documentation for the "proxy" property for more information.
	* <br/><br/>
	* For a light-weight engine (~3.5kb), GTween boasts a number of advanced features:<UL>
	* <LI> frame and time based durations/positions which can be set per tween
	* <LI> works with any numeric properties on any object (not just display objects)
	* <LI> simple sequenced tweens using .nextTween
	* <LI> pause and resume individual tweens or all tweens
	* <LI> jump directly to the end or beginning of a tween with .end() or .beginning()
	* <LI> jump to any arbitrary point in the tween with .position
	* <LI> complete, init, and change callbacks
	* <LI> smart garbage collector interactions (prevents collection while active, allows collection if target is collected)
	* <LI> uses any standard ActionScript tween functions
	* <LI> easy to set up in a single line of code
	* <LI> can repeat or reflect a tween a specified number of times
	* <LI> deterministic, so setting a position on a tween will (almost) always result in predictable results
	* <LI> very powerful sequencing capabilities in conjunction with GTweenTimeline.
	* </UL>
	*
	* <hr/>
	* <b>Version 2 Notes (Oct 2, 2009):</b><br/>
	* GTween version 2 constitutes a complete rewrite of the library. This version
	* is 20% smaller than beta 5 (<3.5kb), it performs up to 5x faster, adds timeScale functionality,
	* and supports a simple but robust plug-in model. The logic and source is also much
	* simpler and easy to follow.
	*
	* <hr/>
	* <b>Version 2.01 Notes (Dec 11, 2009):</b><br/>
	* Minor update based on user feedback:<UL>
	* <LI> added GTween.version property. (thanks Colin Moock for the request)
	* <LI> added .dispatchEvents and GTween.defaultDispatchEvents properties, so you can enable AS3 events. (thanks Colin Moock for the request)
	* <LI> fixed a problem with tweens in a timeline initing at the wrong time, and added support for position values less than -delay. (thanks Erik Blankinship for the bug report)
	* <LI> fixed a problem with tween values being set to NaN before the controlling timeline started playing. (thanks to Erik for the bug report)
	* <LI> added support for multiple callbacks at a single position to GTweenTimeline. (thanks to sharvey, edzis for the feature request)
	* <LI> fixed issue with callbacks being called again when a timeline completes. (thanks to edzis for the bug report)
	* </UL>
	**/
	class GTween extends EventDispatcher {
		
	// Constants:
	#if !neko
	inline static var INT_MX:Int=2147483647;
	inline static var INT_MN:Int=-2147483647;
	#else
	inline static var INT_MX:Int=134217727;	//neko only has 31-bit precision Int
	inline static var INT_MN:Int=-134217727;
	#end
		
	// Static interface:
		/**
		* Indicates the version number for this build. The numeric value will always
		* increase with the version number for easy comparison (ex. GTween.version >= 2.12).
		* Currently, it incorporates the major version as the integer value, and the two digit
		* build number as the decimal value. For example, the fourth build of version 3 would
		* have version=3.04.
		**/
		public static var version:Float;// = 2.01;
		
		/**
		* Sets the default value of dispatchEvents for new instances.
		**/
		public static var defaultDispatchEvents:Bool;//=false;
		
		/**
		* Specifies the default easing function to use with new tweens. Set to GTween.linearEase by default.
		**/
		public static var defaultEase:Float->Float->Float->Float->Float;//Function=linearEase;
		
		/**
		* Setting this to true pauses all tween instances. This does not affect individual tweens' .paused property.
		**/
		public static var pauseAll:Bool;//=false;
		
		/**
		* Sets the time scale for all tweens. For example to run all tweens at half speed,
		* you can set timeScaleAll to 0.5. It is multiplied against each tweens timeScale.
		* For example a tween with timeScale=2 will play back at normal speed if timeScaleAll is set to 0.5.
		**/
		public static var timeScaleAll:Float;
		
		/** @private **/
		private static var hasStarPlugins:Bool;
		/** @private **/
		private static var plugins:Hash<Dynamic>;
		/** @private **/
		private static var ticker:IEventDispatcher;//Shape;
		/** @private **/
		private static var time:Float;
		/** @private **/
		private static var tickList:IntHash<GTween>;
		/** @private **/
		//private static var gcLockList:IntHash;//Dictionary;// = new Dictionary(false);
		/** @private **/
		private static var keyMarker:Int;
		
		private static var _sInited:Bool;
		
		
		/**
		* Installs a plugin for the specified property. Plugins with high priority
		* will always be called before other plugins for the same property. This method
		* is primarily used by plugin developers. Plugins are normally installed by calling
		* the install method on them, such as BlurPlugin.install().
		* <br/><br/>
		* Plugins can register to be associated with a specific property name, or to be
		* called for all tweens by registering for the "*" property name. The latter will be called after
		* all properties are inited or tweened for a particular GTween instance.
		*
		* @param plugin The plugin object to register. The plugin should conform to the IGTweenPlugin interface.
		* @param propertyNames An array of property names to operate on (ex. "rotation"), or "*" to register the plugin to be called for every GTween instance.
		* @param highPriority If true, the plugin will be added to the start of the plugin list for the specified property name, if false it will be added to the end.
		**/
		public static function installPlugin(plugin:Dynamic, propertyNames:Array<String>, ?highPriority:Bool=false):Void {
			var a:Array<Dynamic>;

			for (i in 0...propertyNames.length) {
				var propertyName:String = propertyNames[i];
				if (propertyName == "*") { hasStarPlugins = true; }
				if(!plugins.exists(propertyName)){
					 a= [];
					plugins.set(propertyName,a);
				}else{
					a=plugins.get(propertyName);
				}
				if (highPriority) {
					a.unshift(plugin);
				} else {
					a[a.length]=plugin;
				}
			}
		}
		
		/** The default easing function used by GTween. **/
		public static function linearEase(a:Float, b:Float, c:Float, d:Float):Float {
			return a;
		}
		
		/** @private **/
		private static function staticInit():Void {
			
			if(!_sInited){
			#if flash
				(ticker = new Shape()).addEventListener(Event.ENTER_FRAME,staticTick);
				time = Timer.stamp();
				_sInited=true;
			#elseif js
				throw "When using GTween with JS, you must attach an IEventDispatcher via GTween.patchTick()";
			#elseif cpp
				throw "When using GTween with HXCPP, you must attach an IEventDispatcher via GTween.patchTick()";
			#end
			}
		}
		
		
		/** Shapes in Jeash and NME do not dispatch ENTER_FRAME events unless
		attached to the Stage. Calling this function with a shape that is display
		listed with patch in the requisite tick. **/
		public static function patchTick(s:IEventDispatcher):Void{
			#if !flash
			if(!_sInited){
				ticker=s;
				s.addEventListener(Event.ENTER_FRAME,staticTick);
				time = Timer.stamp();
				_sInited=true;
			}
			#end
		}
		
		
		/**Called prior to any other static calls; setup at compile time**/
		static function __init__() {
			//static public default values
			version=0.2;
			defaultEase=linearEase;
			timeScaleAll=1;

			//static private default values
			plugins=new Hash<Dynamic>();
			tickList= new IntHash();
			keyMarker=INT_MN;
		}
		
		/** @private **/
		private static function staticTick(evt:Event):Void {
			var t:Float = time;
			time = Timer.stamp();
			if (pauseAll) { return; }
			var dt:Float = (time-t)*timeScaleAll;
			for(tween in tickList){	
				tween.position = tween._position+(tween.useFrames?timeScaleAll:dt)*tween.timeScale;
			}
		}
		
		private static function uniqueKey():Int{
			while(keyMarker<INT_MX){
				keyMarker++;
				if(!tickList.exists(keyMarker)){
					return keyMarker;
				}
			}
			keyMarker=INT_MN;
			return uniqueKey();
		}
		
	// Public Properties:
		
		/** @private **/
		private var _values:Hash<Float>;
		/** @private **/
		private var _paused:Bool;		
		public var paused (getPaused, setPaused): Bool;
		/** @private **/
		private var _position:Float;
		public var position (getPosition, setPosition): Float;
		/** @private **/
		private var _delay:Float;//=0;
		public var delay (getDelay, setDelay): Float;
		/** @private **/
		private var _inited:Bool;
		/** @private **/
		private var _initValues:Hash<Float>;
		/** @private **/
		private var _rangeValues:Hash<Float>;
		/** @private **/
		#if flash
		//private var _proxy:TargetProxy;
		//public var proxy (getProxy,never): TargetProxy;
		#end
		
		//used for HAXE IntHash
		private var _hashKey:Int;
		
	// Protected Properties:
		/**
		* Indicates whether the tween should automatically play when an end value is changed.
		**/
		public var autoPlay:Bool;
		
		/**
		* Allows you to associate arbitrary data with your tween. For example, you might use this to reference specific data when handling event callbacks from tweens.
		**/
		public var data:Dynamic; 
		
		/**
		* The length of the tween in frames or seconds (depending on the timingMode). Setting this will also update any child transitions that have synchDuration set to true.
		**/
		public var duration:Float;
		
		/**
		* The easing function to use for calculating the tween. This can be any standard tween function, such as the tween functions in fl.motion.easing.* that come with Flash CS3.
		* New tweens will have this set to <code>defaultTween</code>. Setting this to null will cause GTween to throw null reference errors.
		**/
		public var ease:Float->Float->Float->Float->Float;
		
		/**
		* Specifies another GTween instance that will have <code>paused=false</code> set on it when this tween completes.
		* This happens immediately before onComplete is called.
		**/
		public var nextTween:GTween;
		
		/**
		* Stores data for plugins specific to this instance. Some plugins may allow you to set properties on this object that they use.
		* Check the documentation for your plugin to see if any properties are supported.
		* Most plugins also support a property on this object in the form PluginNameEnabled to enable or disable
		* the plugin for this tween (ex. BlurEnabled for BlurPlugin). Many plugins will also store internal data in this object.
		**/
		public var pluginData:Dynamic;
		
		/**
		* Indicates whether the tween should use the reflect mode when repeating. If reflect is set to true, then the tween will play backwards on every other repeat.
		**/
		public var reflect:Bool;
		
		/**
		* The number of times this tween will run. If 1, the tween will only run once. If 2 or more, the tween will repeat that many times. If 0, the tween will repeat forever.
		**/
		public var repeatCount:Int;
		
		/**
		* The target object to tween. This can be any kind of object. You can retarget a tween at any time, but changing the target in mid-tween may result in unusual behaviour.
		**/
		public var target:Dynamic;
		
		/**
		* If true, durations and positions can be set in frames. If false, they are specified in seconds.
		**/
		public var useFrames:Bool;
		
		/**
		* Allows you to scale the passage of time for a tween. For example, a tween with a duration of 5 seconds, and a timeScale of 2 will complete in 2.5 seconds.
		* With a timeScale of 0.5 the same tween would complete in 10 seconds.
		**/
		public var timeScale:Float;
		
		/**
		* The position of the tween at the previous change. This should not be set directly.
		**/
		public var positionOld:Float;
		
		/**
		* The eased ratio (generally between 0-1) of the tween at the current position. This should not be set directly.
		**/
		public var ratio:Float;
		
		/**
		* The eased ratio (generally between 0-1) of the tween at the previous position. This should not be set directly.
		**/
		public var ratioOld:Float;
		
		/**
		* The current calculated position of the tween. 
		* This is a deterministic value between 0 and duration calculated
		* from the current position based on the duration, repeatCount, and reflect properties.
		* This is always a value between 0 and duration, whereas <code>.position</code> can range
		* between -delay and repeatCount*duration. This should not be set directly.
		**/
		public var calculatedPosition:Float;
		
		/**
		* The previous calculated position of the tween. See <code>.calculatedPosition</code> for more information.
		* This should not be set directly.
		**/
		public var calculatedPositionOld:Float;
		
		/**
		* If true, events/callbacks will not be called. As well as allowing for more
		* control over events, and providing flexibility for extension, this results
		* in a slight performance increase, particularly if useCallbacks is false.
		**/
		public var suppressEvents:Bool;
		
		/**
		* If true, it will dispatch init, change, and complete events in addition to calling the
		* onInit, onChange, and onComplete callbacks. Callbacks provide significantly better
		* performance, whereas events are more standardized and flexible (allowing multiple
		* listeners, for example).
		* <br/><br/>
		* By default this will use the value of defaultDispatchEvents.
		**/
		public var dispatchEvents:Bool;
		
		/**
		* Callback for the complete event. Any function assigned to this callback
		* will be called when the tween finishes with a single parameter containing
		* a reference to the tween.
		* <br/><br/>
		* Ex.<br/>
		* <code><pre>myTween.onComplete = myFunction;
		* function myFunction(tween:GTween):void {
		*	trace("tween completed");
		* }</pre></code>
		**/
		public var onComplete:Dynamic->Dynamic;
		
		/**
		* Callback for the change event. Any function assigned to this callback
		* will be called each frame while the tween is active with a single parameter containing
		* a reference to the tween.
		**/
		public var onChange:Dynamic->Dynamic;
		
		/**
		* Callback for the init event. Any function assigned to this callback
		* will be called when the tween inits with a single parameter containing
		* a reference to the tween. Init is usually triggered when a tween finishes
		* its delay period and becomes active, but it can also be triggered by other
		* features that require the tween to read the initial values, like calling <code>.swapValues()</code>.
		**/
		public var onInit:Dynamic->Dynamic;
		
	// Initialization:
		/**
		* Constructs a new GTween instance.
		*
		* @param target The object whose properties will be tweened. Defaults to null.
		* @param duration The length of the tween in frames or seconds depending on the timingMode. Defaults to 1.
		* @param values An object containing end property values. For example, to tween to x=100, y=100, you could pass {x:100, y:100} as the values object.
		* @param props An object containing properties to set on this tween. For example, you could pass {ease:myEase} to set the ease property of the new instance. It also supports a single special property "swapValues" that will cause <code>.swapValues</code> to be called after the values specified in the values parameter are set.
		* @param pluginData An object containing data for installed plugins to use with this tween. See <code>.pluginData</code> for more information.
		**/
		public function new(?target : Dynamic = null, ?duration : Float = 1, ?values : Dynamic = null, ?props : Dynamic = null, ?pluginData : Dynamic = null) {
			super();
			/////
			//Haxe does not allow variable instantiation prior to constructor
			/////
			_delay=0;
			_paused=true;
			autoPlay=true;
			repeatCount=1;
			timeScale=1;
			//////
			//Get unique IntHash Key
			_hashKey=uniqueKey();
			//////
			if(!_sInited)
				staticInit();
			//////
			ease = defaultEase;
			dispatchEvents = defaultDispatchEvents;
			this.target = target;
			this.duration = duration;
			this.pluginData = copy(pluginData,{});
			var swap:Bool=false;
			if (props) { 
				swap = props.swapValues; 
				Reflect.deleteField(props,"swapValues");
			}
			copy(props,this);
			resetValues(values);
			if (swap) { swapValues(); }
			if (this.duration == 0 && delay == 0 && autoPlay) { position=0; }
			
		}
		
	// Public getter / setters:
		/**
		* Plays or pauses a tween. You can still change the position value externally on a paused
		* tween, but it will not be updated automatically. While paused is false, the tween is also prevented
		* from being garbage collected while it is active.
		* This is achieved in one of two ways:<br/>
		* 1. If the target object is an IEventDispatcher, then the tween will subscribe to a dummy event using a hard reference. This allows
		* the tween to be garbage collected if its target is also collected, and there are no other external references to it.<br/>
		* 2. If the target object is not an IEventDispatcher, then the tween is placed in a global list, to prevent collection until it is paused or completes.<br/>
		* Note that pausing all tweens via the GTween.pauseAll static property will not free the tweens for collection.
		**/

		
		public function getPaused():Bool {
			return _paused;
		}
		public function setPaused(value:Bool):Bool {
			if (value == _paused) { return _paused; }
			_paused = value;
			if (_paused) {
				tickList.remove(_hashKey);
				if (target!=null && Std.is(target,IEventDispatcher))  { target.removeEventListener("_", invalidate); }
			} else {
				if (Math.isNaN(_position) || (repeatCount != 0 && _position >= repeatCount*duration)) {
					// reached the end, reset.
					_inited = false;
					calculatedPosition = calculatedPositionOld = ratio = ratioOld = positionOld = 0;
					_position = -delay;
				}
				tickList.set(_hashKey,this);//tickList[this] = true;
				
				// prevent garbage collection:
				if (target!=null && Std.is(target,IEventDispatcher)) { target.addEventListener("_", invalidate); } 
			}
			return _paused;
		}
		
		/**
		* Gets and sets the position of the tween in frames or seconds (depending on <code>.useFrames</code>). This value will
		* be constrained between -delay and repeatCount*duration. It will be resolved to a <code>calculatedPosition</code> before
		* being applied.
		* <br/><br/>
		* <b>Negative values</b><br/>
		* Values below 0 will always resolve to a calculatedPosition of 0. Negative values can be used to set up a delay on the tween, as the tween will have to count up to 0 before initing.
		* <br/><br/>
		* <b>Positive values</b><br/>
		* Positive values are resolved based on the duration, repeatCount, and reflect properties.
		**/
				
		public function getPosition():Float {
			return _position;
		}
		public function setPosition(value:Float):Float {
			positionOld = _position;
			ratioOld = ratio;
			calculatedPositionOld = calculatedPosition;
			
			var maxPosition:Float = repeatCount*duration;
			var end:Bool = (value >= maxPosition && repeatCount > 0);
			var pluginArr:Array<IGTweenPlugin>;
			var l:Int;
			
			if (end) {
				if (calculatedPositionOld == maxPosition) { return maxPosition; }
				_position = maxPosition;				
				calculatedPosition = (reflect && (repeatCount&1)!=1) ? 0 : duration;
			} else {
				_position = value;
				calculatedPosition = _position<0 ? 0 : _position%duration;
				if (reflect && ((_position/duration)%2)>=1) {
					calculatedPosition = duration-calculatedPosition;
				}
			}
			ratio = (duration == 0 && _position >= 0) ? 1 : ease(calculatedPosition/duration,0,1,1);
			if ((target!=null) && (_position >= 0 || positionOld >= 0) && calculatedPosition != calculatedPositionOld) {
				if (!_inited) { init(); }
				
				for(nm in _values.keys()) {  
					var initVal:Float = _initValues.get(nm);
					var rangeVal:Float = _rangeValues.get(nm);
					var val:Float = initVal+rangeVal*ratio;
					 pluginArr= plugins.get(nm);
					if (pluginArr!=null) {
						l= pluginArr.length;
						for(i in 0...l){
							val = pluginArr[i].tween(this,nm,val,initVal,rangeVal,ratio,end);
						}
						if (!Math.isNaN(val)) {
							Reflect.setField(target,nm,val);
						}
					} else {
						Reflect.setField(target,nm,val);
					}
				}
			}
			
			if (hasStarPlugins) {
				pluginArr = plugins.get("*");
				l = pluginArr.length;
				for(i in 0...l){
					pluginArr[i].tween(this,"*",Math.NaN,Math.NaN,Math.NaN,ratio,end);
				}
			}
			
			if (!suppressEvents) {
				if (dispatchEvents) { dispatchEvt("change"); }
				if (onChange != null) { onChange(this); }
			}
			if (end) {
				paused = true;
				if (nextTween!=null) { nextTween.paused = false; }
				if (!suppressEvents) {
					if (dispatchEvents) { dispatchEvt("complete"); }
					if (onComplete != null) { onComplete(this); }
				}
			}
			return _position;
		}
		
		/**
		* The length of the delay in frames or seconds (depending on <code>.useFrames</code>).
		* The delay occurs before a tween reads initial values or starts playing.
		**/
		public function getDelay():Float {
			return _delay;
		}
		public function setDelay(value:Float):Float {
			if (_position <= 0) {
				_position = -value;
			}
			_delay = value;
			return _delay;
		}
		
		/**
		* The proxy object allows you to work with the properties and methods of the target object directly through GTween.
		* Numeric property assignments will be used by GTween as end values. The proxy will return GTween end values
		* when they are set, or the target's property values if they are not. Delete operations on properties will result in a deleteProperty
		* call. All other property access and method execution through proxy will be passed directly to the target object.
		* <br/><br/>
		* <b>Example 1:</b> Equivalent to calling myGTween.setProperty("scaleY",2.5):<br/>
		* <code>myGTween.proxy.scaleY = 2.5;</code>
		* <br/><br/>
		* <b>Example 2:</b> Gets the current rotation value from the target object (because it hasn't been set yet on the GTween), adds 100 to it, and then
		* calls setProperty on the GTween instance with the appropriate value:<br/>
		* <code>myGTween.proxy.rotation += 100;</code>
		* <br/><br/>
		* <b>Example 3:</b> Sets an end property value (through setProperty) for scaleX, then retrieves it from GTween (because it will always return
		* end values when available):<br/>
		* <code>trace(myGTween.proxy.scaleX); // 1 (value from target, because no end value is set)<br/>
		* myGTween.proxy.scaleX = 2; // set a end value<br/>
		* trace(myGTween.proxy.scaleX); // 2 (end value from GTween)<br/>
		* trace(myGTween.target.scaleX); // 1 (current value from target)</code>
		* <br/><br/>
		* <b>Example 4:</b> Property deletions only affect end properties on GTween, not the target object:<br/>
		* <code>myGTween.proxy.rotation = 50; // set an end value<br/>
		* trace(myGTween.proxy.rotation); // 50 (end value from GTween)<br/>
		* delete(myGTween.proxy.rotation); // delete the end value<br/>
		* trace(myGTween.proxy.rotation); // 0 (current value from target)</code>
		* <br/><br/>
		* <b>Example 5:</b> Non-numeric property access is passed through to the target:<br/>
		* <code>myGTween.proxy.blendMode = "multiply"; // passes value assignment through to the target<br/>
		* trace(myGTween.target.blendMode); // "multiply" (value from target)<br/>
		* trace(myGTween.proxy.blendMode); // "multiply" (value passed through proxy from target)</code>
		* <br/><br/>
		* <b>Example 6:</b> Method calls are passed through to target:<br/>
		* <code>myGTween.proxy.gotoAndStop(30); // gotoAndStop(30) will be called on the target</code>
		**/
		#if flash
		/*public function getProxy():TargetProxy {
			if (_proxy == null) { _proxy = new TargetProxy(this); }
			return _proxy;
		}*/
		#end
		
	// Public Methods:
		/**
		* Sets the numeric end value for a property on the target object that you would like to tween.
		* For example, if you wanted to tween to a new x position, you could use: myGTween.setValue("x",400).
		*
		* @param name The name of the property to tween.
		* @param value The numeric end value (the value to tween to).
		**/
		public function setValue(name:String, value:Float):Void {
			_values.set(name,value);
			invalidate();
		}
		
		/**
		* Returns the end value for the specified property if one exists.
		*
		* @param name The name of the property to return a end value for.
		**/
		public function getValue(name:String):Float {
			return _values.get(name);
		}
		
		/**
		* Removes a end value from the tween. This prevents the GTween instance from tweening the property.
		*
		* @param name The name of the end property to delete.
		**/
		public function deleteValue(name:String):Bool {
			_rangeValues.remove(name);
			_initValues.remove(name);
			return _rangeValues.remove(name);
		}
		
		/**
		* Shorthand method for making multiple setProperty calls quickly.
		* This adds the specified properties to the values list. Passing a
		* property with a value of null will delete that value from the list.
		* <br/><br/>
		* <b>Example:</b> set x and y end values, delete rotation:<br/>
		* <code>myGTween.setProperties({x:200, y:400, rotation:null});</code>
		*
		* @param properties An object containing end property values.
		**/
		public function setValues(values:Dynamic):Void {
			copyToHash(values,_values,true);
			invalidate();
		}
		
		/**
		* Similar to <code>.setValues()</code>, but clears all previous end values
		* before setting the new ones.
		*
		* @param properties An object containing end property values.
		**/
		public function resetValues(values:Dynamic=null):Void {
			_values = new Hash<Float>();
			setValues(values);
		}
		
		/**
		* Returns the hash table of all end properties and their values. This is a copy of the internal hash of values, so modifying
		* the returned object will not affect the tween.
		**/
		public function getValues():Dynamic {
			return copyFromHash(_values, {});
		}
		
		/**
		* Returns the initial value for the specified property.
		* Note that the value will not be available until the tween inits.
		**/
		public function getInitValue(name:String):Float {
			return _initValues.get(name);
		}
		
		/**
		* Swaps the init and end values for the tween, effectively reversing it.
		* This should generally only be called before the tween starts playing.
		* This will force the tween to init if it hasn't already done so, which
		* may result in an onInit call.
		* It will also force a render (so the target immediately jumps to the new values
		* immediately) which will result in the onChange callback being called.
		* <br/><br/>
		* You can also use the special "swapValues" property on the props parameter of
		* the GTween constructor to call swapValues() after the values are set.
		* <br/><br/>
		* The following example would tween the target from 100,100 to its current position:<br/>
		* <code>new GTween(ball, 2, {x:100, y:100}, {swapValues:true});</code>
		**/
		public function swapValues():Void {
			if (!_inited) { init(); }
			var o:Dynamic = _values;
			_values = _initValues;
			_initValues = o;
			for(n in _rangeValues.keys()){ // n is a String
			 _rangeValues.set(n,_rangeValues.get(n)*-1);
			 }
			if (_position < 0) {
				// render it at position 0:
				var pos:Float = positionOld;
				position = 0;
				_position = positionOld;
				positionOld = pos;
			} else {
				position = _position;
			}
		}
		
		/**
		* Reads all of the initial values from target and calls the onInit callback.
		* This is called automatically when a tween becomes active (finishes delaying)
		* and when <code>.swapValues()</code> is called. It would rarely be used directly
		* but is exposed for possible use by plugin developers or power users.
		**/
		public function init():Void {
			_inited = true;
			_initValues = new Hash<Float>();
			_rangeValues = new Hash<Float>();
			var pluginArr:Array<IGTweenPlugin>;
			for (n in _values.keys()) {
				if(plugins.exists(n)){
					pluginArr = plugins.get(n);
					var value:Float;
					#if flash
						value = Reflect.hasField(target,n)?Reflect.field(target,n):Math.NaN; //this works with BlurPlugin in Flash
					#else
						value = Reflect.field(target,n); //this works with AutoHidePlugin in CPP
					#end
					for(i in 0...pluginArr.length){
						value=pluginArr[i].init(this,n,value);
					}
					if (!Math.isNaN(value)) {
						_initValues.set(n,value);
						_rangeValues.set(n,_values.get(n)-_initValues.get(n));
					}
				} else {
					_initValues.set(n,Reflect.field(target,n));
					_rangeValues.set(n,_values.get(n)-_initValues.get(n));
				}
			}
			
			if (hasStarPlugins) {
				pluginArr = plugins.get("*");
				for(i in 0...pluginArr.length){
					pluginArr[i].init(this,"*",Math.NaN);
				}
			}
			
			if (!suppressEvents) {
				if (dispatchEvents) { dispatchEvt("init"); }
				if (onInit != null) { onInit(this); }
			}
		}
		
		/**
		* Jumps the tween to its beginning and pauses it. This is the same as setting <code>position=0</code> and <code>paused=true</code>.
		**/
		public function beginning():Void {
			position = 0;
			paused = true;
		}
		
		/**
		* Jumps the tween to its end and pauses it. This is roughly the same as setting <code>position=repeatCount*duration</code>.
		**/
		public function end():Void {
			position = (repeatCount > 0) ? repeatCount*duration : duration;
		}
		
	// Protected Methods:
		/** @private **/
		private function invalidate():Void {
			_inited = false;
			if (_position > 0) { _position = 0; }
			if (autoPlay) { paused = false; }
		}
	
		/** @private **/
		private function copyToHash(o1:Dynamic,o2:Hash<Dynamic>,smart:Bool=false):Hash<Dynamic> {
			var props:Array<String>=Reflect.fields(o1);
			for(n in props.iterator()){
				if (smart && Reflect.field(o1, n)==null){
					o2.remove(n);
				} else {
					o2.set(n,Reflect.field(o1,n));
				}
			}
			return o2;
		}
		private function copyFromHash(o1:Hash<Dynamic>,o2:Dynamic,smart:Bool=false):Dynamic {
			
			for(n in o1.keys()){	
				if (smart && o1.get(n)==null){
					o2.remove(n);
				} else {
					Reflect.setField(o2,n,o1.get(n));
				}
			}
			return o2;
		}
		private function copy(o1:Dynamic,o2:Dynamic,smart:Bool=false):Dynamic {
			var props:Array<String>=Reflect.fields(o1);
			
			for(n in props.iterator()){	
				if (smart && Reflect.field(o1, n)==null){
					Reflect.deleteField(o2,n);
				} else {
					Reflect.setField(o2,n,Reflect.field(o1,n));
				}
			}
			return o2;
		}
		
		/** @private **/
		private function dispatchEvt(name:String):Void {
			if (hasEventListener(name)) { dispatchEvent(new Event(name)); }
		}
	}

#if flash

/**
* Still working on proxy feature. This will be Flash only.
*/

/*
//http://www.adobe.com/2006/actionscript/flash/proxy

//import flash.utils.Proxy;
//import flash.utils.Namespace;
//import flash.utils.flash_proxy;
class TargetProxy extends Proxy {
	
	//namespace flash_proxy;
	
	private var tween:GTween;
	
	public function TargetProxy(tween:GTween):Void {
		this.tween = tween;
	}
	
// proxy methods:
	flash_proxy override function callProperty(methodName:*, ...args:Array):Dynamic {
		return tween.target[methodName].apply(null,args);
	}
	
	flash_proxy override function getProperty(prop:*):* {
		var value:Float = tween.getValue(prop);
		return (isNaN(value)) ? tween.target[prop] : value;
	}
	
	flash_proxy override function setProperty(prop:*,value:*):Void {
		if (value is Bool || value is String || isNaN(value)) { tween.target[prop] = value; }
		else { tween.setValue(String(prop), Float(value)); }
	}
	
	flash_proxy override function deleteProperty(prop:*):Bool {
		tween.deleteValue(prop);
		return true;
	}
}
*/
#end
