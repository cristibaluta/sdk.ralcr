/**                                                               *                                                               *
* Initial haXe port by Brett Johnson, http://now.periscopic.com   *
* Project site: code.google.com/p/gtweenhx/                       *
* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . *
*
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

package com.gskinner.motion.plugins;
	
	import com.gskinner.motion.GTween;
	
	/**
	* Defines the interface for GTween plugins. GTween does not use this interface
	* internally (for better portability of the class), but it is recommended that
	* plugin developers implement this interface in their plugins so that if changes
	* are made to the interface, compile time errors will be generated for plugins
	* that have not been updated.
	* <br/><br/>
	* Generally, plugins should also expose a static <code>.install()</code> method
	* which registers an instance of the plugin using <code>GTween.registerPlugin()</code>.
	* The easiest way to learn how to develop plugins is to look at the sample plugins.
	* SnappingPlugin and AutoHidePlugin provide simple examples, whereas ColorAdjustPlugin
	* provides a more advanced example.
	**/
	interface IGTweenPlugin {
		/**
		* This method will be called from the GTween init method when it is determining
		* the initial values for a property. A plugin's init method should return the
		* initial value of the specified property (often by just returning the value
		* parameter without modifying it)
		* or NaN to indicate that an initial value should not be set.
		*
		* @param tween The tween this plugin is being applied to.
		* @param name The name of the property being tweened.
		* @param value The current init value that will be applied to the specified property.
		**/
		function init(tween:GTween, name:String, value:Float):Float;
		
		/**
		* This method will be called from a GTween instance when it is rendering a new
		* position value, and is tweening a property that this plugin is registered for.
		* The plugin can affect the target directly, or it can modify and return the value
		* parameter which will then be set on the target.<br/><br/>
		* GTween will call the tween method of each plugin registered for the property,
		* passing in the current calculated value for the property in the tween. Each plugin
		* has the opportunity to return a modified value property, which will then be passed
		* to subsequent plugins and ultimately set on the target, or it can return NaN to
		* indicate that the value should not be set on the target by GTween (ex. because it
		* has already been handled fully by the plugin).<br/><br/>
		* For example, a value snapping plugin could simply round the value parameter and
		* return it, whereas a blur plugin could work on the target's filters directly
		* and return NaN to prevent GTween from attempting to set a nonexistent blur
		* property on the target.
		*
		* @param tween The tween this plugin is being applied to.
		* @param name The name of the property being tweened.
		* @param value The current value that will be applied to the specified property of the target. This is normally equal to <code>initValue+rangeValue*ratio</code>, unless it has been modified by a prior plugin.
		* @param initValue The init value for the specified property.
		* @param rangeValue The range between the initValue and end value for the property.
		* @param ratio The current eased ratio of the tween. This is usually between 0-1.
		* @param end This will be true if the tween is at its end (ie. will call the complete event handler at the end of this tick).
		**/
		function tween(tween:GTween, name:String, value:Float, initValue:Float, rangeValue:Float, ratio:Float, end:Bool):Float;
	}