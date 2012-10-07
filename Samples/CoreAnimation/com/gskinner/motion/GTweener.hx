/**                                                               *                                                               *
* Initial haXe port by Brett Johnson, http://now.periscopic.com   *
* Project site: code.google.com/p/gtweenhx/                       *
* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . *
*
* GTweener by Grant Skinner. Oct 19, 2009
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
	#end
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	
	/**
	* <b>GTweener ©2009 Grant Skinner, gskinner.com. Visit www.gskinner.com/libraries/gtween/ for documentation, updates and more free code. Licensed under the MIT license - see the source file header for more information.</b>
	* <hr>
	* GTweener is an experimental class that provides a static interface and basic
	* override management for GTween. It adds about 1kb to GTween. With GTweener, if you tween a value that is
	* already being tweened, the new tween will override the old tween for only that
	* value. The old tween will continue tweening other values uninterrupted.
	* <br/><br/>
	* GTweener also serves as an interesting example for utilizing GTween's "*" plugin
	* registration feature, where a plugin can be registered to run for every tween.
	* <br/><br/>
	* GTweener introduces a small amount overhead to GTween, which may have a limited impact
	* on performance critical scenarios with large numbers (thousands) of tweens.
	**/
	class GTweener implements IGTweenPlugin{
		
	// Protected Static Properties:
		/** @private **/
		#if flash
			private static var tweens:Dictionary;
		#else
			private static var tweens:NaiveDictionary;
		#end
		/** @private **/
		private static var instance:GTweener;
		
	// Initialization:
		//staticInit();
		/** @private **/
		/*private static function staticInit():Void {
			tweens = new Dictionary(true);
			instance = new GTweener();
			
			// register to be called any time a tween inits or tweens:
			GTween.installPlugin(instance, ["*"]);
		}*/
		static function __init__() {
			#if flash
			tweens = new Dictionary(true);
			#else
			tweens = new NaiveDictionary();
			#end
			
			instance = new GTweener();
			// register to be called any time a tween inits or tweens:
			GTween.installPlugin(instance, ["*"]);
		}
		
		//Empty Constructor
		function new(){}
		
		/** @private **/
		public function init(tween:GTween, name:String, value:Float):Float {
			// don't do anything.
			return value;
		}
		
		/** @private **/
		public function tween(tween:GTween, name:String, value:Float, initValue:Float, rangeValue:Float, ratio:Float, end:Bool):Float {
			// if the tween has just completed and it is currently being managed by GTweener
			// then remove it:
			if (end && tween.pluginData.GTweener) {
				remove(tween);
			}
			return value;
		}
		
	// Public Static Methods:
		/**
		* Tweens the target to the specified values.
		**/
		public static function to(?target:Dynamic=null, ?duration:Float=1, ?values:Dynamic=null, ?props:Dynamic=null, ?pluginData:Dynamic=null):GTween {
			var tween:GTween = new GTween(target, duration, values, props, pluginData);
			add(tween);
			return tween;
		}
		
		/**
		* Tweens the target from the specified values to its current values.
		**/
		public static function from(?target:Dynamic=null, ?duration:Float=1, ?values:Dynamic=null, ?props:Dynamic=null, ?pluginData:Dynamic=null):GTween {
			var tween:GTween = to(target, duration, values, props, pluginData);
			tween.swapValues();
			return tween;
		}
		
		/**
		* Adds a tween to be managed by GTweener.
		**/
		public static function add(tween:GTween):Void {
			var target:Dynamic = tween.target;
			var list:Array<GTween>;
			
			//get tweens from Object keyed based hash
			#if flash
			 untyped list = tweens[target];
			#else
			 list = tweens.getValue(target);
			#end
			
			if (list!=null) {
				clearValues(target,tween.getValues());
			} else {
				list = new Array<GTween>();

				#if flash
				untyped	tweens[target]=list;
				#else
					tweens.setValue(target,list);
				#end
			}
			list[list.length]=tween;
			tween.pluginData.GTweener = true;
		}
		
		/**
		* Gets the tween that is actively tweening the specified property of the target, or null
		* if none.
		**/
		public static function getTween(target:Dynamic, name:String):GTween {
			var list:Array<GTween>;
			#if flash
			untyped list = tweens[target];
			#else
			list = tweens.getValue(target);
			#end
			
			if (list == null) { return null; }
			
			for(tween in list.iterator()){
				if(!Math.isNaN(tween.getValue(name))){ return tween;}
			}
			return null;
		}
		
		/**
		* Returns an array of all tweens that GTweener is managing for the specified target.
		**/
		public static function getTweens(target:Dynamic):Array<GTween> {
			var list:Array<GTween>;
			#if flash
			untyped	list = tweens[target];
			#else
				list = tweens.getValue(target);
			#end
			return list!=null?list:new Array<GTween>();
		}
		
		/**
		* Pauses all tweens that GTweener is managing for the specified target.
		**/
		public static function pauseTweens(target:Dynamic,?paused:Bool=true):Void {
			var list:Array<GTween>;
			#if flash
			untyped list = tweens[target];
			#else
			list = tweens.getValue(target);
			#end
			if (list == null) { return; }
			for(tween in list.iterator()){
				tween.paused = paused;
			}
		}
		
		/**
		* Resumes all tweens that GTweener is managing for the specified target.
		**/
		public static function resumeTweens(target:Dynamic):Void {
			pauseTweens(target,false);
		}
		
		/**
		* Removes a tween from being managed by GTweener.
		**/
		public static function remove(tween:GTween):Void {
			tween.pluginData.GTweener=null;
			var list:Array<GTween>;
			#if flash
			untyped	list = tweens[tween.target];
			#else
				list = tweens.getValue(tween.target);
			#end
			
			if(list==null){ return; }
			
			for( i in 0...list.length){
				if(list[i] == tween){
					#if !flash	//remove reference to object
						if(list.length==1){tweens.remove(tween.target);}
					#end
					list.splice(i,1);
					return;
				}
			}
		}
		
		/**
		* Removes all tweens that GTweener is managing for the specified target.
		**/
		public static function removeTweens(target:Dynamic):Void {
			pauseTweens(target);
			var list:Array<GTween>;
			#if flash
			untyped	list=tweens[target];
			#else
				list=tweens.getValue(target);
			#end
			if (list == null) { return; }
			for( i in 0...list.length){
				list[i].pluginData.GTweener=null;
				#if !flash
				list[i].pluginData.GTweenerCallback=null;
				#end
			}
			#if flash
			untyped __delete__(tweens,target);	//	delete(tweens[target]);
			#else
			tweens.remove(target);
			#end
		}
		
	// Protected Static Methods:
		/** @private **/
		private static function clearValues(target:Dynamic, values:Dynamic):Void {
			for( n in Reflect.fields(values).iterator()){
				var tween:GTween = getTween(target,n);
				if(tween!=null) { tween.deleteValue(n); }
			}
		}
	}
	
	#if !flash
	/** 
	* Since JS & CPP currently have no Dictionary, use a hash
	* based lookup. Deallocation is handled by the 'remove' 
	* function of GTweener.
	**/
	class NaiveDictionary{
		#if js
		private var _hash:Hash<Dynamic>;
		#elseif cpp
		private var _hash:IntHash<Dynamic>;
		#end
		
		public function new(){
			#if js
			_hash = new Hash<Dynamic>();
			#elseif cpp
			_hash = new IntHash<Dynamic>();
			#end
		}
		
		public function getValue(key:Dynamic):Dynamic{
			#if js
			return _hash.get(key.toString());
			#elseif cpp
			var i:Int = untyped __global__.__hxcpp_obj_id(key);
			return _hash.get(i);
			#end
		}
		
		public function setValue(key:Dynamic,value:Dynamic):Void{
			#if js
			_hash.set(key.toString(),value);
			#elseif cpp
			var i:Int = untyped __global__.__hxcpp_obj_id(key);
			 _hash.set(i,value); 
			#end
		}
		
		public function remove(key:Dynamic):Void{
			#if js
			_hash.remove(key.toString());
			#elseif cpp
			var i:Int = untyped __global__.__hxcpp_obj_id(key);
			_hash.remove(i);
			#end
		}
	}
	#end
	
