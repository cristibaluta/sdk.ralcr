package caurina.transitions {
	import caurina.transitions.SpecialPropertyModifier;
	import caurina.transitions.Equations;
	import caurina.transitions.AuxFunctions;
	import caurina.transitions.TweenListObj;
	import flash.display.MovieClip;
	import flash.Lib;
	import caurina.transitions.SpecialPropertySplitter;
	import haxe.Log;
	import caurina.transitions.PropertyInfoObj;
	import flash.events.Event;
	import caurina.transitions.SpecialProperty;
	import flash.Boot;
	public class Tweener {
		public function Tweener() : void { if( !flash.Boot.skip_constructor ) {
			haxe.Log.trace("Tweener is a static class and should not be instantiated.",{ fileName : "Tweener.hx", lineNumber : 74, className : "caurina.transitions.Tweener", methodName : "new"});
		}}
		
		static protected var __tweener_controller__ : flash.display.MovieClip;
		static protected var _engineExists : Boolean = false;
		static protected var _inited : Boolean = false;
		static protected var _currentTime : Number;
		static protected var _currentTimeFrame : int;
		static protected var _tweenList : List;
		static protected var _timeScale : Number = 1;
		static protected var _transitionList : *;
		static protected var _specialPropertyList : *;
		static protected var _specialPropertyModifierList : *;
		static protected var _specialPropertySplitterList : *;
		static public var defaultTransition : String = "easeoutcubic";
		static protected var Flds : Function = Reflect.fields;
		static protected var Get : Function = Reflect.field;
		static protected var Set : Function = Reflect.setField;
		static public function addTween(p_scopes : *,p_parameters : *) : Boolean {
			if(p_scopes == null) return false;
			var rScopes : Array = new Array();
			if(Std._is(p_scopes,Array)) {
				rScopes = p_scopes;
			}
			else {
				rScopes = [p_scopes];
			}
			var p_obj : * = caurina.transitions.TweenListObj.makePropertiesChain(p_parameters);
			if(!_inited) init();
			if(!_engineExists || caurina.transitions.Tweener.__tweener_controller__ == null) startEngine();
			var rTime : Number = ((Math["isNaN"](Get(p_obj,"time")))?0:Get(p_obj,"time"));
			var rDelay : Number = ((Math["isNaN"](Get(p_obj,"delay")))?0:Get(p_obj,"delay"));
			var rProperties : * = { }
			var restrictedWords : * = { time : true, delay : true, useFrames : true, skipUpdates : true, transition : true, transitionParams : true, onStart : true, onUpdate : true, onComplete : true, onOverwrite : true, onError : true, rounded : true, onStartParams : true, onUpdateParams : true, onCompleteParams : true, onOverwriteParams : true, onStartScope : true, onUpdateScope : true, onCompleteScope : true, onOverwriteScope : true, onErrorScope : true, quickAdd : true}
			var modifiedProperties : * = { }
			{
				var _g : int = 0, _g1 : Array = Flds(p_obj);
				while(_g < _g1.length) {
					var istr : String = _g1[_g];
					++_g;
					if(!Get(restrictedWords,istr)) {
						if(Get(_specialPropertySplitterList,istr) != null) {
							var splitProperties : Array = Get(_specialPropertySplitterList,istr).splitValues(Get(p_obj,istr),Get(_specialPropertySplitterList,istr).parameters);
							{
								var _g2 : int = 0;
								while(_g2 < splitProperties.length) {
									var prop : * = splitProperties[_g2];
									++_g2;
									if(Get(_specialPropertySplitterList,prop.name) != null) {
										var splitProperties2 : Array = Get(_specialPropertySplitterList,prop.name).splitValues(prop.value,Get(_specialPropertySplitterList,prop.name).parameters);
										{
											var _g3 : int = 0;
											while(_g3 < splitProperties2.length) {
												var prop2 : * = splitProperties2[_g3];
												++_g3;
												Set(rProperties,prop2.name,{ valueStart : null, valueComplete : prop2.value, arrayIndex : prop2.arrayIndex, isSpecialProperty : false});
											}
										}
									}
									else {
										Set(rProperties,prop.name,{ valueStart : null, valueComplete : prop.value, arrayIndex : prop.arrayIndex, isSpecialProperty : false});
									}
								}
							}
						}
						else if(Get(_specialPropertyModifierList,istr) != null) {
							var tempModifiedProperties : Array = Get(_specialPropertyModifierList,istr).modifyValues(Get(p_obj,istr));
							{
								var _g22 : int = 0;
								while(_g22 < tempModifiedProperties.length) {
									var prop3 : * = tempModifiedProperties[_g22];
									++_g22;
									Set(modifiedProperties,prop3.name,{ modifierParameters : prop3.parameters, modifierFunction : Get(_specialPropertyModifierList,istr).getValue});
								}
							}
						}
						else {
							Set(rProperties,istr,{ valueStart : null, valueComplete : Get(p_obj,istr)});
						}
					}
				}
			}
			{
				var _g4 : int = 0, _g12 : Array = Flds(rProperties);
				while(_g4 < _g12.length) {
					var istr2 : String = _g12[_g4];
					++_g4;
					if(Get(_specialPropertyList,istr2) != null) {
						Get(rProperties,istr2).isSpecialProperty = true;
					}
					else {
						if(Get(rScopes[0],istr2) == null) {
							printError("The property '" + istr2 + "' doesn't seem to be a normal object property of " + rScopes[0].toString() + " or a registered special property.");
						}
					}
				}
			}
			{
				var _g5 : int = 0, _g13 : Array = Flds(modifiedProperties);
				while(_g5 < _g13.length) {
					var istr3 : String = _g13[_g5];
					++_g5;
					if(Get(rProperties,istr3) != null) {
						Get(rProperties,istr3).modifierParameters = Get(modifiedProperties,istr3).modifierParameters;
						Get(rProperties,istr3).modifierFunction = Get(modifiedProperties,istr3).modifierFunction;
					}
				}
			}
			var rTransition : * = null;
			if(Std._is(p_obj.transition,String)) {
				var trans : String = p_obj.transition.toLowerCase();
				rTransition = Get(_transitionList,trans);
			}
			else if(Reflect.isFunction(p_obj.transition)) {
				rTransition = p_obj.transition;
			}
			if(rTransition == null) rTransition = Get(_transitionList,defaultTransition);
			var nProperties : *;
			var nTween : caurina.transitions.TweenListObj;
			{
				var _g14 : int = 0, _g6 : int = rScopes.length;
				while(_g14 < _g6) {
					var i : int = _g14++;
					nProperties = { }
					{
						var _g23 : int = 0, _g32 : Array = Flds(rProperties);
						while(_g23 < _g32.length) {
							var istr4 : String = _g32[_g23];
							++_g23;
							Set(nProperties,istr4,new caurina.transitions.PropertyInfoObj(Get(rProperties,istr4).valueStart,Get(rProperties,istr4).valueComplete,Get(rProperties,istr4).valueComplete,Get(rProperties,istr4).arrayIndex,{ },Get(rProperties,istr4).isSpecialProperty,Get(rProperties,istr4).modifierFunction,Get(rProperties,istr4).modifierParameters));
						}
					}
					nTween = new caurina.transitions.TweenListObj(rScopes[i],((p_obj.useFrames)?caurina.transitions.Tweener._currentTimeFrame + rDelay / _timeScale:caurina.transitions.Tweener._currentTime + rDelay * 1000 / _timeScale),((p_obj.useFrames)?caurina.transitions.Tweener._currentTimeFrame + (rDelay + rTime) / _timeScale:caurina.transitions.Tweener._currentTime + (rDelay * 1000 + rTime * 1000) / _timeScale),((p_obj.useFrames)?true:false),rTransition,p_obj.transitionParams);
					nTween.properties = nProperties;
					nTween.onStart = p_obj.onStart;
					nTween.onUpdate = p_obj.onUpdate;
					nTween.onComplete = p_obj.onComplete;
					nTween.onOverwrite = p_obj.onOverwrite;
					nTween.onError = p_obj.onError;
					nTween.onStartParams = p_obj.onStartParams;
					nTween.onUpdateParams = p_obj.onUpdateParams;
					nTween.onCompleteParams = p_obj.onCompleteParams;
					nTween.onOverwriteParams = p_obj.onOverwriteParams;
					nTween.onStartScope = p_obj.onStartScope;
					nTween.onUpdateScope = p_obj.onUpdateScope;
					nTween.onCompleteScope = p_obj.onCompleteScope;
					nTween.onOverwriteScope = p_obj.onOverwriteScope;
					nTween.onErrorScope = p_obj.onErrorScope;
					nTween.rounded = p_obj.rounded;
					nTween.skipUpdates = p_obj.skipUpdates;
					removeTweensByTime(nTween.scope,nTween.properties,nTween.timeStart,nTween.timeComplete);
					_tweenList.add(nTween);
					if(rTime == 0 && rDelay == 0) {
						updateTweenByObj(nTween);
						removeTweenByObj(nTween);
					}
				}
			}
			return true;
		}
		
		static public function addCaller(p_scopes : *,p_parameters : *) : Boolean {
			if(p_scopes == null) return false;
			var rScopes : Array = new Array();
			if(Std._is(p_scopes,Array)) {
				rScopes = p_scopes;
			}
			else {
				rScopes = [p_scopes];
			}
			var p_obj : * = p_parameters;
			if(!_inited) init();
			if(!_engineExists || caurina.transitions.Tweener.__tweener_controller__ == null) startEngine();
			var rTime : Number = ((Math["isNaN"](Get(p_obj,"time")))?0:Get(p_obj,"time"));
			var rDelay : Number = ((Math["isNaN"](Get(p_obj,"delay")))?0:Get(p_obj,"delay"));
			var rTransition : * = null;
			if(Std._is(p_obj.transition,String)) {
				var trans : String = p_obj.transition.toLowerCase();
				rTransition = Get(_transitionList,trans);
			}
			else if(Reflect.isFunction(p_obj.transition)) {
				rTransition = p_obj.transition;
			}
			if(rTransition == null) rTransition = Get(_transitionList,defaultTransition);
			var nTween : caurina.transitions.TweenListObj;
			{
				var _g1 : int = 0, _g : int = rScopes.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					nTween = new caurina.transitions.TweenListObj(rScopes[i],((p_obj.useFrames)?caurina.transitions.Tweener._currentTimeFrame + rDelay / _timeScale:caurina.transitions.Tweener._currentTime + rDelay * 1000 / _timeScale),((p_obj.useFrames)?caurina.transitions.Tweener._currentTimeFrame + (rDelay + rTime) / _timeScale:caurina.transitions.Tweener._currentTime + (rDelay * 1000 + rTime * 1000) / _timeScale),((p_obj.useFrames)?true:false),rTransition,p_obj.transitionParams);
					nTween.properties = null;
					nTween.onStart = p_obj.onStart;
					nTween.onUpdate = p_obj.onUpdate;
					nTween.onComplete = p_obj.onComplete;
					nTween.onOverwrite = p_obj.onOverwrite;
					nTween.onStartParams = p_obj.onStartParams;
					nTween.onUpdateParams = p_obj.onUpdateParams;
					nTween.onCompleteParams = p_obj.onCompleteParams;
					nTween.onOverwriteParams = p_obj.onOverwriteParams;
					nTween.onStartScope = p_obj.onStartScope;
					nTween.onUpdateScope = p_obj.onUpdateScope;
					nTween.onCompleteScope = p_obj.onCompleteScope;
					nTween.onOverwriteScope = p_obj.onOverwriteScope;
					nTween.onErrorScope = p_obj.onErrorScope;
					nTween.isCaller = true;
					nTween.count = p_obj.count;
					nTween.waitFrames = p_obj.waitFrames;
					_tweenList.add(nTween);
					if(rTime == 0 && rDelay == 0) {
						updateTweenByObj(nTween);
						removeTweenByObj(nTween);
					}
				}
			}
			return true;
		}
		
		static public function removeTweensByTime(p_scope : *,p_properties : *,p_timeStart : Number,p_timeComplete : Number) : Boolean {
			var removed : Boolean = false;
			var removedLocally : Boolean;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			{
				if(p_scope == obj.scope) {
					if(p_timeComplete > obj.timeStart && p_timeStart < obj.timeComplete) {
						removedLocally = false;
						{
							var _g : int = 0, _g1 : Array = Flds(obj.properties);
							while(_g < _g1.length) {
								var pName : String = _g1[_g];
								++_g;
								if(Get(p_properties,pName) != null) {
									if(obj.onOverwrite != null) {
										var eventScope : * = ((obj.onOverwriteScope != null)?obj.onOverwriteScope:obj.scope);
										try {
											Reflect.callMethod(eventScope,obj.onOverwrite,obj.onOverwriteParams);
										}
										catch( e : * ){
											handleError(obj,e,"onOverwrite");
										}
									}
									Set(obj.properties,pName,null);
									removedLocally = true;
									removed = true;
								}
							}
						}
						if(removedLocally) {
							if(caurina.transitions.AuxFunctions.getObjectLength(obj.properties) == 0) removeTweenByObj(obj);
						}
					}
				}
			}
			}}
			return removed;
		}
		
		static public function removeTweens(p_scope : *,args : Array) : Boolean {
			var properties : Array = new Array();
			{
				var _g : int = 0;
				while(_g < args.length) {
					var arg : String = args[_g];
					++_g;
					if(!caurina.transitions.AuxFunctions.isInArray(arg,properties)) {
						if(Get(_specialPropertySplitterList,arg) != null) {
							var sps : caurina.transitions.SpecialPropertySplitter = Get(_specialPropertySplitterList,arg);
							var specialProps : Array = sps.splitValues(p_scope,null);
							{
								var _g1 : int = 0;
								while(_g1 < specialProps.length) {
									var prop : * = specialProps[_g1];
									++_g1;
									properties.push(prop.name);
								}
							}
						}
						else {
							properties.push(arg);
						}
					}
				}
			}
			return affectTweens(caurina.transitions.Tweener.removeTweenByObj,p_scope,properties);
		}
		
		static public function removeAllTweens() : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			else if(_tweenList.isEmpty()) return false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			{
				removeTweenByObj(obj);
			}
			}}
			return true;
		}
		
		static public function pauseTweens(p_scope : *,args : Array) : Boolean {
			var properties : Array = new Array();
			{
				var _g : int = 0;
				while(_g < args.length) {
					var arg : String = args[_g];
					++_g;
					if(Std._is(arg,String) && !caurina.transitions.AuxFunctions.isInArray(arg,properties)) properties.push(arg);
				}
			}
			return affectTweens(caurina.transitions.Tweener.pauseTweenByObj,p_scope,properties);
		}
		
		static public function pauseAllTweens() : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			else if(_tweenList.isEmpty()) return false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			{
				pauseTweenByObj(obj);
			}
			}}
			return true;
		}
		
		static public function resumeTweens(p_scope : *,args : Array) : Boolean {
			var properties : Array = new Array();
			{
				var _g : int = 0;
				while(_g < args.length) {
					var arg : String = args[_g];
					++_g;
					if(Std._is(arg,String) && !caurina.transitions.AuxFunctions.isInArray(arg,properties)) properties.push(arg);
				}
			}
			return affectTweens(caurina.transitions.Tweener.resumeTweenByObj,p_scope,properties);
		}
		
		static public function resumeAllTweens() : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			else if(_tweenList.isEmpty()) return false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			{
				resumeTweenByObj(obj);
			}
			}}
			return true;
		}
		
		static protected function affectTweens(p_affectFunction : *,p_scope : *,p_properties : Array) : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			else if(_tweenList.isEmpty()) return false;
			var affected : Boolean = false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			{
				if(obj.scope == p_scope) {
					if(p_properties.length == 0) {
						p_affectFunction(obj);
						affected = true;
					}
					else {
						var affectedProperties : Array = new Array();
						{
							var _g : int = 0;
							while(_g < p_properties.length) {
								var prop : String = p_properties[_g];
								++_g;
								if(Get(obj.properties,prop) != null) affectedProperties.push(prop);
							}
						}
						if(affectedProperties.length > 0) {
							var objectProperties : int = caurina.transitions.AuxFunctions.getObjectLength(obj.properties);
							if(objectProperties == affectedProperties.length) {
								p_affectFunction(obj);
							}
							else {
								var slicedTweenObj : caurina.transitions.TweenListObj = splitTweens(obj,affectedProperties);
								p_affectFunction(slicedTweenObj);
							}
							affected = true;
						}
					}
				}
			}
			}}
			return affected;
		}
		
		static public function splitTweens(originalTween : caurina.transitions.TweenListObj,p_properties : Array) : caurina.transitions.TweenListObj {
			var newTween : caurina.transitions.TweenListObj = originalTween.clone(false);
			{
				var _g : int = 0;
				while(_g < p_properties.length) {
					var prop : String = p_properties[_g];
					++_g;
					Set(originalTween.properties,prop,null);
				}
			}
			var found : Boolean;
			{
				var _g2 : int = 0, _g1 : Array = Flds(newTween.properties);
				while(_g2 < _g1.length) {
					var pName : String = _g1[_g2];
					++_g2;
					found = false;
					{
						var _g22 : int = 0;
						while(_g22 < p_properties.length) {
							var prop2 : String = p_properties[_g22];
							++_g22;
							if(prop2 == pName) {
								found = true;
								break;
							}
						}
					}
					if(!found) {
						Set(newTween.properties,pName,null);
					}
				}
			}
			_tweenList.add(newTween);
			return newTween;
		}
		
		static protected function updateTweens() : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			else if(_tweenList.isEmpty()) return false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var obj : caurina.transitions.TweenListObj = $it.next();
			if(!obj.isPaused) if(!updateTweenByObj(obj)) removeTweenByObj(obj);
			}}
			return true;
		}
		
		static public function removeTweenByObj(p_tween : caurina.transitions.TweenListObj) : Boolean {
			return _tweenList.remove(p_tween);
		}
		
		static public function pauseTweenByObj(p_tween : caurina.transitions.TweenListObj) : Boolean {
			if(p_tween == null) return false;
			else if(p_tween.isPaused) return false;
			p_tween.timePaused = getCurrentTweeningTime(p_tween);
			p_tween.isPaused = true;
			return true;
		}
		
		static public function resumeTweenByObj(p_tween : caurina.transitions.TweenListObj) : Boolean {
			if(p_tween == null) return false;
			else if(!p_tween.isPaused) return false;
			var cTime : Number = getCurrentTweeningTime(p_tween);
			p_tween.timeStart += cTime - p_tween.timePaused;
			p_tween.timeComplete += cTime - p_tween.timePaused;
			p_tween.timePaused = null;
			p_tween.isPaused = false;
			return true;
		}
		
		static protected function updateTweenByObj(p_tween : caurina.transitions.TweenListObj) : Boolean {
			if(p_tween == null) return false;
			else if(p_tween.scope == null) return false;
			var isOver : Boolean = false;
			var mustUpdate : Boolean;
			var nv : Number;
			var t : Number;
			var b : Number;
			var c : Number;
			var d : Number;
			var pName : String;
			var eventScope : *;
			var tScope : *;
			var cTime : Number = getCurrentTweeningTime(p_tween);
			var tProperty : *;
			if(cTime >= p_tween.timeStart) {
				tScope = p_tween.scope;
				if(p_tween.isCaller) {
					do {
						t = (p_tween.timeComplete - p_tween.timeStart) / p_tween.count * (p_tween.timesCalled + 1);
						b = p_tween.timeStart;
						c = p_tween.timeComplete - p_tween.timeStart;
						d = p_tween.timeComplete - p_tween.timeStart;
						nv = p_tween.transition(t,b,c,d,null);
						if(cTime >= nv) {
							if(p_tween.onUpdate != null) {
								eventScope = ((p_tween.onUpdateScope != null)?p_tween.onUpdateScope:tScope);
								try {
									Reflect.callMethod(eventScope,p_tween.onUpdate,p_tween.onUpdateParams);
								}
								catch( e : * ){
									handleError(p_tween,e,"onUpdate");
								}
							}
							p_tween.timesCalled++;
							if(p_tween.timesCalled >= p_tween.count) {
								isOver = true;
								break;
							}
							if(p_tween.waitFrames) break;
						}
					} while(cTime >= nv);
				}
				else {
					mustUpdate = p_tween.skipUpdates < 1 || p_tween.skipUpdates == null || p_tween.updatesSkipped >= p_tween.skipUpdates;
					if(cTime >= p_tween.timeComplete) {
						isOver = true;
						mustUpdate = true;
					}
					if(!p_tween.hasStarted) {
						if(p_tween.onStart != null) {
							eventScope = ((p_tween.onStartScope != null)?p_tween.onStartScope:tScope);
							try {
								Reflect.callMethod(eventScope,p_tween.onStart,p_tween.onStartParams);
							}
							catch( e2 : * ){
								handleError(p_tween,e2,"onStart");
							}
						}
						var pv : Number = 0;
						{
							var _g : int = 0, _g1 : Array = Flds(p_tween.properties);
							while(_g < _g1.length) {
								var pName1 : String = _g1[_g];
								++_g;
								if(Get(p_tween.properties,pName1).isSpecialProperty) {
									if(Get(_specialPropertyList,pName1) != null) {
										if(Get(_specialPropertyList,pName1).preProcess != null) {
											Get(p_tween.properties,pName1).valueComplete = Get(_specialPropertyList,pName1).preProcess(tScope,Get(_specialPropertyList,pName1).parameters,Get(p_tween.properties,pName1).originalValueComplete,Get(p_tween.properties,pName1).extra);
										}
										pv = Get(_specialPropertyList,pName1).getValue(tScope,Get(_specialPropertyList,pName1).parameters,Get(p_tween.properties,pName1).extra);
									}
								}
								else {
									pv = Get(tScope,pName1);
								}
								Get(p_tween.properties,pName1).valueStart = ((Math["isNaN"](pv))?Get(p_tween.properties,pName1).valueComplete:pv);
							}
						}
						mustUpdate = true;
						p_tween.hasStarted = true;
					}
					if(mustUpdate) {
						{
							var _g2 : int = 0, _g12 : Array = Flds(p_tween.properties);
							while(_g2 < _g12.length) {
								var pName12 : String = _g12[_g2];
								++_g2;
								tProperty = Get(p_tween.properties,pName12);
								if(tProperty == null) return false;
								if(isOver) {
									nv = tProperty.valueComplete;
								}
								else {
									if(tProperty.hasModifier) {
										t = cTime - p_tween.timeStart;
										d = p_tween.timeComplete - p_tween.timeStart;
										nv = p_tween.transition(t,0,1,d,p_tween.transitionParams);
										nv = tProperty.modifierFunction(tProperty.valueStart,tProperty.valueComplete,nv,tProperty.modifierParameters);
									}
									else {
										t = cTime - p_tween.timeStart;
										b = tProperty.valueStart;
										c = tProperty.valueComplete - tProperty.valueStart;
										d = p_tween.timeComplete - p_tween.timeStart;
										nv = p_tween.transition(t,b,c,d,p_tween.transitionParams);
									}
								}
								if(p_tween.rounded) nv = Math.round(nv);
								if(tProperty.isSpecialProperty) {
									Get(_specialPropertyList,pName12).setValue(tScope,nv,Get(_specialPropertyList,pName12).parameters,Get(p_tween.properties,pName12).extra);
								}
								else {
									Set(tScope,pName12,nv);
								}
							}
						}
						p_tween.updatesSkipped = 0;
						if(p_tween.onUpdate != null) {
							eventScope = ((p_tween.onUpdateScope != null)?p_tween.onUpdateScope:tScope);
							try {
								Reflect.callMethod(eventScope,p_tween.onUpdate,p_tween.onUpdateParams);
							}
							catch( e3 : * ){
								handleError(p_tween,e3,"onUpdate");
							}
						}
					}
					else {
						p_tween.updatesSkipped++;
					}
				}
				if(isOver && p_tween.onComplete != null) {
					eventScope = ((p_tween.onCompleteScope != null)?p_tween.onCompleteScope:tScope);
					try {
						Reflect.callMethod(eventScope,p_tween.onComplete,p_tween.onCompleteParams);
					}
					catch( e4 : * ){
						handleError(p_tween,e4,"onComplete");
					}
				}
				return !isOver;
			}
			return true;
		}
		
		static protected function init() : void {
			caurina.transitions.Tweener._inited = true;
			caurina.transitions.Tweener._transitionList = { }
			caurina.transitions.Equations.init();
			caurina.transitions.Tweener._specialPropertyList = { }
			caurina.transitions.Tweener._specialPropertyModifierList = { }
			caurina.transitions.Tweener._specialPropertySplitterList = { }
		}
		
		static public function registerTransition(p_name : String,p_function : *) : void {
			if(!_inited) init();
			Set(_transitionList,p_name,p_function);
		}
		
		static public function registerSpecialProperty(p_name : String,p_getFunction : *,p_setFunction : *,p_parameters : Array = null,p_preProcessFunction : * = null) : void {
			if(!_inited) init();
			var sp : caurina.transitions.SpecialProperty = new caurina.transitions.SpecialProperty(p_getFunction,p_setFunction,p_parameters,p_preProcessFunction);
			Set(_specialPropertyList,p_name,sp);
		}
		
		static public function registerSpecialPropertyModifier(p_name : String,p_modifyFunction : *,p_getFunction : *) : void {
			if(!_inited) init();
			var spm : caurina.transitions.SpecialPropertyModifier = new caurina.transitions.SpecialPropertyModifier(p_modifyFunction,p_getFunction);
			Set(_specialPropertyModifierList,p_name,spm);
		}
		
		static public function registerSpecialPropertySplitter(p_name : String,p_splitFunction : *,p_parameters : Array = null) : void {
			if(!_inited) init();
			var sps : caurina.transitions.SpecialPropertySplitter = new caurina.transitions.SpecialPropertySplitter(p_splitFunction,p_parameters);
			Set(_specialPropertySplitterList,p_name,sps);
		}
		
		static protected function startEngine() : void {
			caurina.transitions.Tweener._engineExists = true;
			caurina.transitions.Tweener._tweenList = new List();
			caurina.transitions.Tweener.__tweener_controller__ = new flash.display.MovieClip();
			__tweener_controller__.addEventListener(flash.events.Event.ENTER_FRAME,caurina.transitions.Tweener.onEnterFrame);
			caurina.transitions.Tweener._currentTimeFrame = 0;
			updateTime();
		}
		
		static protected function stopEngine() : void {
			caurina.transitions.Tweener._engineExists = false;
			caurina.transitions.Tweener._tweenList = null;
			caurina.transitions.Tweener._currentTime = 0;
			caurina.transitions.Tweener._currentTimeFrame = 0;
			__tweener_controller__.removeEventListener(flash.events.Event.ENTER_FRAME,caurina.transitions.Tweener.onEnterFrame);
			caurina.transitions.Tweener.__tweener_controller__ = null;
		}
		
		static public function updateTime() : void {
			caurina.transitions.Tweener._currentTime = flash.Lib._getTimer();
		}
		
		static public function updateFrame() : void {
			_currentTimeFrame++;
		}
		
		static public function onEnterFrame(e : flash.events.Event) : void {
			updateTime();
			updateFrame();
			var hasUpdated : Boolean = false;
			hasUpdated = updateTweens();
			if(!hasUpdated) stopEngine();
		}
		
		static public function setTimeScale(p_time : Number) : void {
			if(Math["isNaN"](p_time)) p_time = 1;
			if(p_time < 0.00001) p_time = 0.00001;
			if(p_time != _timeScale) {
				{ var $it : * = _tweenList.iterator();
				while( $it.hasNext() ) { var tweenListObj : caurina.transitions.TweenListObj = $it.next();
				{
					var cTime : Number = getCurrentTweeningTime(tweenListObj);
					tweenListObj.timeStart = cTime - (cTime - tweenListObj.timeStart) * _timeScale / p_time;
					tweenListObj.timeComplete = cTime - (cTime - tweenListObj.timeComplete) * _timeScale / p_time;
					if(tweenListObj.timePaused != null) tweenListObj.timePaused = cTime - (cTime - tweenListObj.timePaused) * _timeScale / p_time;
				}
				}}
				caurina.transitions.Tweener._timeScale = p_time;
			}
		}
		
		static public function isTweening(p_scope : *) : Boolean {
			if(caurina.transitions.Tweener._tweenList == null) return false;
			if(_tweenList.length == 0) return false;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var tweenListObj : caurina.transitions.TweenListObj = $it.next();
			if(tweenListObj.scope == p_scope) return true;
			}}
			return false;
		}
		
		static public function getTweens(p_scope : *) : Array {
			if(caurina.transitions.Tweener._tweenList == null) return [];
			if(_tweenList.length == 0) return [];
			var tList : Array = new Array();
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var tweenListObj : caurina.transitions.TweenListObj = $it.next();
			if(tweenListObj.scope == p_scope) {
				var _g : int = 0, _g1 : Array = Flds(tweenListObj.properties);
				while(_g < _g1.length) {
					var pName : String = _g1[_g];
					++_g;
					tList.push(pName);
				}
			}
			}}
			return tList;
		}
		
		static public function getTweenCount(p_scope : *) : int {
			if(caurina.transitions.Tweener._tweenList == null) return 0;
			if(_tweenList.length == 0) return 0;
			var c : int = 0;
			{ var $it : * = _tweenList.iterator();
			while( $it.hasNext() ) { var tweenListObj : caurina.transitions.TweenListObj = $it.next();
			if(tweenListObj.scope == p_scope) c += caurina.transitions.AuxFunctions.getObjectLength(tweenListObj.properties);
			}}
			return c;
		}
		
		static protected function handleError(pTweening : caurina.transitions.TweenListObj,pError : *,pCallBackName : String) : void {
			if(pTweening.onError != null && Reflect.isFunction(pTweening.onError)) {
				var eventScope : * = ((pTweening.onErrorScope != null)?pTweening.onErrorScope:pTweening.scope);
				try {
					Reflect.callMethod(eventScope,pTweening.onError,[pTweening.scope,pError]);
				}
				catch( metaError : * ){
					printError(pTweening.scope.toString() + " raised an error while executing the 'onError' handler. Original error:\n " + pError + "\nonError error: " + metaError);
				}
			}
			else {
				if(pTweening.onError == null) {
					printError(pTweening.scope.toString() + " raised an error while executing the '" + pCallBackName.toString() + "'handler. \n" + pError);
				}
			}
		}
		
		static public function getCurrentTweeningTime(p_tweening : *) : Number {
			return ((Get(p_tweening,"useFrames"))?_currentTimeFrame:_currentTime);
		}
		
		static public function getVersion() : String {
			return "haXe2 1.31.74";
		}
		
		static public function getControllerName() : String {
			return "__tweener_controller__" + getVersion();
		}
		
		static public function printError(p_message : String) : void {
			haxe.Log.trace("## [Tweener] Error: " + p_message,{ fileName : "Tweener.hx", lineNumber : 1205, className : "caurina.transitions.Tweener", methodName : "printError"});
		}
		
	}
}
