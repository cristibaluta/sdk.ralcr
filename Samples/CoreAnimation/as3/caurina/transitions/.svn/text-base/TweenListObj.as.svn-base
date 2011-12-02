package caurina.transitions {
	import caurina.transitions.AuxFunctions;
	import flash.Boot;
	public class TweenListObj {
		public function TweenListObj(p_scope : * = null,p_timeStart : Number = NaN,p_timeComplete : Number = NaN,p_useFrames : Boolean = false,p_transition : * = null,p_transitionParams : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.scope = p_scope;
			this.timeStart = p_timeStart;
			this.timeComplete = p_timeComplete;
			this.useFrames = p_useFrames;
			this.transition = p_transition;
			this.transitionParams = p_transitionParams;
			this.properties = { }
			this.isPaused = false;
			this.timePaused = null;
			this.isCaller = false;
			this.updatesSkipped = 0;
			this.timesCalled = 0;
			this.skipUpdates = 0;
			this.hasStarted = false;
		}}
		
		public var scope : *;
		public var properties : *;
		public var valueStart : *;
		public var valueComplete : *;
		public var timeStart : *;
		public var timeComplete : *;
		public var useFrames : Boolean;
		public var transition : *;
		public var transitionParams : *;
		public var onStart : *;
		public var onUpdate : *;
		public var onComplete : *;
		public var onOverwrite : *;
		public var onError : *;
		public var onStartParams : Array;
		public var onUpdateParams : Array;
		public var onCompleteParams : Array;
		public var onOverwriteParams : Array;
		public var onStartScope : *;
		public var onUpdateScope : *;
		public var onCompleteScope : *;
		public var onOverwriteScope : *;
		public var onErrorScope : *;
		public var rounded : Boolean;
		public var isPaused : Boolean;
		public var timePaused : *;
		public var isCaller : Boolean;
		public var count : *;
		public var timesCalled : *;
		public var waitFrames : Boolean;
		public var skipUpdates : *;
		public var updatesSkipped : *;
		public var hasStarted : Boolean;
		public function clone(omitEvents : Boolean) : caurina.transitions.TweenListObj {
			var nTween : caurina.transitions.TweenListObj = new caurina.transitions.TweenListObj(this.scope,this.timeStart,this.timeComplete,this.useFrames,this.transition,this.transitionParams);
			nTween.properties = { }
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this.properties);
				while(_g < _g1.length) {
					var pName : String = _g1[_g];
					++_g;
					Reflect.setField(nTween.properties,pName,Reflect.field(this.properties,pName).clone());
				}
			}
			nTween.skipUpdates = this.skipUpdates;
			nTween.updatesSkipped = this.updatesSkipped;
			if(!omitEvents) {
				nTween.onStart = this.onStart;
				nTween.onUpdate = this.onUpdate;
				nTween.onComplete = this.onComplete;
				nTween.onOverwrite = this.onOverwrite;
				nTween.onError = this.onError;
				nTween.onStartParams = this.onStartParams;
				nTween.onUpdateParams = this.onUpdateParams;
				nTween.onCompleteParams = this.onCompleteParams;
				nTween.onOverwriteParams = this.onOverwriteParams;
				nTween.onStartScope = this.onStartScope;
				nTween.onUpdateScope = this.onUpdateScope;
				nTween.onCompleteScope = this.onCompleteScope;
				nTween.onOverwriteScope = this.onOverwriteScope;
				nTween.onErrorScope = this.onErrorScope;
			}
			nTween.rounded = this.rounded;
			nTween.isPaused = this.isPaused;
			nTween.timePaused = this.timePaused;
			nTween.isCaller = this.isCaller;
			nTween.count = this.count;
			nTween.timesCalled = this.timesCalled;
			nTween.waitFrames = this.waitFrames;
			nTween.hasStarted = this.hasStarted;
			return nTween;
		}
		
		public function toString() : String {
			var returnStr : String = "\n[TweenListObj ";
			returnStr += "scope:" + Std.string(this.scope);
			returnStr += ", properties:";
			var isFirst : Boolean = true;
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(this.properties);
				while(_g < _g1.length) {
					var i : String = _g1[_g];
					++_g;
					if(!isFirst) returnStr += ",";
					returnStr += "[name:" + Std.string(Reflect.field(this.properties,i).name);
					returnStr += ",valueStart:" + Std.string(Reflect.field(this.properties,i).valueStart);
					returnStr += ",valueComplete:" + Std.string(Reflect.field(this.properties,i).valueComplete);
					returnStr += "]";
					isFirst = false;
				}
			}
			returnStr += ", timeStart:" + Std.string(this.timeStart);
			returnStr += ", timeComplete:" + Std.string(this.timeComplete);
			returnStr += ", useFrames:" + Std.string(this.useFrames);
			returnStr += ", transition:" + Std.string(this.transition);
			returnStr += ", transitionParams:" + Std.string(this.transitionParams);
			if(this.skipUpdates != 0) returnStr += ", skipUpdates:" + Std.string(this.skipUpdates);
			if(this.updatesSkipped != 0) returnStr += ", updatesSkipped:" + Std.string(this.updatesSkipped);
			if(this.onStart) returnStr += ", onStart:" + Std.string(this.onStart);
			if(this.onUpdate) returnStr += ", onUpdate:" + Std.string(this.onUpdate);
			if(this.onComplete) returnStr += ", onComplete:" + Std.string(this.onComplete);
			if(this.onOverwrite) returnStr += ", onOverwrite:" + Std.string(this.onOverwrite);
			if(this.onError) returnStr += ", onError:" + Std.string(this.onError);
			if(this.onStartParams.length > 0) returnStr += ", onStartParams:" + Std.string(this.onStartParams);
			if(this.onUpdateParams.length > 0) returnStr += ", onUpdateParams:" + Std.string(this.onUpdateParams);
			if(this.onCompleteParams.length > 0) returnStr += ", onCompleteParams:" + Std.string(this.onCompleteParams);
			if(this.onOverwriteParams.length > 0) returnStr += ", onOverwriteParams:" + Std.string(this.onOverwriteParams);
			if(this.onStartScope) returnStr += ", onStartScope:" + Std.string(this.onStartScope);
			if(this.onUpdateScope) returnStr += ", onUpdateScope:" + Std.string(this.onUpdateScope);
			if(this.onCompleteScope) returnStr += ", onCompleteScope:" + Std.string(this.onCompleteScope);
			if(this.onOverwriteScope) returnStr += ", onOverwriteScope:" + Std.string(this.onOverwriteScope);
			if(this.onErrorScope) returnStr += ", onErrorScope:" + Std.string(this.onErrorScope);
			if(this.rounded) returnStr += ", rounded:" + Std.string(this.rounded);
			if(this.isPaused) returnStr += ", isPaused:" + Std.string(this.isPaused);
			if(this.timePaused != null) returnStr += ", timePaused:" + Std.string(this.timePaused);
			if(this.isCaller) returnStr += ", isCaller:" + Std.string(this.isCaller);
			if(this.count != 0) returnStr += ", count:" + Std.string(this.count);
			if(this.timesCalled != 0) returnStr += ", timesCalled:" + Std.string(this.timesCalled);
			if(this.waitFrames) returnStr += ", waitFrames:" + Std.string(this.waitFrames);
			if(this.hasStarted) returnStr += ", hasStarted:" + Std.string(this.hasStarted);
			returnStr += "]\n";
			return returnStr;
		}
		
		static public function makePropertiesChain(p_obj : *) : * {
			var baseObject : * = p_obj.base;
			if(baseObject != null) {
				var chainedObject : * = { }
				var chain : Array;
				if(Std._is(baseObject,Array)) {
					chain = [];
					{
						var _g1 : int = 0, _g : int = Reflect.fields(baseObject).length;
						while(_g1 < _g) {
							var i : int = _g1++;
							chain.push(baseObject[i]);
						}
					}
				}
				else {
					chain = [baseObject];
				}
				chain.push(p_obj);
				var currChainObj : *;
				{
					var _g2 : int = 0;
					while(_g2 < chain.length) {
						var chainObj : * = chain[_g2];
						++_g2;
						if(Reflect.hasField(chainObj,"base")) {
							currChainObj = caurina.transitions.AuxFunctions.concatObjects([makePropertiesChain(Reflect.field(chainObj,"base")),chainObj]);
						}
						else {
							currChainObj = chainObj;
						}
						chainedObject = caurina.transitions.AuxFunctions.concatObjects([chainedObject,currChainObj]);
					}
				}
				if(Reflect.hasField(chainedObject,"base")) {
					Reflect.setField(chainedObject,"base",null);
				}
				return chainedObject;
			}
			else {
				return p_obj;
			}
		}
		
	}
}
