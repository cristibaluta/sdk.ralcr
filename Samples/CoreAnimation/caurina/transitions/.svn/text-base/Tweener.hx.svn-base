/**
 * Tweener
 * Transition controller for movieclips, sounds, textfields and other objects
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * Ported to haXe by Baluta Cristian (www.ralcr.com/caurina/)
 * @version		1.31.74, compatible with haXe 2.0 (AS2, AS3, JS)
 *
/*
Licensed under the MIT License

Copyright (c) 2006-2007 Zeh Fernando, Nate Chatellier and Arthur Debert

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://code.google.com/p/tweener/  - original project page
http://code.google.com/p/tweener/wiki/License
http://ralcr.com/caurina/	- where is the ported version hosted
http://lib.haxe.org/
*/
package caurina.transitions;

#if flash8
import flash.MovieClip;
#elseif flash9
import flash.display.MovieClip;
import flash.events.Event;
#end
//import haxe.FastList;

class Tweener {
	
	static var __tweener_controller__ : MovieClip;	// Used to ensure the stage copy is always accessible (garbage collection)
	static var _engineExists : Bool = false;		// Whether or not the engine is currently running
	static var _inited : Bool = false;				// Whether or not the class has been initiated
	static var _currentTime : Float;				// The current time. This is generic for all tweenings for a "time grid" based update
	static var _currentTimeFrame : Int;				// The current frame. Used on frame-based tweenings

	static var _tweenList : List<TweenListObj>;		// List of active tweens

	static var _timeScale : Float = 1;				// Time scale (default = 1)

	static var _transitionList : Dynamic;			// List of "pre-fetched" transition functions
	static var _specialPropertyList : Dynamic;		// List of special properties
	static var _specialPropertyModifierList : Dynamic;	// List of special property modifiers
	static var _specialPropertySplitterList : Dynamic;	// List of special property splitters
	
	public static var defaultTransition :String = "easeoutcubic";
	
	// Define some shortcuts for the clearance of the code
	static var Flds = Reflect.fields;
	static var Get = Reflect.field;
	static var Set = Reflect.setField;
	
	/**
	 * There's no constructor.
	 */
	public function new () {
		trace ("Tweener is a static class and should not be instantiated.");
	}


	// ==================================================================================================================================
	// TWEENING CONTROL functions -------------------------------------------------------------------------------------------------------

	/**
	 * Adds a new tweening
	 *
	 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
	 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties
															that should be tweened and their values
	 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
	 * @param		.delay				Number				Delay time (defaults 0)
	 * @param		.useFrames			Boolean				Whether to use frames instead of seconds for time control (defaults false)
	 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
	 * @param		.transitionParams	Object				* Direct property, See the TweenListObj class
	 * @param		.onStart			Function			* Direct property, See the TweenListObj class
	 * @param		.onUpdate			Function			* Direct property, See the TweenListObj class
	 * @param		.onComplete			Function			* Direct property, See the TweenListObj class
	 * @param		.onOverwrite		Function			* Direct property, See the TweenListObj class
	 * @param		.onStartParams		Array				* Direct property, See the TweenListObj class
	 * @param		.onUpdateParams		Array				* Direct property, See the TweenListObj class
	 * @param		.onCompleteParams	Array				* Direct property, See the TweenListObj class
	 * @param		.onOverwriteParams	Array				* Direct property, See the TweenListObj class
	 * @param		.rounded			Boolean				* Direct property, See the TweenListObj class
	 * @param		.skipUpdates		Number				* Direct property, See the TweenListObj class
	 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
	 */
	public static function addTween (p_scopes:Dynamic, p_parameters:Dynamic) : Bool {
		if (p_scopes == null) return false;

		var rScopes = new Array<Dynamic>(); // List of objects to tween
		if (Std.is (p_scopes, Array)) {
			// The first argument is an array
			rScopes = p_scopes;
		}
		else {
			// The first argument(s) is(are) object(s)
			rScopes = [p_scopes];
		}

		// make properties chain ("inheritance")
		var p_obj :Dynamic = TweenListObj.makePropertiesChain (p_parameters);
		
		// Creates the main engine if it isn't active
		if (!_inited) init();
		if (!_engineExists || __tweener_controller__ == null) startEngine();
		// << Quick fix for Flash not resetting the vars on double ctrl+enter...
		
		// Creates a "safer", more strict tweening object
		var rTime :Float = Math.isNaN (Get (p_obj, "time")) ? 0 : Get (p_obj, "time"); // Real time
		var rDelay :Float = Math.isNaN (Get (p_obj, "delay")) ? 0 : Get (p_obj, "delay"); // Real delay

		// Creates the property list; everything that isn't a hardcoded variable
		var rProperties :Dynamic = {}; // Object containing a list of PropertyInfoObj instances
		var restrictedWords = { time:true,
								delay:true,
								useFrames:true,
								skipUpdates:true,
								transition:true,
								transitionParams:true,
								onStart:true, onUpdate:true, onComplete:true, onOverwrite:true, onError:true,
								rounded:true,
								onStartParams:true, onUpdateParams:true, onCompleteParams:true, onOverwriteParams:true,
								onStartScope:true, onUpdateScope:true, onCompleteScope:true, onOverwriteScope:true, onErrorScope:true,
								quickAdd:true
							};
		var modifiedProperties = {};
		
		for (istr in Flds (p_obj)) {
			if (!Get (restrictedWords, istr)) {
				// It's an additional pair, so adds
				if (Get (_specialPropertySplitterList, istr) != null) {
					// Special property splitter
					var splitProperties :Array<Dynamic> = Get (_specialPropertySplitterList,
																istr).splitValues (Get (p_obj,
																istr), Get (_specialPropertySplitterList,
																istr).parameters);

					for (prop in splitProperties) {
						if (Get (_specialPropertySplitterList, prop.name) != null) {
							var splitProperties2 :Array<Dynamic> = Get (_specialPropertySplitterList,
																		prop.name).splitValues (prop.value,
																		Get (_specialPropertySplitterList,
																		prop.name).parameters);
							for (prop2 in splitProperties2) {
								Set (rProperties, prop2.name, { valueStart :null,
																valueComplete :prop2.value,
																arrayIndex :prop2.arrayIndex,
																isSpecialProperty :false});
							}
						}
						else {
							Set (rProperties, prop.name, {	valueStart :null,
															valueComplete :prop.value,
															arrayIndex :prop.arrayIndex,
															isSpecialProperty :false});
						}
					}
				}
				else if (Get (_specialPropertyModifierList, istr) != null) {
					// Special property modifier
					var tempModifiedProperties :Array<Dynamic> = Get (_specialPropertyModifierList, istr).modifyValues (Get (p_obj, istr));
					for (prop in tempModifiedProperties) {
						Set (modifiedProperties, prop.name, {	modifierParameters :prop.parameters,
																modifierFunction :Get (_specialPropertyModifierList, istr).getValue});
					}
				}
				else {
					// Regular property or special property, just add the property normally
					Set (rProperties, istr, {	valueStart :null,
												valueComplete :Get (p_obj, istr)});
				}
			}
		}
		
		// Verifies whether the properties exist or not, for warning messages
		for (istr in Flds (rProperties)) {//trace(Get (Get (rProperties, istr), "valueComplete"));

			if (Get (_specialPropertyList, istr) != null) {
				Get (rProperties, istr).isSpecialProperty = true;
			}
			else {
				if (Get (rScopes[0], istr) == null) {
					printError ("The property '" + istr +
								"' doesn't seem to be a normal object property of " +
								rScopes[0].toString() + " or a registered special property.");
				}
			}
		}

		// Adds the modifiers to the list of properties
		for (istr in Flds (modifiedProperties)) {
			if (Get (rProperties, istr) != null) {
				Get (rProperties, istr).modifierParameters = Get (modifiedProperties, istr).modifierParameters;
				Get (rProperties, istr).modifierFunction = Get (modifiedProperties, istr).modifierFunction;
			}
		}

		var rTransition :Dynamic = null; // Real transition
		
		if (Std.is (p_obj.transition, String)) {
			// String parameter, transition names
			var trans :String = p_obj.transition.toLowerCase();
			rTransition = Get (_transitionList, trans);
		}
		else if (Reflect.isFunction (p_obj.transition)) {
			// Proper transition function
			rTransition = p_obj.transition;
		}
		if (rTransition == null) rTransition = Get (_transitionList, defaultTransition);
		
		
		var nProperties :Dynamic;
		var nTween :TweenListObj;

		for (i in 0...rScopes.length) {
			// Makes a copy of the properties
			nProperties = {};
			for (istr in Flds (rProperties)) {//trace(rProperties);trace(Get (rProperties, istr).valueComplete);
				Set (nProperties, istr, new PropertyInfoObj (	Get (rProperties, istr).valueStart,
																Get (rProperties, istr).valueComplete,
																Get (rProperties, istr).valueComplete,
																Get (rProperties, istr).arrayIndex,
																{},
																Get (rProperties, istr).isSpecialProperty,
																Get (rProperties, istr).modifierFunction,
																Get (rProperties, istr).modifierParameters)
				);
			}
			//trace(nProperties);
			nTween = new TweenListObj (
				/* scope			*/	rScopes[i],
				/* timeStart		*/	p_obj.useFrames ?	(_currentTimeFrame + rDelay / _timeScale) :
															(_currentTime + rDelay * 1000 / _timeScale),
				/* timeComplete		*/	p_obj.useFrames ?	(_currentTimeFrame + (rDelay + rTime) / _timeScale) :
															(_currentTime + (rDelay * 1000 + rTime * 1000) / _timeScale),
				/* useFrames		*/	p_obj.useFrames ? true : false,
				/* transition		*/	rTransition,
										p_obj.transitionParams
			);
			

			nTween.properties			=	nProperties;
			nTween.onStart				=	p_obj.onStart;
			nTween.onUpdate				=	p_obj.onUpdate;
			nTween.onComplete			=	p_obj.onComplete;
			nTween.onOverwrite			=	p_obj.onOverwrite;
			nTween.onError				=	p_obj.onError;
			nTween.onStartParams		=	p_obj.onStartParams;
			nTween.onUpdateParams		=	p_obj.onUpdateParams;
			nTween.onCompleteParams		=	p_obj.onCompleteParams;
			nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
			nTween.onStartScope			=	p_obj.onStartScope;
			nTween.onUpdateScope		=	p_obj.onUpdateScope;
			nTween.onCompleteScope		=	p_obj.onCompleteScope;
			nTween.onOverwriteScope		=	p_obj.onOverwriteScope;
			nTween.onErrorScope			=	p_obj.onErrorScope;
			nTween.rounded				=	p_obj.rounded;
			nTween.skipUpdates			=	p_obj.skipUpdates;

			// Remove other tweenings that occur at the same time
			removeTweensByTime (nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete);

			// And finally adds it to the list
			_tweenList.add (nTween);
			
			// Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
			if (rTime == 0 && rDelay == 0) {
				updateTweenByObj ( nTween );
				removeTweenByObj ( nTween );
			}
		}

		return true;
	}

	// A "caller" is like this: [		   |	 |	| ||] got it? :)
	// this function is crap - should be fixed later/extend on addTween()

	/**
	 * Adds a new *caller* tweening
	 *
	 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
	 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties
															that should be tweened and their values
	 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
	 * @param		.delay				Number				Delay time (defaults 0)
	 * @param		.count				Number				Number of times this caller should be called
	 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
	 * @param		.onStart			Function			Event called when tween starts
	 * @param		.onUpdate			Function			Event called when tween updates
	 * @param		.onComplete			Function			Event called when tween ends
	 * @param		.waitFrames			Boolean				Whether to wait (or not) one frame for each call
	 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
	 */
	
	
#if !tweener_lite


	public static function addCaller (p_scopes:Dynamic, p_parameters:Dynamic) : Bool {
		if (p_scopes == null) return false;

		var rScopes = new Array<Dynamic>(); // List of objects to tween
		if (Std.is (p_scopes, Array)) {
			// The first argument is an array
			rScopes = p_scopes;
		}
		else {
			// The first argument(s) is(are) object(s)
			rScopes = [p_scopes];
		}
		
		var p_obj = p_parameters;
		
		// Creates the main engine if it isn't active
		if (!_inited) init();
		if (!_engineExists || __tweener_controller__ == null) startEngine();
		// << Quick fix for Flash not resetting the vars on double ctrl+enter...
		
		// Creates a "safer", more strict tweening object
		var rTime :Float = Math.isNaN (Get (p_obj, "time")) ? 0 : Get (p_obj, "time"); // Real time
		var rDelay :Float = Math.isNaN (Get (p_obj, "delay")) ? 0 : Get (p_obj, "delay"); // Real delay
		
		var rTransition :Dynamic = null; // Real transition
		if (Std.is (p_obj.transition, String)) {
			// String parameter, transition names
			var trans = p_obj.transition.toLowerCase();
			rTransition = Get (_transitionList, trans);
		}
		else if (Reflect.isFunction (p_obj.transition)) {
			// Proper transition function
			rTransition = p_obj.transition;
		}
		if (rTransition == null) rTransition = Get (_transitionList, defaultTransition);

		var nTween :TweenListObj;
		
		for (i in 0...rScopes.length) {
			
			nTween = new TweenListObj(
				/* scope			*/	rScopes[i],
				/* timeStart		*/	p_obj.useFrames ?	(_currentTimeFrame + rDelay / _timeScale) :
															(_currentTime + rDelay * 1000 / _timeScale),
				/* timeComplete		*/	p_obj.useFrames ?	(_currentTimeFrame + (rDelay + rTime) / _timeScale) :
															(_currentTime + (rDelay * 1000 + rTime * 1000) / _timeScale),
				/* useFrames		*/	p_obj.useFrames ? true : false,
				/* transition		*/	rTransition,
										p_obj.transitionParams
			);
			
			
			nTween.properties			=	null;
			nTween.onStart				=	p_obj.onStart;
			nTween.onUpdate				=	p_obj.onUpdate;
			nTween.onComplete			=	p_obj.onComplete;
			nTween.onOverwrite			=	p_obj.onOverwrite;
			nTween.onStartParams		=	p_obj.onStartParams;
			nTween.onUpdateParams		=	p_obj.onUpdateParams;
			nTween.onCompleteParams		=	p_obj.onCompleteParams;
			nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
			nTween.onStartScope			=	p_obj.onStartScope;
			nTween.onUpdateScope		=	p_obj.onUpdateScope;
			nTween.onCompleteScope		=	p_obj.onCompleteScope;
			nTween.onOverwriteScope		=	p_obj.onOverwriteScope;
			nTween.onErrorScope			=	p_obj.onErrorScope;
			nTween.isCaller				=	true;
			nTween.count				=	p_obj.count;
			nTween.waitFrames			=	p_obj.waitFrames;

			// And finally adds it to the list
			_tweenList.add (nTween);

			// Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
			if (rTime == 0 && rDelay == 0) {
				updateTweenByObj ( nTween );
				removeTweenByObj ( nTween );
			}
		}

		return true;
	}
#end
	/**
	 * Remove an specified tweening of a specified object the tweening list, if it conflicts with the given time
	 *
	 * @param		p_scope				Object						List of objects affected
	 * @param		p_properties		Object						List of properties affected (PropertyInfoObj instances)
	 * @param		p_timeStart			Number						Time when the new tween starts
	 * @param		p_timeComplete		Number						Time when the new tween ends
	 * @return							Boolean						Whether or not it actually deleted something
	 */
	public static function removeTweensByTime ( p_scope:Dynamic, p_properties:Dynamic,
												p_timeStart:Float, p_timeComplete:Float) : Bool {
		var removed = false;
		var removedLocally : Bool;
		
		for (obj in _tweenList.iterator()) {
			
			if (p_scope == obj.scope) {
				// Same object...
				if (p_timeComplete > obj.timeStart && p_timeStart < obj.timeComplete) {
					// New time should override the old one...
					removedLocally = false;
					
					for (pName in Flds (obj.properties)) {
						if (Get (p_properties, pName) != null) {
							// Same object, same property
							// Finally, remove this old tweening and use the new one
							if (obj.onOverwrite != null) {
								var eventScope = obj.onOverwriteScope != null ? obj.onOverwriteScope : obj.scope;
								try {
									Reflect.callMethod (eventScope, obj.onOverwrite, obj.onOverwriteParams);
								}
								catch (e:Dynamic) {
									handleError (obj, e, "onOverwrite");
								}
							}
							Set (obj.properties, pName, null);
							removedLocally = true;
							removed = true;
						}
					}
					if (removedLocally) {
						// Verify if this can be deleted
						if (AuxFunctions.getObjectLength (obj.properties) == 0)
							removeTweenByObj ( obj );
					}
				}
			}
		}

		return removed;
	}

	/**
	 * Remove tweenings from a given object from the tweening list
	 *
	 * @param		p_tween				Object		Object that must have its tweens removed
	 * @param		(2nd-last params)	Object		Property(ies) that must be removed
	 * @return							Boolean		Whether or not it successfully removed this tweening
	 */
	public static function removeTweens (p_scope:Dynamic, args:Array<String>) : Bool {
		// Create the property list
		var properties = new Array<String>();
		
		for (arg in args) {
			if (!AuxFunctions.isInArray (arg, properties)) {
				if (Get (_specialPropertySplitterList, arg) != null) {
					//special property, get splitter array first
					var sps :SpecialPropertySplitter = Get (_specialPropertySplitterList, arg);
					var specialProps :Array<Dynamic> = sps.splitValues (p_scope, null);
					
					for (prop in specialProps) {
						properties.push (prop.name);
					}
				}
				else {
					properties.push (arg);
				}
			}
		}
		// Call the affect function on the specified properties
		return affectTweens (removeTweenByObj, p_scope, properties);
	}

	/**
	 * Remove all tweenings from the engine
	 *
	 * @return							Boolean		Whether or not it successfully removed a tweening
	 */
	public static function removeAllTweens () : Bool {
		if (_tweenList == null) return false;
		else if (_tweenList.isEmpty()) return false;
		
		for (obj in _tweenList.iterator()) {
			removeTweenByObj ( obj );
		}
		return true;
	}

	/**
	 * Pause tweenings from a given object
	 *
	 * @param		p_scope				Object		Object that must have its tweens paused
	 * @param		(2nd-last params)	Object		Property(ies) that must be paused
	 * @return							Boolean		Whether or not it successfully paused something
	 */
	public static function pauseTweens (p_scope:Dynamic, args:Array<String>) : Bool {
		// Create the property list
		var properties = new Array<String>();
		
		for (arg in args) {
			if (Std.is (arg, String) && !AuxFunctions.isInArray (arg, properties)) properties.push ( arg );
		}
		// Call the affect function on the specified properties
		return affectTweens (pauseTweenByObj, p_scope, properties);
	}

	/**
	 * Pause all tweenings on the engine
	 *
	 * @return							Boolean		Whether or not it successfully paused a tweening
	 */
	public static function pauseAllTweens () : Bool {
		if (_tweenList == null) return false;
		else if (_tweenList.isEmpty()) return false;
		
		for (obj in _tweenList.iterator()) {
			pauseTweenByObj ( obj );
		}
		return true;
	}
	
	/**
	 * Resume tweenings from a given object
	 *
	 * @param		p_scope				Object		Object that must have its tweens resumed
	 * @param		(2nd-last params)	Object		Property(ies) that must be resumed
	 * @return							Boolean		Whether or not it successfully resumed something
	 */
	public static function resumeTweens (p_scope:Dynamic, args:Array<String>) : Bool {
		// Create the property list
		var properties = new Array<String>();
		
		for (arg in args) {
			if (Std.is (arg, String) && !AuxFunctions.isInArray (arg, properties)) properties.push ( arg );
		}
		// Call the affect function on the specified properties
		return affectTweens (resumeTweenByObj, p_scope, properties);
	}
	
	/**
	 * Resume all tweenings on the engine
	 *
	 * @return							Boolean		Whether or not it successfully resumed a tweening
	 */
	public static function resumeAllTweens () : Bool {
		if (_tweenList == null) return false;
		else if (_tweenList.isEmpty()) return false;
		
		for (obj in _tweenList.iterator()) {
			resumeTweenByObj ( obj );
		}
		return true;
	}

	/**
	 * Do some generic action on specific tweenings (pause, resume, remove, more?)
	 *
	 * @param		p_function			Function	Function to run on the tweenings that match
	 * @param		p_scope				Object		Object that must have its tweens affected by the function
	 * @param		p_properties		Array		Array of strings that must be affected
	 * @return							Boolean		Whether or not it successfully affected something
	 */
	static function affectTweens (p_affectFunction:Dynamic, p_scope:Dynamic, p_properties:Array<String>) : Bool {
		if (_tweenList == null) return false;
		else if (_tweenList.isEmpty()) return false;
		
		var affected = false;
		
		for (obj in _tweenList.iterator()) {
			if (obj.scope == p_scope) {
				if (p_properties.length == 0) {
					// Can affect everything
					p_affectFunction ( obj );
					affected = true;
				}
				else {
					// Must check whether this tween must have specific properties affected
					var affectedProperties = new Array<String>();
					for (prop in p_properties)
						if (Get (obj.properties, prop) != null)
							affectedProperties.push (prop);
					
					if (affectedProperties.length > 0) {
						// This tween has some properties that need to be affected
						var objectProperties = AuxFunctions.getObjectLength (obj.properties);
						if (objectProperties == affectedProperties.length) {
							// The list of properties is the same as all properties, so affect it all
							p_affectFunction ( obj );
						}
						else {
							// The properties are mixed, so split the tween and affect only certain specific properties
							var slicedTweenObj :TweenListObj = splitTweens (obj, affectedProperties);
							p_affectFunction (slicedTweenObj);
						}
						affected = true;
					}
				}
			}
		}
		return affected;
	}
	
	/**
	 * Splits a tweening in two
	 *
	 * @param		p_tween				Number		Object that must have its tweens split
	 * @param		p_properties		Array		Array of strings containing the list of properties that must be separated
	 * @return							Number		The index number of the new tween
	 */
	public static function splitTweens (originalTween:TweenListObj, p_properties:Array<String>) : TweenListObj {
		// First, duplicates
		var newTween :TweenListObj = originalTween.clone (false);
		
		// Now, removes tweenings where needed
		// Removes the specified properties from the old one
		for (prop in p_properties)
			Set (originalTween.properties, prop, null);

		// Removes the unspecified properties from the new one
		var found : Bool;
		for (pName in Flds (newTween.properties)) {
			found = false;
			for (prop in p_properties) {
				if (prop == pName) {
					found = true;
					break;
				}
			}
			if (!found) {
				Set (newTween.properties, pName, null);
			}
		}

		// If there are empty property lists, a cleanup is done on the next updateTweens() cycle
		_tweenList.add ( newTween );
		return newTween;
		
	}


	// ==================================================================================================================================
	// ENGINE functions -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates all existing tweenings
	 *
	 * @return	Boolean		FALSE if no update was made because there's no tweening (even delayed ones)
	 */
	static function updateTweens () : Bool {
		
		if (_tweenList == null) return false;
		else if (_tweenList.isEmpty()) return false;
		
		for (obj in _tweenList.iterator())
			if (!obj.isPaused)
				if (!updateTweenByObj (obj))
					removeTweenByObj ( obj );
		
		return true;
	}
	
	/**
	 * Remove an specific tweening from the tweening list
	 *
	 * @param		p_tween				Number		Index of the tween to be removed on the tweenings list
	 * @return							Boolean		Whether or not it successfully removed this tweening
	 */
	public static function removeTweenByObj (p_tween:TweenListObj) : Bool {
		return _tweenList.remove (p_tween);
	}

	/**
	 * Pauses an specific tween
	 *
	 * @param		p_tween				Number		Index of the tween to be paused
	 * @return							Boolean		Whether or not it successfully paused this tweening
	 */
	public static function pauseTweenByObj (p_tween:TweenListObj) : Bool {
		
		if (p_tween == null) return false;
		else if (p_tween.isPaused) return false;
		
		p_tween.timePaused = getCurrentTweeningTime ( p_tween );
		p_tween.isPaused = true;
		
		return true;
	}

	/**
	 * Resumes an specific tween
	 *
	 * @param		p_tween				Number		Index of the tween to be resumed
	 * @return							Boolean		Whether or not it successfully resumed this tweening
	 */
	public static function resumeTweenByObj (p_tween:TweenListObj) : Bool {
		
		if (p_tween == null) return false;
		else if (!p_tween.isPaused) return false;
		
		var cTime :Float = getCurrentTweeningTime ( p_tween );
		p_tween.timeStart += cTime - p_tween.timePaused;
		p_tween.timeComplete += cTime - p_tween.timePaused;
		p_tween.timePaused = null;
		p_tween.isPaused = false;

		return true;
	}

	/**
	 * Updates an specific tween
	 *
	 * @param		i					Number		Index (from the tween list) of the tween that should be updated
	 * @return							Boolean		FALSE if it's already finished and should be deleted, TRUE if otherwise
	 */
	static function updateTweenByObj (p_tween:TweenListObj) : Bool {//trace("update by index "+i);
		
		if (p_tween == null) return false;
		else if (p_tween.scope == null) return false;
		
		var isOver = false;				// Whether or not it's over the update time
		var mustUpdate : Bool;			// Whether or not it should be updated (skipped if false)
		
		var nv : Float;					// New value for each property
		var t : Float;					// current time (frames, seconds)
		var b : Float;					// beginning value
		var c : Float;					// change in value
		var d : Float;					// duration (frames, seconds)
		
		var pName : String;				// Property name, used in loops
		var eventScope : Dynamic;		// Event scope, used to call functions

		// Shortcut stuff for speed
		var tScope : Dynamic;			// Current scope
		var cTime : Float = getCurrentTweeningTime ( p_tween );
		var tProperty : Dynamic;		// Property being checked
		
		if (cTime >= p_tween.timeStart) {
			// Can already start

			tScope = p_tween.scope;

			if (p_tween.isCaller) {
				// It's a 'caller' tween
				do {
					t = ((p_tween.timeComplete - p_tween.timeStart) / p_tween.count) * (p_tween.timesCalled + 1);
					b = p_tween.timeStart;
					c = p_tween.timeComplete - p_tween.timeStart;
					d = p_tween.timeComplete - p_tween.timeStart;
					nv = p_tween.transition (t, b, c, d, null);
					
					if (cTime >= nv) {
						if (p_tween.onUpdate != null) {
							eventScope = p_tween.onUpdateScope != null ? p_tween.onUpdateScope : tScope;
							try {
								Reflect.callMethod (eventScope, p_tween.onUpdate, p_tween.onUpdateParams);
							}
							catch (e:Dynamic) {
								handleError (p_tween, e, "onUpdate");
							}
						}
						
						p_tween.timesCalled ++;
						
						if (p_tween.timesCalled >= p_tween.count) {
							isOver = true;
							break;
						}
						if (p_tween.waitFrames) break;
					}
					
				} while (cTime >= nv);
			}
			else {
				// It's a normal transition tween

				mustUpdate = p_tween.skipUpdates < 1 || p_tween.skipUpdates == null || p_tween.updatesSkipped >= p_tween.skipUpdates;
				
				if (cTime >= p_tween.timeComplete) {
					isOver = true;
					mustUpdate = true;
				}
				
				if (!p_tween.hasStarted) {

					// First update, read all default values (for proper filter tweening)
					if (p_tween.onStart != null) {
						eventScope = p_tween.onStartScope != null ? p_tween.onStartScope : tScope;
						try {
							Reflect.callMethod (eventScope, p_tween.onStart, p_tween.onStartParams);
						}
						catch (e:Dynamic) {
							handleError (p_tween, e, "onStart");
						}
					}
					var pv :Float = 0;

					for (pName in Flds (p_tween.properties)) {
						if (Get (p_tween.properties, pName).isSpecialProperty) {
							// It's a special property, tunnel via the special property function
							if (Get (_specialPropertyList, pName) != null) {
								if (Get (_specialPropertyList, pName).preProcess != null) {
									Get (p_tween.properties, pName).valueComplete = Get (	_specialPropertyList,
																							pName).preProcess (tScope,
																							Get (_specialPropertyList,
																							pName).parameters,
																							Get (p_tween.properties,
																							pName).originalValueComplete,
																							Get (p_tween.properties,
																							pName).extra);
								}
								pv = Get (_specialPropertyList, pName).getValue (	tScope,
																					Get (_specialPropertyList, pName).parameters,
																					Get (p_tween.properties, pName).extra);
							}
						}
						else {
							// Directly read property
							pv = Get (tScope, pName);
						}
						Get (p_tween.properties, pName).valueStart = Math.isNaN (pv) ? Get (p_tween.properties, pName).valueComplete : pv;
					}

					mustUpdate = true;
					p_tween.hasStarted = true;
				}
				
				if (mustUpdate) {//trace(tTweening);
					for (pName in Flds (p_tween.properties)) {//trace("> "+pName);
						
						tProperty = Get (p_tween.properties, pName);
if (tProperty == null) return false;
						if (isOver) {
							// Tweening time has finished, just set it to the final value
							nv = tProperty.valueComplete;
						}
						else {
							if (tProperty.hasModifier) {
								// Modified
								t = cTime - p_tween.timeStart;
								d = p_tween.timeComplete - p_tween.timeStart;
								nv = p_tween.transition (t, 0, 1, d, p_tween.transitionParams);
								nv = tProperty.modifierFunction (	tProperty.valueStart,
																	tProperty.valueComplete,
																	nv,
																	tProperty.modifierParameters);
							}
							else {
								// Normal update
								t = cTime - p_tween.timeStart;
								b = tProperty.valueStart;
								c = tProperty.valueComplete - tProperty.valueStart;
								d = p_tween.timeComplete - p_tween.timeStart;
								nv = p_tween.transition (t, b, c, d, p_tween.transitionParams);
							}
						}
						//trace("nv= "+nv);
						if (p_tween.rounded) nv = Math.round (nv);
						if (tProperty.isSpecialProperty) {
							// It's a special property, tunnel via the special property method
							Get (_specialPropertyList, pName).setValue (tScope, nv,
																		Get (_specialPropertyList, pName).parameters,
																		Get (p_tween.properties, pName).extra);
						}
						else {
							// Directly set property
							Set (tScope, pName, nv);
						}
					}
					
					p_tween.updatesSkipped = 0;
					
					if (p_tween.onUpdate != null) {
						eventScope = p_tween.onUpdateScope != null ? p_tween.onUpdateScope : tScope;
						try {
							Reflect.callMethod (eventScope, p_tween.onUpdate, p_tween.onUpdateParams);
						}
						catch (e:Dynamic) {
							handleError (p_tween, e, "onUpdate");
						}
					}
				}
				else {
					p_tween.updatesSkipped ++;
				}
			}
			
			if (isOver && p_tween.onComplete != null) {
				eventScope = p_tween.onCompleteScope != null ? p_tween.onCompleteScope : tScope;
				try {
					Reflect.callMethod (eventScope, p_tween.onComplete, p_tween.onCompleteParams);
				}
				catch (e:Dynamic) {
					handleError (p_tween, e, "onComplete");
				}
			}

			return (!isOver);
		}

		// On delay, hasn't started, so return true
		return true;
	}

	/**
	 * Initiates the Tweener. Should only be ran once
	 */
	private static function init () : Void {
		_inited = true;
		
		// Registers all default equations
		_transitionList = {};
		Equations.init();
		
		// Registers all default special properties
		_specialPropertyList = {};
		_specialPropertyModifierList = {};
		_specialPropertySplitterList = {};
	}
	
	/**
	 * Adds a new function to the available transition list "shortcuts"
	 *
	 * @param		p_name				String		Shorthand transition name
	 * @param		p_function			Function	The proper equation function
	 */
	public static function registerTransition (p_name:String, p_function:Dynamic) : Void {
		if (!_inited) init();
		Set (_transitionList, p_name, p_function);
	}
	
	/**
	 * Adds a new special property to the available special property list.
	 *
	 * @param		p_name				Name of the "special" property.
	 * @param		p_getFunction		Function that gets the value.
	 * @param		p_setFunction		Function that sets the value.
	 */
	public static function registerSpecialProperty (p_name:String,
													p_getFunction:Dynamic,
													p_setFunction:Dynamic,
													?p_parameters:Array<Dynamic>,
													?p_preProcessFunction:Dynamic) : Void {
		if (!_inited) init();
		var sp = new SpecialProperty (p_getFunction, p_setFunction, p_parameters, p_preProcessFunction);
		Set (_specialPropertyList, p_name, sp);
	}

	/**
	 * Adds a new special property modifier to the available modifier list.
	 *
	 * @param		p_name				Name of the "special" property modifier.
	 * @param		p_modifyFunction	Function that modifies the value.
	 * @param		p_getFunction		Function that gets the value.
	 */
	public static function registerSpecialPropertyModifier (p_name:String,
															p_modifyFunction:Dynamic,
															p_getFunction:Dynamic) : Void {
		if (!_inited) init();
		var spm = new SpecialPropertyModifier (p_modifyFunction, p_getFunction);
		Set (_specialPropertyModifierList, p_name, spm);
	}

	/**
	 * Adds a new special property splitter to the available splitter list.
	 *
	 * @param		p_name				Name of the "special" property splitter.
	 * @param		p_splitFunction		Function that splits the value.
	 */
	public static function registerSpecialPropertySplitter (p_name:String,
															p_splitFunction:Dynamic,
															?p_parameters:Array<Dynamic>) : Void {
		if (!_inited) init();
		var sps = new SpecialPropertySplitter (p_splitFunction, p_parameters);
		Set (_specialPropertySplitterList, p_name, sps);
	}

	/**
	 * Starts the Tweener class engine. It is supposed to be running every time a tween exists
	 */
	static function startEngine () : Void {//trace(">>>>>>>>>>>>>>>>>>>START ENGINE<<<<<<<<<<<<<<<<<");
		_engineExists = true;
		_tweenList = new List<TweenListObj>();
#if flash8
		var randomDepth = Math.floor (Math.random() * 999999);
		__tweener_controller__ = flash.Lib._root.createEmptyMovieClip (getControllerName(), 31338+randomDepth);
		__tweener_controller__.onEnterFrame = onEnterFrame;
#elseif flash9
		__tweener_controller__ = new MovieClip();
		__tweener_controller__.addEventListener (Event.ENTER_FRAME, onEnterFrame);
#end
		_currentTimeFrame = 0;
		updateTime();
	}

	/**
	 * Stops the Tweener class engine
	 */
	static function stopEngine () : Void {//trace(">>>>>>>>>>>>>>>>>>>STOP ENGINE");
		_engineExists = false;
		_tweenList = null;
		_currentTime = 0;
		_currentTimeFrame = 0;
#if flash8
		__tweener_controller__.onEnterFrame = null;
		__tweener_controller__.removeMovieClip();
#elseif flash9
		__tweener_controller__.removeEventListener (Event.ENTER_FRAME, onEnterFrame);
		__tweener_controller__ = null;
#end
	}

	/**
	 * Updates the time to enforce time grid-based updates
	 */
	public static function updateTime () : Void {
		_currentTime = flash.Lib.getTimer();
	}
	
	/**
	 * Updates the current frame count
	 */
	public static function updateFrame () : Void {
		_currentTimeFrame++;
	}

	/**
	 * Ran once every frame. It's the main engine, updates all existing tweenings.
	 */
#if flash8
	public static function onEnterFrame () : Void {
#elseif flash9
	public static function onEnterFrame (e:Event) : Void {
#end
		updateTime();
		updateFrame();
		var hasUpdated = false;
		hasUpdated = updateTweens();
		if (!hasUpdated) stopEngine();	// There's no tweening to update or wait, so it's better to stop the engine
	}

	/**
	 * Sets the new time scale.
	 *
	 * @param		p_time				Number		New time scale (0.5 = slow, 1 = normal, 2 = 2x fast forward, etc)
	 */
	public static function setTimeScale (p_time:Float) : Void {
		if (Math.isNaN (p_time)) p_time = 1;
		if (p_time < 0.00001) p_time = 0.00001;
		if (p_time != _timeScale) {
			// Multiplies all existing tween times accordingly
			for (tweenListObj in _tweenList) {
				var cTime = getCurrentTweeningTime (tweenListObj);
				tweenListObj.timeStart	  = cTime - ((cTime - tweenListObj.timeStart) * _timeScale / p_time);
				tweenListObj.timeComplete = cTime - ((cTime - tweenListObj.timeComplete) * _timeScale / p_time);
				if (tweenListObj.timePaused != null)
					tweenListObj.timePaused = cTime - ((cTime - tweenListObj.timePaused) * _timeScale / p_time);
			}
			// Sets the new timescale value (for new tweenings)
			_timeScale = p_time;
		}
	}
	
	
#if !tweener_lite


	// ==================================================================================================================================
	// AUXILIARY functions --------------------------------------------------------------------------------------------------------------

	/**
	 * Finds whether or not an object has any tweening
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Boolean		Whether or not there's a tweening occuring on this object (paused, delayed, or active)
	 */
	public static function isTweening (p_scope:Dynamic) : Bool {
		if (_tweenList == null) return false;
		if (_tweenList.length == 0) return false;
		
		for (tweenListObj in _tweenList)
			if (tweenListObj.scope == p_scope)
				return true;

		return false;
	}

	/**
	 * Return an array containing a list of the properties being tweened for this object
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Array		List of strings with properties being tweened (including delayed or paused)
	 */
	public static function getTweens (p_scope:Dynamic) : Array<String> {
		if (_tweenList == null) return [];
		if (_tweenList.length == 0) return [];
		var tList = new Array<String>();
		
		for (tweenListObj in _tweenList)
			if (tweenListObj.scope == p_scope)
				for (pName in Flds (tweenListObj.properties))
					tList.push (pName);
					
		return tList;
	}

	/**
	 * Return the number of properties being tweened for this object
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Number		Total count of properties being tweened (including delayed or paused)
	 */
	public static function getTweenCount (p_scope:Dynamic) : Int {
		if (_tweenList == null) return 0;
		if (_tweenList.length == 0) return 0;
		var c = 0;

		for (tweenListObj in _tweenList)
			if (tweenListObj.scope == p_scope)
				c += AuxFunctions.getObjectLength (tweenListObj.properties);
				
		return c;
	}


#end


	/* Handles errors when Tweener executes any callbacks (onStart, onUpdate, etc)
	*  If the TweenListObj specifies an <code>onError</code> callback it well get called,
	*  passing the <code>Error</code> object and the current scope as parameters.
	*  If no <code>onError</code> callback is specified, it will trace a stackTrace.
	*/
	private static function handleError (pTweening:TweenListObj, pError:Dynamic, pCallBackName:String) : Void {
		// do we have an error handler?
		if (pTweening.onError != null && Reflect.isFunction (pTweening.onError)){
			// yup, there's a handler. Wrap this in a try catch in case the onError throws an error itself.
			var eventScope:Dynamic = pTweening.onErrorScope != null ? pTweening.onErrorScope : pTweening.scope;
			try {
				Reflect.callMethod (eventScope, pTweening.onError, [pTweening.scope, pError]);
			}
			catch (metaError : Dynamic) {
				printError (pTweening.scope.toString() +
							" raised an error while executing the 'onError' handler. Original error:\n " +
							pError +  "\nonError error: " + metaError);
			}
		}
		else {
			// if handler is undefied or null trace the error message (allows empty onErro's to ignore errors)
			if (pTweening.onError == null) {
				printError (pTweening.scope.toString() +
							" raised an error while executing the '" +
							pCallBackName.toString() + "'handler. \n" + pError );
			}
		}
	}

	/**
	 * Get the current tweening time (no matter if it uses frames or time as basis), given a specific tweening
	 *
	 * @param		p_tweening				TweenListObj		Tween information
	 */
	public static function getCurrentTweeningTime (p_tweening:Dynamic) : Float {
		return Get (p_tweening, "useFrames") ? _currentTimeFrame : _currentTime;
	}

	/**
	 * Return the current tweener version
	 *
	 * @return							String		The number of the current Tweener version
	 */
	public static function getVersion () : String {
		return "haXe2 1.31.74";
	}

	/**
	 * Return the name for the controller movieclip
	 *
	 * @return							String		The number of the current Tweener version
	 */
	public static function getControllerName () : String {
		return "__tweener_controller__" + getVersion();
	}



	// ======================================================================================================
	// DEBUG functions --------------------------------------------------------------------------------------

	/**
	 * Output an error message
	 *
	 * @param		p_message				String		The error message to output
	 */
	public static function printError (p_message:String) : Void {
		//
		trace ("## [Tweener] Error: " + p_message);
	}

}
