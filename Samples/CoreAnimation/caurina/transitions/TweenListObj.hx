/**
 * The tween list object. Stores all of the properties and information that pertain to individual tweens.
 *
 * @author		Nate Chatellier, Zeh Fernando
 * @version		1.0.4
 */
package caurina.transitions;

class TweenListObj {

	public var scope					:Dynamic;	// Object affected by this tweening
	public var properties				:Dynamic;	// List of properties that are tweened (PropertyInfoObj instances)
	public var valueStart				:Null<Float>;	// Initial value of the property
	public var valueComplete			:Null<Float>;	// The value the property should have when completed
	public var timeStart				:Null<Float>;// Time when this tweening should start
	public var timeComplete				:Null<Float>;// Time when this tweening should end
	public var useFrames				:Bool;		// Whether or not to use frames instead of time
	public var transition				:Dynamic;	// Equation to control the transition animation
	public var transitionParams			:Dynamic;	// Additional parameters for the transition
	public var onStart					:Dynamic;	// Function to be executed on the object when the tween starts (once)
	public var onUpdate					:Dynamic;	// Function to be executed on the object when the tween updates (several times)
	public var onComplete				:Dynamic;	// Function to be executed on the object when the tween completes (once)
	public var onOverwrite				:Dynamic;	// Function to be executed on the object when the tween is overwritten
	public var onError  				:Dynamic;	// Function to be executed if an error is thrown when tweener exectues a callback (onComplete, onUpdate etc)
	public var onStartParams			:Array<Dynamic>;	// Array of parameters to be passed for the event
	public var onUpdateParams			:Array<Dynamic>;	// Array of parameters to be passed for the event
	public var onCompleteParams			:Array<Dynamic>;	// Array of parameters to be passed for the event
	public var onOverwriteParams		:Array<Dynamic>;	// Array of parameters to be passed for the event
	public var onStartScope				:Dynamic;	// Scope in which the event function is ran
	public var onUpdateScope			:Dynamic;	// Scope in which the event function is ran
	public var onCompleteScope			:Dynamic;	// Scope in which the event function is ran
	public var onOverwriteScope			:Dynamic;	// Scope in which the event function is ran
	public var onErrorScope				:Dynamic;	// Scope in which the event function is ran
	public var rounded					:Bool;		// Use rounded values when updating
	public var isPaused					:Bool;		// Whether or not this tween is paused
	public var timePaused				:Null<Float>;	// Time when this tween was paused
	public var isCaller					:Bool;		// Whether or not this tween is a "caller" tween
	public var count					:Null<Int>;	// Number of times this caller should be called
	public var timesCalled				:Null<Int>;	// How many times the caller has already been called ("caller" tweens only)
	public var waitFrames				:Bool;		// Whether or not this caller should wait at least one frame for each call execution ("caller" tweens only)
	public var skipUpdates				:Null<Int>;	// How many updates should be skipped (default = 0; 1 = update-skip-update-skip...)
	public var updatesSkipped			:Null<Int>;	// How many updates have already been skipped
	public var hasStarted				:Bool;		// Whether or not this tween has already started

	// ==================================================================================================================================
	// CORCTRUCTOR function -------------------------------------------------------------------------------------------------------------

	/**
	 * Initializes the basic TweenListObj
	 *
	 * @param	p_scope				Object		Object affected by this tweening
	 * @param	p_timeStart			Number		Time when this tweening should start
	 * @param	p_timeComplete		Number		Time when this tweening should end
	 * @param	p_useFrames			Boolean		Whether or not to use frames instead of time
	 * @param	p_transition		Function	Equation to control the transition animation
	 */
	public function new (p_scope:Dynamic, p_timeStart:Float, p_timeComplete:Float, p_useFrames:Bool, p_transition:Dynamic, p_transitionParams:Dynamic) {
		scope				=	p_scope;
		timeStart			=	p_timeStart;
		timeComplete		=	p_timeComplete;
		useFrames			=	p_useFrames;
		transition			=	p_transition;
		transitionParams	=	p_transitionParams;

		// Other default information
		properties		=	{};
		isPaused		=	false;
		timePaused		=	null;
		isCaller		=	false;
		updatesSkipped	=	0;
		timesCalled		=	0;
		skipUpdates 	= 	0;
		hasStarted		=	false;
	}


	// ==================================================================================================================================
	// OTHER functions ------------------------------------------------------------------------------------------------------------------

	/**
	 * Clones this tweening and returns the new TweenListObj
	 *
	 * @param	omitEvents		Boolean			Whether or not events such as onStart (and its parameters) should be omitted
	 * @return 					TweenListObj	A copy of this object
	 */
	public function clone (omitEvents:Bool) : TweenListObj {
		
		var nTween = new TweenListObj (scope, timeStart, timeComplete, useFrames, transition, transitionParams);
		nTween.properties = {};
		
		for (pName in Reflect.fields (properties)) {
			Reflect.setField (nTween.properties, pName, Reflect.field (properties, pName).clone());
		}
		
		nTween.skipUpdates = skipUpdates;
		nTween.updatesSkipped = updatesSkipped;
		if (!omitEvents) {
			nTween.onStart = onStart;
			nTween.onUpdate = onUpdate;
			nTween.onComplete = onComplete;
			nTween.onOverwrite = onOverwrite;
			nTween.onError = onError;
			nTween.onStartParams = onStartParams;
			nTween.onUpdateParams = onUpdateParams;
			nTween.onCompleteParams = onCompleteParams;
			nTween.onOverwriteParams = onOverwriteParams;
			nTween.onStartScope = onStartScope;
			nTween.onUpdateScope = onUpdateScope;
			nTween.onCompleteScope = onCompleteScope;
			nTween.onOverwriteScope = onOverwriteScope;
			nTween.onErrorScope = onErrorScope;
		}
		nTween.rounded = rounded;
		nTween.isPaused = isPaused;
		nTween.timePaused = timePaused;
		nTween.isCaller = isCaller;
		nTween.count = count;
		nTween.timesCalled = timesCalled;
		nTween.waitFrames = waitFrames;
		nTween.hasStarted = hasStarted;

		return nTween;
	}

	/**
	 * Returns this object described as a String.
	 *
	 * @return 					String		The description of this object.
	 */
	public function toString () : String {
		var returnStr = "\n[TweenListObj ";
		returnStr += "scope:" + Std.string (scope);
		returnStr += ", properties:";
		var isFirst = true;
		for (i in Reflect.fields (properties)) {
			if (!isFirst) returnStr += ",";
			returnStr += "[name:" + Std.string (Reflect.field (properties, i).name);
			returnStr += ",valueStart:" + Std.string (Reflect.field (properties, i).valueStart);
			returnStr += ",valueComplete:" + Std.string (Reflect.field (properties, i).valueComplete);
			returnStr += "]";
			isFirst = false;
		}
		returnStr += ", timeStart:" + Std.string (timeStart);
		returnStr += ", timeComplete:" + Std.string (timeComplete);
		returnStr += ", useFrames:" + Std.string (useFrames);
		returnStr += ", transition:" + Std.string (transition);
		returnStr += ", transitionParams:" + Std.string (transitionParams);

		if (skipUpdates != 0)	returnStr += ", skipUpdates:"		+ Std.string (skipUpdates);
		if (updatesSkipped != 0)returnStr += ", updatesSkipped:"	+ Std.string (updatesSkipped);

		if (onStart)			returnStr += ", onStart:"			+ Std.string (onStart);
		if (onUpdate)			returnStr += ", onUpdate:"			+ Std.string (onUpdate);
		if (onComplete)			returnStr += ", onComplete:"		+ Std.string (onComplete);
		if (onOverwrite)		returnStr += ", onOverwrite:"		+ Std.string (onOverwrite);
		if (onError)		    returnStr += ", onError:"		    + Std.string (onError);

		if (onStartParams.length > 0)		returnStr += ", onStartParams:"		+ Std.string (onStartParams);
		if (onUpdateParams.length > 0)		returnStr += ", onUpdateParams:"	+ Std.string (onUpdateParams);
		if (onCompleteParams.length > 0)	returnStr += ", onCompleteParams:"	+ Std.string (onCompleteParams);
		if (onOverwriteParams.length > 0)	returnStr += ", onOverwriteParams:"	+ Std.string (onOverwriteParams);

		if (onStartScope)		returnStr += ", onStartScope:"		+ Std.string (onStartScope);
		if (onUpdateScope)		returnStr += ", onUpdateScope:"		+ Std.string (onUpdateScope);
		if (onCompleteScope)	returnStr += ", onCompleteScope:"	+ Std.string (onCompleteScope);
		if (onOverwriteScope)	returnStr += ", onOverwriteScope:"	+ Std.string (onOverwriteScope);
		if (onErrorScope)		returnStr += ", onErrorScope:"		+ Std.string (onErrorScope);

		if (rounded)			returnStr += ", rounded:"			+ Std.string (rounded);
		if (isPaused)			returnStr += ", isPaused:"			+ Std.string (isPaused);
		if (timePaused != null)	returnStr += ", timePaused:"		+ Std.string (timePaused);
		if (isCaller)			returnStr += ", isCaller:"			+ Std.string (isCaller);
		if (count != 0)			returnStr += ", count:"				+ Std.string (count);
		if (timesCalled != 0)	returnStr += ", timesCalled:"		+ Std.string (timesCalled);
		if (waitFrames)			returnStr += ", waitFrames:"		+ Std.string (waitFrames);
		if (hasStarted)			returnStr += ", hasStarted:"		+ Std.string (hasStarted);
		
		returnStr += "]\n";
		return returnStr;
	}
	
	/**
	 * Checks if p_obj "inherits" properties from other objects, as set by the "base" property. Will create a new object, leaving others intact.
	 * o_bj.base can be an object or an array of objects. Properties are collected from the first to the last element of the "base" filed, with higher
	 * indexes overwritting smaller ones. Does not modify any of the passed objects, but makes a shallow copy of all properties.
	 *
	 * @param		p_obj		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
	 * @return					Object				A new object with all properties from the p_obj and p_obj.base.
	 */

	public static function makePropertiesChain (p_obj:Dynamic) : Dynamic {
		// Is this object inheriting properties from another object?
		var baseObject :Dynamic = p_obj.base;
		if (baseObject != null) {
			// object inherits. Are we inheriting from an object or an array
			var chainedObject : Dynamic = {};
			var chain : Array<Dynamic>;
			if (Std.is (baseObject, Array)) {
				// Inheritance chain is the base array
				chain = [];
				// make a shallow copy
				for (i in 0...Reflect.fields (baseObject).length) chain.push (baseObject[i]);
			}
			else {
				// Only one object to be added to the array
				chain = [baseObject];
			}
			// add the final object to the array, so it's properties are added last
			chain.push (p_obj);
			var currChainObj : Dynamic;
			// Loops through each object adding it's property to the final object
			for (chainObj in chain) {
				if (Reflect.hasField (chainObj, "base")) {
					// deal with recursion: watch the order! "parent" base must be concatenated first!
					currChainObj = AuxFunctions.concatObjects ( [makePropertiesChain (Reflect.field (chainObj, "base")), chainObj] );
				}
				else {
					currChainObj = chainObj ;
				}
				chainedObject = AuxFunctions.concatObjects ( [chainedObject, currChainObj] );
			}
			if (Reflect.hasField (chainedObject, "base")) {
			    Reflect.setField (chainedObject, "base", null);
			}
			return chainedObject;
		}
		else {
			// No inheritance, just return the object itself
			return p_obj;
		}
	}
}
