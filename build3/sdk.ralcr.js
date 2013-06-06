(function () { "use strict";
var $hxClasses = {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var CAObject = function(target,properties,duration,delay,Eq,pos) {
	this.target = target;
	this.properties = properties;
	this.repeatCount = 0;
	this.autoreverses = false;
	this.startPointPassed = false;
	this.fromTime = new Date().getTime();
	this.duration = duration == null?RCAnimation.defaultDuration:duration <= 0?0.001:duration;
	this.delay = delay == null || delay < 0?0:delay;
	if(Eq == null) this.timingFunction = RCAnimation.defaultTimingFunction; else this.timingFunction = Eq;
	this.pos = pos;
	this.fromValues = { };
	this.toValues = { };
};
$hxClasses["CAObject"] = CAObject;
CAObject.__name__ = ["CAObject"];
CAObject.prototype = {
	toString: function() {
		return "[CAObject: target=" + Std.string(this.target) + ", duration=" + this.duration + ", delay=" + this.delay + ", fromTime=" + this.fromTime + ", properties=" + Std.string(this.properties) + ", repeatCount=" + this.repeatCount + "]";
	}
	,calculate: function(time_diff,prop) {
		return this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null);
	}
	,repeat: function() {
		this.fromTime = new Date().getTime();
		this.delay = 0;
		if(this.autoreverses) {
			var v = this.fromValues;
			this.fromValues = this.toValues;
			this.toValues = v;
		}
		this.repeatCount--;
		if(Reflect.isFunction(this.animationDidReversed)) this.animationDidReversed.apply(null,this["arguments"]);
	}
	,stop: function() {
		if(Reflect.isFunction(this.animationDidStop)) try {
			this.animationDidStop.apply(null,this["arguments"]);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CAObject.hx", lineNumber : 107, className : "CAObject", methodName : "stop"});
			haxe.Log.trace(this.pos.className + " -> " + this.pos.methodName + " -> " + this.pos.lineNumber,{ fileName : "CAObject.hx", lineNumber : 108, className : "CAObject", methodName : "stop"});
			var stack = haxe.CallStack.exceptionStack();
			haxe.Log.trace(haxe.CallStack.toString(stack),{ fileName : "CAObject.hx", lineNumber : 110, className : "CAObject", methodName : "stop"});
		}
	}
	,start: function() {
		this.startPointPassed = true;
		if(Reflect.isFunction(this.animationDidStart)) try {
			this.animationDidStart.apply(null,this["arguments"]);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CAObject.hx", lineNumber : 95, className : "CAObject", methodName : "start"});
		}
	}
	,initTime: function() {
		this.fromTime = new Date().getTime();
		this.duration = this.duration * 1000;
		this.delay = this.delay * 1000;
	}
	,animate: function(time_diff) {
		throw "CAObject can't be used directly, use a CATransition (" + Std.string(this.pos) + ")";
	}
	,init: function() {
		throw "CAObject can't be used directly, use a CATransition (" + Std.string(this.pos) + ")";
	}
	,pos: null
	,'arguments': null
	,animationDidReversed: null
	,animationDidStop: null
	,animationDidStart: null
	,constraintBounds: null
	,timingFunction: null
	,autoreverses: null
	,startPointPassed: null
	,repeatCount: null
	,duration: null
	,delay: null
	,fromTime: null
	,toValues: null
	,fromValues: null
	,properties: null
	,next: null
	,prev: null
	,target: null
	,__class__: CAObject
}
var CATransitionInterface = function() { }
$hxClasses["CATransitionInterface"] = CATransitionInterface;
CATransitionInterface.__name__ = ["CATransitionInterface"];
CATransitionInterface.prototype = {
	animate: null
	,init: null
	,__class__: CATransitionInterface
}
var CATCallFunc = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATCallFunc"] = CATCallFunc;
CATCallFunc.__name__ = ["CATCallFunc"];
CATCallFunc.__interfaces__ = [CATransitionInterface];
CATCallFunc.__super__ = CAObject;
CATCallFunc.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			try {
				this.target(this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null));
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATCallFunc.hx", lineNumber : 41, className : "CATCallFunc", methodName : "animate"});
			}
		}
	}
	,init: function() {
		if(!Reflect.isFunction(this.target)) throw "Function must be of type: Float->Void";
		var _g = 0, _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(js.Boot.__instanceof(Reflect.field(this.properties,p),Int) || js.Boot.__instanceof(Reflect.field(this.properties,p),Float)) {
				this.fromValues[p] = 0;
				this.toValues[p] = Reflect.field(this.properties,p);
			} else try {
				this.fromValues[p] = Reflect.field(Reflect.field(this.properties,p),"fromValue");
				try {
					this.target(Reflect.field(this.fromValues,p));
				} catch( e ) {
					haxe.Log.trace(e,{ fileName : "CATCallFunc.hx", lineNumber : 28, className : "CATCallFunc", methodName : "init"});
				}
				this.toValues[p] = Reflect.field(Reflect.field(this.properties,p),"toValue");
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATCallFunc.hx", lineNumber : 31, className : "CATCallFunc", methodName : "init"});
			}
		}
	}
	,__class__: CATCallFunc
});
var CATColors = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATColors"] = CATColors;
CATColors.__name__ = ["CATColors"];
CATColors.__interfaces__ = [CATransitionInterface];
CATColors.__super__ = CAObject;
CATColors.prototype = $extend(CAObject.prototype,{
	resetColors: function(obj) {
	}
	,numberToB: function(p_num) {
		return p_num & 255;
	}
	,numberToG: function(p_num) {
		return (p_num & 65280) >> 8;
	}
	,numberToR: function(p_num) {
		return (p_num & 16711680) >> 16;
	}
	,setColorTransform: function(obj,prop,value) {
	}
	,getColorTransform: function(obj,param) {
		return 0;
	}
	,animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			this.setColorTransform(this.target,prop,Math.round(this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null)));
		}
	}
	,init: function() {
		var toMultiplier = 1;
		var fromOffset = null;
		var toOffset = null;
		var fromAlpha = 0;
		var toAlpha = null;
		var toColor = null;
		var color = Reflect.field(this.properties,"color");
		if(color != null) {
			if(js.Boot.__instanceof(color,Int)) {
				toColor = color;
				toMultiplier = 0;
			} else if(js.Boot.__instanceof(color,String)) {
				fromAlpha = 0;
				toAlpha = 0;
				var _g = color.toLowerCase();
				switch(_g) {
				case "colorburnout":
					fromOffset = 255;
					toOffset = 0;
					break;
				case "colorburnin":
					fromOffset = 0;
					toOffset = 255;
					break;
				case "colordodgeout":
					fromOffset = -255;
					toOffset = 0;
					break;
				case "colordodgein":
					fromOffset = 0;
					toOffset = -255;
					break;
				}
			} else {
				fromOffset = Reflect.field(color,"fromOffset");
				toOffset = Reflect.field(color,"toOffset");
				var _fromAlpha = Reflect.field(color,"fromAlpha");
				toAlpha = Reflect.field(color,"toAlpha");
				if(_fromAlpha != null) fromAlpha = _fromAlpha;
			}
		}
		var redMultiplier = 0;
		var redOffset = 0;
		var greenMultiplier = 0;
		var greenOffset = 0;
		var blueMultiplier = 0;
		var blueOffset = 0;
		var alphaMultiplier = 0;
		var alphaOffset = 0;
		this.fromValues = { redMultiplier : redMultiplier, redOffset : fromOffset != null?fromOffset:redOffset, greenMultiplier : greenMultiplier, greenOffset : fromOffset != null?fromOffset:greenOffset, blueMultiplier : blueMultiplier, blueOffset : fromOffset != null?fromOffset:blueOffset, alphaMultiplier : alphaMultiplier, alphaOffset : fromAlpha};
		this.toValues = { redMultiplier : toMultiplier, redOffset : toOffset == null?(toColor & 16711680) >> 16:toOffset, greenMultiplier : toMultiplier, greenOffset : toOffset == null?(toColor & 65280) >> 8:toOffset, blueMultiplier : toMultiplier, blueOffset : toOffset == null?toColor & 255:toOffset, alphaMultiplier : 1, alphaOffset : toColor != null?0:toAlpha};
		var _g = 0, _g1 = Reflect.fields(this.fromValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			this.setColorTransform(this.target,prop,Reflect.field(this.fromValues,prop));
		}
	}
	,__class__: CATColors
});
var CATFrames = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATFrames"] = CATFrames;
CATFrames.__name__ = ["CATFrames"];
CATFrames.__interfaces__ = [CATransitionInterface];
CATFrames.__super__ = CAObject;
CATFrames.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
	}
	,init: function() {
		var fromFrame = this.target.currentFrame;
		var toFrame = this.target.currentFrame;
		var frame = Reflect.field(this.properties,"frame");
		if(frame != null) {
			if(js.Boot.__instanceof(frame,Int) || js.Boot.__instanceof(frame,Float)) toFrame = Math.round(frame); else {
				var _fromFrame = Reflect.field(frame,"fromValue");
				var _toFrame = Reflect.field(frame,"toValue");
				if(_fromFrame != null) fromFrame = _fromFrame;
				if(_toFrame != null) toFrame = _toFrame;
			}
		}
		this.fromValues = { frame : fromFrame};
		this.toValues = { frame : toFrame};
	}
	,__class__: CATFrames
});
var CATKenBurns = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATKenBurns"] = CATKenBurns;
CATKenBurns.__name__ = ["CATKenBurns"];
CATKenBurns.__interfaces__ = [CATransitionInterface];
CATKenBurns.__super__ = CAObject;
CATKenBurns.prototype = $extend(CAObject.prototype,{
	kbOut: function() {
		this.kenBurnsPointOutPassed = true;
		if(Reflect.isFunction(this.kenBurnsBeginsFadingOut)) try {
			this.kenBurnsBeginsFadingOut.apply(null,this["arguments"]);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CATKenBurns.hx", lineNumber : 166, className : "CATKenBurns", methodName : "kbOut"});
		}
	}
	,kbIn: function() {
		this.kenBurnsPointInPassed = true;
		if(Reflect.isFunction(this.kenBurnsDidFadedIn)) try {
			this.kenBurnsDidFadedIn.apply(null,this["arguments"]);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CATKenBurns.hx", lineNumber : 159, className : "CATKenBurns", methodName : "kbIn"});
		}
	}
	,calculateAlpha: function(time_diff,fromAlpha,toAlpha) {
		var duration = fromAlpha == 0?this.kenBurnsPointIn:this.duration - this.kenBurnsPointOut;
		return this.timingFunction(time_diff,fromAlpha,toAlpha - fromAlpha,duration,null);
	}
	,animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			if(prop != "alpha") this.target[prop] = this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null); else if(time_diff < this.kenBurnsPointIn) this.target[prop] = this.calculateAlpha(time_diff,0,1); else if(time_diff > this.kenBurnsPointOut) this.target[prop] = this.calculateAlpha(time_diff - this.kenBurnsPointOut,1,0);
		}
		if(this.kenBurnsPointIn != null) {
			if(time_diff > this.kenBurnsPointIn && !this.kenBurnsPointInPassed) this.kbIn();
			if(time_diff > this.kenBurnsPointOut && !this.kenBurnsPointOutPassed) this.kbOut();
		}
	}
	,init: function() {
		this.kenBurnsPointInPassed = false;
		this.kenBurnsPointOutPassed = false;
		var random_direction_x = Std.random(10);
		var random_direction_y = Std.random(10);
		this.target.scaleX = 1;
		this.target.scaleY = 1;
		var f_w = this.target.width;
		var f_h = this.target.height;
		var x = this.constraintBounds.origin.x;
		var y = this.constraintBounds.origin.y;
		var w = this.constraintBounds.size.width;
		var h = this.constraintBounds.size.height;
		if(w / this.target.width > h / this.target.height) {
			this.target.width = w;
			this.target.height = w * f_h / f_w;
		} else {
			this.target.height = h;
			this.target.width = h * f_w / f_h;
		}
		if(f_w < w || f_h < h) {
			f_w = this.target.width;
			f_h = this.target.height;
		}
		var f_x = random_direction_x > 5?x - f_w + w:x;
		var f_y = random_direction_y > 5?y - f_h + h:y;
		this.target.x = random_direction_x > 5?x:x - this.target.width + w;
		this.target.y = random_direction_y > 5?y:y - this.target.height + h;
		this.target.alpha = 0;
		var i_w = this.target.width;
		var i_h = this.target.height;
		var i_x = this.target.x;
		var i_y = this.target.y;
		var p1 = this.kenBurnsPointIn;
		var p2 = this.kenBurnsPointOut;
		if(p1 == null) this.kenBurnsPointIn = this.duration * 1000 / 5;
		if(p2 == null) this.kenBurnsPointOut = this.duration * 1000 * 4 / 5;
		this.fromValues = { x : this.target.x, y : this.target.y, width : this.target.width, height : this.target.height, alpha : null};
		this.toValues = { x : f_x, y : f_y, width : f_w, height : f_h, alpha : null};
	}
	,kenBurnsPointOut: null
	,kenBurnsPointIn: null
	,kenBurnsPointOutPassed: null
	,kenBurnsPointInPassed: null
	,kenBurnsArgs: null
	,kenBurnsBeginsFadingOut: null
	,kenBurnsDidFadedIn: null
	,__class__: CATKenBurns
});
var CATMorph = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATMorph"] = CATMorph;
CATMorph.__name__ = ["CATMorph"];
CATMorph.__interfaces__ = [CATransitionInterface];
CATMorph.__super__ = CAObject;
CATMorph.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
	}
	,init: function() {
	}
	,__class__: CATMorph
});
var CATShake = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATShake"] = CATShake;
CATShake.__name__ = ["CATShake"];
CATShake.__interfaces__ = [CATransitionInterface];
CATShake.__super__ = CAObject;
CATShake.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		if(time_diff > this.nextMove) {
			this.target.set_x(this.originalX + Math.random() * this.magnitude * 2 - this.magnitude);
			this.target.set_y(this.originalY + Math.random() * this.magnitude * 2 - this.magnitude);
			this.nextMove = Math.round(time_diff + 15 + Math.random() * 10);
		}
		if(time_diff >= this.duration) {
			this.target.x = this.originalX;
			this.target.y = this.originalY;
		}
	}
	,init: function() {
		this.magnitude = Reflect.field(this.properties,"magnitude");
		if(this.magnitude == null) this.magnitude = 10;
		this.originalX = this.target.getX();
		this.originalY = this.target.getY();
		this.nextMove = 0;
	}
	,nextMove: null
	,originalY: null
	,originalX: null
	,magnitude: null
	,__class__: CATShake
});
var CATSlide = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATSlide"] = CATSlide;
CATSlide.__name__ = ["CATSlide"];
CATSlide.__interfaces__ = [CATransitionInterface];
CATSlide.__super__ = CAObject;
CATSlide.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			this.target[prop] = this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null);
		}
	}
	,init: function() {
		var fromScale = 1.;
		var toScale = 1.;
		var fromAlpha = .0;
		var toAlpha = 1.;
		var fromRotation = .0;
		var toRotation = .0;
		var zoom = Reflect.field(this.properties,"slide");
		if(zoom != null) {
			if(js.Boot.__instanceof(zoom,Int) || js.Boot.__instanceof(zoom,Float)) {
				fromScale = this.target.scaleX;
				toScale = fromScale * zoom;
			} else if(js.Boot.__instanceof(zoom,String)) {
				var _g = zoom.toLowerCase();
				switch(_g) {
				case "tumbleweed":
					null;
					break;
				case "push":
					null;
					break;
				case "slide":
					null;
					break;
				case "reveal":
					null;
					break;
				}
			} else {
				var _fromScale = Reflect.field(zoom,"fromScale");
				var _toScale = Reflect.field(zoom,"toScale");
				var _fromAlpha = Reflect.field(zoom,"fromAlpha");
				var _toAlpha = Reflect.field(zoom,"toAlpha");
				var _fromRot = Reflect.field(zoom,"fromRotation");
				var _toRot = Reflect.field(zoom,"toRotation");
				if(_fromScale != null) fromScale = _fromScale;
				if(_toScale != null) toScale = _toScale;
				if(_fromAlpha != null) fromAlpha = _fromAlpha;
				if(_toAlpha != null) toAlpha = _toAlpha;
				if(_fromRot != null) fromRotation = _fromRot;
				if(_toRot != null) toRotation = _toRot;
			}
		}
		var i_w = this.target.width;
		var i_h = this.target.height;
		var i_x = this.target.x;
		var i_y = this.target.y;
		var f_w = i_w * toScale;
		var f_h = i_h * toScale;
		var f_x = Math.round(i_x + (i_w - f_w) / 2);
		var f_y = Math.round(i_y + (i_h - f_h) / 2);
		this.target.width *= fromScale;
		this.target.height *= fromScale;
		this.target.x = Math.round(i_x + (i_w - this.target.width) / 2);
		this.target.y = Math.round(i_y + (i_h - this.target.height) / 2);
		this.target.alpha = fromAlpha;
		this.fromValues = { x : this.target.x, y : this.target.y, width : this.target.width, height : this.target.height, alpha : fromAlpha};
		this.toValues = { x : f_x, y : f_y, width : f_w, height : f_h, alpha : toAlpha};
	}
	,__class__: CATSlide
});
var CATText = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATText"] = CATText;
CATText.__name__ = ["CATText"];
CATText.__interfaces__ = [CATransitionInterface];
CATText.__super__ = CAObject;
CATText.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var nrOfLetters = Math.round(this.timingFunction(time_diff,Reflect.field(this.fromValues,"nrOfLetters"),Reflect.field(this.toValues,"nrOfLetters") - Reflect.field(this.fromValues,"nrOfLetters"),this.duration,null));
		this.target.set_text(Reflect.field(this.toValues,"text").substr(0,nrOfLetters));
	}
	,init: function() {
		this.direction = -1;
		var fromText = "";
		var toText = "";
		var text = Reflect.field(this.properties,"text");
		if(text != null) {
			if(js.Boot.__instanceof(text,String)) {
				fromText = this.target.get_text();
				toText = text;
			} else {
				var _fromText = Reflect.field(text,"fromValue");
				var _toText = Reflect.field(text,"toValue");
				if(_fromText != null) fromText = _fromText;
				if(_toText != null) toText = _toText;
			}
		}
		this.fromValues = { text : fromText, nrOfLetters : 0};
		this.toValues = { text : toText, nrOfLetters : toText.length};
	}
	,html: null
	,direction: null
	,__class__: CATText
});
var CATZoomType = $hxClasses["CATZoomType"] = { __ename__ : ["CATZoomType"], __constructs__ : ["CATZoomInIn","CATZoomOutIn","CATZoomInOut","CATZoomOutOut","CATSpinIn","CATSpinOut"] }
CATZoomType.CATZoomInIn = ["CATZoomInIn",0];
CATZoomType.CATZoomInIn.toString = $estr;
CATZoomType.CATZoomInIn.__enum__ = CATZoomType;
CATZoomType.CATZoomOutIn = ["CATZoomOutIn",1];
CATZoomType.CATZoomOutIn.toString = $estr;
CATZoomType.CATZoomOutIn.__enum__ = CATZoomType;
CATZoomType.CATZoomInOut = ["CATZoomInOut",2];
CATZoomType.CATZoomInOut.toString = $estr;
CATZoomType.CATZoomInOut.__enum__ = CATZoomType;
CATZoomType.CATZoomOutOut = ["CATZoomOutOut",3];
CATZoomType.CATZoomOutOut.toString = $estr;
CATZoomType.CATZoomOutOut.__enum__ = CATZoomType;
CATZoomType.CATSpinIn = ["CATSpinIn",4];
CATZoomType.CATSpinIn.toString = $estr;
CATZoomType.CATSpinIn.__enum__ = CATZoomType;
CATZoomType.CATSpinOut = ["CATSpinOut",5];
CATZoomType.CATSpinOut.toString = $estr;
CATZoomType.CATSpinOut.__enum__ = CATZoomType;
var CATZoom = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATZoom"] = CATZoom;
CATZoom.__name__ = ["CATZoom"];
CATZoom.__interfaces__ = [CATransitionInterface];
CATZoom.__super__ = CAObject;
CATZoom.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			var setter = "set_" + prop;
			if(setter != null) Reflect.field(this.target,setter).apply(this.target,[this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null)]);
		}
	}
	,init: function() {
		var fromScale = 1.;
		var toScale = 1.;
		var fromAlpha = .0;
		var toAlpha = 1.;
		var fromRotation = .0;
		var toRotation = .0;
		var zoom = Reflect.field(this.properties,"zoom");
		if(zoom != null) {
			if(js.Boot.__instanceof(zoom,Int) || js.Boot.__instanceof(zoom,Float)) {
				fromScale = this.target.get_scaleX();
				toScale = fromScale * zoom;
			} else if(js.Boot.__instanceof(zoom,String)) {
				var _g = zoom.toLowerCase();
				switch(_g) {
				case "zoominin":
					fromScale = 0.7;
					break;
				case "zoomoutin":
					fromScale = 1.3;
					break;
				case "zoominout":
					fromScale = 1;
					toScale = 1.3;
					fromAlpha = 1;
					toAlpha = 0;
					break;
				case "zoomoutout":
					fromScale = 1;
					toScale = .7;
					fromAlpha = 1;
					toAlpha = 0;
					break;
				case "spinin":
					fromRotation -= 300;
					break;
				case "spinout":
					toRotation = 0;
					break;
				}
			} else {
				var _fromScale = Reflect.field(zoom,"fromScale");
				var _toScale = Reflect.field(zoom,"toScale");
				var _fromAlpha = Reflect.field(zoom,"fromAlpha");
				var _toAlpha = Reflect.field(zoom,"toAlpha");
				var _fromRot = Reflect.field(zoom,"fromRotation");
				var _toRot = Reflect.field(zoom,"toRotation");
				if(_fromScale != null) fromScale = _fromScale;
				if(_toScale != null) toScale = _toScale;
				if(_fromAlpha != null) fromAlpha = _fromAlpha;
				if(_toAlpha != null) toAlpha = _toAlpha;
				if(_fromRot != null) fromRotation = _fromRot;
				if(_toRot != null) toRotation = _toRot;
			}
		}
		var i_w = this.target.get_width();
		var i_h = this.target.get_height();
		var i_x = this.target.get_x();
		var i_y = this.target.get_y();
		var f_w = i_w * toScale;
		var f_h = i_h * toScale;
		var f_x = Math.round(i_x + (i_w - f_w) / 2);
		var f_y = Math.round(i_y + (i_h - f_h) / 2);
		this.target.set_width(i_w * fromScale);
		this.target.set_height(i_h * fromScale);
		this.target.set_x(Math.round(i_x + (i_w - this.target.get_width()) / 2));
		this.target.set_y(Math.round(i_y + (i_h - this.target.get_height()) / 2));
		this.target.set_alpha(fromAlpha);
		this.fromValues = { x : this.target.get_x(), y : this.target.get_y(), width : this.target.get_width(), height : this.target.get_height(), alpha : fromAlpha};
		this.toValues = { x : f_x, y : f_y, width : f_w, height : f_h, alpha : toAlpha};
	}
	,__class__: CATZoom
});
var CATween = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
$hxClasses["CATween"] = CATween;
CATween.__name__ = ["CATween"];
CATween.__interfaces__ = [CATransitionInterface];
CATween.__super__ = CAObject;
CATween.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			var setter = "set_" + prop;
			if(setter != null) try {
				Reflect.field(this.target,setter).apply(this.target,[this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null)]);
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 47, className : "CATween", methodName : "animate"});
			}
		}
	}
	,init: function() {
		var _g = 0, _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(js.Boot.__instanceof(Reflect.field(this.properties,p),Int) || js.Boot.__instanceof(Reflect.field(this.properties,p),Float)) {
				var getter = "get_" + p;
				if(getter == null) this.fromValues[p] = Reflect.field(this.target,p); else this.fromValues[p] = Reflect.field(this.target,getter).apply(this.target,[]);
				this.toValues[p] = Reflect.field(this.properties,p);
			} else try {
				this.fromValues[p] = Reflect.field(Reflect.field(this.properties,p),"fromValue");
				Reflect.setProperty(this.target,p,Reflect.field(this.fromValues,p));
				this.toValues[p] = Reflect.field(Reflect.field(this.properties,p),"toValue");
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 32, className : "CATween", methodName : "init"});
			}
		}
	}
	,__class__: CATween
});
var ColorMatrix = function(p_matrix) {
	this.arr = new Array();
	p_matrix = this.fixMatrix(p_matrix);
	this.copyMatrix(p_matrix.length == ColorMatrix.LENGTH?p_matrix:[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0]);
};
$hxClasses["ColorMatrix"] = ColorMatrix;
ColorMatrix.__name__ = ["ColorMatrix"];
ColorMatrix.DELTA_INDEX = function() {
	return [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,1.0,1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0,2.12,2.25,2.37,2.50,2.62,2.75,2.87,3.0,3.2,3.4,3.6,3.8,4.0,4.3,4.7,4.9,5.0,5.5,6.0,6.5,6.8,7.0,7.3,7.5,7.8,8.0,8.4,8.7,9.0,9.4,9.6,9.8,10.0];
}
ColorMatrix.IDENTITY_MATRIX = function() {
	return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0];
}
ColorMatrix.prototype = {
	fixMatrix: function(p_matrix) {
		if(p_matrix == null) return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0];
		if(js.Boot.__instanceof(p_matrix,ColorMatrix)) p_matrix = p_matrix.slice(0);
		if(p_matrix.length < ColorMatrix.LENGTH) p_matrix = p_matrix.slice(0,p_matrix.length).concat([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0].slice(p_matrix.length,ColorMatrix.LENGTH)); else if(p_matrix.length > ColorMatrix.LENGTH) p_matrix = p_matrix.slice(0,ColorMatrix.LENGTH);
		return p_matrix;
	}
	,cleanValue: function(p_val,p_limit) {
		return Math.min(p_limit,Math.max(-p_limit,p_val));
	}
	,multiplyMatrix: function(p_matrix) {
		var col = new Array();
		var _g = 0;
		while(_g < 5) {
			var i = _g++;
			var _g1 = 0;
			while(_g1 < 5) {
				var j = _g1++;
				col[j] = this.arr[j + i * 5];
			}
			var _g1 = 0;
			while(_g1 < 5) {
				var j = _g1++;
				var val = 0.0;
				var _g2 = 0;
				while(_g2 < 5) {
					var k = _g2++;
					val += p_matrix[j + k * 5] * col[k];
				}
				this.arr[j + i * 5] = val;
			}
		}
	}
	,copyMatrix: function(p_matrix) {
		var l = ColorMatrix.LENGTH;
		var _g = 0;
		while(_g < l) {
			var i = _g++;
			this.arr[i] = p_matrix[i];
		}
	}
	,toArray: function() {
		return this.arr.slice(0,20);
	}
	,toString: function() {
		return "ColorMatrix [ " + this.arr.join(" , ") + " ]";
	}
	,clone: function() {
		return new ColorMatrix(this.arr);
	}
	,concat: function(p_matrix) {
		p_matrix = this.fixMatrix(p_matrix);
		if(p_matrix.length != ColorMatrix.LENGTH) return;
		this.multiplyMatrix(p_matrix);
	}
	,adjustHue: function(p_val) {
		p_val = this.cleanValue(p_val,180) / 180 * Math.PI;
		if(p_val == 0 || Math.isNaN(p_val)) return;
		var cosVal = Math.cos(p_val);
		var sinVal = Math.sin(p_val);
		var lumR = 0.213;
		var lumG = 0.715;
		var lumB = 0.072;
		this.multiplyMatrix([lumR + cosVal * (1 - lumR) + sinVal * -lumR,lumG + cosVal * -lumG + sinVal * -lumG,lumB + cosVal * -lumB + sinVal * (1 - lumB),0,0,lumR + cosVal * -lumR + sinVal * 0.143,lumG + cosVal * (1 - lumG) + sinVal * 0.140,lumB + cosVal * -lumB + sinVal * -0.283,0,0,lumR + cosVal * -lumR + sinVal * -(1 - lumR),lumG + cosVal * -lumG + sinVal * lumG,lumB + cosVal * (1 - lumB) + sinVal * lumB,0,0,0,0,0,1,0,0,0,0,0,1]);
	}
	,adjustSaturation: function(p_val) {
		p_val = this.cleanValue(p_val,100);
		if(p_val == 0 || Math.isNaN(p_val)) return;
		var x = 1 + (p_val > 0?3 * p_val / 100:p_val / 100);
		var lumR = 0.3086;
		var lumG = 0.6094;
		var lumB = 0.0820;
		this.multiplyMatrix([lumR * (1 - x) + x,lumG * (1 - x),lumB * (1 - x),0,0,lumR * (1 - x),lumG * (1 - x) + x,lumB * (1 - x),0,0,lumR * (1 - x),lumG * (1 - x),lumB * (1 - x) + x,0,0,0,0,0,1,0,0,0,0,0,1]);
	}
	,adjustContrast: function(p_val) {
		p_val = this.cleanValue(p_val,100);
		if(p_val == 0 || Math.isNaN(p_val)) return;
		var x = 0.0;
		if(p_val < 0) x = 127 + p_val / 100 * 127; else {
			x = p_val % 1;
			if(x == 0) x = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,1.0,1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0,2.12,2.25,2.37,2.50,2.62,2.75,2.87,3.0,3.2,3.4,3.6,3.8,4.0,4.3,4.7,4.9,5.0,5.5,6.0,6.5,6.8,7.0,7.3,7.5,7.8,8.0,8.4,8.7,9.0,9.4,9.6,9.8,10.0][Math.round(p_val)]; else x = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,1.0,1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0,2.12,2.25,2.37,2.50,2.62,2.75,2.87,3.0,3.2,3.4,3.6,3.8,4.0,4.3,4.7,4.9,5.0,5.5,6.0,6.5,6.8,7.0,7.3,7.5,7.8,8.0,8.4,8.7,9.0,9.4,9.6,9.8,10.0][Math.round(p_val)] * (1 - x) + [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,1.0,1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0,2.12,2.25,2.37,2.50,2.62,2.75,2.87,3.0,3.2,3.4,3.6,3.8,4.0,4.3,4.7,4.9,5.0,5.5,6.0,6.5,6.8,7.0,7.3,7.5,7.8,8.0,8.4,8.7,9.0,9.4,9.6,9.8,10.0][Math.round(p_val + 1)] * x;
			x = x * 127 + 127;
		}
		this.multiplyMatrix([x / 127,0,0,0,0.5 * (127 - x),0,x / 127,0,0,0.5 * (127 - x),0,0,x / 127,0,0.5 * (127 - x),0,0,0,1,0,0,0,0,0,1]);
	}
	,adjustBrightness: function(p_val) {
		p_val = this.cleanValue(p_val,100);
		if(p_val == 0 || Math.isNaN(p_val)) return;
		this.multiplyMatrix([1,0,0,0,p_val,0,1,0,0,p_val,0,0,1,0,p_val,0,0,0,1,0,0,0,0,0,1]);
	}
	,adjustColor: function(p_brightness,p_contrast,p_saturation,p_hue) {
		this.adjustHue(p_hue);
		this.adjustContrast(p_contrast);
		this.adjustBrightness(p_brightness);
		this.adjustSaturation(p_saturation);
	}
	,reset: function() {
		var _g1 = 0, _g = ColorMatrix.LENGTH;
		while(_g1 < _g) {
			var i = _g1++;
			this.arr[i] = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0][i];
		}
	}
	,arr: null
	,__class__: ColorMatrix
}
var Csv = function() {
	this.index = 0;
	this.source = new Array();
};
$hxClasses["Csv"] = Csv;
Csv.__name__ = ["Csv"];
Csv.prototype = {
	replaceStr: function(str,a,b) {
		var o = str.split(a);
		return o.join(b);
	}
	,escapeCell: function(cell) {
		cell = this.replaceStr(cell,"\"","\"\"");
		cell = "\"" + cell + "\"";
		return cell;
	}
	,hasEscapeChar: function(cell,splitter) {
		var _g = 0, _g1 = ["\"","\n","\r","\t"," ",splitter];
		while(_g < _g1.length) {
			var split = _g1[_g];
			++_g;
			if(cell.indexOf(split) >= 0) return true;
		}
		return false;
	}
	,skipSpace: function() {
		if(this.csv_str.charAt(this.index) == " ") this.index++;
	}
	,getColStr: function() {
		this.index++;
		var col = "";
		while(this.index < this.csv_str.length) {
			if(HxOverrides.substr(this.csv_str,this.index,2) == "\"\"") {
				col += "\"";
				this.index += 2;
				continue;
			}
			var c = this.csv_str.charAt(this.index);
			if(c == "\"") {
				this.index++;
				this.skipSpace();
				if(this.csv_str.charAt(this.index) == ",") this.index++;
				break;
			}
			col += c;
			this.index++;
		}
		return col;
	}
	,getColSimple: function() {
		var col = "";
		while(this.index < this.csv_str.length) {
			if(HxOverrides.substr(this.csv_str,this.index,2) == "\"\"") {
				col += "\"";
				this.index += 2;
				continue;
			}
			var c = this.csv_str.charAt(this.index);
			if(c == this.splitter) {
				this.index++;
				break;
			}
			if(c == "\n") break;
			col += c;
			this.index++;
		}
		return col;
	}
	,getCols: function() {
		var cols = new Array();
		this.index = 0;
		while(this.index < this.csv_str.length) {
			var c = this.csv_str.charAt(this.index);
			var col;
			if(c == "\n") {
				this.index++;
				break;
			}
			col = c == "\""?this.getColStr():this.getColSimple();
			this.skipSpace();
			cols.push(col);
			haxe.Log.trace(col,{ fileName : "Csv.hx", lineNumber : 106, className : "Csv", methodName : "getCols"});
		}
		this.csv_str = HxOverrides.substr(this.csv_str,this.index,null);
		haxe.Log.trace("fin",{ fileName : "Csv.hx", lineNumber : 109, className : "Csv", methodName : "getCols"});
		return cols;
	}
	,split: function(csv_str,splitter) {
		csv_str = this.replaceStr(csv_str,"\r\n","\n");
		csv_str = this.replaceStr(csv_str,"\r","\n");
		this.csv_str = csv_str;
		this.splitter = splitter;
		haxe.Log.trace("split " + csv_str,{ fileName : "Csv.hx", lineNumber : 84, className : "Csv", methodName : "split"});
		var result = new Array();
		while(csv_str.length > 0) result.push(this.getCols());
		return result;
	}
	,getArray: function() {
		return this.source;
	}
	,getCsv: function(splitter,use_escape) {
		if(use_escape == null) use_escape = false;
		if(splitter == null) splitter = ",";
		var res = "";
		var _g1 = 0, _g = this.source.length;
		while(_g1 < _g) {
			var row = _g1++;
			var cols = this.source[row];
			var _g3 = 0, _g2 = cols.length;
			while(_g3 < _g2) {
				var col = _g3++;
				var cell = cols[col];
				if(use_escape || this.hasEscapeChar(cell,splitter)) cell = this.escapeCell(cell);
				res += cell + splitter;
			}
			if(cols.length > 0) res = HxOverrides.substr(res,0,res.length - 1);
			res += "\n";
		}
		if(this.source.length > 0) res = HxOverrides.substr(res,0,res.length - 1);
		return res;
	}
	,initWithArray: function(csv_arr,splitter,use_escape) {
		if(use_escape == null) use_escape = false;
		if(splitter == null) splitter = ",";
		this.source = csv_arr;
	}
	,initWithTsv: function(tsv_str) {
		this.source = this.split(tsv_str,"\t");
	}
	,initWithCsv: function(csv_str) {
		this.source = this.split(csv_str,",");
	}
	,source: null
	,index: null
	,splitter: null
	,csv_str: null
	,__class__: Csv
}
var DateTools = function() { }
$hxClasses["DateTools"] = DateTools;
DateTools.__name__ = ["DateTools"];
DateTools.__format_get = function(d,e) {
	return (function($this) {
		var $r;
		switch(e) {
		case "%":
			$r = "%";
			break;
		case "C":
			$r = StringTools.lpad(Std.string(d.getFullYear() / 100 | 0),"0",2);
			break;
		case "d":
			$r = StringTools.lpad(Std.string(d.getDate()),"0",2);
			break;
		case "D":
			$r = DateTools.__format(d,"%m/%d/%y");
			break;
		case "e":
			$r = Std.string(d.getDate());
			break;
		case "H":case "k":
			$r = StringTools.lpad(Std.string(d.getHours()),e == "H"?"0":" ",2);
			break;
		case "I":case "l":
			$r = (function($this) {
				var $r;
				var hour = d.getHours() % 12;
				$r = StringTools.lpad(Std.string(hour == 0?12:hour),e == "I"?"0":" ",2);
				return $r;
			}($this));
			break;
		case "m":
			$r = StringTools.lpad(Std.string(d.getMonth() + 1),"0",2);
			break;
		case "M":
			$r = StringTools.lpad(Std.string(d.getMinutes()),"0",2);
			break;
		case "n":
			$r = "\n";
			break;
		case "p":
			$r = d.getHours() > 11?"PM":"AM";
			break;
		case "r":
			$r = DateTools.__format(d,"%I:%M:%S %p");
			break;
		case "R":
			$r = DateTools.__format(d,"%H:%M");
			break;
		case "s":
			$r = Std.string(d.getTime() / 1000 | 0);
			break;
		case "S":
			$r = StringTools.lpad(Std.string(d.getSeconds()),"0",2);
			break;
		case "t":
			$r = "\t";
			break;
		case "T":
			$r = DateTools.__format(d,"%H:%M:%S");
			break;
		case "u":
			$r = (function($this) {
				var $r;
				var t = d.getDay();
				$r = t == 0?"7":Std.string(t);
				return $r;
			}($this));
			break;
		case "w":
			$r = Std.string(d.getDay());
			break;
		case "y":
			$r = StringTools.lpad(Std.string(d.getFullYear() % 100),"0",2);
			break;
		case "Y":
			$r = Std.string(d.getFullYear());
			break;
		default:
			$r = (function($this) {
				var $r;
				throw "Date.format %" + e + "- not implemented yet.";
				return $r;
			}($this));
		}
		return $r;
	}(this));
}
DateTools.__format = function(d,f) {
	var r = new StringBuf();
	var p = 0;
	while(true) {
		var np = f.indexOf("%",p);
		if(np < 0) break;
		r.addSub(f,p,np - p);
		r.b += Std.string(DateTools.__format_get(d,HxOverrides.substr(f,np + 1,1)));
		p = np + 2;
	}
	r.addSub(f,p,f.length - p);
	return r.b;
}
DateTools.format = function(d,f) {
	return DateTools.__format(d,f);
}
DateTools.delta = function(d,t) {
	return (function($this) {
		var $r;
		var d1 = new Date();
		d1.setTime(d.getTime() + t);
		$r = d1;
		return $r;
	}(this));
}
DateTools.getMonthDays = function(d) {
	var month = d.getMonth();
	var year = d.getFullYear();
	if(month != 1) return DateTools.DAYS_OF_MONTH[month];
	var isB = year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
	return isB?29:28;
}
DateTools.seconds = function(n) {
	return n * 1000.0;
}
DateTools.minutes = function(n) {
	return n * 60.0 * 1000.0;
}
DateTools.hours = function(n) {
	return n * 60.0 * 60.0 * 1000.0;
}
DateTools.days = function(n) {
	return n * 24.0 * 60.0 * 60.0 * 1000.0;
}
DateTools.parse = function(t) {
	var s = t / 1000;
	var m = s / 60;
	var h = m / 60;
	return { ms : t % 1000, seconds : s % 60 | 0, minutes : m % 60 | 0, hours : h % 24 | 0, days : h / 24 | 0};
}
DateTools.make = function(o) {
	return o.ms + 1000.0 * (o.seconds + 60.0 * (o.minutes + 60.0 * (o.hours + 24.0 * o.days)));
}
DateTools.makeUtc = function(year,month,day,hour,min,sec) {
	return Date.UTC(year,month,day,hour,min,sec);
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	map: function(s,f) {
		var offset = 0;
		var buf = new StringBuf();
		do {
			if(offset >= s.length) break; else if(!this.matchSub(s,offset)) {
				buf.b += Std.string(HxOverrides.substr(s,offset,null));
				break;
			}
			var p = this.matchedPos();
			buf.b += Std.string(HxOverrides.substr(s,offset,p.pos - offset));
			buf.b += Std.string(f(this));
			if(p.len == 0) {
				buf.b += Std.string(HxOverrides.substr(s,p.pos,1));
				offset = p.pos + 1;
			} else offset = p.pos + p.len;
		} while(this.r.global);
		if(!this.r.global && offset > 0 && offset < s.length) buf.b += Std.string(HxOverrides.substr(s,offset,null));
		return buf.b;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,matchSub: function(s,pos,len) {
		if(len == null) len = -1;
		return this.r.global?(function($this) {
			var $r;
			$this.r.lastIndex = pos;
			$this.r.m = $this.r.exec(len < 0?s:HxOverrides.substr(s,0,pos + len));
			var b = $this.r.m != null;
			if(b) $this.r.s = s;
			$r = b;
			return $r;
		}(this)):(function($this) {
			var $r;
			var b = $this.match(len < 0?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len));
			if(b) {
				$this.r.s = s;
				$this.r.m.index += pos;
			}
			$r = b;
			return $r;
		}(this));
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,r: null
	,__class__: EReg
}
var RCSignal = function() {
	this.enabled = true;
	this.removeAll();
};
$hxClasses["RCSignal"] = RCSignal;
RCSignal.__name__ = ["RCSignal"];
RCSignal.prototype = {
	destroy: function(pos) {
		this.listeners = null;
		this.exposableListener = null;
	}
	,exists: function(listener) {
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			if(l == listener) return true;
		}
		return false;
	}
	,callMethod: function(listener,args,pos) {
		try {
			listener.apply(null,args);
		} catch( e ) {
			haxe.Log.trace("[RCSignal error: " + Std.string(e) + ", called from: " + Std.string(pos) + "]",{ fileName : "RCSignal.hx", lineNumber : 75, className : "RCSignal", methodName : "callMethod"});
			Fugu.stack();
		}
	}
	,dispatch: function(p1,p2,p3,p4,pos) {
		if(!this.enabled) return;
		var args = new Array();
		var _g = 0, _g1 = [p1,p2,p3,p4];
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(p != null) args.push(p); else break;
		}
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var listener = $it0.next();
			this.callMethod(listener,args,pos);
		}
		if(this.exposableListener != null) {
			this.callMethod(this.exposableListener,args,pos);
			this.exposableListener = null;
		}
	}
	,removeAll: function() {
		this.listeners = new List();
		this.exposableListener = null;
	}
	,remove: function(listener) {
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			if(Reflect.compareMethods(l,listener)) {
				this.listeners.remove(l);
				break;
			}
		}
		if(Reflect.compareMethods(this.exposableListener,listener)) this.exposableListener = null;
	}
	,addFirst: function(listener,pos) {
		this.listeners.push(listener);
	}
	,addOnce: function(listener,pos) {
		if(this.exists(listener)) haxe.Log.trace("This listener is already added, it will not be called only once as you expect. " + Std.string(pos),{ fileName : "RCSignal.hx", lineNumber : 23, className : "RCSignal", methodName : "addOnce"});
		this.exposableListener = listener;
	}
	,add: function(listener) {
		this.listeners.add(listener);
	}
	,enabled: null
	,exposableListener: null
	,listeners: null
	,__class__: RCSignal
}
var EVFullScreen = function() {
	RCSignal.call(this);
};
$hxClasses["EVFullScreen"] = EVFullScreen;
EVFullScreen.__name__ = ["EVFullScreen"];
EVFullScreen.__super__ = RCSignal;
EVFullScreen.prototype = $extend(RCSignal.prototype,{
	__class__: EVFullScreen
});
var EVLoop = function(pos) {
};
$hxClasses["EVLoop"] = EVLoop;
EVLoop.__name__ = ["EVLoop"];
EVLoop.prototype = {
	destroy: function() {
		this.stop();
	}
	,stop: function() {
		if(this.ticker == null) return;
		this.ticker.stop();
		this.ticker = null;
	}
	,loop: function() {
		if(this._run != null) this._run();
	}
	,set_run: function(func) {
		this.stop();
		this._run = func;
		this.ticker = new haxe.Timer(Math.round(1 / EVLoop.FPS * 1000));
		this.ticker.run = $bind(this,this.loop);
		return func;
	}
	,run: null
	,_run: null
	,ticker: null
	,__class__: EVLoop
	,__properties__: {set_run:"set_run"}
}
var EVMouse = function(type,target,pos) {
	if(target == null) throw "Can't use a null target. " + Std.string(pos);
	RCSignal.call(this);
	this.type = type;
	this.target = target;
	this.delta = 0;
	this.targets = new List();
	if(js.Boot.__instanceof(target,JSView)) this.layer = (js.Boot.__cast(target , JSView)).layer;
	if(this.layer == null) this.layer = target;
	this.addEventListener(pos);
};
$hxClasses["EVMouse"] = EVMouse;
EVMouse.__name__ = ["EVMouse"];
EVMouse.__super__ = RCSignal;
EVMouse.prototype = $extend(RCSignal.prototype,{
	destroy: function(pos) {
		this.removeEventListener();
		RCSignal.prototype.destroy.call(this,{ fileName : "EVMouse.hx", lineNumber : 246, className : "EVMouse", methodName : "destroy"});
	}
	,isTouchDevice: function() {
		return !!('ontouchstart' in window) // works on most browsers 
	      || !!('onmsgesturechange' in window); // works on ie10;
		return false;
	}
	,MouseScroll: function(e) {
		if(Reflect.field(e,"wheelDelta") != null) this.delta = e.wheelDelta; else if(Reflect.field(e,"detail") != null) this.delta = -Math.round(e.detail * 5);
		this.e = e;
		this.dispatch(this,null,null,null,{ fileName : "EVMouse.hx", lineNumber : 232, className : "EVMouse", methodName : "MouseScroll"});
	}
	,mouseScrollHandler: null
	,removeWheelListener: function() {
		if(($_=this.layer,$bind($_,$_.removeEventListener))) {
			this.layer.removeEventListener("mousewheel",this.mouseScrollHandler,false);
			this.layer.removeEventListener("DOMMouseScroll",this.mouseScrollHandler,false);
		} else if(this.layer.detachEvent) this.layer.detachEvent("onmousewheel",this.mouseScrollHandler);
	}
	,addWheelListener: function() {
		this.mouseScrollHandler = $bind(this,this.MouseScroll);
		if(($_=this.layer,$bind($_,$_.addEventListener))) {
			this.layer.addEventListener("mousewheel",this.mouseScrollHandler,false);
			this.layer.addEventListener("DOMMouseScroll",this.mouseScrollHandler,false);
		} else if(this.layer.attachEvent) this.layer.attachEvent("onmousewheel",this.mouseScrollHandler);
	}
	,updateAfterEvent: function() {
	}
	,mouseHandler: function(e) {
		if(e == null) e = js.Lib.window.event;
		this.e = e;
		this.dispatch(this,null,null,null,{ fileName : "EVMouse.hx", lineNumber : 174, className : "EVMouse", methodName : "mouseHandler"});
	}
	,removeEventListener: function() {
		if(this.isTouchDevice()) {
			var _g = this;
			switch(_g.type) {
			case "mouseup":
				this.layer.ontouchend = null;
				break;
			case "mousedown":
				this.layer.ontouchstart = null;
				break;
			case "mouseout":
				this.layer.ontouchcancel = null;
				break;
			case "mousemove":
				this.layer.ontouchmove = null;
				break;
			case "mouseclick":
				this.layer.onclick = null;
				break;
			}
		} else {
			var _g = this;
			switch(_g.type) {
			case "mouseup":
				this.layer.onmouseup = null;
				break;
			case "mousedown":
				this.layer.onmousedown = null;
				break;
			case "mouseover":
				this.layer.onmouseover = null;
				break;
			case "mouseout":
				this.layer.onmouseout = null;
				break;
			case "mousemove":
				this.layer.onmousemove = null;
				break;
			case "mouseclick":
				this.layer.onclick = null;
				break;
			case "mousedoubleclick":
				this.layer.ondblclick = null;
				break;
			case "mousewheel":
				this.removeWheelListener();
				break;
			}
		}
	}
	,addEventListener: function(pos) {
		var $it0 = this.targets.iterator();
		while( $it0.hasNext() ) {
			var t = $it0.next();
			if(t.target == this.target && t.type == this.type) {
				haxe.Log.trace("Target already in use by this event type. Called from " + Std.string(pos),{ fileName : "EVMouse.hx", lineNumber : 85, className : "EVMouse", methodName : "addEventListener"});
				return;
			}
		}
		if(this.isTouchDevice()) {
			var _g = this;
			switch(_g.type) {
			case "mouseup":
				this.layer.ontouchend = $bind(this,this.mouseHandler);
				break;
			case "mousedown":
				this.layer.ontouchstart = $bind(this,this.mouseHandler);
				break;
			case "mouseout":
				this.layer.ontouchcancel = $bind(this,this.mouseHandler);
				break;
			case "mousemove":
				this.layer.ontouchmove = $bind(this,this.mouseHandler);
				break;
			case "mouseclick":
				this.layer.onclick = $bind(this,this.mouseHandler);
				break;
			default:
				haxe.Log.trace("The mouse event you're trying to add does not exist. " + Std.string(pos),{ fileName : "EVMouse.hx", lineNumber : 103, className : "EVMouse", methodName : "addEventListener"});
			}
		} else {
			var _g = this;
			switch(_g.type) {
			case "mouseup":
				this.layer.onmouseup = $bind(this,this.mouseHandler);
				break;
			case "mousedown":
				this.layer.onmousedown = $bind(this,this.mouseHandler);
				break;
			case "mouseover":
				this.layer.onmouseover = $bind(this,this.mouseHandler);
				break;
			case "mouseout":
				this.layer.onmouseout = $bind(this,this.mouseHandler);
				break;
			case "mousemove":
				this.layer.onmousemove = $bind(this,this.mouseHandler);
				break;
			case "mouseclick":
				this.layer.onclick = $bind(this,this.mouseHandler);
				break;
			case "mousedoubleclick":
				this.layer.ondblclick = $bind(this,this.mouseHandler);
				break;
			case "mousewheel":
				this.addWheelListener();
				break;
			default:
				haxe.Log.trace("The mouse event you're trying to add does not exist. " + Std.string(pos),{ fileName : "EVMouse.hx", lineNumber : 116, className : "EVMouse", methodName : "addEventListener"});
			}
		}
	}
	,targets: null
	,layer: null
	,delta: null
	,e: null
	,type: null
	,target: null
	,__class__: EVMouse
});
var EVResize = function() {
	RCSignal.call(this);
	js.Browser.window.onresize = $bind(this,this.resizeHandler);
};
$hxClasses["EVResize"] = EVResize;
EVResize.__name__ = ["EVResize"];
EVResize.__super__ = RCSignal;
EVResize.prototype = $extend(RCSignal.prototype,{
	destroy: function(pos) {
		js.Browser.window.onresize = null;
		RCSignal.prototype.destroy.call(this,{ fileName : "EVResize.hx", lineNumber : 43, className : "EVResize", methodName : "destroy"});
	}
	,resizeHandler: function(e) {
		var w = js.Browser.window.innerWidth;
		var h = js.Browser.window.innerHeight;
		this.dispatch(w,h,null,null,{ fileName : "EVResize.hx", lineNumber : 34, className : "EVResize", methodName : "resizeHandler"});
	}
	,__class__: EVResize
});
var EVTouch = function(type,target,pos) {
	if(target == null) throw "Can't use a null target. " + Std.string(pos);
	RCSignal.call(this);
	this.type = type;
	this.target = target;
	this.targets = new List();
	if(js.Boot.__instanceof(target,JSView)) this.layer = (js.Boot.__cast(target , JSView)).layer;
	if(this.layer == null) this.layer = target;
	this.addEventListener(pos);
};
$hxClasses["EVTouch"] = EVTouch;
EVTouch.__name__ = ["EVTouch"];
EVTouch.__super__ = RCSignal;
EVTouch.prototype = $extend(RCSignal.prototype,{
	destroy: function(pos) {
		this.removeEventListener();
		RCSignal.prototype.destroy.call(this,{ fileName : "EVTouch.hx", lineNumber : 133, className : "EVTouch", methodName : "destroy"});
	}
	,updateAfterEvent: function() {
	}
	,touchHandler: function(e) {
		this.e = e;
		this.dispatch(this,null,null,null,{ fileName : "EVTouch.hx", lineNumber : 124, className : "EVTouch", methodName : "touchHandler"});
	}
	,removeEventListener: function() {
		var _g = this;
		switch(_g.type) {
		case "touchstart":
			this.layer.touchstart = null;
			break;
		case "touchend":
			this.layer.touchend = null;
			break;
		case "touchenter":
			this.layer.touchenter = null;
			break;
		case "touchleave":
			this.layer.touchleave = null;
			break;
		case "touchmove":
			this.layer.touchmove = null;
			break;
		case "touchtap":
			this.layer.touchtap = null;
			break;
		case "touchcancel":
			this.layer.touchcancel = null;
			break;
		}
	}
	,addEventListener: function(pos) {
		var $it0 = this.targets.iterator();
		while( $it0.hasNext() ) {
			var t = $it0.next();
			if(t.target == this.target && t.type == this.type) {
				haxe.Log.trace("Target already in use by this event type. Called from " + Std.string(pos),{ fileName : "EVTouch.hx", lineNumber : 80, className : "EVTouch", methodName : "addEventListener"});
				return;
			}
		}
		this.targets.add({ target : this.target, type : this.type, instance : this});
		var _g = this;
		switch(_g.type) {
		case "touchstart":
			this.layer.touchstart = $bind(this,this.touchHandler);
			break;
		case "touchend":
			this.layer.touchend = $bind(this,this.touchHandler);
			break;
		case "touchenter":
			this.layer.touchenter = $bind(this,this.touchHandler);
			break;
		case "touchleave":
			this.layer.touchleave = $bind(this,this.touchHandler);
			break;
		case "touchmove":
			this.layer.touchmove = $bind(this,this.touchHandler);
			break;
		case "touchtap":
			this.layer.touchtap = $bind(this,this.touchHandler);
			break;
		case "touchcancel":
			this.layer.touchcancel = $bind(this,this.touchHandler);
			break;
		default:
			haxe.Log.trace("The mouse event you're trying to add does not exist. " + Std.string(pos),{ fileName : "EVTouch.hx", lineNumber : 94, className : "EVTouch", methodName : "addEventListener"});
		}
	}
	,targets: null
	,layer: null
	,e: null
	,type: null
	,target: null
	,__class__: EVTouch
});
var Evaluate = function() { }
$hxClasses["Evaluate"] = Evaluate;
Evaluate.__name__ = ["Evaluate"];
Evaluate.operations = function(strOperation,rect) {
	var result = 0;
	var operators = ["+","-","*","/"];
	var lastOperator = "+";
	var letters = strOperation.toLowerCase().split("");
	var word = "";
	var _g = 0;
	while(_g < letters.length) {
		var letter = letters[_g];
		++_g;
		if(Zeta.isIn(letter,operators)) {
			result = Evaluate.makeOperation(result,word,lastOperator,rect);
			word = "";
			lastOperator = letter;
		} else if(letter == " ") continue; else word += letter;
	}
	return Evaluate.makeOperation(result,word,lastOperator,rect);
}
Evaluate.makeOperation = function(result,word,operator,rect) {
	return (function($this) {
		var $r;
		switch(operator) {
		case "+":
			$r = result + Evaluate.parseInt(word,rect);
			break;
		case "-":
			$r = result - Evaluate.parseInt(word,rect);
			break;
		case "*":
			$r = Math.round(result * Evaluate.parseInt(word,rect));
			break;
		case "/":
			$r = Math.round(result / Evaluate.parseInt(word,rect));
			break;
		default:
			$r = result;
		}
		return $r;
	}(this));
}
Evaluate.parseInt = function(str,rect) {
	return Math.round((function($this) {
		var $r;
		switch(str) {
		case "stagewidth":
			$r = RCWindow.sharedWindow().get_width();
			break;
		case "stageheight":
			$r = RCWindow.sharedWindow().get_height();
			break;
		case "photowidth":
			$r = rect == null?0.0:rect.size.width;
			break;
		case "photoheight":
			$r = rect == null?0.0:rect.size.height;
			break;
		case "content_max_width":
			$r = RCWindow.sharedWindow().get_width();
			break;
		default:
			$r = Std.parseInt(str);
		}
		return $r;
	}(this)));
}
var Facebook = function(applicationId,_callback,options) {
	if(Facebook._instance != null) throw "Facebook is a singleton and cannot be instantiated.";
	this.openUICalls = new haxe.ds.StringMap();
	this.resultHash = new Array();
	this.requests = new Array();
	this._initCallback = _callback;
	var accessToken = RCUserDefaults.stringForKey("SocialFacebookAccessToken");
	this.session = this.generateSession({ access_token : accessToken});
	this.applicationId = applicationId;
	this.oauth2 = true;
	if(options == null) options = { };
	options.appId = applicationId;
	options.oauth = true;
	if(accessToken != null) this.authResponse = { uid : null, expireDate : null, accessToken : accessToken, signedRequest : null};
	if(options.status != false) this.getLoginStatus(); else if(this._initCallback != null) {
		this._initCallback(this.session,null);
		this._initCallback = null;
	}
};
$hxClasses["Facebook"] = Facebook;
Facebook.__name__ = ["Facebook"];
Facebook._instance = null;
Facebook.sharedFacebook = function() {
	if(Facebook._instance == null) throw "Call Facebook.init before obtaining the instance";
	return Facebook._instance;
}
Facebook.init = function(applicationId,_callback,options) {
	if(Facebook._instance == null) Facebook._instance = new Facebook(applicationId,_callback,options);
	return Facebook._instance;
}
Facebook.prototype = {
	deleteObject: function(method,_callback) {
		var params = { method : "delete"};
		this.api(method,_callback,params,"POST");
	}
	,fqlQuery: function(query,_callback,values) {
		var _g = 0, _g1 = Reflect.fields(values);
		while(_g < _g1.length) {
			var n = _g1[_g];
			++_g;
		}
		this.callRestAPI("fql.query",_callback,{ query : query});
	}
	,callRestAPI: function(methodName,_callback,values,requestMethod) {
		if(requestMethod == null) requestMethod = "GET";
		if(values == null) values = { };
		values.format = "json";
		if(this.getAccessToken() != null) values.access_token = this.getAccessToken();
		if(this.locale != null) values.locale = this.locale;
	}
	,handleRequestLoad: function(req,_callback,success) {
		var json = haxe.Json.parse(req.result);
		if(success) {
			var data = Reflect.field(json,"data") != null?json.data:json;
			this.resultHash.push(data);
			if(Reflect.field(data,"error_code") != null) _callback(null,data); else _callback(data,null);
		} else _callback(null,json);
		HxOverrides.remove(this.requests,req);
	}
	,pagingCall: function(url,_callback) {
		var params = { locale : this.locale};
		var req = new RCHttp();
		req.onComplete = (function(f,a1,a2,a3) {
			return function() {
				return f(a1,a2,a3);
			};
		})($bind(this,this.handleRequestLoad),req,_callback,true);
		req.onError = (function(f1,a11,a21,a31) {
			return function() {
				return f1(a11,a21,a31);
			};
		})($bind(this,this.handleRequestLoad),req,_callback,false);
		req.call(url,params,"GET");
		this.requests.push(req);
		return req;
	}
	,previousPage: function(data,_callback) {
		var req = null;
		var rawObj = this.getRawResult(data);
		if(rawObj && rawObj.paging && rawObj.paging.previous) req = this.pagingCall(rawObj.paging.previous,_callback); else if(_callback != null) _callback(null,"no page");
		return req;
	}
	,nextPage: function(data,_callback) {
		var req = null;
		var rawObj = this.getRawResult(data);
		if(rawObj && rawObj.paging && rawObj.paging.next) req = this.pagingCall(rawObj.paging.next,_callback); else if(_callback != null) _callback(null,"no page");
		return req;
	}
	,hasPrevious: function(data) {
		var result = this.getRawResult(data);
		return result.paging != null && result.paging.previous != null;
	}
	,hasNext: function(data) {
		var result = this.getRawResult(data);
		return result.paging != null && result.paging.next != null;
	}
	,getRawResult: function(data) {
		return this.resultHash[data];
	}
	,errorHandler: function(req,_callback) {
		haxe.Log.trace(req.result,{ fileName : "Facebook.hx", lineNumber : 488, className : "Facebook", methodName : "errorHandler"});
		var parsedData = haxe.Json.parse(req.result);
		_callback(null,parsedData);
	}
	,completeHandler: function(req,_callback) {
		var parsedData = null;
		try {
			parsedData = haxe.Json.parse(req.result);
			if(parsedData.error != null) _callback(null,parsedData.error); else if(parsedData.data != null) {
				if(this.session.uid == null) this.session.uid = parsedData.id;
				_callback(parsedData.data,null);
			} else {
				if(this.session.uid == null) this.session.uid = parsedData.id;
				_callback(parsedData,null);
			}
		} catch( e ) {
			parsedData = req.result;
			this.errorHandler(req,_callback);
		}
	}
	,api: function(method,_callback,params,requestMethod) {
		if(requestMethod == null) requestMethod = "GET";
		if(method.indexOf("/") != 0) method = "/" + method;
		if(this.getAccessToken() != null) {
			if(params == null) params = { };
			params.access_token = this.getAccessToken();
		}
		if(this.locale != null) params.locale = this.locale;
		var req = new RCHttp();
		req.onComplete = (function(f,a1,a2) {
			return function() {
				return f(a1,a2);
			};
		})($bind(this,this.completeHandler),req,_callback);
		req.onError = (function(f1,a11,a21) {
			return function() {
				return f1(a11,a21);
			};
		})($bind(this,this.errorHandler),req,_callback);
		req.call("https://graph.facebook.com" + method,params,requestMethod);
		this.requests.push(req);
	}
	,handleUI: function(result,method) {
		haxe.Log.trace("handleUI " + result,{ fileName : "Facebook.hx", lineNumber : 405, className : "Facebook", methodName : "handleUI"});
		haxe.Log.trace(method,{ fileName : "Facebook.hx", lineNumber : 405, className : "Facebook", methodName : "handleUI"});
		var decodedResult = result != null?haxe.Json.parse(result):null;
		var uiCallback = this.openUICalls.get(method);
		if(uiCallback != null) uiCallback(decodedResult);
		this.openUICalls.remove(method);
	}
	,ui: function(method,data,_callback,display) {
		data.method = method;
		if(display != null) data.display = display;
	}
	,getAccessToken: function() {
		if(this.oauth2 && this.authResponse != null) return this.authResponse.accessToken; else if(this.session != null) return this.session.accessToken;
		return null;
	}
	,handleAuthResponseChange: function(result) {
		var resultObj = null;
		var success = true;
		if(result != null) try {
			resultObj = haxe.Json.parse(result);
		} catch( e ) {
			success = false;
		} else success = false;
		if(success) {
			this.authResponse = this.generateAuthResponse(resultObj);
			this.session = this.generateSession(this.authResponse);
			haxe.Log.trace(this.authResponse,{ fileName : "Facebook.hx", lineNumber : 359, className : "Facebook", methodName : "handleAuthResponseChange"});
		}
		if(this._initCallback != null) {
			this._initCallback(this.session,null);
			this._initCallback = null;
		}
		if(this._loginCallback != null) {
			this._loginCallback(this.session,null);
			this._loginCallback = null;
		}
	}
	,handleLogout: function() {
		this.authResponse = null;
		if(this._logoutCallback != null) {
			this._logoutCallback(true);
			this._logoutCallback = null;
		}
	}
	,generateSession: function(json) {
		if(json == null) json = { };
		var expireTimestamp = new Date().getTime() + (json != null?Std["int"](json.expires):0);
		var expireDate = (function($this) {
			var $r;
			var d = new Date();
			d.setTime(expireTimestamp);
			$r = d;
			return $r;
		}(this));
		return { uid : json.uid, user : null, sessionKey : json.session_key, expireDate : expireDate, accessToken : json.access_token, secret : json.secret, sig : json.sig, availablePermissions : []};
	}
	,generateAuthResponse: function(json) {
		return { uid : json.userID, expireDate : (function($this) {
			var $r;
			var d = new Date();
			d.setTime(new Date().getTime() + json.expiresIn * 1000);
			$r = d;
			return $r;
		}(this)), accessToken : json.access_token != null?json.access_token:json.accessToken, signedRequest : json.signedRequest};
	}
	,getAuthResponse: function() {
		haxe.Log.trace("getAuthResponse: ",{ fileName : "Facebook.hx", lineNumber : 280, className : "Facebook", methodName : "getAuthResponse"});
		return this.authResponse;
	}
	,logout: function(_callback) {
		this._logoutCallback = _callback;
	}
	,login: function(_callback,options) {
		this._loginCallback = _callback;
	}
	,myId: function() {
		return this.session.uid;
	}
	,isConnected: function() {
		return this.getAccessToken() != null;
	}
	,getLoginStatus: function() {
		haxe.Log.trace("getLoginStatus",{ fileName : "Facebook.hx", lineNumber : 150, className : "Facebook", methodName : "getLoginStatus"});
	}
	,launchWebView: function(url) {
		return null;
	}
	,webView: null
	,resultHash: null
	,requests: null
	,locale: null
	,oauth2: null
	,authResponse: null
	,session: null
	,_logoutCallback: null
	,_loginCallback: null
	,_initCallback: null
	,applicationId: null
	,openUICalls: null
	,__class__: Facebook
}
var Direction = $hxClasses["Direction"] = { __ename__ : ["Direction"], __constructs__ : ["left","right"] }
Direction.left = ["left",0];
Direction.left.toString = $estr;
Direction.left.__enum__ = Direction;
Direction.right = ["right",1];
Direction.right.toString = $estr;
Direction.right.__enum__ = Direction;
var FloatIter = function(v1,v2,step) {
	this.v1 = v1;
	this.v2 = v2;
	this.direction = v1 < v2?Direction.right:Direction.left;
	this.step = step;
};
$hxClasses["FloatIter"] = FloatIter;
FloatIter.__name__ = ["FloatIter"];
FloatIter.prototype = {
	next: function() {
		var _g = this;
		switch( (_g.direction)[1] ) {
		case 0:
			this.v2 -= this.step;
			break;
		case 1:
			this.v1 += this.step;
			break;
		}
		return this.v1 += this.step;
	}
	,hasNext: function() {
		var _g = this;
		switch( (_g.direction)[1] ) {
		case 0:
			this.v1 < this.v2;
			break;
		case 1:
			this.v2 > this.v1;
			break;
		}
		return this.v2 > this.v1;
	}
	,step: null
	,v2: null
	,v1: null
	,direction: null
	,__class__: FloatIter
}
var Fugu = function() { }
$hxClasses["Fugu"] = Fugu;
Fugu.__name__ = ["Fugu"];
Fugu.safeDestroy = function(obj,destroy,pos) {
	if(destroy == null) destroy = true;
	if(obj == null) return false;
	var objs = js.Boot.__instanceof(obj,Array)?obj:[obj];
	var _g = 0;
	while(_g < objs.length) {
		var o = objs[_g];
		++_g;
		if(o == null) continue;
		if(destroy) try {
			o.destroy();
		} catch( e ) {
			haxe.Log.trace("[Error when destroying object: " + Std.string(o) + ", called from " + Std.string(pos) + "]",{ fileName : "Fugu.hx", lineNumber : 28, className : "Fugu", methodName : "safeDestroy"});
			Fugu.stack();
		}
		if(js.Boot.__instanceof(o,JSView)) (js.Boot.__cast(o , JSView)).removeFromSuperview(); else {
			var parent = null;
			try {
				parent = o.parent;
			} catch( e ) {
				null;
			}
			if(parent != null) {
				if(parent.contains(o)) parent.removeChild(o);
			}
		}
	}
	return true;
}
Fugu.safeRemove = function(obj) {
	return Fugu.safeDestroy(obj,false,{ fileName : "Fugu.hx", lineNumber : 46, className : "Fugu", methodName : "safeRemove"});
}
Fugu.safeAdd = function(target,obj) {
	if(target == null || obj == null) return false;
	var objs = js.Boot.__instanceof(obj,Array)?obj:[obj];
	var _g = 0;
	while(_g < objs.length) {
		var o = objs[_g];
		++_g;
		if(o != null) target.addChild(o);
	}
	return true;
}
Fugu.glow = function(target,color,alpha,blur,strength) {
	if(strength == null) strength = 0.6;
}
Fugu.color = function(target,color) {
}
Fugu.resetColor = function(target) {
}
Fugu.brightness = function(target,brightness) {
}
Fugu.align = function(obj,alignment,constraint_w,constraint_h,obj_w,obj_h,margin_x,margin_y) {
	if(margin_y == null) margin_y = 0;
	if(margin_x == null) margin_x = 0;
	if(obj == null) return;
	var arr = alignment.toLowerCase().split(",");
	if(obj_w == null) obj_w = obj.get_width();
	if(obj_h == null) obj_h = obj.get_height();
	obj.set_x((function($this) {
		var $r;
		var _g = arr[0];
		$r = (function($this) {
			var $r;
			switch(_g) {
			case "l":
				$r = margin_x;
				break;
			case "m":
				$r = Math.round((constraint_w - obj_w) / 2);
				break;
			case "r":
				$r = Math.round(constraint_w - obj_w - margin_x);
				break;
			default:
				$r = Std.parseInt(arr[0]);
			}
			return $r;
		}($this));
		return $r;
	}(this)));
	obj.set_y((function($this) {
		var $r;
		var _g1 = arr[1];
		$r = (function($this) {
			var $r;
			switch(_g1) {
			case "t":
				$r = margin_y;
				break;
			case "m":
				$r = Math.round((constraint_h - obj_h) / 2);
				break;
			case "b":
				$r = Math.round(constraint_h - obj_h - margin_y);
				break;
			default:
				$r = Std.parseInt(arr[1]);
			}
			return $r;
		}($this));
		return $r;
	}(this)));
}
Fugu.stack = function() {
	var stack = haxe.CallStack.exceptionStack();
	haxe.Log.trace(haxe.CallStack.toString(stack),{ fileName : "Fugu.hx", lineNumber : 161, className : "Fugu", methodName : "stack"});
}
var RCDisplayObject = function() {
	this.viewWillAppear = new RCSignal();
	this.viewWillDisappear = new RCSignal();
	this.viewDidAppear = new RCSignal();
	this.viewDidDisappear = new RCSignal();
};
$hxClasses["RCDisplayObject"] = RCDisplayObject;
RCDisplayObject.__name__ = ["RCDisplayObject"];
RCDisplayObject.prototype = {
	toString: function() {
		return "[RCView bounds:" + this.get_bounds().origin.x + "x" + this.get_bounds().origin.y + "," + this.get_bounds().size.width + "x" + this.get_bounds().size.height + "]";
	}
	,destroy: function() {
		RCAnimation.remove(this.caobj);
		this.size = null;
	}
	,addAnimation: function(obj) {
		RCAnimation.add(this.caobj = obj);
	}
	,hitTest: function(otherObject) {
		return false;
	}
	,removeChild: function(child) {
	}
	,addChildAt: function(child,index) {
	}
	,addChild: function(child) {
	}
	,get_mouseY: function() {
		return 0;
	}
	,get_mouseX: function() {
		return 0;
	}
	,resetScale: function() {
		this.set_width(this.originalSize.width);
		this.set_height(this.originalSize.height);
	}
	,scale: function(sx,sy) {
	}
	,scaleToFill: function(w,h) {
		if(w / this.originalSize.width > h / this.originalSize.height) {
			this.set_width(w);
			this.set_height(w * this.originalSize.height / this.originalSize.width);
		} else {
			this.set_height(h);
			this.set_width(h * this.originalSize.width / this.originalSize.height);
		}
	}
	,scaleToFit: function(w,h) {
		if(this.size.width / w > this.size.height / h && this.size.width > w) {
			this.set_width(w);
			this.set_height(w * this.originalSize.height / this.originalSize.width);
		} else if(this.size.height > h) {
			this.set_height(h);
			this.set_width(h * this.originalSize.width / this.originalSize.height);
		} else if(this.size.width > this.originalSize.width && this.size.height > this.originalSize.height) {
			this.set_width(this.size.width);
			this.set_height(this.size.height);
		} else this.resetScale();
	}
	,set_center: function(pos) {
		this.center = pos;
		this.set_x(pos.x - this.size.width / 2 | 0);
		this.set_y(pos.y - this.size.height / 2 | 0);
		return this.center;
	}
	,set_backgroundColor: function(color) {
		return color;
	}
	,set_clipsToBounds: function(clip) {
		return clip;
	}
	,set_scaleY: function(sy) {
		this.scaleY_ = sy;
		this.scale(this.scaleX_,this.scaleY_);
		return this.scaleY_;
	}
	,get_scaleY: function() {
		return this.scaleY_;
	}
	,set_scaleX: function(sx) {
		this.scaleX_ = sx;
		this.scale(this.scaleX_,this.scaleY_);
		return this.scaleX_;
	}
	,get_scaleX: function() {
		return this.scaleX_;
	}
	,set_bounds: function(b) {
		this.set_x(b.origin.x);
		this.set_y(b.origin.y);
		this.set_width(b.size.width);
		this.set_height(b.size.height);
		return b;
	}
	,get_bounds: function() {
		return new RCRect(this.x_,this.y_,this.size.width,this.size.height);
	}
	,set_rotation: function(r) {
		return this.rotation_ = r;
	}
	,get_rotation: function() {
		return this.rotation_;
	}
	,set_contentSize: function(s) {
		return this.contentSize_ = s;
	}
	,get_contentSize: function() {
		return this.size;
	}
	,set_height: function(h) {
		return this.size.height = h;
	}
	,get_height: function() {
		return this.size.height;
	}
	,set_width: function(w) {
		return this.size.width = w;
	}
	,get_width: function() {
		return this.size.width;
	}
	,set_y: function(y) {
		return this.y_ = y;
	}
	,get_y: function() {
		return this.y_;
	}
	,set_x: function(x) {
		return this.x_ = x;
	}
	,get_x: function() {
		return this.x_;
	}
	,set_alpha: function(a) {
		return this.alpha_ = a;
	}
	,get_alpha: function() {
		return this.alpha_;
	}
	,set_visible: function(v) {
		return this.visible = v;
	}
	,init: function() {
	}
	,caobj: null
	,originalSize: null
	,contentSize_: null
	,rotation_: null
	,scaleY_: null
	,scaleX_: null
	,alpha_: null
	,y_: null
	,x_: null
	,parent: null
	,mouseY: null
	,mouseX: null
	,visible: null
	,backgroundColor: null
	,clipsToBounds: null
	,center: null
	,size: null
	,viewDidDisappear: null
	,viewDidAppear: null
	,viewWillDisappear: null
	,viewWillAppear: null
	,__class__: RCDisplayObject
	,__properties__: {set_bounds:"set_bounds",get_bounds:"get_bounds",set_contentSize:"set_contentSize",get_contentSize:"get_contentSize",set_center:"set_center",set_clipsToBounds:"set_clipsToBounds",set_backgroundColor:"set_backgroundColor",set_x:"set_x",get_x:"get_x",set_y:"set_y",get_y:"get_y",set_width:"set_width",get_width:"get_width",set_height:"set_height",get_height:"get_height",set_scaleX:"set_scaleX",get_scaleX:"get_scaleX",set_scaleY:"set_scaleY",get_scaleY:"get_scaleY",set_alpha:"set_alpha",get_alpha:"get_alpha",set_rotation:"set_rotation",get_rotation:"get_rotation",set_visible:"set_visible",get_mouseX:"get_mouseX",get_mouseY:"get_mouseY"}
}
var JSView = function(x,y,w,h) {
	RCDisplayObject.call(this);
	this.size = new RCSize(w,h);
	this.contentSize_ = this.size.copy();
	this.scaleX_ = 1;
	this.scaleY_ = 1;
	this.alpha_ = 1;
	this.layer = js.Browser.document.createElement("div");
	this.layer.style.position = "absolute";
	this.layer.style.margin = "0px 0px 0px 0px";
	this.layer.style.width = "auto";
	this.layer.style.height = "auto";
	this.set_x(x);
	this.set_y(y);
};
$hxClasses["JSView"] = JSView;
JSView.__name__ = ["JSView"];
JSView.__super__ = RCDisplayObject;
JSView.prototype = $extend(RCDisplayObject.prototype,{
	get_mouseY: function() {
		if(this.parent == null) return this.mouseY;
		return this.parent.get_mouseY() - this.get_y();
	}
	,get_mouseX: function() {
		return this.layer.clientX;
		if(this.parent == null) return this.mouseX;
		return this.parent.get_mouseX() - this.get_x();
	}
	,stopDrag: function() {
	}
	,startDrag: function(lockCenter,rect) {
	}
	,set_rotation: function(r) {
		this.layer.style[this.getTransformProperty()] = "rotate(" + r + "deg)";
		return RCDisplayObject.prototype.set_rotation.call(this,r);
	}
	,getTransformProperty: function() {
		if(this.transformProperty != null) return this.transformProperty;
		var _g = 0, _g1 = ["transform","WebkitTransform","msTransform","MozTransform","OTransform"];
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(this.layer.style[p] != null) {
				this.transformProperty = p;
				return p;
			}
		}
		return "transform";
	}
	,scale: function(sx,sy) {
		this.layer.style[this.getTransformProperty() + "Origin"] = "top left";
		this.layer.style[this.getTransformProperty()] = "scale(" + sx + "," + sy + ")";
	}
	,transformProperty: null
	,get_contentSize: function() {
		this.contentSize_.width = this.layer.scrollWidth;
		this.contentSize_.height = this.layer.scrollHeight;
		return this.contentSize_;
	}
	,set_height: function(h) {
		this.layer.style.height = h + "px";
		return RCDisplayObject.prototype.set_height.call(this,h);
	}
	,set_width: function(w) {
		this.layer.style.width = w + "px";
		return RCDisplayObject.prototype.set_width.call(this,w);
	}
	,set_y: function(y) {
		this.layer.style.top = Std.string(y * RCDevice.currentDevice().dpiScale) + "px";
		return RCDisplayObject.prototype.set_y.call(this,y);
	}
	,set_x: function(x) {
		this.layer.style.left = Std.string(x * RCDevice.currentDevice().dpiScale) + "px";
		return RCDisplayObject.prototype.set_x.call(this,x);
	}
	,set_alpha: function(a) {
		if(RCDevice.currentDevice().userAgent == RCUserAgent.MSIE) {
			this.layer.style.msFilter = "progid:DXImageTransform.Microsoft.Alpha(Opacity=" + Std.string(a * 100) + ")";
			this.layer.style.filter = "alpha(opacity=" + Std.string(a * 100) + ")";
		} else this.layer.style.opacity = Std.string(a);
		return RCDisplayObject.prototype.set_alpha.call(this,a);
	}
	,set_visible: function(v) {
		this.layer.style.visibility = v?"visible":"hidden";
		return RCDisplayObject.prototype.set_visible.call(this,v);
	}
	,set_clipsToBounds: function(clip) {
		if(clip) {
			this.layer.style.overflow = "hidden";
			this.layerScrollable = js.Browser.document.createElement("div");
			this.layerScrollable.style.width = this.size.width + "px";
			this.layerScrollable.style.height = this.size.height + "px";
			while(this.layer.hasChildNodes()) this.layerScrollable.appendChild(this.layer.removeChild(this.layer.firstChild));
			this.layer.appendChild(this.layerScrollable);
		} else {
			while(this.layerScrollable.hasChildNodes()) this.layer.appendChild(this.layerScrollable.removeChild(this.layerScrollable.firstChild));
			this.layer.style.overflow = null;
			this.layer.removeChild(this.layerScrollable);
			this.layerScrollable = null;
		}
		return clip;
	}
	,set_backgroundColor: function(color) {
		if(color == null) {
			this.layer.style.background = null;
			return color;
		}
		var red = (color & 16711680) >> 16;
		var green = (color & 65280) >> 8;
		var blue = color & 255;
		this.layer.style.backgroundColor = "rgb(" + red + "," + green + "," + blue + ")";
		return color;
	}
	,removeFromSuperview: function() {
		if(this.parent != null) this.parent.removeChild(this);
	}
	,removeChild: function(child) {
		if(child == null) return;
		child.viewWillDisappear.dispatch(null,null,null,null,{ fileName : "JSView.hx", lineNumber : 75, className : "JSView", methodName : "removeChild"});
		child.parent = null;
		this.layer.removeChild(child.layer);
		child.viewDidDisappear.dispatch(null,null,null,null,{ fileName : "JSView.hx", lineNumber : 78, className : "JSView", methodName : "removeChild"});
	}
	,addChildAt: function(child,index) {
		if(this.layer.childNodes[index] != null) this.layer.insertBefore(child.layer,this.layer.childNodes[index]); else this.layer.appendChild(child.layer);
	}
	,addChild: function(child) {
		if(child == null) return;
		child.viewWillAppear.dispatch(null,null,null,null,{ fileName : "JSView.hx", lineNumber : 58, className : "JSView", methodName : "addChild"});
		child.parent = this;
		this.layer.appendChild(child.layer);
		child.viewDidAppear.dispatch(null,null,null,null,{ fileName : "JSView.hx", lineNumber : 61, className : "JSView", methodName : "addChild"});
	}
	,gl: null
	,graphics: null
	,layerScrollable: null
	,layer: null
	,__class__: JSView
});
var GKSprite = function(x,y) {
	JSView.call(this,x,y);
	this.layer2 = new JSView(0,0);
	this.addChild(this.layer2);
};
$hxClasses["GKSprite"] = GKSprite;
GKSprite.__name__ = ["GKSprite"];
GKSprite.__super__ = JSView;
GKSprite.prototype = $extend(JSView.prototype,{
	destroy: function() {
		JSView.prototype.destroy.call(this);
	}
	,set_registrationPoint: function(point) {
		this.layer2.set_x(Math.round(-point.x));
		this.layer2.set_y(Math.round(-point.y));
		return point;
	}
	,registrationPoint: null
	,layer2: null
	,collisionArea: null
	,isOnGround: null
	,jumpForce: null
	,frictionX: null
	,bounceY: null
	,bounceX: null
	,ay: null
	,ax: null
	,vy: null
	,vx: null
	,gravity: null
	,mass: null
	,__class__: GKSprite
	,__properties__: $extend(JSView.prototype.__properties__,{set_registrationPoint:"set_registrationPoint"})
});
var GKCharacter = function(x,y) {
	GKSprite.call(this,x,y);
	this.init();
};
$hxClasses["GKCharacter"] = GKCharacter;
GKCharacter.__name__ = ["GKCharacter"];
GKCharacter.__super__ = GKSprite;
GKCharacter.prototype = $extend(GKSprite.prototype,{
	destroy: function() {
		GKSprite.prototype.destroy.call(this);
	}
	,showState: function(key) {
	}
	,setState: function(key,sprite) {
		try {
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "GKCharacter.hx", lineNumber : 47, className : "GKCharacter", methodName : "setState"});
			Fugu.stack();
		}
	}
	,init: function() {
		GKSprite.prototype.init.call(this);
		this.frames = new haxe.ds.StringMap();
	}
	,frames: null
	,__class__: GKCharacter
});
var GKHealth = function() {
	this.health_ = 0;
};
$hxClasses["GKHealth"] = GKHealth;
GKHealth.__name__ = ["GKHealth"];
GKHealth.prototype = {
	destroy: function() {
	}
	,set_health: function(h) {
		return this.health_ = h;
	}
	,get_health: function() {
		return this.health_;
	}
	,init: function() {
	}
	,health_: null
	,maxHealth: null
	,minHealth: null
	,__class__: GKHealth
	,__properties__: {set_health:"set_health",get_health:"get_health"}
}
var GKMath = function() { }
$hxClasses["GKMath"] = GKMath;
GKMath.__name__ = ["GKMath"];
GKMath.linesIntersection = function(A,B,C,D) {
	var denominator = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);
	if(denominator == 0) return null;
	var rTop = (A.y - C.y) * (D.x - C.x) - (A.x - C.x) * (D.y - C.y);
	var sTop = (A.y - C.y) * (B.x - A.x) - (A.x - C.x) * (B.y - A.y);
	var r = rTop / denominator;
	var s = sTop / denominator;
	if(r > 0 && r < 1 && s > 0 && s < 1) return new RCPoint(A.x + r * (B.x - A.x),A.y + r * (B.y - A.y));
	return null;
}
GKMath.distanceToLine = function(point,A,B) {
	var dx = B.x - A.x;
	var dy = B.y - A.y;
	var u = ((point.x - A.x) * dx + (point.y - A.y) * dy) / (dx * dx + dy * dy);
	return u < 0?new RCPoint(A.x,A.y):u > 1?new RCPoint(B.x,B.y):new RCPoint(A.x + u * dx,A.y + u * dy);
}
var GKPathFinding = function() {
};
$hxClasses["GKPathFinding"] = GKPathFinding;
GKPathFinding.__name__ = ["GKPathFinding"];
GKPathFinding.prototype = {
	__class__: GKPathFinding
}
var GKScore = function() {
	this.reset();
};
$hxClasses["GKScore"] = GKScore;
GKScore.__name__ = ["GKScore"];
GKScore.prototype = {
	destroy: function() {
		RCAnimation.remove(this.obj);
		this.obj = null;
	}
	,update: function(v) {
		this.score = Math.round(v);
		this.onChange();
	}
	,set: function(s) {
		this.totalScore = s;
		if(this.score > this.bestScore) this.bestScore = this.score;
		RCAnimation.remove(this.obj);
		this.obj = new CATCallFunc($bind(this,this.update),{ value : { fromValue : this.score, toValue : this.totalScore}},this.speed,0,eq.Cubic.IN_OUT,{ fileName : "GKScore.hx", lineNumber : 67, className : "GKScore", methodName : "set"});
		RCAnimation.add(this.obj);
		return this.totalScore;
	}
	,remove: function(s) {
		this.downs++;
		return this.set(this.totalScore - s);
	}
	,push: function(s) {
		this.ups++;
		return this.set(this.totalScore + s);
	}
	,reset: function() {
		RCAnimation.remove(this.obj);
		this.score = 0;
		this.totalScore = 0;
		this.bestScore = 0;
		this.speed = 1;
		this.ups = 0;
		this.downs = 0;
	}
	,onChange: function() {
	}
	,downs: null
	,ups: null
	,speed: null
	,totalScore: null
	,bestScore: null
	,score: null
	,obj: null
	,__class__: GKScore
}
var RCRequest = function() {
};
$hxClasses["RCRequest"] = RCRequest;
RCRequest.__name__ = ["RCRequest"];
RCRequest.prototype = {
	destroy: function() {
		this.removeListeners(this.loader);
		this.loader = null;
	}
	,createVariables: function(variables_list) {
		if(variables_list == null) return null;
		var variables = new _RCRequest.URLVariables();
		if(variables_list != null) {
			var _g = 0, _g1 = Reflect.fields(variables_list);
			while(_g < _g1.length) {
				var f = _g1[_g];
				++_g;
				variables[f] = Reflect.field(variables_list,f);
			}
		}
		return variables;
	}
	,createRequest: function(URL,variables,method) {
		return null;
	}
	,ioErrorHandler: function(e) {
		this.result = e;
		this.onError();
	}
	,httpStatusHandler: function(e) {
		this.status = e;
		this.onStatus();
	}
	,securityErrorHandler: function(e) {
		this.result = e;
		this.onError();
	}
	,progressHandler: function(e) {
	}
	,completeHandler: function(e) {
		this.result = e;
		if(this.result.indexOf("error::") != -1) {
			this.result = this.result.split("error::").pop();
			this.onError();
		} else this.onComplete();
	}
	,openHandler: function(e) {
		this.onOpen();
	}
	,removeListeners: function(dispatcher) {
		if(dispatcher == null) return;
		dispatcher.onData = null;
		dispatcher.onError = null;
		dispatcher.onStatus = null;
	}
	,addListeners: function(dispatcher) {
		if(dispatcher == null) return;
		dispatcher.onData = $bind(this,this.completeHandler);
		dispatcher.onError = $bind(this,this.securityErrorHandler);
		dispatcher.onStatus = $bind(this,this.httpStatusHandler);
	}
	,load: function(URL,variables,method) {
		if(method == null) method = "GET";
		this.loader = new haxe.Http(URL);
		this.loader.async = true;
		var _g = 0, _g1 = Reflect.fields(variables);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			this.loader.setParameter(key,Reflect.field(variables,key));
		}
		this.addListeners(this.loader);
		this.loader.request(method == "POST"?true:false);
	}
	,onStatus: function() {
	}
	,onProgress: function() {
	}
	,onError: function() {
	}
	,onComplete: function() {
	}
	,onOpen: function() {
	}
	,percentLoaded: null
	,status: null
	,result: null
	,loader: null
	,__class__: RCRequest
}
var GKScoreBoard = function(apiPath,userId) {
	this.userId = userId;
	this.apiPath = apiPath;
	if(apiPath != "" && !StringTools.endsWith(apiPath,"/")) this.apiPath += "/";
	RCRequest.call(this);
};
$hxClasses["GKScoreBoard"] = GKScoreBoard;
GKScoreBoard.__name__ = ["GKScoreBoard"];
GKScoreBoard.__super__ = RCRequest;
GKScoreBoard.prototype = $extend(RCRequest.prototype,{
	writeAchievement: function(achievementId,value) {
		var vars = { userId : this.userId, achievementId : achievementId, value : value};
		this.load(this.apiPath + "gamekit/achievements/write.php",this.createVariables(vars),"POST");
	}
	,requestAchievements: function() {
		var vars = { userId : this.userId};
		this.load(this.apiPath + "gamekit/achievements/read.php",this.createVariables(vars),"GET");
	}
	,writeScore: function(score) {
		var vars = { userId : this.userId, score : score};
		this.load(this.apiPath + "gamekit/scoreboard/write.php",this.createVariables(vars),"POST");
	}
	,requestGeneralTopScore: function(minDate) {
		var vars = { timestamp : minDate != null?minDate.getTime():new Date().getTime()};
		this.load(this.apiPath + "gamekit/scoreboard/read.php",this.createVariables(vars),"GET");
	}
	,requestFriendsTopScore: function(minDate) {
		var vars = { userId : this.userId, includeFriends : "true", timestamp : minDate != null?minDate.getTime():new Date().getTime()};
		this.load(this.apiPath + "gamekit/scoreboard/read.php",this.createVariables(vars),"GET");
	}
	,requestYourTopScore: function(minDate) {
		var vars = { userId : this.userId, timestamp : minDate != null?minDate.getTime():new Date().getTime()};
		this.load(this.apiPath + "gamekit/scoreboard/read.php",this.createVariables(vars),"GET");
	}
	,writeFriends: function(ids) {
		var vars = { userId : this.userId, friends : ids.join(",")};
		this.load(this.apiPath + "gamekit/friends/write.php",this.createVariables(vars),"POST");
	}
	,userId: null
	,apiPath: null
	,__class__: GKScoreBoard
});
var GKSound = function() { }
$hxClasses["GKSound"] = GKSound;
GKSound.__name__ = ["GKSound"];
GKSound.sounds = null;
GKSound.muted = null;
GKSound.init = function() {
	if(GKSound.sounds == null) {
		GKSound.sounds = new haxe.ds.StringMap();
		GKSound.muted = false;
	}
}
GKSound.preloadBackgroundMusic = function(id,url) {
	var snd = new JSAudio(url);
	snd.init();
	GKSound.sounds.set(id,snd);
}
GKSound.preloadEffectSound = function(id,url) {
	var snd = new JSAudio(url);
	snd.init();
	GKSound.sounds.set(id,snd);
}
GKSound.playBackgroundMusic = function(id,repeat) {
	if(repeat == null) repeat = true;
	if(!GKSound.muted) {
		var snd = GKSound.sounds.get(id);
		if(snd != null) {
			snd.repeat = repeat;
			snd.start();
		}
	}
}
GKSound.playEffectSound = function(id,repeat) {
	if(repeat == null) repeat = false;
	if(!GKSound.muted) {
		var snd = GKSound.sounds.get(id);
		if(snd != null) {
			snd.repeat = repeat;
			snd.start();
		}
	}
}
GKSound.stopSound = function(id) {
	var snd = GKSound.sounds.get(id);
	if(snd != null) snd.stop();
}
GKSound.mute = function(b) {
	GKSound.muted = b;
	var $it0 = GKSound.sounds.iterator();
	while( $it0.hasNext() ) {
		var snd = $it0.next();
		if(GKSound.muted) snd.stop();
	}
}
GKSound.isMuted = function() {
	return GKSound.muted;
}
var HTTPTokenizedRequest = function(scripts_path) {
	this.scripts_path = scripts_path;
	RCRequest.call(this);
};
$hxClasses["HTTPTokenizedRequest"] = HTTPTokenizedRequest;
HTTPTokenizedRequest.__name__ = ["HTTPTokenizedRequest"];
HTTPTokenizedRequest.__super__ = RCRequest;
HTTPTokenizedRequest.prototype = $extend(RCRequest.prototype,{
	destroy: function() {
	}
	,init: function() {
	}
	,scripts_path: null
	,__class__: HTTPTokenizedRequest
});
var JSExternalInterface = function() { }
$hxClasses["JSExternalInterface"] = JSExternalInterface;
JSExternalInterface.__name__ = ["JSExternalInterface"];
JSExternalInterface.addCallback = function(functionName,closure) {
	switch(functionName) {
	case "setSWFAddressValue":
		SWFAddress.addEventListener("change",function(e) {
			closure(e.value);
		});
		break;
	}
}
JSExternalInterface.call = function(functionName,p1,p2,p3,p4,p5) {
	switch(functionName) {
	case "SWFAddress.back":
		SWFAddress.back();
		break;
	case "SWFAddress.forward":
		SWFAddress.forward();
		break;
	case "SWFAddress.go":
		SWFAddress.go(p1);
		break;
	case "SWFAddress.href":
		SWFAddress.href(p1,p2);
		break;
	case "SWFAddress.popup":
		SWFAddress.popup(p1,p2,p3,p4);
		break;
	case "SWFAddress.getBaseURL":
		return SWFAddress.getBaseURL();
	case "SWFAddress.getStrict":
		return SWFAddress.getStrict();
	case "SWFAddress.setStrict":
		SWFAddress.setStrict(p1);
		break;
	case "SWFAddress.getHistory":
		return SWFAddress.getHistory();
	case "SWFAddress.setHistory":
		SWFAddress.setHistory(p1);
		break;
	case "SWFAddress.getTracker":
		return SWFAddress.getTracker();
	case "SWFAddress.setTracker":
		SWFAddress.setTracker(p1);
		break;
	case "SWFAddress.getTitle":
		return SWFAddress.getTitle();
	case "SWFAddress.setTitle":
		SWFAddress.setTitle(p1);
		break;
	case "SWFAddress.getStatus":
		return SWFAddress.getStatus();
	case "SWFAddress.setStatus":
		SWFAddress.setStatus(p1);
		break;
	case "SWFAddress.resetStatus":
		SWFAddress.resetStatus();
		break;
	case "SWFAddress.getValue":
		return SWFAddress.getValue();
	case "SWFAddress.setValue":
		SWFAddress.setValue(p1);
		break;
	case "SWFAddress.getIds":
		return SWFAddress.getIds();
	case "function() { return (typeof SWFAddress != \"undefined\"); }":
		return function() { return (typeof SWFAddress != "undefined"); }();
	default:
		throw "You are trying to call an inexisting extern method";
	}
	return null;
}
var HXAddressSignal = function() {
	this.removeAll();
};
$hxClasses["HXAddressSignal"] = HXAddressSignal;
HXAddressSignal.__name__ = ["HXAddressSignal"];
HXAddressSignal.prototype = {
	dispatch: function(args) {
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var listener = $it0.next();
			try {
				listener.apply(null,[args.slice()]);
			} catch( e ) {
				haxe.Log.trace("[HXAddressEvent error calling: " + Std.string(listener) + "]",{ fileName : "HXAddress.hx", lineNumber : 524, className : "HXAddressSignal", methodName : "dispatch"});
			}
		}
	}
	,removeAll: function() {
		this.listeners = new List();
	}
	,remove: function(listener) {
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			if(Reflect.compareMethods(l,listener)) {
				this.listeners.remove(listener);
				return;
			}
		}
	}
	,add: function(listener) {
		this.listeners.add(listener);
	}
	,listeners: null
	,__class__: HXAddressSignal
}
var haxe = {}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
}
haxe.Timer.prototype = {
	run: function() {
	}
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,id: null
	,__class__: haxe.Timer
}
var HXAddress = function() {
	throw "HXAddress should not be instantiated.";
};
$hxClasses["HXAddress"] = HXAddress;
HXAddress.__name__ = ["HXAddress"];
HXAddress._queueTimer = null;
HXAddress._initTimer = null;
HXAddress.init = null;
HXAddress.change = null;
HXAddress.externalChange = null;
HXAddress.internalChange = null;
HXAddress._initialize = function() {
	if(HXAddress._availability) try {
		HXAddress._availability = JSExternalInterface.call("function() { return (typeof SWFAddress != \"undefined\"); }");
		JSExternalInterface.addCallback("getSWFAddressValue",function() {
			return HXAddress._value;
		});
		JSExternalInterface.addCallback("setSWFAddressValue",HXAddress._setValue);
	} catch( e ) {
		HXAddress._availability = false;
	}
	HXAddress.init = new HXAddressSignal();
	HXAddress.change = new HXAddressSignal();
	HXAddress.externalChange = new HXAddressSignal();
	HXAddress.internalChange = new HXAddressSignal();
	HXAddress._initTimer = new haxe.Timer(10);
	HXAddress._initTimer.run = HXAddress._check;
	return true;
}
HXAddress._check = function() {
	if(HXAddress.init.listeners.length > 0 && !HXAddress._init) {
		HXAddress._setValueInit(HXAddress._getValue());
		HXAddress._init = true;
	}
	if(HXAddress.change.listeners.length > 0) {
		if(HXAddress._initTimer != null) HXAddress._initTimer.stop();
		HXAddress._initTimer = null;
		HXAddress._init = true;
		HXAddress._setValueInit(HXAddress._getValue());
	}
}
HXAddress._strictCheck = function(value,force) {
	if(HXAddress.getStrict()) {
		if(force) {
			if(HxOverrides.substr(value,0,1) != "/") value = "/" + value;
		} else if(value == "") value = "/";
	}
	return value;
}
HXAddress._getValue = function() {
	var value = null, ids = null;
	if(HXAddress._availability) {
		value = Std.string(JSExternalInterface.call("SWFAddress.getValue"));
		var arr = JSExternalInterface.call("SWFAddress.getIds");
		if(arr != null) ids = arr.toString();
	}
	if(HXAddress.isNull(ids) || !HXAddress._availability || HXAddress._initChanged) value = HXAddress._value; else if(HXAddress.isNull(value)) value = "";
	return HXAddress._strictCheck(value,false);
}
HXAddress._setValueInit = function(value) {
	HXAddress._value = value;
	var pathNames = HXAddress.getPathNames();
	if(!HXAddress._init) HXAddress.init.dispatch(pathNames); else {
		HXAddress.change.dispatch(pathNames);
		HXAddress.externalChange.dispatch(pathNames);
	}
	HXAddress._initChange = true;
}
HXAddress._setValue = function(value) {
	if(HXAddress.isNull(value)) value = "";
	if(HXAddress._value == value && HXAddress._init) return;
	if(!HXAddress._initChange) return;
	HXAddress._value = value;
	var pathNames = HXAddress.getPathNames();
	if(!HXAddress._init) {
		HXAddress._init = true;
		HXAddress.init.dispatch(pathNames);
	}
	HXAddress.change.dispatch(pathNames);
	HXAddress.externalChange.dispatch(pathNames);
}
HXAddress._callQueue = function() {
	haxe.Log.trace("If you see this trace means something went wrong, _callQueue is used in flash on Mac only",{ fileName : "HXAddress.hx", lineNumber : 142, className : "HXAddress", methodName : "_callQueue"});
	if(HXAddress._queue.length != 0) {
		var script = "";
		var _g = 0, _g1 = HXAddress._queue;
		while(_g < _g1.length) {
			var q = _g1[_g];
			++_g;
			if(js.Boot.__instanceof(q.param,String)) q.param = "\"" + Std.string(q.param) + "\"";
			script += q.fn + "(" + Std.string(q.param) + ");";
		}
		HXAddress._queue = [];
	} else if(HXAddress._queueTimer != null) {
		HXAddress._queueTimer.stop();
		HXAddress._queueTimer = null;
	}
}
HXAddress._call = function(fn,param) {
	if(param == null) param = "";
	if(HXAddress._availability) {
		JSExternalInterface.call(fn,param);
		return;
		if(HXAddress.isMac()) {
			if(HXAddress._queue.length == 0) {
				if(HXAddress._queueTimer != null) HXAddress._queueTimer.stop();
				HXAddress._queueTimer = new haxe.Timer(10);
				HXAddress._queueTimer.run = HXAddress._callQueue;
			}
			var q = { fn : fn, param : param};
			HXAddress._queue.push(q);
		} else JSExternalInterface.call(fn,param);
	}
}
HXAddress.back = function() {
	HXAddress._call("SWFAddress.back");
}
HXAddress.forward = function() {
	HXAddress._call("SWFAddress.forward");
}
HXAddress.up = function() {
	var path = HXAddress.getPath();
	HXAddress.setValue(HxOverrides.substr(path,0,path.lastIndexOf("/",path.length - 2) + (HxOverrides.substr(path,path.length - 1,null) == "/"?1:0)));
}
HXAddress.go = function(delta) {
	HXAddress._call("SWFAddress.go",delta);
}
HXAddress.href = function(url,target) {
	if(target == null) target = "_self";
	if(HXAddress._availability && (HXAddress.isActiveX() || HXAddress.isJS())) {
		JSExternalInterface.call("SWFAddress.href",url,target);
		return;
	}
}
HXAddress.popup = function(url,name,options,handler) {
	if(handler == null) handler = "";
	if(options == null) options = "\"\"";
	if(name == null) name = "popup";
	if(HXAddress._availability && (HXAddress.isActiveX() || HXAddress.isJS() || JSExternalInterface.call("asual.util.Browser.isSafari"))) {
		haxe.Log.trace("good to go",{ fileName : "HXAddress.hx", lineNumber : 243, className : "HXAddress", methodName : "popup"});
		JSExternalInterface.call("SWFAddress.popup",url,name,options,handler);
		return;
	}
}
HXAddress.getBaseURL = function() {
	var url = null;
	if(HXAddress._availability) url = Std.string(JSExternalInterface.call("SWFAddress.getBaseURL"));
	return HXAddress.isNull(url) || !HXAddress._availability?"":url;
}
HXAddress.getStrict = function() {
	var strict = null;
	if(HXAddress._availability) strict = Std.string(JSExternalInterface.call("SWFAddress.getStrict"));
	return HXAddress.isNull(strict)?HXAddress._strict:strict == "true";
}
HXAddress.setStrict = function(strict) {
	HXAddress._call("SWFAddress.setStrict",strict);
	HXAddress._strict = strict;
}
HXAddress.getHistory = function() {
	if(HXAddress._availability) {
		var hasHistory = JSExternalInterface.call("SWFAddress.getHistory");
		return hasHistory == "true" || hasHistory == true;
	}
	return false;
}
HXAddress.setHistory = function(history) {
	HXAddress._call("SWFAddress.setHistory",history);
}
HXAddress.getTracker = function() {
	return HXAddress._availability?Std.string(JSExternalInterface.call("SWFAddress.getTracker")):"";
}
HXAddress.setTracker = function(tracker) {
	HXAddress._call("SWFAddress.setTracker",tracker);
}
HXAddress.getTitle = function() {
	var title = HXAddress._availability?Std.string(JSExternalInterface.call("SWFAddress.getTitle")):"";
	if(HXAddress.isNull(title)) title = "";
	return StringTools.htmlUnescape(title);
}
HXAddress.setTitle = function(title) {
	HXAddress._call("SWFAddress.setTitle",StringTools.htmlEscape(StringTools.htmlUnescape(title)));
}
HXAddress.getStatus = function() {
	var status = HXAddress._availability?Std.string(JSExternalInterface.call("SWFAddress.getStatus")):"";
	if(HXAddress.isNull(status)) status = "";
	return StringTools.htmlUnescape(status);
}
HXAddress.setStatus = function(status) {
	HXAddress._call("SWFAddress.setStatus",StringTools.htmlEscape(StringTools.htmlUnescape(status)));
}
HXAddress.resetStatus = function() {
	HXAddress._call("SWFAddress.resetStatus");
}
HXAddress.getValue = function() {
	return StringTools.htmlUnescape(HXAddress._strictCheck(HXAddress._value,false));
}
HXAddress.setValue = function(value) {
	if(HXAddress.isNull(value)) value = "";
	value = StringTools.htmlEscape(StringTools.htmlUnescape(HXAddress._strictCheck(value,true)));
	if(HXAddress._value == value) return;
	HXAddress._value = value;
	HXAddress._call("SWFAddress.setValue",value);
	if(HXAddress._init) {
		var pathNames = HXAddress.getPathNames();
		HXAddress.change.dispatch(pathNames);
		HXAddress.internalChange.dispatch(pathNames);
	} else HXAddress._initChanged = true;
}
HXAddress.getPath = function() {
	var value = HXAddress.getValue();
	if(value.indexOf("?") != -1) return value.split("?")[0]; else if(value.indexOf("#") != -1) return value.split("#")[0]; else return value;
}
HXAddress.getPathNames = function() {
	var path = HXAddress.getPath();
	var names = path.split("/");
	if(HxOverrides.substr(path,0,1) == "/" || path.length == 0) names.splice(0,1);
	if(HxOverrides.substr(path,path.length - 1,1) == "/") names.splice(names.length - 1,1);
	return names;
}
HXAddress.getQueryString = function() {
	var value = HXAddress.getValue();
	var index = value.indexOf("?");
	if(index != -1 && index < value.length) return HxOverrides.substr(value,index + 1,null);
	return null;
}
HXAddress.getParameter = function(param) {
	var value = HXAddress.getValue();
	var index = value.indexOf("?");
	if(index != -1) {
		value = HxOverrides.substr(value,index + 1,null);
		var params = value.split("&");
		var i = params.length;
		while(i-- >= 0) {
			var p = params[i].split("=");
			if(p[0] == param) return p[1];
		}
	}
	return null;
}
HXAddress.getParameterNames = function() {
	var value = HXAddress.getValue();
	var index = value.indexOf("?");
	var names = new Array();
	if(index != -1) {
		value = HxOverrides.substr(value,index + 1,null);
		if(value != "" && value.indexOf("=") != -1) {
			var params = value.split("&");
			var i = 0;
			while(i < params.length) {
				names.push(params[i].split("=")[0]);
				i++;
			}
		}
	}
	return names;
}
HXAddress.isNull = function(value) {
	return value == "undefined" || value == "null" || value == null;
}
HXAddress.isMac = function() {
	return true;
}
HXAddress.isActiveX = function() {
	return true;
}
HXAddress.isJS = function() {
	return true;
}
HXAddress.prototype = {
	__class__: HXAddress
}
var HXAddressManager = function() { }
$hxClasses["HXAddressManager"] = HXAddressManager;
HXAddressManager.__name__ = ["HXAddressManager"];
HXAddressManager._title = null;
HXAddressManager._pages = null;
HXAddressManager.init = function(title) {
	HXAddressManager._title = title;
	if(HXAddressManager._pages != null) return;
	HXAddressManager._pages = new haxe.ds.StringMap();
	HXAddress.change.add(HXAddressManager.onChangeHandler);
}
HXAddressManager.registerPage = function(key,func) {
	if(key == null) key = "";
	if(HXAddressManager._pages == null) HXAddressManager.init("HXAddress");
	if(!Reflect.isFunction(func)) return;
	var value = func;
	HXAddressManager._pages.set(key,value);
}
HXAddressManager.navigateToPage = function(addr) {
	HXAddress.setValue("/" + addr);
}
HXAddressManager.onChangeHandler = function(pathNames) {
	HXAddress.setTitle(HXAddressManager.formatTitle(HXAddress.getValue()));
	HXAddressManager.call(pathNames.shift());
}
HXAddressManager.call = function(key) {
	if(key == null) key = "";
	if(HXAddressManager._pages.exists(key)) try {
		(HXAddressManager._pages.get(key))();
	} catch( e ) {
		haxe.Log.trace("[HXAddressManager error on executing page key: {" + key + "}], {" + Std.string(e) + "}",{ fileName : "HXAddressManager.hx", lineNumber : 59, className : "HXAddressManager", methodName : "call"});
	}
}
HXAddressManager.formatTitle = function(title) {
	return HXAddressManager._title + (title != "/"?" / " + HXAddressManager.toTitleCase(StringTools.replace(HxOverrides.substr(title,1,title.length - 1),"/"," / ")):"");
}
HXAddressManager.toTitleCase = function(str) {
	return HxOverrides.substr(str,0,1).toUpperCase() + HxOverrides.substr(str,1,null);
}
var HxOverrides = function() { }
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntIterator = function(min,max) {
	this.min = min;
	this.max = max;
};
$hxClasses["IntIterator"] = IntIterator;
IntIterator.__name__ = ["IntIterator"];
IntIterator.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIterator
}
var RCAudioInterface = function() { }
$hxClasses["RCAudioInterface"] = RCAudioInterface;
RCAudioInterface.__name__ = ["RCAudioInterface"];
RCAudioInterface.prototype = {
	set_volume: null
	,get_volume: null
	,destroy: null
	,__class__: RCAudioInterface
}
var JSAudio = function(URL) {
	this.URL = URL;
	this.updateTime = JSAudio.DISPLAY_TIMER_UPDATE_DELAY;
	this.repeat = false;
	this.volume_ = 1;
};
$hxClasses["JSAudio"] = JSAudio;
JSAudio.__name__ = ["JSAudio"];
JSAudio.__interfaces__ = [RCAudioInterface];
JSAudio.prototype = {
	destroy: function() {
		this.stop();
		if(this.timer != null) this.timer.stop();
		this.timer = null;
	}
	,set_volume: function(volume) {
		this.volume_ = volume > 1?1:volume;
		if(this.sound != null) this.sound.volume = this.volume_;
		return this.volume_;
	}
	,get_volume: function() {
		return this.volume_;
	}
	,loop: function() {
		this.onPlayingProgress();
	}
	,id3Handler: function() {
		this.medatadaReady = true;
		this.onID3();
	}
	,completeHandler: function(e) {
		this.onLoadComplete();
	}
	,stop: function() {
		if(this.playing_ && this.sound != null) {
			this.sound.pause();
			this.playing_ = false;
		}
		this.time = 0;
		if(this.timer != null) this.timer.stop();
		this.soundDidStopPlaying();
	}
	,start: function(time) {
		if(this.sound == null) this.init();
		if(this.sound != null) {
			try {
				this.sound.currentTime = 0;
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "JSAudio.hx", lineNumber : 85, className : "JSAudio", methodName : "start"});
			}
			this.sound.play();
			this.playing_ = true;
		}
		this.soundDidStartPlaying();
	}
	,init: function() {
		this.loaded_ = true;
		this.playing_ = false;
		this.sound = new Audio();
		this.sound.autoplay = false;
		this.sound.preload = "auto";
		this.sound.loop = false;
		this.sound.src = this.URL;
		this.sound.load();
		js.Browser.document.body.appendChild(this.sound);
		this.timer = new haxe.Timer(this.updateTime);
	}
	,soundDidStopPlaying: function() {
	}
	,soundDidStartPlaying: function() {
	}
	,soundDidFinishPlaying: function() {
	}
	,onID3: function() {
	}
	,onError: function() {
	}
	,onLoadComplete: function() {
	}
	,onLoadingProgress: function() {
	}
	,onPlayingProgress: function() {
	}
	,repeat: null
	,id3: null
	,duration: null
	,time: null
	,updateTime: null
	,percentPlayed: null
	,percentLoaded: null
	,errorMessage: null
	,medatadaReady: null
	,playing_: null
	,loaded_: null
	,volume_: null
	,timer: null
	,channel: null
	,sound: null
	,URL: null
	,__class__: JSAudio
	,__properties__: {set_volume:"set_volume",get_volume:"get_volume"}
}
var JSPluginLoader = function(path) {
	haxe.Log.trace("load new Plugin " + path,{ fileName : "JSPluginLoader.hx", lineNumber : 21, className : "JSPluginLoader", methodName : "new"});
	var fileref = null;
	if(path.indexOf(".js") != -1) {
		fileref = js.Browser.document.createElement("script");
		fileref.setAttribute("type","text/javascript");
		fileref.setAttribute("src",path);
	} else if(path.indexOf(".css") != -1) {
		fileref = js.Browser.document.createElement("link");
		fileref.setAttribute("rel","stylesheet");
		fileref.setAttribute("type","text/css");
		fileref.setAttribute("href",path);
	}
	if(fileref != null) {
		fileref.onload = $bind(this,this.completeHandler);
		js.Browser.document.getElementsByTagName("head")[0].appendChild(fileref);
	}
};
$hxClasses["JSPluginLoader"] = JSPluginLoader;
JSPluginLoader.__name__ = ["JSPluginLoader"];
JSPluginLoader.exists = function(filename) {
	haxe.Log.trace("exists " + filename,{ fileName : "JSPluginLoader.hx", lineNumber : 77, className : "JSPluginLoader", methodName : "exists"});
	var element = filename.indexOf(".js") != -1?"script":filename.indexOf(".css") != -1?"link":"none";
	var attr = filename.indexOf(".js") != -1?"src":filename.indexOf(".css") != -1?"href":"none";
	var collection = js.Browser.document.getElementsByTagName(element);
	var _g1 = 0, _g = collection.length;
	while(_g1 < _g) {
		var i = _g1++;
		var e = collection.item(i);
		haxe.Log.trace(e.src,{ fileName : "JSPluginLoader.hx", lineNumber : 84, className : "JSPluginLoader", methodName : "exists"});
		haxe.Log.trace(e.getAttribute(attr),{ fileName : "JSPluginLoader.hx", lineNumber : 85, className : "JSPluginLoader", methodName : "exists"});
		if(e.getAttribute(attr) != null && e.getAttribute(attr).indexOf(filename) != -1) return true;
	}
	return false;
}
JSPluginLoader.prototype = {
	destroy: function() {
	}
	,remove: function(path) {
		return true;
	}
	,completeHandler: function(e) {
		haxe.Log.trace("plugin loaded asyncronously",{ fileName : "JSPluginLoader.hx", lineNumber : 44, className : "JSPluginLoader", methodName : "completeHandler"});
		this.onComplete();
	}
	,onError: function() {
	}
	,onComplete: function() {
	}
	,onProgress: function() {
	}
	,percentLoaded: null
	,__class__: JSPluginLoader
}
var RCVideoInterface = function() { }
$hxClasses["RCVideoInterface"] = RCVideoInterface;
RCVideoInterface.__name__ = ["RCVideoInterface"];
RCVideoInterface.prototype = {
	destroy: null
	,togglePause: null
	,replayVideo: null
	,resumeVideo: null
	,pauseVideo: null
	,stopSeeking: null
	,seekTo: null
	,stopVideo: null
	,startVideo: null
	,init: null
	,__class__: RCVideoInterface
}
var JSVideo = function(x,y,URL,w,h) {
	JSView.call(this,x,y,w,h);
	this.videoURL = URL;
	this.inited_ = false;
	this.loaded_ = false;
	this.seeking_ = false;
	this.isPlaying = false;
	this.percentLoaded = 0;
	this.percentPlayed = 0;
	this.time = 0.0;
	this.duration = 0.0;
	this.statusMessage = "Not inited";
	this.updateTime = JSVideo.DISPLAY_TIMER_UPDATE_DELAY;
	this.volume_ = JSVideo.DEFAULT_VOLUME;
	this.addChild(this.background = new RCRectangle(0,0,w,h,0,0));
	this.init();
};
$hxClasses["JSVideo"] = JSVideo;
JSVideo.__name__ = ["JSVideo"];
JSVideo.__interfaces__ = [RCVideoInterface];
JSVideo.__super__ = JSView;
JSVideo.prototype = $extend(JSView.prototype,{
	destroy: function() {
		if(this.timer != null) this.timer.stop();
		this.video.src = "";
		this.video.removeEventListener("error",$bind(this,this.errorHandler),false);
		this.video.removeEventListener("loadedmetadata",$bind(this,this.onMetaData),false);
		this.video.removeEventListener("playing",$bind(this,this.videoDidStartHandler),false);
		this.video.removeEventListener("ended",$bind(this,this.videoDidFinishPlayingHandler),false);
		this.video.removeEventListener("stalled",$bind(this,this.onBufferEmptyHandler),false);
		this.video.removeEventListener("canplay",$bind(this,this.onBufferFullHandler),false);
		this.video.removeEventListener("canplaythrough",$bind(this,this.onBufferFullHandler),false);
		this.video.removeEventListener("waiting",$bind(this,this.onBufferEmptyHandler),false);
		this.video = null;
		JSView.prototype.destroy.call(this);
	}
	,setSize: function(w,h) {
		this.size.width = w;
		this.size.height = h;
		this.background.set_width(w);
		this.background.set_height(h);
		var holderAspectRatio = w / h;
		if(this.aspectRatio != null) {
			if(this.aspectRatio < holderAspectRatio) {
				this.video.height = Math.round(h);
				this.video.width = Math.round(h * this.aspectRatio);
			} else {
				this.video.width = Math.round(w);
				this.video.height = Math.round(w / this.aspectRatio);
			}
		} else {
			this.video.width = Math.round(w);
			this.video.height = Math.round(h);
		}
		this.video.style.left = Math.round((w - this.video.width) / 2) + "px";
		this.video.style.top = Math.round((h - this.video.height) / 2) + "px";
	}
	,set_volume: function(volume) {
		this.volume_ = volume > 1?1:volume;
		this.video.volume = Math.round(this.volume_ * 10) / 10;
		return this.volume_;
	}
	,get_volume: function() {
		return this.volume_;
	}
	,stopSeeking: function() {
		this.seeking_ = false;
	}
	,seekTo: function(time) {
		this.seeking_ = true;
		if(time > this.duration * this.percentLoaded / 100) return false;
		this.video.currentTime = time;
		return true;
	}
	,togglePause: function() {
		if(this.isPlaying) this.pauseVideo(); else this.resumeVideo();
	}
	,resumeVideo: function() {
		this.video.play();
	}
	,pauseVideo: function() {
		this.video.pause();
	}
	,stopVideo: function() {
		this.video.src = "";
	}
	,replayVideo: function() {
		this.video.currentTime = 0;
		this.video.play();
	}
	,startVideo: function(file) {
		this.video.load();
		this.isPlaying = true;
	}
	,videoDidStartHandler: function(e) {
		haxe.Log.trace("videoDidStart",{ fileName : "JSVideo.hx", lineNumber : 240, className : "JSVideo", methodName : "videoDidStartHandler"});
		this.videoDidStart();
		this.timer.run = $bind(this,this.loop);
	}
	,videoDidFinishPlayingHandler: function(e) {
		haxe.Log.trace("videoDidFinishPlaying",{ fileName : "JSVideo.hx", lineNumber : 235, className : "JSVideo", methodName : "videoDidFinishPlayingHandler"});
		this.videoDidFinishPlaying();
		this.timer.stop();
	}
	,onMetaData: function(e) {
		haxe.Log.trace("JSVideo medatada received. Now ready to play.",{ fileName : "JSVideo.hx", lineNumber : 210, className : "JSVideo", methodName : "onMetaData"});
		if(this.seeking_) return;
		if(this.duration != 0) return;
		var videoWidth = Std.parseInt(Std.string(this.video.videoWidth));
		var videoHeight = Std.parseInt(Std.string(this.video.videoHeight));
		this.duration = Std.parseInt(Std.string(this.video.duration));
		this.aspectRatio = videoWidth != null && videoHeight != null?videoWidth / videoHeight:null;
		haxe.Log.trace("aspectRatio " + this.aspectRatio,{ fileName : "JSVideo.hx", lineNumber : 220, className : "JSVideo", methodName : "onMetaData"});
		haxe.Log.trace("duration" + this.duration,{ fileName : "JSVideo.hx", lineNumber : 221, className : "JSVideo", methodName : "onMetaData"});
		if(this.size.width != 0 && this.size.height != 0) this.setSize(this.size.width,this.size.height); else this.setSize(videoWidth,videoHeight);
		this.timer.run = $bind(this,this.loop);
	}
	,loop: function() {
		try {
			if(!this.seeking_) {
				this.time = this.video.currentTime;
				this.percentPlayed = Math.round(this.time / this.duration * 100);
				this.onPlayingProgress();
			}
			if(!this.loaded_) {
				if(this.video.buffered != null) {
					if(this.video.buffered.length > 0) {
						this.percentLoaded = Math.ceil(this.video.buffered.end(0) / this.duration);
						if(this.percentLoaded >= 100) this.loaded_ = true;
						this.onLoadingProgress();
					}
				} else this.percentLoaded = 0;
			}
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "JSVideo.hx", lineNumber : 199, className : "JSVideo", methodName : "loop"});
			var stack = haxe.CallStack.exceptionStack();
			haxe.Log.trace(haxe.CallStack.toString(stack),{ fileName : "JSVideo.hx", lineNumber : 201, className : "JSVideo", methodName : "loop"});
		}
	}
	,onBufferFullHandler: function(e) {
		this.onBufferFull();
	}
	,onBufferEmptyHandler: function(e) {
		this.onBufferEmpty();
	}
	,errorHandler: function(e) {
		this.onError();
	}
	,initHandler: function() {
		this.set_volume(this.volume_);
		this.onInit();
	}
	,addAlternativeURL: function(url) {
		if(this.video.canPlayType("video/" + url.split(".").pop()) != "") this.video.src = url;
	}
	,init: function() {
		JSView.prototype.init.call(this);
		this.timer = new haxe.Timer(this.updateTime);
		this.video = js.Browser.document.createElement("video");
		this.layer.appendChild(this.video);
		this.video.preload = "auto";
		this.video.autoplay = true;
		this.video.controls = true;
		this.video.addEventListener("error",$bind(this,this.errorHandler),false);
		this.video.addEventListener("loadedmetadata",$bind(this,this.onMetaData),false);
		this.video.addEventListener("playing",$bind(this,this.videoDidStartHandler),false);
		this.video.addEventListener("ended",$bind(this,this.videoDidFinishPlayingHandler),false);
		this.video.addEventListener("stalled",$bind(this,this.onBufferEmptyHandler),false);
		this.video.addEventListener("canplay",$bind(this,this.onBufferFullHandler),false);
		this.video.addEventListener("canplaythrough",$bind(this,this.onBufferFullHandler),false);
		this.video.addEventListener("waiting",$bind(this,this.onBufferEmptyHandler),false);
		this.video.src = this.videoURL;
	}
	,secureTokenResponse: function(token) {
	}
	,streamWantsSecureToken: function() {
	}
	,onBufferFull: function() {
	}
	,onBufferEmpty: function() {
	}
	,onPlayingProgress: function() {
	}
	,onLoadingProgress: function() {
	}
	,videoDidFinishPlaying: function() {
	}
	,videoDidStop: function() {
	}
	,videoDidStart: function() {
	}
	,onError: function() {
	}
	,onInit: function() {
	}
	,secureToken: null
	,statusMessage: null
	,percentPlayed: null
	,percentLoaded: null
	,duration: null
	,time: null
	,aspectRatio: null
	,isPlaying: null
	,updateTime: null
	,background: null
	,timer: null
	,volume_: null
	,seeking_: null
	,loaded_: null
	,inited_: null
	,videoURL: null
	,video: null
	,__class__: JSVideo
	,__properties__: $extend(JSView.prototype.__properties__,{set_volume:"set_volume",get_volume:"get_volume"})
});
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b += Std.string(sep);
			s.b += Std.string(l[0]);
			l = l[1];
		}
		return s.b;
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b += "{";
		while(l != null) {
			if(first) first = false; else s.b += ", ";
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,length: null
	,q: null
	,h: null
	,__class__: List
}
var Main = function() { }
$hxClasses["Main"] = Main;
Main.__name__ = ["Main"];
Main.main = function() {
}
var _Map = {}
_Map.Map_Impl_ = function() { }
$hxClasses["_Map.Map_Impl_"] = _Map.Map_Impl_;
_Map.Map_Impl_.__name__ = ["_Map","Map_Impl_"];
_Map.Map_Impl_._new = null;
_Map.Map_Impl_.set = function(this1,key,value) {
	this1.set(key,value);
}
_Map.Map_Impl_.get = function(this1,key) {
	return this1.get(key);
}
_Map.Map_Impl_.exists = function(this1,key) {
	return this1.exists(key);
}
_Map.Map_Impl_.remove = function(this1,key) {
	return this1.remove(key);
}
_Map.Map_Impl_.keys = function(this1) {
	return this1.keys();
}
_Map.Map_Impl_.iterator = function(this1) {
	return this1.iterator();
}
_Map.Map_Impl_.toString = function(this1) {
	return this1.toString();
}
_Map.Map_Impl_.arrayWrite = function(this1,k,v) {
	this1.set(k,v);
	return v;
}
_Map.Map_Impl_.toStringMap = function(t) {
	return new haxe.ds.StringMap();
}
_Map.Map_Impl_.toIntMap = function(t) {
	return new haxe.ds.IntMap();
}
_Map.Map_Impl_.toEnumValueMapMap = function(t) {
	return new haxe.ds.EnumValueMap();
}
_Map.Map_Impl_.toObjectMap = function(t) {
	return new haxe.ds.ObjectMap();
}
_Map.Map_Impl_.fromStringMap = function(map) {
	return map;
}
_Map.Map_Impl_.fromIntMap = function(map) {
	return map;
}
_Map.Map_Impl_.fromObjectMap = function(map) {
	return map;
}
var IMap = function() { }
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
IMap.prototype = {
	toString: null
	,iterator: null
	,keys: null
	,remove: null
	,exists: null
	,set: null
	,get: null
	,__class__: IMap
}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe.ds.StringMap;
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += " => ";
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += ", ";
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,h: null
	,__class__: haxe.ds.StringMap
}
var OrderedMap = function() {
	haxe.ds.StringMap.call(this);
	this.array = new Array();
};
$hxClasses["OrderedMap"] = OrderedMap;
OrderedMap.__name__ = ["OrderedMap"];
OrderedMap.__super__ = haxe.ds.StringMap;
OrderedMap.prototype = $extend(haxe.ds.StringMap.prototype,{
	indexForKey: function(key) {
		var _g1 = 0, _g = this.array.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.array[i] == key) return i;
		}
		return -1;
	}
	,insert: function(pos,key,value) {
		if(haxe.ds.StringMap.prototype.exists.call(this,key)) return;
		this.array.splice(pos,0,key);
		haxe.ds.StringMap.prototype.set.call(this,key,value);
	}
	,remove: function(key) {
		HxOverrides.remove(this.array,key);
		return haxe.ds.StringMap.prototype.remove.call(this,key);
	}
	,set: function(key,value) {
		if(!haxe.ds.StringMap.prototype.exists.call(this,key)) this.array.push(key);
		haxe.ds.StringMap.prototype.set.call(this,key,value);
	}
	,array: null
	,__class__: OrderedMap
});
var RCProgressIndicator = function(x,y,skin) {
	JSView.call(this,x,y);
	this.skin = skin;
	this.addChild(skin.normal.background);
	this.addChild(skin.normal.otherView);
	this.set_clipsToBounds(true);
};
$hxClasses["RCProgressIndicator"] = RCProgressIndicator;
RCProgressIndicator.__name__ = ["RCProgressIndicator"];
RCProgressIndicator.__super__ = JSView;
RCProgressIndicator.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.skin.destroy();
		JSView.prototype.destroy.call(this);
	}
	,updateProgressBarWithPercent: function(percent) {
		this.skin.normal.otherView.set_width(Zeta.lineEquationInt(0,this.size.width,percent,0,100));
	}
	,skin: null
	,__class__: RCProgressIndicator
});
var RCActivityIndicator = function(x,y,stepX,skin) {
	if(stepX == null) stepX = 0;
	RCProgressIndicator.call(this,x,y,skin);
	this.stepX = stepX;
	this.speedX = 1;
	this.enterFrame = new EVLoop({ fileName : "RCActivityIndicator.hx", lineNumber : 48, className : "RCActivityIndicator", methodName : "new"});
	this.enterFrame.set_run($bind(this,this.loop));
};
$hxClasses["RCActivityIndicator"] = RCActivityIndicator;
RCActivityIndicator.__name__ = ["RCActivityIndicator"];
RCActivityIndicator.__super__ = RCProgressIndicator;
RCActivityIndicator.prototype = $extend(RCProgressIndicator.prototype,{
	destroy: function() {
		if(this.enterFrame != null) this.enterFrame.destroy();
		this.enterFrame = null;
		RCProgressIndicator.prototype.destroy.call(this);
	}
	,loop: function() {
		var _g = this.skin.normal.otherView;
		_g.set_x(_g.get_x() - this.speedX);
		if(Math.abs(this.skin.normal.otherView.get_x()) >= Math.abs(this.stepX)) this.skin.normal.otherView.set_x(0);
	}
	,enterFrame: null
	,speedX: null
	,stepX: null
	,__class__: RCActivityIndicator
});
var RCAlertView = function(skin) {
	JSView.call(this,0,0);
	this.background = skin.normal.background;
	this.text = skin.normal.label;
	this.addChild(this.background);
	this.addChild(this.text);
};
$hxClasses["RCAlertView"] = RCAlertView;
RCAlertView.__name__ = ["RCAlertView"];
RCAlertView.__super__ = JSView;
RCAlertView.prototype = $extend(JSView.prototype,{
	destroy: function() {
		if(this.buttons != null) this.buttons.destroy();
		this.buttons = null;
		JSView.prototype.destroy.call(this);
	}
	,onClickHandler: function(e) {
	}
	,initWithLabels: function(arr,constructButton) {
		this.buttons = new RCGroup(0,0,10,null,constructButton);
		this.buttons.add(arr);
		this.buttons.set_x(Math.round((this.background.get_width() - this.buttons.get_width()) / 2));
		this.buttons.set_y(Math.round(this.background.get_height() - this.buttons.get_height() - 10));
		this.addChild(this.buttons);
	}
	,onClick: function() {
	}
	,label: null
	,buttons: null
	,text: null
	,background: null
	,COLORS: null
	,__class__: RCAlertView
});
var eq = {}
eq.Linear = function() { }
$hxClasses["eq.Linear"] = eq.Linear;
eq.Linear.__name__ = ["eq","Linear"];
eq.Linear.NONE = function(t,b,c,d,p_params) {
	return c * t / d + b;
}
var RCAnimation = function() { }
$hxClasses["RCAnimation"] = RCAnimation;
RCAnimation.__name__ = ["RCAnimation"];
RCAnimation.latest = null;
RCAnimation.ticker = null;
RCAnimation.add = function(obj) {
	if(obj == null) return;
	if(obj.target == null) return;
	var a = RCAnimation.latest;
	var prev = RCAnimation.latest;
	if(prev != null) prev.next = obj;
	obj.prev = prev;
	RCAnimation.latest = obj;
	obj.init();
	obj.initTime();
	if(RCAnimation.ticker == null) {
		RCAnimation.ticker = new EVLoop({ fileName : "RCAnimation.hx", lineNumber : 50, className : "RCAnimation", methodName : "add"});
		RCAnimation.ticker.set_run(RCAnimation.updateAnimations);
	}
}
RCAnimation.remove = function(obj) {
	if(obj == null) return;
	var a = RCAnimation.latest;
	while(a != null) {
		if(a.target == obj) RCAnimation.removeCAObject(a);
		a = a.prev;
	}
}
RCAnimation.removeCAObject = function(a) {
	if(a.prev != null) a.prev.next = a.next;
	if(a.next != null) a.next.prev = a.prev;
	if(RCAnimation.latest == a) RCAnimation.latest = a.prev != null?a.prev:null;
	RCAnimation.removeTimer();
	a = null;
}
RCAnimation.removeTimer = function() {
	if(RCAnimation.latest == null && RCAnimation.ticker != null) {
		RCAnimation.ticker.destroy();
		RCAnimation.ticker = null;
	}
}
RCAnimation.destroy = function() {
	RCAnimation.latest = null;
	RCAnimation.removeTimer();
}
RCAnimation.updateAnimations = function() {
	var current_time = new Date().getTime();
	var time_diff = 0.0;
	var a = RCAnimation.latest;
	while(a != null) {
		if(a.target == null) {
			a = a.prev;
			RCAnimation.removeCAObject(a);
			break;
		}
		time_diff = current_time - a.fromTime - a.delay;
		if(time_diff >= a.duration) time_diff = a.duration;
		if(time_diff > 0) {
			a.animate(time_diff);
			if(time_diff > 0 && !a.startPointPassed) a.start();
			if(time_diff >= a.duration) {
				if(a.repeatCount > 0) a.repeat(); else {
					RCAnimation.removeCAObject(a);
					a.stop();
				}
			}
		}
		a = a.prev;
	}
}
RCAnimation.timestamp = function() {
	return new Date().getTime();
}
var RCAnimationSequence = function(objs) {
	this.objs = objs;
};
$hxClasses["RCAnimationSequence"] = RCAnimationSequence;
RCAnimationSequence.__name__ = ["RCAnimationSequence"];
RCAnimationSequence.prototype = {
	animationDidStopHandler: function(func) {
		if(func != null) {
			if(Reflect.isFunction(func)) func.apply(null,[]);
		}
		if(this.objs.length > 0) this.start();
	}
	,start: function() {
		var obj = this.objs.shift();
		if(this.objs.length > 0) {
			var $arguments = obj.animationDidStop;
			obj.animationDidStop = $bind(this,this.animationDidStopHandler);
			obj["arguments"] = [$arguments];
		}
		RCAnimation.add(obj);
	}
	,objs: null
	,__class__: RCAnimationSequence
}
var RCAppDelegate = function() {
	RCWindow.sharedWindow();
	JSView.call(this,0,0);
	RCNotificationCenter.addObserver("resize",$bind(this,this.resize));
	RCNotificationCenter.addObserver("fullscreen",$bind(this,this.fullscreen));
	this.applicationDidFinishLaunching();
};
$hxClasses["RCAppDelegate"] = RCAppDelegate;
RCAppDelegate.__name__ = ["RCAppDelegate"];
RCAppDelegate.__super__ = JSView;
RCAppDelegate.prototype = $extend(JSView.prototype,{
	fullscreen: function(b) {
	}
	,resize: function(w,h) {
	}
	,applicationWillTerminate: function() {
		haxe.Log.trace("applicationWillTerminate",{ fileName : "RCAppDelegate.hx", lineNumber : 40, className : "RCAppDelegate", methodName : "applicationWillTerminate"});
	}
	,applicationWillResignActive: function() {
	}
	,applicationDidBecomeActive: function() {
	}
	,applicationDidFinishLaunching: function() {
	}
	,__class__: RCAppDelegate
});
var RCAssets = function() {
	this.imagesList = new haxe.ds.StringMap();
	this.swfList = new haxe.ds.StringMap();
	this.dataList = new haxe.ds.StringMap();
	this.nr = 0;
	this.max = 0;
};
$hxClasses["RCAssets"] = RCAssets;
RCAssets.__name__ = ["RCAssets"];
RCAssets.INSTANCE = null;
RCAssets.errorMessage = null;
RCAssets.currentPercentLoaded = null;
RCAssets.percentLoaded = null;
RCAssets.useCache = null;
RCAssets.onComplete = function() {
}
RCAssets.onProgress = function() {
}
RCAssets.onError = function() {
}
RCAssets.init = function() {
	if(RCAssets.INSTANCE != null) return;
	RCAssets.INSTANCE = new RCAssets();
	RCAssets.currentPercentLoaded = new haxe.ds.StringMap();
	RCAssets.useCache = false;
}
RCAssets.sharedAssets = function() {
	RCAssets.init();
	return RCAssets.INSTANCE;
}
RCAssets.loadFileWithKey = function(key,URL) {
	return RCAssets.sharedAssets().set(key,URL);
}
RCAssets.loadFontWithKey = function(key,URL) {
	return RCAssets.sharedAssets().set(key,URL,false);
}
RCAssets.getFileWithKey = function(key,returnAsBitmap) {
	if(returnAsBitmap == null) returnAsBitmap = true;
	return RCAssets.sharedAssets().get(key,returnAsBitmap);
}
RCAssets.prototype = {
	get: function(key,returnAsBitmap,returnACopy) {
		if(returnACopy == null) returnACopy = true;
		if(returnAsBitmap == null) returnAsBitmap = true;
		RCAssets.init();
		if(this.imagesList.exists(key)) {
			if(returnACopy) return this.imagesList.get(key).copy(); else return this.imagesList.get(key);
		} else if(this.dataList.exists(key)) return this.dataList.get(key); else if(this.swfList.exists(key)) return this.swfList.get(key);
		haxe.Log.trace("Asset with key '" + key + "'  was not found.",{ fileName : "RCAssets.hx", lineNumber : 265, className : "RCAssets", methodName : "get"});
		return null;
	}
	,totalProgress: function() {
		var totalPercent = 0;
		var i = 0;
		var $it0 = RCAssets.currentPercentLoaded.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			i++;
			totalPercent += RCAssets.currentPercentLoaded.get(key);
		}
		RCAssets.percentLoaded = Math.round(totalPercent / i);
		RCAssets.onProgress();
	}
	,onCompleteHandler: function() {
		this.nr++;
		if(this.nr >= this.max) RCAssets.onComplete();
	}
	,completeHandler: function(key,obj) {
		var class_name = Type.getClassName(Type.getClass(obj));
		switch(class_name) {
		case "RCImage":
			var value = obj;
			this.imagesList.set(key,value);
			break;
		case "RCHttp":
			var value = obj.result;
			this.dataList.set(key,value);
			break;
		case "RCSwf":
			var value = obj;
			this.swfList.set(key,value);
			break;
		default:
			haxe.Log.trace("Asset not supported: key=" + key + ", class_name=" + class_name,{ fileName : "RCAssets.hx", lineNumber : 192, className : "RCAssets", methodName : "completeHandler"});
		}
		this.onCompleteHandler();
	}
	,progressHandler: function(key,obj) {
		var value = obj.percentLoaded;
		RCAssets.currentPercentLoaded.set(key,value);
		this.totalProgress();
	}
	,errorHandler: function(key,obj) {
		haxe.Log.trace("Error loading URL for key: '" + key + "' with object: " + Std.string(obj),{ fileName : "RCAssets.hx", lineNumber : 173, className : "RCAssets", methodName : "errorHandler"});
		this.max--;
		RCAssets.onError();
		if(this.nr >= this.max) RCAssets.onComplete();
	}
	,loadFont: function(key,URL) {
		var fontType = "";
		var st = js.Browser.document.createElement("style");
		st.innerHTML = "@font-face{font-family:" + key + "; src: url('" + URL + "')" + fontType + ";}";
		js.Browser.document.getElementsByTagName("head")[0].appendChild(st);
		haxe.Timer.delay($bind(this,this.onCompleteHandler),16);
	}
	,loadText: function(key,URL) {
		var _g = this;
		var data = new RCHttp();
		if(data.result == null) {
			data.onProgress = (function(f,a1,a2) {
				return function() {
					return f(a1,a2);
				};
			})($bind(this,this.progressHandler),key,data);
			data.onComplete = (function(f1,a11,a21) {
				return function() {
					return f1(a11,a21);
				};
			})($bind(this,this.completeHandler),key,data);
			data.onError = (function(f2,a12,a22) {
				return function() {
					return f2(a12,a22);
				};
			})($bind(this,this.errorHandler),key,data);
			data.readFile(URL);
		} else haxe.Timer.delay(function() {
			_g.completeHandler(key,data);
		},10);
	}
	,loadSwf: function(key,URL,newDomain) {
		if(newDomain == null) newDomain = true;
		var swf = new RCSwf(0,0,URL,newDomain);
		swf.onProgress = (function(f,a1,a2) {
			return function() {
				return f(a1,a2);
			};
		})($bind(this,this.progressHandler),key,swf);
		swf.onComplete = (function(f1,a11,a21) {
			return function() {
				return f1(a11,a21);
			};
		})($bind(this,this.completeHandler),key,swf);
		swf.onError = (function(f2,a12,a22) {
			return function() {
				return f2(a12,a22);
			};
		})($bind(this,this.errorHandler),key,swf);
	}
	,loadPhoto: function(key,URL) {
		var photo = new RCImage(0,0,URL);
		photo.onProgress = (function(f,a1,a2) {
			return function() {
				return f(a1,a2);
			};
		})($bind(this,this.progressHandler),key,photo);
		photo.onComplete = (function(f1,a11,a21) {
			return function() {
				return f1(a11,a21);
			};
		})($bind(this,this.completeHandler),key,photo);
		photo.onError = (function(f2,a12,a22) {
			return function() {
				return f2(a12,a22);
			};
		})($bind(this,this.errorHandler),key,photo);
	}
	,set: function(key,URL,newDomain) {
		if(newDomain == null) newDomain = true;
		this.max++;
		if(key == null) key = Std.string(Math.random());
		if(URL.toLowerCase().indexOf(".swf") != -1) this.loadSwf(key,URL,newDomain); else if(URL.toLowerCase().indexOf(".xml") != -1 || URL.toLowerCase().indexOf(".plist") != -1 || URL.toLowerCase().indexOf(".txt") != -1 || URL.toLowerCase().indexOf(".css") != -1) this.loadText(key,URL); else if(URL.toLowerCase().indexOf(".ttf") != -1 || URL.toLowerCase().indexOf(".otf") != -1) this.loadFont(key,URL); else {
			if(RCDevice.currentDevice().dpiScale == 2) {
				var u = URL.split(".");
				var ext = u.pop();
				URL = u.join(".") + "@2x." + ext;
			}
			this.loadPhoto(key,URL);
		}
		return true;
	}
	,max: null
	,nr: null
	,dataList: null
	,swfList: null
	,imagesList: null
	,__class__: RCAssets
}
var RCAttach = function(x,y,id) {
	JSView.call(this,x,y);
	this.id = id;
	try {
		this.target = RCAssets.getFileWithKey(id);
	} catch( e ) {
		haxe.Log.trace(Std.string(e) + " : id=" + id,{ fileName : "RCAttach.hx", lineNumber : 36, className : "RCAttach", methodName : "new"});
	}
};
$hxClasses["RCAttach"] = RCAttach;
RCAttach.__name__ = ["RCAttach"];
RCAttach.__super__ = JSView;
RCAttach.prototype = $extend(JSView.prototype,{
	copy: function() {
		return new RCAttach(this.get_x(),this.get_y(),this.id);
	}
	,id: null
	,target: null
	,__class__: RCAttach
});
var RCControl = function(x,y,w,h) {
	JSView.call(this,x,y,w,h);
	this.configureDispatchers();
	this.set_enabled(true);
};
$hxClasses["RCControl"] = RCControl;
RCControl.__name__ = ["RCControl"];
RCControl.__super__ = JSView;
RCControl.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.click.destroy({ fileName : "RCControl.hx", lineNumber : 171, className : "RCControl", methodName : "destroy"});
		this.press.destroy({ fileName : "RCControl.hx", lineNumber : 172, className : "RCControl", methodName : "destroy"});
		this.release.destroy({ fileName : "RCControl.hx", lineNumber : 173, className : "RCControl", methodName : "destroy"});
		this.over.destroy({ fileName : "RCControl.hx", lineNumber : 174, className : "RCControl", methodName : "destroy"});
		this.out.destroy({ fileName : "RCControl.hx", lineNumber : 175, className : "RCControl", methodName : "destroy"});
		JSView.prototype.destroy.call(this);
	}
	,get_highlighted: function() {
		return this.state_ == RCControlState.HIGHLIGHTED;
	}
	,set_enabled: function(c) {
		this.enabled_ = c;
		this.click.enabled = this.enabled_;
		this.press.enabled = this.enabled_;
		this.release.enabled = this.enabled_;
		this.over.enabled = this.enabled_;
		this.out.enabled = this.enabled_;
		return this.enabled_;
	}
	,get_enabled: function() {
		return this.enabled_;
	}
	,get_selected: function() {
		return this.state_ == RCControlState.SELECTED;
	}
	,setState: function(state) {
		this.state_ = state;
		var _g = this;
		switch( (_g.state_)[1] ) {
		case 0:
			js.Browser.document.body.style.cursor = "auto";
			break;
		case 1:
			js.Browser.document.body.style.cursor = "pointer";
			break;
		case 2:
			js.Browser.document.body.style.cursor = "auto";
			break;
		case 3:
			js.Browser.document.body.style.cursor = "auto";
			break;
		}
	}
	,clickHandler: function(e) {
		this.setState(RCControlState.SELECTED);
		this.onClick();
	}
	,rollOutHandler: function(e) {
		this.setState(RCControlState.NORMAL);
		this.onOut();
	}
	,rollOverHandler: function(e) {
		this.setState(RCControlState.HIGHLIGHTED);
		this.onOver();
	}
	,mouseUpHandler: function(e) {
		this.setState(RCControlState.HIGHLIGHTED);
		this.onRelease();
	}
	,mouseDownHandler: function(e) {
		this.setState(RCControlState.SELECTED);
		this.onPress();
	}
	,configureDispatchers: function() {
		this.click = new EVMouse("mouseclick",this,{ fileName : "RCControl.hx", lineNumber : 80, className : "RCControl", methodName : "configureDispatchers"});
		this.press = new EVMouse("mousedown",this,{ fileName : "RCControl.hx", lineNumber : 82, className : "RCControl", methodName : "configureDispatchers"});
		this.release = new EVMouse("mouseup",this,{ fileName : "RCControl.hx", lineNumber : 83, className : "RCControl", methodName : "configureDispatchers"});
		this.over = new EVMouse("mouseover",this,{ fileName : "RCControl.hx", lineNumber : 84, className : "RCControl", methodName : "configureDispatchers"});
		this.out = new EVMouse("mouseout",this,{ fileName : "RCControl.hx", lineNumber : 85, className : "RCControl", methodName : "configureDispatchers"});
		this.click.addFirst($bind(this,this.clickHandler),{ fileName : "RCControl.hx", lineNumber : 87, className : "RCControl", methodName : "configureDispatchers"});
		this.press.addFirst($bind(this,this.mouseDownHandler),{ fileName : "RCControl.hx", lineNumber : 88, className : "RCControl", methodName : "configureDispatchers"});
		this.release.addFirst($bind(this,this.mouseUpHandler),{ fileName : "RCControl.hx", lineNumber : 89, className : "RCControl", methodName : "configureDispatchers"});
		this.over.addFirst($bind(this,this.rollOverHandler),{ fileName : "RCControl.hx", lineNumber : 90, className : "RCControl", methodName : "configureDispatchers"});
		this.out.addFirst($bind(this,this.rollOutHandler),{ fileName : "RCControl.hx", lineNumber : 91, className : "RCControl", methodName : "configureDispatchers"});
	}
	,init: function() {
		if(this.state_ == null) this.setState(RCControlState.NORMAL);
	}
	,onOut: function() {
	}
	,onOver: function() {
	}
	,onRelease: function() {
	}
	,onPress: function() {
	}
	,onClick: function() {
	}
	,state_: null
	,enabled_: null
	,selected: null
	,highlighted: null
	,editingDidEndOnExit: null
	,editingDidEnd: null
	,editingChanged: null
	,editingDidBegin: null
	,out: null
	,over: null
	,release: null
	,press: null
	,click: null
	,__class__: RCControl
	,__properties__: $extend(JSView.prototype.__properties__,{set_enabled:"set_enabled",get_enabled:"get_enabled",get_highlighted:"get_highlighted",get_selected:"get_selected"})
});
var RCButton = function(x,y,skin) {
	this.setup(skin);
	RCControl.call(this,x,y,this.currentBackground.get_width(),this.currentBackground.get_height());
};
$hxClasses["RCButton"] = RCButton;
RCButton.__name__ = ["RCButton"];
RCButton.__super__ = RCControl;
RCButton.prototype = $extend(RCControl.prototype,{
	toString: function() {
		return "[RCButton bounds:" + this.get_bounds().origin.x + "x" + this.get_bounds().origin.y + "," + this.get_bounds().size.width + "x" + this.get_bounds().size.height + "]";
	}
	,setBackgroundImage: function(image,state) {
	}
	,setTitleColor: function(color,state) {
	}
	,setTitle: function(title,state) {
	}
	,setState: function(state) {
		if(this.state_ == state) return;
		try {
			Fugu.safeRemove([this.currentBackground,this.currentImage]);
			switch( (state)[1] ) {
			case 0:
				this.currentBackground = this.skin.normal.background;
				this.currentImage = this.skin.normal.label;
				break;
			case 1:
				this.currentBackground = this.skin.highlighted.background;
				this.currentImage = this.skin.highlighted.label;
				break;
			case 2:
				this.currentBackground = this.skin.disabled.background;
				this.currentImage = this.skin.disabled.label;
				break;
			case 3:
				this.currentBackground = this.skin.selected.background;
				this.currentImage = this.skin.selected.label;
				break;
			}
			if(this.currentBackground != null) this.addChild(this.currentBackground);
			if(this.currentImage != null) this.addChild(this.currentImage);
			if(this.skin.hit != null) this.addChild(this.skin.hit);
			this.size.width = this.currentBackground != null?this.currentBackground.get_width():this.currentImage.get_width();
			this.size.height = this.currentBackground != null?this.currentBackground.get_height():this.currentImage.get_height();
			RCControl.prototype.setState.call(this,state);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "RCButton.hx", lineNumber : 103, className : "RCButton", methodName : "setState"});
		}
	}
	,setup: function(skin) {
		this.skin = skin;
		if(skin.hit != null) skin.hit.set_alpha(0);
		if(skin.normal.label == null) skin.normal.label = skin.normal.image;
		if(skin.normal.label == null) skin.normal.label = skin.normal.otherView;
		var _g = 0, _g1 = Reflect.fields(skin.normal);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			if(key == "colors") continue;
			if(Reflect.field(skin.highlighted,key) == null) skin.highlighted[key] = Reflect.field(skin.normal,key);
			if(Reflect.field(skin.selected,key) == null) skin.selected[key] = Reflect.field(skin.highlighted,key);
			if(Reflect.field(skin.disabled,key) == null) skin.disabled[key] = Reflect.field(skin.normal,key);
		}
		this.currentBackground = skin.normal.background;
		this.currentImage = skin.normal.label;
	}
	,currentBackground: null
	,currentImage: null
	,currentTitleColor: null
	,currentTitle: null
	,skin: null
	,__class__: RCButton
});
var RCButtonRadio = function(x,y,skin) {
	RCButton.call(this,x,y,skin);
	this.toggable_ = true;
};
$hxClasses["RCButtonRadio"] = RCButtonRadio;
RCButtonRadio.__name__ = ["RCButtonRadio"];
RCButtonRadio.__super__ = RCButton;
RCButtonRadio.prototype = $extend(RCButton.prototype,{
	untoggle: function() {
		if(this.toggable_) this.setState(RCControlState.NORMAL);
	}
	,toggle: function() {
		if(this.toggable_) this.setState(RCControlState.SELECTED);
	}
	,set_toggable: function(v) {
		if(!v) this.setState(RCControlState.NORMAL);
		return this.toggable_ = v;
	}
	,get_toggable: function() {
		return this.toggable_;
	}
	,rollOutHandler: function(e) {
		if(!this.get_selected()) this.setState(RCControlState.NORMAL);
		this.onOut();
	}
	,rollOverHandler: function(e) {
		if(!this.get_selected()) this.setState(RCControlState.HIGHLIGHTED);
		this.onOver();
	}
	,clickHandler: function(e) {
		this.setState(this.get_selected()?RCControlState.NORMAL:RCControlState.SELECTED);
		this.onClick();
	}
	,mouseUpHandler: function(e) {
		this.onRelease();
	}
	,mouseDownHandler: function(e) {
		this.onPress();
	}
	,toggable_: null
	,__class__: RCButtonRadio
	,__properties__: $extend(RCButton.prototype.__properties__,{set_toggable:"set_toggable",get_toggable:"get_toggable"})
});
var RCColor = function(fillColor,strokeColor,a) {
	this.fillColor = fillColor;
	this.strokeColor = strokeColor;
	this.alpha = a == null?1.0:a;
	this.redComponent = (fillColor >> 16 & 255) / 255;
	this.greenComponent = (fillColor >> 8 & 255) / 255;
	this.blueComponent = (fillColor & 255) / 255;
	this.fillColorStyle = RCColor.HEXtoString(fillColor);
	this.strokeColorStyle = RCColor.HEXtoString(strokeColor);
};
$hxClasses["RCColor"] = RCColor;
RCColor.__name__ = ["RCColor"];
RCColor.blackColor = function() {
	return RCColor.colorWithWhite(0);
}
RCColor.darkGrayColor = function() {
	return RCColor.colorWithWhite(0.333);
}
RCColor.lightGrayColor = function() {
	return RCColor.colorWithWhite(0.667);
}
RCColor.whiteColor = function() {
	return RCColor.colorWithWhite(1);
}
RCColor.grayColor = function() {
	return RCColor.colorWithWhite(0.5);
}
RCColor.redColor = function() {
	return RCColor.colorWithRGBA(1,0,0);
}
RCColor.greenColor = function() {
	return RCColor.colorWithRGBA(0,1,0);
}
RCColor.blueColor = function() {
	return RCColor.colorWithRGBA(0,0,1);
}
RCColor.cyanColor = function() {
	return RCColor.colorWithRGBA(0,1,1);
}
RCColor.yellowColor = function() {
	return RCColor.colorWithRGBA(1,1,0);
}
RCColor.magentaColor = function() {
	return RCColor.colorWithRGBA(1,0,1);
}
RCColor.orangeColor = function() {
	return RCColor.colorWithRGBA(1,0.5,0);
}
RCColor.purpleColor = function() {
	return RCColor.colorWithRGBA(0.5,0,0.5);
}
RCColor.brownColor = function() {
	return RCColor.colorWithRGBA(0.6,0.4,0.2);
}
RCColor.clearColor = function() {
	return RCColor.colorWithWhite(0,0);
}
RCColor.colorWithWhite = function(white,alpha) {
	if(alpha == null) alpha = 1.0;
	return new RCColor(RCColor.RGBtoHEX(white,white,white),null,alpha);
}
RCColor.colorWithRGBA = function(red,green,blue,alpha) {
	if(alpha == null) alpha = 1.0;
	return new RCColor(RCColor.RGBtoHEX(red,green,blue),null,alpha);
}
RCColor.colorWithHSBA = function(hue,saturation,brightness,alpha) {
	if(alpha == null) alpha = 1.0;
	return new RCColor(RCColor.RGBtoHEX(hue,saturation,brightness),null,alpha);
}
RCColor.colorWithFillAndStroke = function(fillColor,strokeColor) {
	return new RCColor(fillColor,strokeColor);
}
RCColor.HEXtoString = function(color) {
	if(color == null) return null;
	return "#" + StringTools.lpad(StringTools.hex(color),"0",6);
}
RCColor.RGBtoHEX = function(r,g,b) {
	return Math.round(r * 255) << 16 | Math.round(g * 255) << 8 | Math.round(b * 255);
}
RCColor.prototype = {
	alpha: null
	,blueComponent: null
	,greenComponent: null
	,redComponent: null
	,strokeColorStyle: null
	,fillColorStyle: null
	,strokeColor: null
	,fillColor: null
	,__class__: RCColor
}
var RCControlState = $hxClasses["RCControlState"] = { __ename__ : ["RCControlState"], __constructs__ : ["NORMAL","HIGHLIGHTED","DISABLED","SELECTED"] }
RCControlState.NORMAL = ["NORMAL",0];
RCControlState.NORMAL.toString = $estr;
RCControlState.NORMAL.__enum__ = RCControlState;
RCControlState.HIGHLIGHTED = ["HIGHLIGHTED",1];
RCControlState.HIGHLIGHTED.toString = $estr;
RCControlState.HIGHLIGHTED.__enum__ = RCControlState;
RCControlState.DISABLED = ["DISABLED",2];
RCControlState.DISABLED.toString = $estr;
RCControlState.DISABLED.__enum__ = RCControlState;
RCControlState.SELECTED = ["SELECTED",3];
RCControlState.SELECTED.toString = $estr;
RCControlState.SELECTED.__enum__ = RCControlState;
var RCCustomCursor = function(target) {
	JSView.call(this,0,0);
	this.target = target;
	this.mouseMove = new EVMouse("mousemove",target,{ fileName : "RCCustomCursor.hx", lineNumber : 31, className : "RCCustomCursor", methodName : "new"});
	this.mouseMove.add($bind(this,this.moveHandler));
};
$hxClasses["RCCustomCursor"] = RCCustomCursor;
RCCustomCursor.__name__ = ["RCCustomCursor"];
RCCustomCursor.__super__ = JSView;
RCCustomCursor.prototype = $extend(JSView.prototype,{
	destroy: function() {
		js.Browser.document.body.style.cursor = "auto";
		this.mouseMove.destroy({ fileName : "RCCustomCursor.hx", lineNumber : 77, className : "RCCustomCursor", methodName : "destroy"});
		JSView.prototype.destroy.call(this);
	}
	,moveHandler: function(e) {
	}
	,draw: function(obj) {
		var x = 0, y = 0;
		js.Browser.document.body.style.cursor = "url(" + Std.string(obj) + ") " + x + " " + y + ", auto";
	}
	,mouseMove: null
	,cursor: null
	,target: null
	,__class__: RCCustomCursor
});
var RCDraw = function(x,y,w,h,color,alpha) {
	if(alpha == null) alpha = 1.0;
	JSView.call(this,x,y,w,h);
	this.set_alpha(alpha);
	this.borderThickness = 1;
	try {
		this.graphics = this.layer;
	} catch( e ) {
		haxe.Log.trace(e,{ fileName : "RCDraw.hx", lineNumber : 37, className : "RCDraw", methodName : "new"});
	}
	if(js.Boot.__instanceof(color,RCColor) || js.Boot.__instanceof(color,RCGradient)) this.color = color; else if(js.Boot.__instanceof(color,Int) || js.Boot.__instanceof(color,Int)) this.color = new RCColor(color); else if(js.Boot.__instanceof(color,Array)) this.color = new RCColor(color[0],color[1]); else this.color = new RCColor(0);
};
$hxClasses["RCDraw"] = RCDraw;
RCDraw.__name__ = ["RCDraw"];
RCDraw.__super__ = JSView;
RCDraw.prototype = $extend(JSView.prototype,{
	frame: function() {
		return new RCRect(this.get_x(),this.get_y(),this.size.width,this.size.height);
	}
	,configure: function() {
		if(js.Boot.__instanceof(this.color,RCColor)) {
		}
	}
	,borderThickness: null
	,color: null
	,__class__: RCDraw
});
var RCDrawInterface = function() { }
$hxClasses["RCDrawInterface"] = RCDrawInterface;
RCDrawInterface.__name__ = ["RCDrawInterface"];
RCDrawInterface.prototype = {
	redraw: null
	,configure: null
	,__class__: RCDrawInterface
}
var RCDashedLine = function(x,y,w,h,color,alpha,dashWidth,dashGap) {
	RCDraw.call(this,x,y,w,h,color,alpha);
	this.dashWidth = dashWidth;
	this.dashGap = dashGap;
	this.redraw();
};
$hxClasses["RCDashedLine"] = RCDashedLine;
RCDashedLine.__name__ = ["RCDashedLine"];
RCDashedLine.__interfaces__ = [RCDrawInterface];
RCDashedLine.__super__ = RCDraw;
RCDashedLine.prototype = $extend(RCDraw.prototype,{
	redraw: function() {
		if(this.dashGap == null) this.dashGap = this.dashWidth;
		var nr_of_dashes = Math.round((this.size.width > this.size.height?this.size.width:this.size.height) / (this.dashWidth + this.dashGap));
		var _g = 0;
		while(_g < nr_of_dashes) {
			var i = _g++;
			var X = this.size.width > this.size.height?i * (this.dashWidth + this.dashGap):0;
			var Y = this.size.width < this.size.height?i * (this.dashWidth + this.dashGap):0;
			var W = this.size.width > this.size.height?this.dashWidth:this.size.width;
			var H = this.size.width < this.size.height?this.dashWidth:this.size.height;
			var dash = js.Browser.document.createElement("div");
			dash.style.position = "absolute";
			dash.style.margin = "0px 0px 0px 0px";
			dash.style.left = X + "px";
			dash.style.top = Y + "px";
			dash.style.width = W + "px";
			dash.style.height = H + "px";
			dash.style.backgroundColor = this.color.fillColorStyle;
			this.layer.appendChild(dash);
		}
	}
	,dashGap: null
	,dashWidth: null
	,__class__: RCDashedLine
});
var RCDateTools = function() { }
$hxClasses["RCDateTools"] = RCDateTools;
RCDateTools.__name__ = ["RCDateTools"];
RCDateTools.MONTHS = function() {
	return ["January","February","March","April","May","June","July","August","September","October","November","December"];
}
RCDateTools.DAYS = function() {
	return ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
}
RCDateTools.decodeDate = function(s) {
	var date = HxOverrides.strDate(s);
	return ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][date.getDay()] + " " + date.getDate() + " " + ["January","February","March","April","May","June","July","August","September","October","November","December"][date.getMonth()] + " " + date.getFullYear();
}
RCDateTools.decodeTime = function(s) {
	var date = HxOverrides.strDate(s);
	return RCDateTools.add0(date.getHours()) + ":" + RCDateTools.add0(date.getMinutes());
}
RCDateTools.extractDate = function(s) {
	return s.split(" ").shift();
}
RCDateTools.add0 = function(nr) {
	return Std.string((nr >= 10?"":"0") + nr);
}
var RCDeviceOrientation = $hxClasses["RCDeviceOrientation"] = { __ename__ : ["RCDeviceOrientation"], __constructs__ : ["UIDeviceOrientationUnknown","UIDeviceOrientationPortrait","UIDeviceOrientationPortraitUpsideDown","UIDeviceOrientationLandscapeLeft","UIDeviceOrientationLandscapeRight","UIDeviceOrientationFaceUp","UIDeviceOrientationFaceDown"] }
RCDeviceOrientation.UIDeviceOrientationUnknown = ["UIDeviceOrientationUnknown",0];
RCDeviceOrientation.UIDeviceOrientationUnknown.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationUnknown.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationPortrait = ["UIDeviceOrientationPortrait",1];
RCDeviceOrientation.UIDeviceOrientationPortrait.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationPortrait.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationPortraitUpsideDown = ["UIDeviceOrientationPortraitUpsideDown",2];
RCDeviceOrientation.UIDeviceOrientationPortraitUpsideDown.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationPortraitUpsideDown.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationLandscapeLeft = ["UIDeviceOrientationLandscapeLeft",3];
RCDeviceOrientation.UIDeviceOrientationLandscapeLeft.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationLandscapeLeft.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationLandscapeRight = ["UIDeviceOrientationLandscapeRight",4];
RCDeviceOrientation.UIDeviceOrientationLandscapeRight.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationLandscapeRight.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationFaceUp = ["UIDeviceOrientationFaceUp",5];
RCDeviceOrientation.UIDeviceOrientationFaceUp.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationFaceUp.__enum__ = RCDeviceOrientation;
RCDeviceOrientation.UIDeviceOrientationFaceDown = ["UIDeviceOrientationFaceDown",6];
RCDeviceOrientation.UIDeviceOrientationFaceDown.toString = $estr;
RCDeviceOrientation.UIDeviceOrientationFaceDown.__enum__ = RCDeviceOrientation;
var RCDeviceType = $hxClasses["RCDeviceType"] = { __ename__ : ["RCDeviceType"], __constructs__ : ["IPhone","IPad","IPod","Android","WebOS","Mac","Playstation","Other"] }
RCDeviceType.IPhone = ["IPhone",0];
RCDeviceType.IPhone.toString = $estr;
RCDeviceType.IPhone.__enum__ = RCDeviceType;
RCDeviceType.IPad = ["IPad",1];
RCDeviceType.IPad.toString = $estr;
RCDeviceType.IPad.__enum__ = RCDeviceType;
RCDeviceType.IPod = ["IPod",2];
RCDeviceType.IPod.toString = $estr;
RCDeviceType.IPod.__enum__ = RCDeviceType;
RCDeviceType.Android = ["Android",3];
RCDeviceType.Android.toString = $estr;
RCDeviceType.Android.__enum__ = RCDeviceType;
RCDeviceType.WebOS = ["WebOS",4];
RCDeviceType.WebOS.toString = $estr;
RCDeviceType.WebOS.__enum__ = RCDeviceType;
RCDeviceType.Mac = ["Mac",5];
RCDeviceType.Mac.toString = $estr;
RCDeviceType.Mac.__enum__ = RCDeviceType;
RCDeviceType.Playstation = ["Playstation",6];
RCDeviceType.Playstation.toString = $estr;
RCDeviceType.Playstation.__enum__ = RCDeviceType;
RCDeviceType.Other = ["Other",7];
RCDeviceType.Other.toString = $estr;
RCDeviceType.Other.__enum__ = RCDeviceType;
var RCUserAgent = $hxClasses["RCUserAgent"] = { __ename__ : ["RCUserAgent"], __constructs__ : ["MSIE","MSIE9","GECKO","WEBKIT","PRESTO","OTHER"] }
RCUserAgent.MSIE = ["MSIE",0];
RCUserAgent.MSIE.toString = $estr;
RCUserAgent.MSIE.__enum__ = RCUserAgent;
RCUserAgent.MSIE9 = ["MSIE9",1];
RCUserAgent.MSIE9.toString = $estr;
RCUserAgent.MSIE9.__enum__ = RCUserAgent;
RCUserAgent.GECKO = ["GECKO",2];
RCUserAgent.GECKO.toString = $estr;
RCUserAgent.GECKO.__enum__ = RCUserAgent;
RCUserAgent.WEBKIT = ["WEBKIT",3];
RCUserAgent.WEBKIT.toString = $estr;
RCUserAgent.WEBKIT.__enum__ = RCUserAgent;
RCUserAgent.PRESTO = ["PRESTO",4];
RCUserAgent.PRESTO.toString = $estr;
RCUserAgent.PRESTO.__enum__ = RCUserAgent;
RCUserAgent.OTHER = ["OTHER",5];
RCUserAgent.OTHER.toString = $estr;
RCUserAgent.OTHER.__enum__ = RCUserAgent;
var RCDevice = function() {
	this.dpiScale = 1;
	this.userAgent = this.detectUserAgent();
	this.type = this.detectType();
};
$hxClasses["RCDevice"] = RCDevice;
RCDevice.__name__ = ["RCDevice"];
RCDevice._currentDevice = null;
RCDevice.currentDevice = function() {
	if(RCDevice._currentDevice == null) RCDevice._currentDevice = new RCDevice();
	return RCDevice._currentDevice;
}
RCDevice.prototype = {
	detectType: function() {
		var agent = js.Browser.window.navigator.userAgent.toLowerCase();
		if(agent.indexOf("iphone") > -1) return RCDeviceType.IPhone;
		if(agent.indexOf("ipad") > -1) return RCDeviceType.IPad;
		if(agent.indexOf("ipod") > -1) return RCDeviceType.IPod;
		if(agent.indexOf("android") > -1) return RCDeviceType.Android;
		if(agent.indexOf("macintosh") > -1) return RCDeviceType.Mac;
		if(agent.indexOf("playstation") > -1) return RCDeviceType.Playstation;
		return RCDeviceType.Other;
	}
	,detectUserAgent: function() {
		var agent = js.Browser.window.navigator.userAgent.toLowerCase();
		if(agent.indexOf("msie") > -1) return RCUserAgent.MSIE;
		if(agent.indexOf("msie 9.") > -1) return RCUserAgent.MSIE9;
		if(agent.indexOf("webkit") > -1) return RCUserAgent.WEBKIT;
		if(agent.indexOf("gecko") > -1) return RCUserAgent.GECKO;
		if(agent.indexOf("presto") > -1) return RCUserAgent.PRESTO;
		return RCUserAgent.OTHER;
	}
	,isTouch: function() {
		return !!('ontouchstart' in window) // works on most browsers 
	      || !!('onmsgesturechange' in window); // works on ie10;
		return false;
	}
	,userAgent: null
	,dpiScale: null
	,type: null
	,orientation: null
	,__class__: RCDevice
}
var _RCDraw = {}
_RCDraw.LineScaleMode = function() { }
$hxClasses["_RCDraw.LineScaleMode"] = _RCDraw.LineScaleMode;
_RCDraw.LineScaleMode.__name__ = ["_RCDraw","LineScaleMode"];
var RCDropDown = function(x,y,w,h,skin) {
	JSView.call(this,x,y);
	this.size.width = w;
	this.size.height = h;
};
$hxClasses["RCDropDown"] = RCDropDown;
RCDropDown.__name__ = ["RCDropDown"];
RCDropDown.__super__ = JSView;
RCDropDown.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.closeDropDown();
		JSView.prototype.destroy.call(this);
	}
	,mouseMoveHandler: function(e) {
		var xm1 = 10;
		var xm2 = this.background.get_height() - 10;
		var xm = this.background.get_mouseY();
		if(xm < xm1) xm = xm1;
		if(xm > xm2) xm = xm2;
		var x1 = 0;
		var x2 = x1 - this.items.get_height() + this.background.get_height();
		this.items.set_y(Zeta.lineEquationInt(x1,x2,xm,xm1,xm2));
	}
	,mouseOutHandler: function(e) {
		haxe.Log.trace("mouesout",{ fileName : "RCDropDown.hx", lineNumber : 118, className : "RCDropDown", methodName : "mouseOutHandler"});
		this.closeDropDown();
	}
	,mouseOverHandler: function(e) {
		haxe.Log.trace("over",{ fileName : "RCDropDown.hx", lineNumber : 114, className : "RCDropDown", methodName : "mouseOverHandler"});
	}
	,onClickHandler: function(e) {
	}
	,closeDropDown: function() {
	}
	,openDropDown: function() {
		this.dropDownDidOpen.dispatch(this,null,null,null,{ fileName : "RCDropDown.hx", lineNumber : 70, className : "RCDropDown", methodName : "openDropDown"});
		if(this.items.get_height() < this.background.get_height()) this.background.set_height(this.items.get_height());
	}
	,select: function(label) {
		this.closeDropDown();
		this.currentItem = this.button(label);
		this.currentItem.onClick = $bind(this,this.openDropDown);
		this.addChild(this.currentItem);
	}
	,initWithLabels: function(labels,maxLines) {
		if(maxLines == null) maxLines = 10;
		JSView.prototype.init.call(this);
		this.labels = labels;
		this.maxLines = maxLines;
	}
	,itemDidSelect: null
	,dropDownDidClose: null
	,dropDownDidOpen: null
	,button: null
	,maxLines: null
	,currentItem: null
	,items: null
	,labels: null
	,open_but: null
	,scrollView: null
	,background: null
	,__class__: RCDropDown
});
var RCEllipse = function(x,y,w,h,color,alpha) {
	if(alpha == null) alpha = 1.0;
	RCDraw.call(this,x,y,w,h,color,alpha);
	this.redraw();
};
$hxClasses["RCEllipse"] = RCEllipse;
RCEllipse.__name__ = ["RCEllipse"];
RCEllipse.__interfaces__ = [RCDrawInterface];
RCEllipse.__super__ = RCDraw;
RCEllipse.prototype = $extend(RCDraw.prototype,{
	fillEllipse: function(xc,yc,width,height) {
		var iHtml = new Array();
		var a = Math.round(width / 2);
		var b = Math.round(height / 2);
		var hexColor = (js.Boot.__cast(this.color , RCColor)).fillColorStyle;
		var x = 0;
		var y = b;
		var a2 = a * a;
		var b2 = b * b;
		var xp, yp;
		xp = 1;
		yp = y;
		while(b2 * x < a2 * y) {
			x++;
			if(b2 * x * x + a2 * (y - 0.5) * (y - 0.5) - a2 * b2 >= 0) y--;
			if(x == 1 && y != yp) {
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc + yp - 1) + "px;background-color:" + hexColor + "\"></DIV>";
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc - yp) + "px;background-color:" + hexColor + "\"></DIV>";
			}
			if(y != yp) {
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc - x + 1) + "px;top:" + (yc - yp) + "px;width:" + (2 * x - 1) + "px;background-color:" + hexColor + "\"></DIV>";
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc - x + 1) + "px;top:" + (yc + yp) + "px;width:" + (2 * x - 1) + "px;background-color:" + hexColor + "\"></DIV>";
				yp = y;
				xp = x;
			}
			if(b2 * x >= a2 * y) {
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc - x) + "px;top:" + (yc - yp) + "px;width:" + (2 * x + 1) + "px;background-color:" + hexColor + "\"></DIV>";
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc - x) + "px;top:" + (yc + yp) + "px;width:" + (2 * x + 1) + "px;background-color:" + hexColor + "\"></DIV>";
			}
		}
		xp = x;
		yp = y;
		var divHeight = 1;
		while(y != 0) {
			y--;
			if(b2 * (x + 0.5) * (x + 0.5) + a2 * y * y - a2 * b2 <= 0) x++;
			if(x != xp) {
				divHeight = yp - y;
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + (xc - xp) + "px;top:" + (yc - yp) + "px;width:" + (2 * xp + 1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + (xc - xp) + "px;top:" + (yc + y + 1) + "px;width:" + (2 * xp + 1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				xp = x;
				yp = y;
			}
			if(y == 0) {
				divHeight = yp - y + 1;
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + (xc - xp) + "px;top:" + (yc - yp) + "px;width:" + (2 * x + 1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + (xc - xp) + "px;top:" + (yc + y) + "px;width:" + (2 * x + 1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
			}
		}
		this.layer.innerHTML = iHtml.join("");
		return this.layer;
	}
	,redraw: function() {
		this.fillEllipse(Math.round(this.size.width / 2),Math.round(this.size.height / 2),this.size.width,this.size.height);
	}
	,__class__: RCEllipse
});
var RCHttp = function(apiPath) {
	if(apiPath == null) apiPath = "";
	this.apiPath = apiPath;
	if(apiPath != "" && !StringTools.endsWith(apiPath,"/")) this.apiPath += "/";
	RCRequest.call(this);
};
$hxClasses["RCHttp"] = RCHttp;
RCHttp.__name__ = ["RCHttp"];
RCHttp.__super__ = RCRequest;
RCHttp.prototype = $extend(RCRequest.prototype,{
	navigateToURL: function(URL,variables_list,method,target) {
		if(target == null) target = "_self";
		if(method == null) method = "POST";
		var variables = this.createVariables(variables_list);
	}
	,call: function(script,variables_list,method) {
		if(method == null) method = "POST";
		this.load(this.apiPath + script,this.createVariables(variables_list),method);
	}
	,readDirectory: function(directoryName) {
		var variables = this.createVariables({ path : directoryName});
		this.load(this.apiPath + "filesystem/readDirectory.php",variables);
	}
	,readFile: function(file) {
		this.load(file);
	}
	,apiPath: null
	,__class__: RCHttp
});
var RCFileSystem = function(apiPath) {
	RCHttp.call(this,apiPath);
};
$hxClasses["RCFileSystem"] = RCFileSystem;
RCFileSystem.__name__ = ["RCFileSystem"];
RCFileSystem.__super__ = RCHttp;
RCFileSystem.prototype = $extend(RCHttp.prototype,{
	rename: function(file,new_file) {
		var variables = this.createVariables({ path : file, new_path : new_file, apiPath : this.apiPath});
		this.load(this.apiPath + "filesystem/rename.php",variables);
	}
	,deleteFile: function(file) {
		var variables = this.createVariables({ path : file, apiPath : this.apiPath});
		this.load(this.apiPath + "filesystem/deleteFile.php",variables);
	}
	,deleteDirectory: function(directory) {
		var variables = this.createVariables({ path : directory, apiPath : this.apiPath});
		this.load(this.apiPath + "filesystem/deleteDirectory.php",variables);
	}
	,createDirectory: function(directory) {
		var variables = this.createVariables({ path : directory, apiPath : this.apiPath});
		this.load(this.apiPath + "filesystem/createDirectory.php",variables);
	}
	,__class__: RCFileSystem
});
var RCFiles = function(files) {
	this.dir = new Array();
	this.media = new Array();
	this.images = new Array();
	this.flash = new Array();
	this.pano2vr = new Array();
	this.music = new Array();
	this.video = new Array();
	this.text = new Array();
	this.xml = new Array();
	this.extra = new Array();
	var _g = 0;
	while(_g < files.length) {
		var file = files[_g];
		++_g;
		this.push(file);
	}
};
$hxClasses["RCFiles"] = RCFiles;
RCFiles.__name__ = ["RCFiles"];
RCFiles.PHOTOS = function() {
	return [".jpg",".jpeg",".png",".gif"];
}
RCFiles.MUSIC = function() {
	return [".mp3"];
}
RCFiles.FLASH = function() {
	return [".swf"];
}
RCFiles.PANO2VR = function() {
	return [".pano2vr"];
}
RCFiles.VIDEOS = function() {
	return [".flv",".f4v",".mp4",".m4v",".webm",".ogv",".ytb"];
}
RCFiles.TEXT = function() {
	return [".txt",".data"];
}
RCFiles.IGNORE = function() {
	return [".","..",".DS_Store","_vti_cnf","Thumbs.db","_thumb.jpg"];
}
RCFiles.filesWithString = function(str,separator) {
	if(separator == null) separator = "*";
	return new RCFiles(str.split("[FILES::").pop().split("::FILES]").shift().split(separator));
}
RCFiles.isDirectory = function(file) {
	return !Zeta.isIn(file,[".jpg",".jpeg",".png",".gif"].concat([".mp3"]).concat([".swf"]).concat([".flv",".f4v",".mp4",".m4v",".webm",".ogv",".ytb"]).concat([".txt",".data"]).concat([".pano2vr"]),"end");
}
RCFiles.prototype = {
	toString: function() {
		return "[Files:\ndir: " + Std.string(this.dir) + "\nmedia: " + Std.string(this.media) + "\nimages: " + Std.string(this.images) + "\nflash: " + Std.string(this.flash) + "\npano2vr: " + Std.string(this.pano2vr) + "\nmusic: " + Std.string(this.music) + "\nvideo: " + Std.string(this.video) + "\ntext: " + Std.string(this.text) + "\nxml: " + Std.string(this.xml) + "\nextra: " + Std.string(this.extra) + "]";
	}
	,push: function(file) {
		if(Zeta.isIn(file,[".","..",".DS_Store","_vti_cnf","Thumbs.db","_thumb.jpg"],"end")) return;
		if(Zeta.isIn(file,[".jpg",".jpeg",".png",".gif"],"end")) {
			this.images.push(file);
			this.media.push(file);
		} else if(Zeta.isIn(file,[".mp3"],"end")) this.music.push(file); else if(Zeta.isIn(file,[".flv",".f4v",".mp4",".m4v",".webm",".ogv",".ytb"],"end")) {
			this.video.push(file);
			this.media.push(file);
		} else if(Zeta.isIn(file,[".swf"],"end")) {
			this.flash.push(file);
			this.media.push(file);
		} else if(Zeta.isIn(file,[".pano2vr"],"end")) {
			this.pano2vr.push(file);
			this.media.push(file);
		} else if(Zeta.isIn(file,[".txt",".data"],"end")) this.text.push(file); else if(Zeta.isIn(file,[".xml"],"end")) this.xml.push(file); else this.dir.push(file);
	}
	,extra: null
	,xml: null
	,text: null
	,video: null
	,music: null
	,pano2vr: null
	,flash: null
	,images: null
	,media: null
	,dir: null
	,__class__: RCFiles
}
var RCFont = function() {
	this.font = "Arial";
	this.html = true;
	this.embedFonts = true;
	this.autoSize = true;
	this.selectable = false;
	this.color = 14540253;
	this.size = 12;
	this.leading = 4;
	this.leftMargin = 0;
	this.rightMargin = 0;
	this.letterSpacing = 0;
	this.format = { };
	this.style = { };
};
$hxClasses["RCFont"] = RCFont;
RCFont.__name__ = ["RCFont"];
RCFont.fontWithName = function(fontName,size) {
	var fnt = new RCFont();
	fnt.font = fontName;
	fnt.size = size;
	return fnt;
}
RCFont.familyNames = function() {
	return [];
}
RCFont.systemFontOfSize = function(size) {
	var fnt = new RCFont();
	fnt.size = size;
	fnt.embedFonts = false;
	return fnt;
}
RCFont.boldSystemFontOfSize = function(size) {
	var fnt = RCFont.systemFontOfSize(size);
	fnt.bold = true;
	return fnt;
}
RCFont.italicSystemFontOfSize = function(size) {
	var fnt = RCFont.systemFontOfSize(size);
	fnt.italic = true;
	return fnt;
}
RCFont.prototype = {
	get_style: function() {
		return this.style;
	}
	,get_format: function() {
		this.format.align = null;
		this.format.blockIndent = this.blockIndent;
		this.format.bold = this.bold;
		this.format.bullet = this.bullet;
		this.format.color = this.color;
		this.format.font = this.font;
		this.format.italic = this.italic;
		this.format.indent = this.indent;
		this.format.kerning = this.kerning;
		this.format.leading = this.leading * RCDevice.currentDevice().dpiScale;
		this.format.leftMargin = this.leftMargin * RCDevice.currentDevice().dpiScale;
		this.format.letterSpacing = this.letterSpacing;
		this.format.rightMargin = this.rightMargin * RCDevice.currentDevice().dpiScale;
		this.format.size = this.size * RCDevice.currentDevice().dpiScale;
		this.format.target = this.target;
		this.format.underline = this.underline;
		this.format.url = this.url;
		return this.format;
	}
	,copy: function(exceptions) {
		var rcfont = new RCFont();
		var fields = Type.getInstanceFields(RCFont);
		var _g = 0;
		while(_g < fields.length) {
			var field = fields[_g];
			++_g;
			if(field == "copy" || field == "getFormat" || field == "getStyleSheet" || field == "get_format" || field == "get_style") continue;
			rcfont[field] = Reflect.field(this,field);
		}
		if(exceptions != null) {
			var _g = 0, _g1 = Reflect.fields(exceptions);
			while(_g < _g1.length) {
				var excp = _g1[_g];
				++_g;
				if(Reflect.hasField(rcfont,excp)) rcfont[excp] = Reflect.field(exceptions,excp);
			}
		}
		return rcfont;
	}
	,url: null
	,underline: null
	,target: null
	,tabStops: null
	,size: null
	,rightMargin: null
	,letterSpacing: null
	,leftMargin: null
	,leading: null
	,kerning: null
	,italic: null
	,indent: null
	,font: null
	,display: null
	,color: null
	,bullet: null
	,bold: null
	,blockIndent: null
	,align: null
	,thickness: null
	,sharpness: null
	,selectable: null
	,displayAsPassword: null
	,autoSize: null
	,antiAliasType: null
	,type: null
	,embedFonts: null
	,style: null
	,format: null
	,html: null
	,__class__: RCFont
	,__properties__: {get_format:"get_format",get_style:"get_style"}
}
var RCFontManager = function() {
};
$hxClasses["RCFontManager"] = RCFontManager;
RCFontManager.__name__ = ["RCFontManager"];
RCFontManager.INSTANCE = null;
RCFontManager.init = function() {
	if(RCFontManager.INSTANCE == null) {
		RCFontManager.INSTANCE = new RCFontManager();
		RCFontManager.INSTANCE.initDefaults();
	}
}
RCFontManager.instance = function() {
	if(RCFontManager.INSTANCE == null) RCFontManager.init();
	return RCFontManager.INSTANCE;
}
RCFontManager.registerFont = function(key,data) {
	RCFontManager.instance().hash_rcfont.set(key,data);
}
RCFontManager.registerStyle = function(key,data) {
	var value = data;
	RCFontManager.instance().hash_style.set(key,value);
}
RCFontManager.remove = function(key) {
	RCFontManager.instance().hash_style.remove(key);
	RCFontManager.instance().hash_rcfont.remove(key);
}
RCFontManager.getFont = function(key,exceptions) {
	if(key == null) key = "system";
	return RCFontManager.instance().hash_rcfont.get(key).copy(exceptions);
}
RCFontManager.getStyleSheet = function(key,exception) {
	if(key == null) key = "default";
	if(key == "css" && RCFontManager.instance().hash_style.exists("css")) return RCFontManager.instance().hash_style.get("css");
	return RCFontManager.instance().createStyle(RCFontManager.INSTANCE.hash_style.get(key),exception);
}
RCFontManager.addSwf = function(swf) {
	RCFontManager.instance().push(swf);
}
RCFontManager.setCSS = function(css) {
	RCFontManager.instance().setCSSFile(css);
}
RCFontManager.registerSwfFont = function(str) {
	return false;
}
RCFontManager.prototype = {
	createStyle: function(properties,exceptions) {
		var style = null;
		return style;
	}
	,setCSSFile: function(css) {
	}
	,push: function(e) {
		this.fontsSwfList.push(e);
	}
	,initDefaults: function() {
		this.hash_style = new haxe.ds.StringMap();
		this.hash_rcfont = new haxe.ds.StringMap();
		this.fontsSwfList = new Array();
		this._defaultStyleSheetData = { a_link : { color : "#999999", textDecoration : "underline"}, a_hover : { color : "#33CCFF"}, h1 : { size : 16}};
		RCFontManager.registerStyle("default",this._defaultStyleSheetData);
	}
	,hash_rcfont: null
	,hash_style: null
	,_defaultStyleSheetData: null
	,event: null
	,fontsSwfList: null
	,fontsDomain: null
	,__class__: RCFontManager
}
var _RCGestureRecognizer = {}
_RCGestureRecognizer.MovementDirection = $hxClasses["_RCGestureRecognizer.MovementDirection"] = { __ename__ : ["_RCGestureRecognizer","MovementDirection"], __constructs__ : ["left","right","down","up"] }
_RCGestureRecognizer.MovementDirection.left = ["left",0];
_RCGestureRecognizer.MovementDirection.left.toString = $estr;
_RCGestureRecognizer.MovementDirection.left.__enum__ = _RCGestureRecognizer.MovementDirection;
_RCGestureRecognizer.MovementDirection.right = ["right",1];
_RCGestureRecognizer.MovementDirection.right.toString = $estr;
_RCGestureRecognizer.MovementDirection.right.__enum__ = _RCGestureRecognizer.MovementDirection;
_RCGestureRecognizer.MovementDirection.down = ["down",2];
_RCGestureRecognizer.MovementDirection.down.toString = $estr;
_RCGestureRecognizer.MovementDirection.down.__enum__ = _RCGestureRecognizer.MovementDirection;
_RCGestureRecognizer.MovementDirection.up = ["up",3];
_RCGestureRecognizer.MovementDirection.up.toString = $estr;
_RCGestureRecognizer.MovementDirection.up.__enum__ = _RCGestureRecognizer.MovementDirection;
var RCGestureRecognizer = function(target,target_click) {
	this.target = target;
	this.clickableTarget = target_click == null?target:target_click;
	this.lastX = target.get_mouseX();
	this.lastY = target.get_mouseY();
	this.lastDirection = _RCGestureRecognizer.MovementDirection.right;
	this.resume();
};
$hxClasses["RCGestureRecognizer"] = RCGestureRecognizer;
RCGestureRecognizer.__name__ = ["RCGestureRecognizer"];
RCGestureRecognizer.prototype = {
	destroy: function() {
		this.hold();
	}
	,forceDirection: function(direction) {
		switch(direction) {
		case "left":
			this.lastGesture = _RCGestureRecognizer.MovementDirection.left;
			this.lastDirection = _RCGestureRecognizer.MovementDirection.left;
			break;
		case "right":
			this.lastGesture = _RCGestureRecognizer.MovementDirection.right;
			this.lastDirection = _RCGestureRecognizer.MovementDirection.right;
			break;
		case "up":
			this.lastGesture = _RCGestureRecognizer.MovementDirection.up;
			this.lastDirection = _RCGestureRecognizer.MovementDirection.up;
			break;
		case "down":
			this.lastGesture = _RCGestureRecognizer.MovementDirection.down;
			this.lastDirection = _RCGestureRecognizer.MovementDirection.down;
			break;
		}
	}
	,dispatchGesture: function(force) {
		if(force == null) force = false;
		var _g = this;
		switch( (_g.lastDirection)[1] ) {
		case 0:
			if(this.lastGesture != _RCGestureRecognizer.MovementDirection.left || force) {
				this.onLeft();
				return true;
			}
			break;
		case 1:
			if(this.lastGesture != _RCGestureRecognizer.MovementDirection.right || force) {
				this.onRight();
				return true;
			}
			break;
		case 3:
			if(this.lastGesture != _RCGestureRecognizer.MovementDirection.up || force) {
				this.onUp();
				return true;
			}
			break;
		case 2:
			if(this.lastGesture != _RCGestureRecognizer.MovementDirection.down || force) {
				this.onDown();
				return true;
			}
			break;
		}
		return false;
	}
	,updateDirection: function() {
		if(this.target.get_mouseX() > this.lastX + 10) {
			this.lastX = this.target.get_mouseX();
			if(this.lastDirection != _RCGestureRecognizer.MovementDirection.right) this.lastDirection = _RCGestureRecognizer.MovementDirection.right;
			return true;
		} else if(this.target.get_mouseX() < this.lastX - 10) {
			this.lastX = this.target.get_mouseX();
			if(this.lastDirection != _RCGestureRecognizer.MovementDirection.left) this.lastDirection = _RCGestureRecognizer.MovementDirection.left;
			return true;
		}
		if(this.target.get_mouseY() > this.lastY + 10) {
			this.lastY = this.target.get_mouseY();
			if(this.lastDirection != _RCGestureRecognizer.MovementDirection.down) this.lastDirection = _RCGestureRecognizer.MovementDirection.down;
			return true;
		} else if(this.target.get_mouseY() < this.lastY - 10) {
			this.lastY = this.target.get_mouseY();
			if(this.lastDirection != _RCGestureRecognizer.MovementDirection.up) this.lastDirection = _RCGestureRecognizer.MovementDirection.up;
			return true;
		}
		return false;
	}
	,mouseMoveHandler: function(e) {
		if(this.updateDirection()) {
			if(this.dispatchGesture()) this.lastGesture = this.lastDirection;
		}
		e.updateAfterEvent();
	}
	,mouseUpHandler: function(event) {
		if(this.target.get_mouseX() > this.lastClickedX + 10) this.clickDragRightRelease(); else if(this.target.get_mouseX() < this.lastClickedX - 10) this.clickDragLeftRelease(); else this.onClick();
	}
	,mouseDownHandler: function(event) {
		this.lastClickedX = this.target.get_mouseX();
	}
	,hold: function() {
	}
	,resume: function() {
	}
	,onClick: function() {
	}
	,clickDragRightRelease: function() {
	}
	,clickDragLeftRelease: function() {
	}
	,onDown: function() {
	}
	,onUp: function() {
	}
	,onRight: function() {
	}
	,onLeft: function() {
	}
	,lastClickedX: null
	,lastY: null
	,lastX: null
	,lastGesture: null
	,lastDirection: null
	,clickableTarget: null
	,target: null
	,__class__: RCGestureRecognizer
}
var RCGradient = function(colors,alphas,linear) {
	if(linear == null) linear = true;
	this.gradientColors = colors;
	this.gradientAlphas = alphas == null?[1.0,1.0]:alphas;
	this.gradientRatios = [0,255];
	this.focalPointRatio = 0;
	this.tx = 0;
	this.ty = 0;
	this.matrixRotation = Math.PI * 0.5;
};
$hxClasses["RCGradient"] = RCGradient;
RCGradient.__name__ = ["RCGradient"];
RCGradient.prototype = {
	matrixRotation: null
	,ty: null
	,tx: null
	,focalPointRatio: null
	,gradientType: null
	,interpolationMethod: null
	,spreadMethod: null
	,gradientRatios: null
	,gradientAlphas: null
	,gradientColors: null
	,strokeColor: null
	,__class__: RCGradient
}
var RCGroup = function(x,y,gapX,gapY,constructor_) {
	JSView.call(this,x,y);
	this.gapX = gapX;
	this.gapY = gapY;
	this.constructor_ = constructor_;
	this.items = new Array();
	this.itemPush = new RCSignal();
	this.itemRemove = new RCSignal();
	this.update = new RCSignal();
};
$hxClasses["RCGroup"] = RCGroup;
RCGroup.__name__ = ["RCGroup"];
RCGroup.__super__ = JSView;
RCGroup.prototype = $extend(JSView.prototype,{
	destroy: function() {
		Fugu.safeDestroy(this.items,null,{ fileName : "RCGroup.hx", lineNumber : 130, className : "RCGroup", methodName : "destroy"});
		this.items = null;
		JSView.prototype.destroy.call(this);
	}
	,get: function(i) {
		return this.items[i];
	}
	,keepItemsArranged: function() {
		var _g1 = 0, _g = this.items.length;
		while(_g1 < _g) {
			var i = _g1++;
			var newX = 0.0, newY = 0.0;
			var new_s = this.items[i];
			var old_s = this.items[i - 1];
			if(i != 0) {
				if(this.gapX != null) newX = old_s.get_x() + old_s.get_width() + this.gapX;
				if(this.gapY != null) newY = old_s.get_y() + old_s.get_height() + this.gapY;
			}
			new_s.set_x(newX);
			new_s.set_y(newY);
			this.size.width = newX + new_s.size.width;
			this.size.height = newY + new_s.size.height;
		}
		this.update.dispatch(this,null,null,null,{ fileName : "RCGroup.hx", lineNumber : 101, className : "RCGroup", methodName : "keepItemsArranged"});
	}
	,remove: function(i) {
		Fugu.safeDestroy(this.items[i],null,{ fileName : "RCGroup.hx", lineNumber : 69, className : "RCGroup", methodName : "remove"});
		this.keepItemsArranged();
		this.itemRemove.dispatch(new RCIndexPath(0,i),null,null,null,{ fileName : "RCGroup.hx", lineNumber : 74, className : "RCGroup", methodName : "remove"});
	}
	,add: function(params,alternativeConstructor) {
		if(!Reflect.isFunction(this.constructor_) && !Reflect.isFunction(alternativeConstructor)) return;
		if(alternativeConstructor != null) this.constructor_ = alternativeConstructor;
		if(this.constructor_ == null) throw "RCGroup needs passed a constructor function.";
		var i = 0;
		var _g = 0;
		while(_g < params.length) {
			var param = params[_g];
			++_g;
			var s = this.constructor_(new RCIndexPath(0,i));
			this.addChild(s);
			this.items.push(s);
			s.init();
			this.itemPush.dispatch(new RCIndexPath(0,i),null,null,null,{ fileName : "RCGroup.hx", lineNumber : 59, className : "RCGroup", methodName : "add"});
			i++;
		}
		this.keepItemsArranged();
	}
	,update: null
	,itemRemove: null
	,itemPush: null
	,gapY: null
	,gapX: null
	,constructor_: null
	,items: null
	,__class__: RCGroup
});
var RCImage = function(x,y,URL) {
	JSView.call(this,x,y);
	this.loader = js.Browser.document.createElement("img");
	this.addListeners();
	this.initWithContentsOfFile(URL);
};
$hxClasses["RCImage"] = RCImage;
RCImage.__name__ = ["RCImage"];
RCImage.imageNamed = function(name) {
	return new RCImage(0,0,name);
}
RCImage.imageWithContentsOfFile = function(path) {
	return new RCImage(0,0,path);
}
RCImage.imageWithRegionOfImage = function(image,size,source_rect,draw_at) {
	var im = image.copy();
	im.set_width(draw_at.size.width);
	im.set_height(draw_at.size.height);
	im.layer.style.overflow = "hidden";
	im.loader.style.left = "-" + source_rect.origin.x + "px";
	im.loader.style.top = "-" + source_rect.origin.y + "px";
	return im;
}
RCImage.__super__ = JSView;
RCImage.prototype = $extend(JSView.prototype,{
	scaleToFill: function(w,h) {
		JSView.prototype.scaleToFill.call(this,w,h);
		this.loader.style.width = this.size.width + "px";
		this.loader.style.height = this.size.height + "px";
	}
	,scaleToFit: function(w,h) {
		JSView.prototype.scaleToFit.call(this,w,h);
		this.loader.style.width = this.size.width + "px";
		this.loader.style.height = this.size.height + "px";
	}
	,destroy: function() {
		this.removeListeners();
		this.loader = null;
		JSView.prototype.destroy.call(this);
	}
	,removeListeners: function() {
		this.loader.onload = null;
		this.loader.onerror = null;
	}
	,addListeners: function() {
		this.loader.onload = $bind(this,this.completeHandler);
		this.loader.onerror = $bind(this,this.errorHandler);
	}
	,copy: function() {
		return new RCImage(0,0,this.loader.src);
	}
	,ioErrorHandler: function(e) {
		this.errorMessage = Std.string(e);
		this.onError();
	}
	,errorHandler: function(e) {
		this.errorMessage = Std.string(e);
		this.onError();
	}
	,completeHandler: function(e) {
		var _g = this;
		this.size.width = this.loader.width;
		this.size.height = this.loader.height;
		this.layer.appendChild(this.loader);
		this.loader.style.position = "absolute";
		this.originalSize = this.size.copy();
		this.isLoaded = true;
		if(RCDevice.currentDevice().userAgent == RCUserAgent.MSIE) {
			haxe.Timer.delay(function() {
				_g.onComplete();
			},1);
			return;
		}
		this.onComplete();
	}
	,initWithContentsOfFile: function(URL) {
		this.isLoaded = false;
		this.percentLoaded = 0;
		if(URL == null) return;
		this.loader.draggable = false;
		this.loader.src = URL;
	}
	,onError: function() {
	}
	,onProgress: function() {
	}
	,onComplete: function() {
	}
	,errorMessage: null
	,percentLoaded: null
	,isLoaded: null
	,bitmapData: null
	,loader: null
	,__class__: RCImage
});
var RCImageAnimated = function(x,y,urls) {
	JSView.call(this,x,y);
	this.isLoaded = false;
	this.percentLoaded = 0;
	this.currentFrame = 0;
	this._fps = 10;
	this.reverse = false;
	this.repeat = false;
	this.nr = 0;
	this.max = 0;
	if(urls == null) return;
	this.images = new Array();
	var _g = 0;
	while(_g < urls.length) {
		var url = urls[_g];
		++_g;
		var im = new RCImage(0,0,url);
		im.onProgress = $bind(this,this.progressHandler);
		im.onError = $bind(this,this.errorHandler);
		im.onComplete = $bind(this,this.completeHandler);
		this.images.push(im);
	}
	this.max = this.images.length;
};
$hxClasses["RCImageAnimated"] = RCImageAnimated;
RCImageAnimated.__name__ = ["RCImageAnimated"];
RCImageAnimated.animatedImageWithImages = function(x,y,images) {
	var im = new RCImageAnimated(x,y,null);
	im.images = images;
	im.gotoAndStop(1);
	return im;
}
RCImageAnimated.__super__ = JSView;
RCImageAnimated.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.stop();
		Fugu.safeDestroy(this.images,null,{ fileName : "RCImageAnimated.hx", lineNumber : 152, className : "RCImageAnimated", methodName : "destroy"});
		this.images = null;
		JSView.prototype.destroy.call(this);
	}
	,set_fps: function(f) {
		this._fps = f;
		if(this.timer != null) this.play(f);
		return f;
	}
	,errorHandler: function() {
		this.onError();
		this.onCompleteHandler();
	}
	,progressHandler: function() {
	}
	,onCompleteHandler: function() {
		this.nr++;
		if(this.nr >= this.max) this.onComplete();
	}
	,completeHandler: function() {
		this.onCompleteHandler();
	}
	,loop: function() {
		this.gotoAndStop(this.currentFrame + 1);
	}
	,stop: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
	}
	,play: function(newFPS) {
		if(newFPS != null) {
			this._fps = newFPS;
			this.stop();
		}
		if(this.currentFrame >= this.images.length && !this.repeat) this.gotoAndStop(1);
		if(this.timer == null) {
			this.timer = new haxe.Timer(Math.round(1000 / this._fps));
			this.timer.run = $bind(this,this.loop);
		}
	}
	,gotoLastFrame: function() {
		this.gotoAndStop(this.images.length);
	}
	,gotoAndStop: function(f) {
		if(f == 0 || f > this.images.length) {
			if(f > this.images.length && this.repeat) f = 1; else this.stop();
		}
		if(this.currentFrame > 0) this.removeChild(this.images[this.currentFrame - 1]);
		this.addChild(this.images[f - 1]);
		this.currentFrame = f;
	}
	,onError: function() {
	}
	,onProgress: function() {
	}
	,onComplete: function() {
	}
	,_fps: null
	,timer: null
	,max: null
	,nr: null
	,repeat: null
	,reverse: null
	,fps: null
	,errorMessage: null
	,percentLoaded: null
	,isLoaded: null
	,currentFrame: null
	,images: null
	,__class__: RCImageAnimated
	,__properties__: $extend(JSView.prototype.__properties__,{set_fps:"set_fps"})
});
var RCImageStretchable = function(x,y,imageLeft,imageMiddle,imageRight) {
	JSView.call(this,x,y);
	this.l = new RCImage(0,0,imageLeft);
	this.l.onComplete = $bind(this,this.onCompleteHandler);
	this.m = new RCImage(0,0,imageMiddle);
	this.m.onComplete = $bind(this,this.onCompleteHandler);
	this.r = new RCImage(0,0,imageRight);
	this.r.onComplete = $bind(this,this.onCompleteHandler);
	this.addChild(this.l);
	this.addChild(this.m);
	this.addChild(this.r);
};
$hxClasses["RCImageStretchable"] = RCImageStretchable;
RCImageStretchable.__name__ = ["RCImageStretchable"];
RCImageStretchable.__super__ = JSView;
RCImageStretchable.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.l.destroy();
		this.m.destroy();
		this.r.destroy();
		JSView.prototype.destroy.call(this);
	}
	,set_width: function(w) {
		this.size.width = w;
		if(!this.l.isLoaded || !this.m.isLoaded || !this.r.isLoaded) return w;
		this.l.set_x(0);
		this.m.set_x(Math.round(this.l.get_width()));
		var mw = Math.round(w - this.l.get_width() - this.r.get_width());
		if(mw < 0) mw = 0;
		this.m.set_width(mw);
		var rx = Math.round(w - this.r.get_width());
		if(rx < this.m.get_x() + mw) rx = Math.round(this.m.get_x() + mw);
		this.r.set_x(rx);
		return w;
	}
	,onCompleteHandler: function() {
		if(this.l.isLoaded && this.m.isLoaded && this.r.isLoaded && this.size.width != 0) this.set_width(this.size.width);
		this.onComplete();
	}
	,onComplete: function() {
	}
	,r: null
	,m: null
	,l: null
	,__class__: RCImageStretchable
});
var RCIndexPath = function(section,row) {
	this.section = section;
	this.row = row;
};
$hxClasses["RCIndexPath"] = RCIndexPath;
RCIndexPath.__name__ = ["RCIndexPath"];
RCIndexPath.prototype = {
	toString: function() {
		return "[RCIndexPath section : " + this.section + ", row : " + this.row + "]";
	}
	,copy: function() {
		return new RCIndexPath(this.section,this.row);
	}
	,next: function() {
		return this;
	}
	,hasNext: function() {
		return true;
	}
	,row: null
	,section: null
	,__class__: RCIndexPath
}
var RCIterator = function(interval,min,max,step) {
	this.interval = interval;
	this.min = min;
	this.max = max;
	this.step = step;
	this.timer = new haxe.Timer(interval);
};
$hxClasses["RCIterator"] = RCIterator;
RCIterator.__name__ = ["RCIterator"];
RCIterator.prototype = {
	destroy: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
	}
	,loop: function() {
		this.min += this.step;
		this.run(this.min);
		if(this.min >= this.max) {
			this.destroy();
			this.onComplete();
		}
	}
	,start: function() {
		this.run(this.min);
		this.timer.run = $bind(this,this.loop);
	}
	,onComplete: function() {
	}
	,run: function(i) {
	}
	,interval: null
	,timer: null
	,percentCompleted: null
	,step: null
	,max: null
	,min: null
	,__class__: RCIterator
}
var RCKeyboardController = function() {
	this.resume();
};
$hxClasses["RCKeyboardController"] = RCKeyboardController;
RCKeyboardController.__name__ = ["RCKeyboardController"];
RCKeyboardController.prototype = {
	destroy: function() {
		this.hold();
	}
	,hold: function() {
		js.Browser.document.onkeydown = null;
		js.Browser.document.onkeyup = null;
	}
	,resume: function() {
		js.Browser.document.onkeydown = $bind(this,this.keyDownHandler);
		js.Browser.document.onkeyup = $bind(this,this.keyUpHandler);
	}
	,keyUpHandler: function(e) {
		this["char"] = "";
		this.onKeyUp();
	}
	,keyDownHandler: function(e) {
		this.keyCode = e.keyCode;
		haxe.Log.trace(this.keyCode,{ fileName : "RCKeyboardController.hx", lineNumber : 42, className : "RCKeyboardController", methodName : "keyDownHandler"});
		this["char"] = "";
		this.onKeyDown();
		switch(e.keyCode) {
		case 37:
			this.onLeft();
			break;
		case 39:
			this.onRight();
			break;
		case 38:
			this.onUp();
			break;
		case 40:
			this.onDown();
			break;
		case 13:
			this.onEnter();
			break;
		case 32:
			this.onSpace();
			break;
		case 27:
			this.onEsc();
			break;
		}
	}
	,keyCode: null
	,'char': null
	,onKeyDown: function() {
	}
	,onKeyUp: function() {
	}
	,onEsc: function() {
	}
	,onSpace: function() {
	}
	,onEnter: function() {
	}
	,onDown: function() {
	}
	,onUp: function() {
	}
	,onRight: function() {
	}
	,onLeft: function() {
	}
	,__class__: RCKeyboardController
}
var Keyboard = function() { }
$hxClasses["Keyboard"] = Keyboard;
Keyboard.__name__ = ["Keyboard"];
var RCLine = function(x1,y1,x2,y2,color,alpha,lineWeight) {
	if(lineWeight == null) lineWeight = 1;
	if(alpha == null) alpha = 1.0;
	RCDraw.call(this,x1,y1,x2 - x1,y2 - y1,color,alpha);
	this.lineWeight = lineWeight;
	this.redraw();
};
$hxClasses["RCLine"] = RCLine;
RCLine.__name__ = ["RCLine"];
RCLine.__interfaces__ = [RCDrawInterface];
RCLine.__super__ = RCDraw;
RCLine.prototype = $extend(RCDraw.prototype,{
	drawLine: function(x0,y0,x1,y1) {
		var hexColor = (js.Boot.__cast(this.color , RCColor)).fillColorStyle;
		if(y0 == y1) {
			if(x0 <= x1) this.layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y0 + "px;width:" + (x1 - x0 + 1) + "px;height:" + this.lineWeight + ";background-color:" + hexColor + "\"></DIV>"; else if(x0 > x1) this.layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x1 + "px;top:" + y0 + "px;width:" + (x0 - x1 + 1) + "px;height:" + this.lineWeight + ";background-color:" + hexColor + "\"></DIV>";
			return this.layer;
		}
		if(x0 == x1) {
			if(y0 <= y1) this.layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y0 + "px;width:" + this.lineWeight + ";height:" + (y1 - y0 + 1) + "px;background-color:" + hexColor + "\"></DIV>"; else if(y0 > y1) this.layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y1 + "px;width:" + this.lineWeight + ";height:" + (y0 - y1 + 1) + "px;background-color:" + hexColor + "\"></DIV>";
			return this.layer;
		}
		var iHtml = new Array();
		var yArray = new Array();
		var dx = Math.abs(x1 - x0);
		var dy = Math.abs(y1 - y0);
		var pixHeight = Math.round(Math.sqrt(this.lineWeight * this.lineWeight / (dy * dy / (dx * dx) + 1)));
		var pixWidth = Math.round(Math.sqrt(this.lineWeight * this.lineWeight - pixHeight * pixHeight));
		if(pixWidth == 0) pixWidth = 1;
		if(pixHeight == 0) pixHeight = 1;
		var steep = Math.abs(y1 - y0) > Math.abs(x1 - x0);
		if(steep) {
			var tmp = x0;
			x0 = y0;
			y0 = tmp;
			tmp = x1;
			x1 = y1;
			y1 = tmp;
		}
		if(x0 > x1) {
			var tmp = x0;
			x0 = x1;
			x1 = tmp;
			tmp = y0;
			y0 = y1;
			y1 = tmp;
		}
		var deltax = x1 - x0;
		var deltay = Math.abs(y1 - y0);
		var error = deltax / 2;
		var ystep;
		var y = y0;
		ystep = y0 < y1?1:-1;
		var xp = 0;
		var yp = 0;
		var divWidth = 0;
		var divHeight = 0;
		if(steep) divWidth = pixWidth; else divHeight = pixHeight;
		var _g1 = x0, _g = x1 + 1;
		while(_g1 < _g) {
			var x = _g1++;
			if(steep) {
				if(x == x0) {
					xp = y;
					yp = x;
				} else if(y == xp) divHeight = divHeight + 1; else {
					divHeight = divHeight + pixHeight;
					iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					divHeight = 0;
					xp = y;
					yp = x;
				}
				if(x == x1) {
					if(divHeight != 0) {
						divHeight = divHeight + pixHeight;
						iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					} else {
						divHeight = pixHeight;
						iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + y + "px;top:" + x + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					}
				}
			} else {
				if(x == x0) {
					xp = x;
					yp = y;
				} else if(y == yp) divWidth = divWidth + 1; else {
					divWidth = divWidth + pixWidth;
					iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					divWidth = 0;
					xp = x;
					yp = y;
				}
				if(x == x1) {
					if(divWidth != 0) {
						divWidth = divWidth + pixWidth;
						iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					} else {
						divWidth = pixWidth;
						iHtml[iHtml.length] = "<DIV style=\"position:absolute;overflow:hidden;left:" + x + "px;top:" + y + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
					}
				}
			}
			error = error - deltay;
			if(error < 0) {
				y = y + ystep;
				error = error + deltax;
			}
		}
		this.layer.innerHTML = iHtml.join("");
		return this.layer;
	}
	,redraw: function() {
		this.layer.innerHTML = "";
		this.drawLine(0,0,Math.round(this.size.width),Math.round(this.size.height));
	}
	,lineWeight: null
	,__class__: RCLine
});
var RCLog = function() { }
$hxClasses["RCLog"] = RCLog;
RCLog.__name__ = ["RCLog"];
RCLog.redirectTraces = function() {
	haxe.Log.trace = RCLog.trace;
	if (!window.console) window.console = {};
			if (!window.console.log) window.console.log = function () { };;
}
RCLog.allowClasses = function(arr) {
	RCLog.ALLOW_TRACES_FROM = RCLog.ALLOW_TRACES_FROM.concat(arr);
}
RCLog.trace = function(v,inf) {
	if(RCLog.ALLOW_TRACES_FROM.length == 0) RCLog._trace(v,inf); else {
		var _g = 0, _g1 = RCLog.ALLOW_TRACES_FROM;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(c == inf.className.split(".").pop()) RCLog._trace(v,inf);
		}
	}
}
RCLog.error = function(v,inf) {
	if(RCLog.ALLOW_TRACES_FROM.length == 0) RCLog._trace(v,inf,"error"); else {
		var _g = 0, _g1 = RCLog.ALLOW_TRACES_FROM;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(c == inf.className.split(".").pop()) RCLog._trace(v,inf,"error");
		}
	}
}
RCLog._trace = function(v,inf,type) {
	if(type == null) type = "log";
	var line1 = RCLog.lastMethod == inf.methodName?"":"\n";
	var fileInfo = line1 + inf.fileName + " : " + inf.methodName;
	if(RCLog.lastMethod != inf.methodName) {
		if(type == "log") console.log(fileInfo); else if(type == "error") console.error(fileInfo);
	}
	console.log(inf.lineNumber + " :  " + Std.string(v));
	RCLog.lastMethod = inf.methodName;
}
var RCMail = function(apiPath) {
	this.apiPath = apiPath;
	if(apiPath != "" && !StringTools.endsWith(apiPath,"/")) this.apiPath += "/";
	RCRequest.call(this);
};
$hxClasses["RCMail"] = RCMail;
RCMail.__name__ = ["RCMail"];
RCMail.__super__ = RCRequest;
RCMail.prototype = $extend(RCRequest.prototype,{
	send: function(to,subject,message,from) {
		var variables = this.createVariables({ to : to, subject : subject, message : message, from : from});
		this.load(this.apiPath + "others/sendMail.php",variables,"POST");
	}
	,apiPath: null
	,__class__: RCMail
});
var RCMath = function() { }
$hxClasses["RCMath"] = RCMath;
RCMath.__name__ = ["RCMath"];
RCMath.angleOnCircle = function(i,nrOfItems) {
	return i * (Math.PI * 2 / nrOfItems);
}
RCMath.positionOnEllipse = function(angle,radiusX,radiusY) {
	return new RCPoint(Math.cos(angle) * radiusX,Math.sin(angle) * radiusY);
}
RCMath.radians = function(deg) {
	return deg * Math.PI / 180;
}
RCMath.degrees = function(rad) {
	return rad * 180 / Math.PI;
}
RCMath.distanceBetween2Points = function(p1,p2) {
	var dx = p2.x - p1.x;
	var dy = p2.y - p1.y;
	return Math.sqrt(dx * dx + dy * dy);
}
RCMath.ponderatedSum = function(a,p) {
	var f1 = 0, f2 = 0;
	var _g1 = 0, _g = a.length;
	while(_g1 < _g) {
		var i = _g1++;
		f1 += a[i] * p[i];
		f2 += p[i];
	}
	return f1 / f2;
}
RCMath.sum = function(a) {
	var f1 = 0;
	var _g = 0;
	while(_g < a.length) {
		var i = a[_g];
		++_g;
		f1 += i;
	}
	return f1;
}
RCMath.random = function(min,max) {
	return Math.round(min + Math.random() * (max - min));
}
var RCViewController = function(x,y,w,h) {
	JSView.call(this,x,y,w,h);
	RCNotificationCenter.addObserver("orientationWillChange",$bind(this,this.orientationWillChange));
	RCNotificationCenter.addObserver("orientationChanged",$bind(this,this.orientationChanged));
};
$hxClasses["RCViewController"] = RCViewController;
RCViewController.__name__ = ["RCViewController"];
RCViewController.__super__ = JSView;
RCViewController.prototype = $extend(JSView.prototype,{
	destroy: function() {
		RCNotificationCenter.removeObserver("orientationWillChange",$bind(this,this.orientationWillChange));
		RCNotificationCenter.removeObserver("orientationChanged",$bind(this,this.orientationChanged));
		JSView.prototype.destroy.call(this);
	}
	,dismissModalViewController: function() {
		RCWindow.sharedWindow().dismissModalViewController();
	}
	,addModalViewController: function(view) {
		RCWindow.sharedWindow().addModalViewController(view);
	}
	,shouldAutorotateToInterfaceOrientation: function(toOrientation) {
		return true;
	}
	,orientationChanged: function() {
	}
	,orientationWillChange: function() {
	}
	,__class__: RCViewController
});
var RCModalViewController = function(x,y,w,h) {
	RCViewController.call(this,x,y,w,h);
};
$hxClasses["RCModalViewController"] = RCModalViewController;
RCModalViewController.__name__ = ["RCModalViewController"];
RCModalViewController.__super__ = RCViewController;
RCModalViewController.prototype = $extend(RCViewController.prototype,{
	modalViewWillDisappear: function() {
	}
	,modalViewDidAppear: function() {
	}
	,__class__: RCModalViewController
});
var RCMysql = function(scriptsPath) {
	this.scriptsPath = scriptsPath;
	RCRequest.call(this);
};
$hxClasses["RCMysql"] = RCMysql;
RCMysql.__name__ = ["RCMysql"];
RCMysql.__super__ = RCRequest;
RCMysql.prototype = $extend(RCRequest.prototype,{
	call: function(script,variables_list) {
		this.load(script,this.createVariables(variables_list));
	}
	,length: function(variables) {
		this.call(this.scriptsPath + "mysql/length.php",variables);
	}
	,'delete': function(variables) {
		this.call(this.scriptsPath + "mysql/delete.php",variables);
	}
	,update: function(variables) {
		this.call(this.scriptsPath + "mysql/update.php",variables);
	}
	,insert: function(variables) {
		this.call(this.scriptsPath + "mysql/insert.php",variables);
	}
	,select: function(variables) {
		this.call(this.scriptsPath + "mysql/select.php",variables);
	}
	,scriptsPath: null
	,__class__: RCMysql
});
var RCMysqlTools = function(_path) {
	RCMysql.call(this,_path);
};
$hxClasses["RCMysqlTools"] = RCMysqlTools;
RCMysqlTools.__name__ = ["RCMysqlTools"];
RCMysqlTools.__super__ = RCMysql;
RCMysqlTools.prototype = $extend(RCMysql.prototype,{
	user_register: function(column_list,values_list) {
		var insert_info = new Array();
		var _g1 = 0, _g = column_list.length;
		while(_g1 < _g) {
			var i = _g1++;
			insert_info.push([column_list[i],values_list[i]].join("="));
		}
	}
	,user_login: function(user,parola) {
		var login_info = new Array();
		login_info.push(["user",user].join("="));
		login_info.push(["parola",haxe.crypto.Md5.encode(parola)].join("="));
	}
	,__class__: RCMysqlTools
});
var RCNotification = function(name,functionToCall) {
	this.name = name;
	this.functionToCall = functionToCall;
};
$hxClasses["RCNotification"] = RCNotification;
RCNotification.__name__ = ["RCNotification"];
RCNotification.prototype = {
	toString: function() {
		return "[RCNotification with name: '" + this.name + "', functionToCall: " + Std.string(this.functionToCall) + "]";
	}
	,functionToCall: null
	,name: null
	,__class__: RCNotification
}
var RCNotificationCenter = function() { }
$hxClasses["RCNotificationCenter"] = RCNotificationCenter;
RCNotificationCenter.__name__ = ["RCNotificationCenter"];
RCNotificationCenter.notificationsList = null;
RCNotificationCenter.init = function() {
	if(RCNotificationCenter.notificationsList == null) {
		RCNotificationCenter.notificationsList = new List();
		var fs = new EVFullScreen();
		fs.add(RCNotificationCenter.fullScreenHandler);
		var rs = new EVResize();
		rs.add(RCNotificationCenter.resizeHandler);
	}
}
RCNotificationCenter.resizeHandler = function(w,h) {
	RCNotificationCenter.postNotification("resize",[w,h],{ fileName : "RCNotificationCenter.hx", lineNumber : 27, className : "RCNotificationCenter", methodName : "resizeHandler"});
}
RCNotificationCenter.fullScreenHandler = function(b) {
	RCNotificationCenter.postNotification("fullscreen",[b],{ fileName : "RCNotificationCenter.hx", lineNumber : 30, className : "RCNotificationCenter", methodName : "fullScreenHandler"});
}
RCNotificationCenter.addObserver = function(name,func) {
	RCNotificationCenter.init();
	RCNotificationCenter.notificationsList.add(new RCNotification(name,func));
}
RCNotificationCenter.removeObserver = function(name,func) {
	RCNotificationCenter.init();
	var $it0 = RCNotificationCenter.notificationsList.iterator();
	while( $it0.hasNext() ) {
		var notification = $it0.next();
		if(notification.name == name && Reflect.compareMethods(notification.functionToCall,func)) RCNotificationCenter.notificationsList.remove(notification);
	}
}
RCNotificationCenter.postNotification = function(name,args,pos) {
	RCNotificationCenter.init();
	var notificationFound = false;
	var $it0 = RCNotificationCenter.notificationsList.iterator();
	while( $it0.hasNext() ) {
		var notification = $it0.next();
		if(notification.name == name) try {
			notificationFound = true;
			notification.functionToCall.apply(null,args);
		} catch( e ) {
			haxe.Log.trace("[RCNotificationCenter error calling function: " + Std.string(notification.functionToCall) + " from: " + Std.string(pos) + "]",{ fileName : "RCNotificationCenter.hx", lineNumber : 72, className : "RCNotificationCenter", methodName : "postNotification"});
		}
	}
	return notificationFound;
}
RCNotificationCenter.list = function() {
	var $it0 = RCNotificationCenter.notificationsList.iterator();
	while( $it0.hasNext() ) {
		var notification = $it0.next();
		haxe.Log.trace(notification,{ fileName : "RCNotificationCenter.hx", lineNumber : 83, className : "RCNotificationCenter", methodName : "list"});
	}
}
var RCPageControl = function(x,y,w,h,skin) {
	RCControl.call(this,x,y,w,h);
	this.currentPage = 0;
	this.hidesForSinglePage = false;
};
$hxClasses["RCPageControl"] = RCPageControl;
RCPageControl.__name__ = ["RCPageControl"];
RCPageControl.__super__ = RCControl;
RCPageControl.prototype = $extend(RCControl.prototype,{
	destroy: function() {
		RCControl.prototype.destroy.call(this);
	}
	,sizeForNumberOfPages: function(pageCount) {
		return new RCSize(0,0);
	}
	,updateCurrentPageDisplay: function() {
	}
	,clickHandler: function(e) {
		this.currentPage = 0;
		this.onClick();
	}
	,defersCurrentPageDisplay: null
	,hidesForSinglePage: null
	,currentPage: null
	,numberOfPages: null
	,displayedPage: null
	,indicators: null
	,__class__: RCPageControl
});
var RCPoint = function(x,y) {
	this.x = x == null?0:x;
	this.y = y == null?0:y;
};
$hxClasses["RCPoint"] = RCPoint;
RCPoint.__name__ = ["RCPoint"];
RCPoint.prototype = {
	toString: function() {
		return "[RCPoint x:" + this.x + ", y:" + this.y + "]";
	}
	,copy: function() {
		return new RCPoint(this.x,this.y);
	}
	,y: null
	,x: null
	,__class__: RCPoint
}
var RCPolygon = function(x,y,points,color,alpha) {
	if(alpha == null) alpha = 1.0;
	RCDraw.call(this,x,y,0,0,color,alpha);
	this.points = points;
	this.redraw();
};
$hxClasses["RCPolygon"] = RCPolygon;
RCPolygon.__name__ = ["RCPolygon"];
RCPolygon.__interfaces__ = [RCDrawInterface];
RCPolygon.__super__ = RCDraw;
RCPolygon.prototype = $extend(RCDraw.prototype,{
	redraw: function() {
	}
	,points: null
	,__class__: RCPolygon
});
var RCRect = function(x,y,w,h) {
	this.origin = new RCPoint(x,y);
	this.size = new RCSize(w,h);
};
$hxClasses["RCRect"] = RCRect;
RCRect.__name__ = ["RCRect"];
RCRect.prototype = {
	toString: function() {
		return "[RCRect x:" + this.origin.x + ", y:" + this.origin.y + ", width:" + this.size.width + ", height:" + this.size.height + "]";
	}
	,copy: function() {
		return new RCRect(this.origin.x,this.origin.y,this.size.width,this.size.height);
	}
	,size: null
	,origin: null
	,__class__: RCRect
}
var RCRectangle = function(x,y,w,h,color,alpha,r) {
	if(alpha == null) alpha = 1.0;
	RCDraw.call(this,x,y,w,h,color,alpha);
	this.roundness = r;
	this.redraw();
};
$hxClasses["RCRectangle"] = RCRectangle;
RCRectangle.__name__ = ["RCRectangle"];
RCRectangle.__interfaces__ = [RCDrawInterface];
RCRectangle.__super__ = RCDraw;
RCRectangle.prototype = $extend(RCDraw.prototype,{
	set_height: function(h) {
		this.size.height = h;
		this.redraw();
		return h;
	}
	,set_width: function(w) {
		this.size.width = w;
		this.redraw();
		return w;
	}
	,redraw: function() {
		var dpi = RCDevice.currentDevice().dpiScale;
		var fillColorStyle = this.color.fillColorStyle;
		var strokeColorStyle = this.color.strokeColorStyle;
		this.layer.style.margin = "0px 0px 0px 0px";
		this.layer.style.width = this.size.width * dpi + "px";
		this.layer.style.height = this.size.height * dpi + "px";
		this.layer.style.backgroundColor = fillColorStyle + "";
		if(strokeColorStyle != null) {
			this.layer.style.borderStyle = "solid";
			this.layer.style.borderWidth = this.borderThickness + "px";
			this.layer.style.borderColor = strokeColorStyle + "";
		}
		if(this.roundness != null) {
			this.layer.style.MozBorderRadius = this.roundness * dpi / 2 + "px";
			this.layer.style.borderRadius = this.roundness * dpi / 2 + "px";
		}
	}
	,roundness: null
	,__class__: RCRectangle
});
var _RCRequest = {}
_RCRequest.URLVariables = function() {
};
$hxClasses["_RCRequest.URLVariables"] = _RCRequest.URLVariables;
_RCRequest.URLVariables.__name__ = ["_RCRequest","URLVariables"];
_RCRequest.URLVariables.prototype = {
	__class__: _RCRequest.URLVariables
}
var _RCScrollBar = {}
_RCScrollBar.Direction = $hxClasses["_RCScrollBar.Direction"] = { __ename__ : ["_RCScrollBar","Direction"], __constructs__ : ["HORIZONTAL","VERTICAL"] }
_RCScrollBar.Direction.HORIZONTAL = ["HORIZONTAL",0];
_RCScrollBar.Direction.HORIZONTAL.toString = $estr;
_RCScrollBar.Direction.HORIZONTAL.__enum__ = _RCScrollBar.Direction;
_RCScrollBar.Direction.VERTICAL = ["VERTICAL",1];
_RCScrollBar.Direction.VERTICAL.toString = $estr;
_RCScrollBar.Direction.VERTICAL.__enum__ = _RCScrollBar.Direction;
var RCScrollBar = function(x,y,w,h,indicatorSize,skin) {
	RCControl.call(this,x,y,w,h);
	this.moving = false;
	this.minValue_ = 0;
	this.maxValue_ = 100;
	this.value_ = 0.0;
	this.skin = skin;
	this.indicatorSize = indicatorSize;
	this.viewDidAppear.add($bind(this,this.init));
};
$hxClasses["RCScrollBar"] = RCScrollBar;
RCScrollBar.__name__ = ["RCScrollBar"];
RCScrollBar.__super__ = RCControl;
RCScrollBar.prototype = $extend(RCControl.prototype,{
	destroy: function() {
		this.valueChanged.destroy({ fileName : "RCScrollBar.hx", lineNumber : 163, className : "RCScrollBar", methodName : "destroy"});
		this.mouseUpOverStage_.destroy({ fileName : "RCScrollBar.hx", lineNumber : 164, className : "RCScrollBar", methodName : "destroy"});
		this.mouseMoveOverStage_.destroy({ fileName : "RCScrollBar.hx", lineNumber : 165, className : "RCScrollBar", methodName : "destroy"});
		this.skin.destroy();
		RCControl.prototype.destroy.call(this);
	}
	,set_value: function(v) {
		var x1 = 0.0, x2 = 0.0;
		this.value_ = v;
		var _g = this;
		switch( (_g.direction_)[1] ) {
		case 0:
			x2 = this.size.width - this.scrollbar.get_width();
			this.scrollbar.set_x(Zeta.lineEquationInt(x1,x2,v,this.minValue_,this.maxValue_));
			break;
		case 1:
			x2 = this.size.height - this.scrollbar.get_height();
			this.scrollbar.set_y(Zeta.lineEquationInt(x1,x2,v,this.minValue_,this.maxValue_));
			break;
		}
		this.valueChanged.dispatch(this,null,null,null,{ fileName : "RCScrollBar.hx", lineNumber : 154, className : "RCScrollBar", methodName : "set_value"});
		return this.value_;
	}
	,get_value: function() {
		return this.value_;
	}
	,mouseMoveHandler: function(e) {
		var y0 = 0.0, y1 = 0.0, y2 = 0.0;
		var _g = this;
		switch( (_g.direction_)[1] ) {
		case 0:
			y2 = this.size.width - this.scrollbar.get_width();
			y0 = Zeta.limitsInt(this.get_mouseX() - this.scrollbar.get_width() / 2,0,y2);
			break;
		case 1:
			y2 = this.size.height - this.scrollbar.get_height();
			y0 = Zeta.limitsInt(this.get_mouseY() - this.scrollbar.get_height() / 2,0,y2);
			break;
		}
		this.set_value(Zeta.lineEquation(this.minValue_,this.maxValue_,y0,y1,y2));
		e.updateAfterEvent();
	}
	,clickHandler: function(e) {
		this.setState(RCControlState.SELECTED);
		this.onClick();
	}
	,rollOutHandler: function(e) {
		this.setState(RCControlState.NORMAL);
		this.scrollbar.set_alpha(0.4);
		this.onOut();
	}
	,rollOverHandler: function(e) {
		this.setState(RCControlState.HIGHLIGHTED);
		this.scrollbar.set_alpha(1);
		this.onOver();
	}
	,mouseUpHandler: function(e) {
		this.moving = false;
		this.mouseUpOverStage_.remove($bind(this,this.mouseUpHandler));
		this.mouseMoveOverStage_.remove($bind(this,this.mouseMoveHandler));
		this.setState(RCControlState.HIGHLIGHTED);
		this.onRelease();
	}
	,mouseDownHandler: function(e) {
		haxe.Log.trace("mouseDownHandler",{ fileName : "RCScrollBar.hx", lineNumber : 79, className : "RCScrollBar", methodName : "mouseDownHandler"});
		this.moving = true;
		this.mouseUpOverStage_.add($bind(this,this.mouseUpHandler));
		this.mouseMoveOverStage_.add($bind(this,this.mouseMoveHandler));
		this.mouseMoveHandler(e);
		this.setState(RCControlState.SELECTED);
		this.onPress();
	}
	,configureDispatchers: function() {
		RCControl.prototype.configureDispatchers.call(this);
		this.valueChanged = new RCSignal();
		this.mouseUpOverStage_ = new EVMouse("mouseup",RCWindow.sharedWindow().stage,{ fileName : "RCScrollBar.hx", lineNumber : 75, className : "RCScrollBar", methodName : "configureDispatchers"});
		this.mouseMoveOverStage_ = new EVMouse("mousemove",RCWindow.sharedWindow().stage,{ fileName : "RCScrollBar.hx", lineNumber : 76, className : "RCScrollBar", methodName : "configureDispatchers"});
	}
	,init: function() {
		RCControl.prototype.init.call(this);
		this.direction_ = this.size.width > this.size.height?_RCScrollBar.Direction.HORIZONTAL:_RCScrollBar.Direction.VERTICAL;
		this.background = this.skin.normal.background;
		this.background.set_width(this.size.width);
		this.background.set_height(this.size.height);
		this.addChild(this.background);
		this.scrollbar = this.skin.normal.otherView;
		this.scrollbar.set_width(this.direction_ == _RCScrollBar.Direction.HORIZONTAL?this.indicatorSize:this.size.width);
		this.scrollbar.set_height(this.direction_ == _RCScrollBar.Direction.VERTICAL?this.indicatorSize:this.size.height);
		this.scrollbar.set_alpha(0.4);
		this.addChild(this.scrollbar);
	}
	,valueChanged: null
	,mouseMoveOverStage_: null
	,mouseUpOverStage_: null
	,moving: null
	,maxValue_: null
	,minValue_: null
	,value_: null
	,direction_: null
	,indicatorSize: null
	,scrollbar: null
	,background: null
	,skin: null
	,__class__: RCScrollBar
	,__properties__: $extend(RCControl.prototype.__properties__,{set_value:"set_value",get_value:"get_value"})
});
var RCScrollView = function(x,y,w,h) {
	JSView.call(this,x,y,w,h);
	this.set_clipsToBounds(true);
	this.setContentView(new JSView(0,0));
};
$hxClasses["RCScrollView"] = RCScrollView;
RCScrollView.__name__ = ["RCScrollView"];
RCScrollView.__super__ = JSView;
RCScrollView.prototype = $extend(JSView.prototype,{
	destroy: function() {
		Fugu.safeDestroy([this.vertScrollBarSync,this.horizScrollBarSync,this.vertScrollBar,this.horizScrollBar],null,{ fileName : "RCScrollView.hx", lineNumber : 140, className : "RCScrollView", methodName : "destroy"});
		this.vertScrollBarSync = null;
		this.horizScrollBarSync = null;
		JSView.prototype.destroy.call(this);
	}
	,hold: function() {
		if(this.vertScrollBarSync != null) this.vertScrollBarSync.hold();
		if(this.horizScrollBarSync != null) this.horizScrollBarSync.hold();
	}
	,resume: function() {
		if(this.vertScrollBarSync != null) this.vertScrollBarSync.resume();
		if(this.horizScrollBarSync != null) this.horizScrollBarSync.resume();
	}
	,set_enableMarginsFade: function(b) {
		return b;
	}
	,set_bounces: function(b) {
		this.bounces_ = b;
		return b;
	}
	,zoomToRect: function(rect,animated) {
	}
	,scrollRectToVisible: function(rect,animated) {
	}
	,scrollViewDidScrollHandler: function(s) {
		this.scrollViewDidScroll();
	}
	,set_scrollEnabled: function(b) {
		haxe.Log.trace("setScrollEnabled " + Std.string(b),{ fileName : "RCScrollView.hx", lineNumber : 60, className : "RCScrollView", methodName : "set_scrollEnabled"});
		var colors = [null,null,14540253,16777215];
		haxe.Log.trace("contentSize " + Std.string(this.contentView.get_contentSize()),{ fileName : "RCScrollView.hx", lineNumber : 62, className : "RCScrollView", methodName : "set_scrollEnabled"});
		haxe.Log.trace(this.size,{ fileName : "RCScrollView.hx", lineNumber : 63, className : "RCScrollView", methodName : "set_scrollEnabled"});
		if(this.contentSize_.width > this.size.width && this.horizScrollBarSync == null && b && false) {
			haxe.Log.trace("add horiz",{ fileName : "RCScrollView.hx", lineNumber : 67, className : "RCScrollView", methodName : "set_scrollEnabled"});
			var scroller_w = Zeta.lineEquationInt(this.size.width / 2,this.size.width,this.contentSize_.width,this.size.width * 2,this.size.width);
			var skinH = new haxe.SKScrollBar(colors);
			this.horizScrollBar = new RCScrollBar(0,this.size.height - 10,this.size.width,8,scroller_w,skinH);
			this.horizScrollBarSync = new RCSliderSync(RCWindow.sharedWindow().target,this.contentView,this.horizScrollBar,this.size.width,"horizontal");
			this.horizScrollBarSync.valueChanged.add($bind(this,this.scrollViewDidScrollHandler));
			this.addChild(this.horizScrollBar);
		} else {
			Fugu.safeDestroy([this.horizScrollBar,this.horizScrollBarSync],null,{ fileName : "RCScrollView.hx", lineNumber : 76, className : "RCScrollView", methodName : "set_scrollEnabled"});
			this.horizScrollBar = null;
			this.horizScrollBarSync = null;
		}
		haxe.Log.trace("contentView.height " + this.contentView.get_height(),{ fileName : "RCScrollView.hx", lineNumber : 80, className : "RCScrollView", methodName : "set_scrollEnabled"});
		if(this.contentView.get_height() > this.size.height && this.vertScrollBarSync == null && b) {
			haxe.Log.trace("add vert",{ fileName : "RCScrollView.hx", lineNumber : 85, className : "RCScrollView", methodName : "set_scrollEnabled"});
			var scroller_h = Zeta.lineEquationInt(this.size.height / 2,this.size.height,this.contentSize_.height,this.size.height * 2,this.size.height);
			var skinV = new haxe.SKScrollBar(colors);
			this.vertScrollBar = new RCScrollBar(this.size.width - 10,0,8,this.size.height,scroller_h,skinV);
			this.vertScrollBarSync = new RCSliderSync(RCWindow.sharedWindow().target,this.contentView,this.vertScrollBar,this.size.height,"vertical");
			this.vertScrollBarSync.valueChanged.add($bind(this,this.scrollViewDidScrollHandler));
			this.addChild(this.vertScrollBar);
		} else {
			Fugu.safeDestroy([this.vertScrollBar,this.vertScrollBarSync],null,{ fileName : "RCScrollView.hx", lineNumber : 94, className : "RCScrollView", methodName : "set_scrollEnabled"});
			this.vertScrollBar = null;
			this.vertScrollBarSync = null;
		}
		return b;
	}
	,setContentView: function(content) {
		Fugu.safeRemove(this.contentView);
		this.contentView = content;
		this.addChild(this.contentView);
		this.set_contentSize(this.contentView.get_contentSize());
		this.set_scrollEnabled(true);
	}
	,scrollViewDidEndScrollingAnimation: function() {
	}
	,scrollViewDidScrollToTop: function() {
	}
	,scrollViewDidEndDragging: function() {
	}
	,scrollViewWillBeginDragging: function() {
	}
	,scrollViewDidScroll: function() {
	}
	,scrollIndicatorInsets: null
	,scrollEnabled: null
	,pagingEnabled: null
	,decelerationRate: null
	,bounces: null
	,enableMarginsFade: null
	,autohideSliders: null
	,dragging: null
	,contentView: null
	,bounces_: null
	,horizScrollBarSync: null
	,vertScrollBarSync: null
	,horizScrollBar: null
	,vertScrollBar: null
	,__class__: RCScrollView
	,__properties__: $extend(JSView.prototype.__properties__,{set_enableMarginsFade:"set_enableMarginsFade",set_bounces:"set_bounces",set_scrollEnabled:"set_scrollEnabled"})
});
var RCSegmentedControl = function(x,y,w,h,skin) {
	JSView.call(this,x,y,w,h);
	this.selectedIndex_ = -1;
	this.items = new OrderedMap();
	this.click = new RCSignal();
	this.itemAdded = new RCSignal();
	this.itemRemoved = new RCSignal();
	if(skin == null) skin = ios.SKSegment;
	this.skin = skin;
};
$hxClasses["RCSegmentedControl"] = RCSegmentedControl;
RCSegmentedControl.__name__ = ["RCSegmentedControl"];
RCSegmentedControl.__super__ = JSView;
RCSegmentedControl.prototype = $extend(JSView.prototype,{
	destroy: function() {
		if(this.items != null) {
			var $it0 = this.items.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				Fugu.safeDestroy(this.items.get(key),null,{ fileName : "RCSegmentedControl.hx", lineNumber : 245, className : "RCSegmentedControl", methodName : "destroy"});
			}
		}
		this.items = null;
		this.click.destroy({ fileName : "RCSegmentedControl.hx", lineNumber : 247, className : "RCSegmentedControl", methodName : "destroy"});
		this.itemAdded.destroy({ fileName : "RCSegmentedControl.hx", lineNumber : 248, className : "RCSegmentedControl", methodName : "destroy"});
		this.itemRemoved.destroy({ fileName : "RCSegmentedControl.hx", lineNumber : 249, className : "RCSegmentedControl", methodName : "destroy"});
		JSView.prototype.destroy.call(this);
	}
	,clickHandler: function(label) {
		this.set_selectedIndex(this.items.indexForKey(label));
		this.click.dispatch(this,null,null,null,{ fileName : "RCSegmentedControl.hx", lineNumber : 239, className : "RCSegmentedControl", methodName : "clickHandler"});
	}
	,disable: function(label) {
		this.items.get(label).set_enabled(false);
		this.items.get(label).set_alpha(0.4);
	}
	,enable: function(label) {
		this.items.get(label).set_enabled(true);
		this.items.get(label).set_alpha(1);
	}
	,exists: function(label) {
		return this.items.exists(label);
	}
	,get: function(label) {
		return this.items.get(label);
	}
	,toggled: function(label) {
		return this.items.get(label).get_selected();
	}
	,unselect: function(label) {
		this.items.get(label).set_enabled(true);
		this.items.get(label).untoggle();
	}
	,select: function(label,can_unselect) {
		if(can_unselect == null) can_unselect = true;
		haxe.Log.trace("select " + label + ", " + Std.string(can_unselect),{ fileName : "RCSegmentedControl.hx", lineNumber : 178, className : "RCSegmentedControl", methodName : "select"});
		if(this.items.exists(label)) {
			this.items.get(label).toggle();
			if(can_unselect) this.items.get(label).set_enabled(false); else this.items.get(label).set_enabled(true);
		}
		if(can_unselect) {
			var $it0 = this.items.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				if(key != label) this.unselect(key);
			}
		}
	}
	,keepButtonsArranged: function() {
		return;
		var _g1 = 0, _g = this.items.array.length;
		while(_g1 < _g) {
			var i = _g1++;
			var newX = 0.0, newY = 0.0;
			var new_b = this.items.get(this.items.array[i]);
		}
	}
	,remove: function(label) {
		if(this.items.exists(label)) {
			Fugu.safeDestroy(this.items.get(label),null,{ fileName : "RCSegmentedControl.hx", lineNumber : 147, className : "RCSegmentedControl", methodName : "remove"});
			this.items.remove(label);
		}
		this.keepButtonsArranged();
		this.itemRemoved.dispatch(this,null,null,null,{ fileName : "RCSegmentedControl.hx", lineNumber : 155, className : "RCSegmentedControl", methodName : "remove"});
	}
	,set_selectedIndex: function(i) {
		haxe.Log.trace("setIndex " + this.selectedIndex_ + " > " + i,{ fileName : "RCSegmentedControl.hx", lineNumber : 132, className : "RCSegmentedControl", methodName : "set_selectedIndex"});
		if(this.selectedIndex_ == i) return i;
		this.selectedIndex_ = i;
		this.select(this.labels[i]);
		return this.selectedIndex_;
	}
	,get_selectedIndex: function() {
		return this.selectedIndex_;
	}
	,constructButton: function(i) {
		var position = "middle";
		if(i == 0) position = "left";
		if(i == this.labels.length - 1) position = "left";
		var segmentX = 0;
		var _g = 0;
		while(_g < i) {
			var j = _g++;
			segmentX += this.segmentsWidth[j];
		}
		var s = Type.createInstance(this.skin,[this.labels[i],this.segmentsWidth[i],this.size.height,position,null]);
		var b = new RCButtonRadio(segmentX,0,s);
		return b;
	}
	,initWithLabels: function(labels,equalSizes) {
		if(equalSizes == null) equalSizes = true;
		this.labels = labels;
		this.segmentsWidth = new Array();
		if(equalSizes) {
			var segmentWidth = Math.round(this.size.width / labels.length);
			var _g = 0;
			while(_g < labels.length) {
				var l = labels[_g];
				++_g;
				this.segmentsWidth.push(segmentWidth);
			}
		} else {
			var labelLengths = new Array();
			var totalLabelsLength = 0;
			var _g = 0;
			while(_g < labels.length) {
				var l = labels[_g];
				++_g;
				labelLengths.push(l.length);
				totalLabelsLength += l.length;
			}
			var _g = 0;
			while(_g < labelLengths.length) {
				var ll = labelLengths[_g];
				++_g;
				var p = ll * 100 / totalLabelsLength;
				this.segmentsWidth.push(Math.round(p * this.size.width / 100));
			}
		}
		var i = 0;
		var _g = 0;
		while(_g < labels.length) {
			var label = labels[_g];
			++_g;
			if(this.items.exists(label)) continue;
			var b = this.constructButton(i);
			b.onClick = (function(f,a1) {
				return function() {
					return f(a1);
				};
			})($bind(this,this.clickHandler),label);
			this.addChild(b);
			b.init();
			this.items.set(label,b);
			this.itemAdded.dispatch(this,null,null,null,{ fileName : "RCSegmentedControl.hx", lineNumber : 92, className : "RCSegmentedControl", methodName : "initWithLabels"});
			i++;
		}
		this.keepButtonsArranged();
	}
	,itemRemoved: null
	,itemAdded: null
	,click: null
	,selectedIndex_: null
	,segmentsWidth: null
	,items: null
	,labels: null
	,skin: null
	,__class__: RCSegmentedControl
	,__properties__: $extend(JSView.prototype.__properties__,{set_selectedIndex:"set_selectedIndex",get_selectedIndex:"get_selectedIndex"})
});
var RCSize = function(w,h) {
	this.width = w == null?0:w;
	this.height = h == null?0:h;
};
$hxClasses["RCSize"] = RCSize;
RCSize.__name__ = ["RCSize"];
RCSize.prototype = {
	toString: function() {
		return "[RCSize width:" + this.width + ", height:" + this.height + "]";
	}
	,copy: function() {
		return new RCSize(this.width,this.height);
	}
	,height: null
	,width: null
	,__class__: RCSize
}
var RCSkin = function(colors) {
	this.normal = { background : null, label : null, image : null, otherView : null, colors : { background : null, label : null, image : null, otherView : null}, scale : 1};
	this.highlighted = { background : null, label : null, image : null, otherView : null, colors : { background : null, label : null, image : null, otherView : null}, scale : 1};
	this.disabled = { background : null, label : null, image : null, otherView : null, colors : { background : null, label : null, image : null, otherView : null}, scale : 1};
	this.selected = { background : null, label : null, image : null, otherView : null, colors : { background : null, label : null, image : null, otherView : null}, scale : 1};
	if(colors != null) {
		this.normal.colors.background = colors[0];
		this.normal.colors.label = colors[1];
		this.highlighted.colors.background = colors[2];
		this.highlighted.colors.label = colors[3];
		this.disabled.colors.background = colors[2];
		this.disabled.colors.label = colors[3];
	}
};
$hxClasses["RCSkin"] = RCSkin;
RCSkin.__name__ = ["RCSkin"];
RCSkin.prototype = {
	destroy: function() {
	}
	,hit: null
	,selected: null
	,disabled: null
	,highlighted: null
	,normal: null
	,__class__: RCSkin
}
var _RCSlider = {}
_RCSlider.Direction = $hxClasses["_RCSlider.Direction"] = { __ename__ : ["_RCSlider","Direction"], __constructs__ : ["HORIZONTAL","VERTICAL"] }
_RCSlider.Direction.HORIZONTAL = ["HORIZONTAL",0];
_RCSlider.Direction.HORIZONTAL.toString = $estr;
_RCSlider.Direction.HORIZONTAL.__enum__ = _RCSlider.Direction;
_RCSlider.Direction.VERTICAL = ["VERTICAL",1];
_RCSlider.Direction.VERTICAL.toString = $estr;
_RCSlider.Direction.VERTICAL.__enum__ = _RCSlider.Direction;
var RCSlider = function(x,y,w,h,skin) {
	this.init_ = false;
	this.moving_ = false;
	this.minValue_ = 0.0;
	this.maxValue_ = 100.0;
	this.value_ = 0.0;
	this.direction_ = w > h?_RCSlider.Direction.HORIZONTAL:_RCSlider.Direction.VERTICAL;
	if(skin == null) skin = new haxe.SKSlider();
	this.skin = skin;
	RCControl.call(this,x,y,w,h);
	this.viewDidAppear.add($bind(this,this.viewDidAppear_));
};
$hxClasses["RCSlider"] = RCSlider;
RCSlider.__name__ = ["RCSlider"];
RCSlider.__super__ = RCControl;
RCSlider.prototype = $extend(RCControl.prototype,{
	destroy: function() {
		this.mouseUpOverStage_.destroy({ fileName : "RCSlider.hx", lineNumber : 217, className : "RCSlider", methodName : "destroy"});
		this.mouseMoveOverStage_.destroy({ fileName : "RCSlider.hx", lineNumber : 218, className : "RCSlider", methodName : "destroy"});
		this.valueChanged.destroy({ fileName : "RCSlider.hx", lineNumber : 219, className : "RCSlider", methodName : "destroy"});
		this.skin.destroy();
		RCControl.prototype.destroy.call(this);
	}
	,set_maximumValueImage: function(v) {
		return v;
	}
	,set_minimumValueImage: function(v) {
		return v;
	}
	,set_maxValue: function(v) {
		this.maxValue_ = v;
		this.set_value(this.value_);
		return v;
	}
	,set_minValue: function(v) {
		this.minValue_ = v;
		this.set_value(this.value_);
		return v;
	}
	,set_value: function(v) {
		this.value_ = v;
		if(!this.init_) return v;
		var x1 = 0.0, x2 = 0.0;
		var _g = this;
		switch( (_g.direction_)[1] ) {
		case 0:
			x2 = this.size.width - this.scrubber.get_width();
			this.scrubber.set_x(Zeta.lineEquationInt(x1,x2,v,this.minValue_,this.maxValue_));
			this.scrubber.set_y(Math.round((this.size.height - this.scrubber.get_height()) / 2));
			this.sliderHighlighted.set_width(this.scrubber.get_x() + this.scrubber.get_width() / 2);
			break;
		case 1:
			x2 = this.size.height - this.scrubber.get_height();
			this.scrubber.set_y(Zeta.lineEquationInt(x1,x2,v,this.minValue_,this.maxValue_));
			this.sliderHighlighted.set_height(this.scrubber.get_y() + this.scrubber.get_height() / 2);
			break;
		}
		this.valueChanged.dispatch(this,null,null,null,{ fileName : "RCSlider.hx", lineNumber : 173, className : "RCSlider", methodName : "set_value"});
		return this.value_;
	}
	,get_value: function() {
		return this.value_;
	}
	,mouseMoveHandler: function(e) {
		var y0 = 0.0, y1 = 0.0, y2 = 0.0;
		var _g = this;
		switch( (_g.direction_)[1] ) {
		case 0:
			y2 = this.size.width - this.scrubber.get_width();
			y0 = Zeta.limitsInt(this.get_mouseX() - this.scrubber.get_width() / 2,0,y2);
			break;
		case 1:
			y2 = this.size.height - this.scrubber.get_height();
			y0 = Zeta.limitsInt(this.get_mouseY() - this.scrubber.get_height() / 2,0,y2);
			break;
		}
		this.set_value(Zeta.lineEquation(this.minValue_,this.maxValue_,y0,y1,y2));
	}
	,mouseUpHandler: function(e) {
		this.moving_ = false;
		this.mouseUpOverStage_.remove($bind(this,this.mouseUpHandler));
		this.mouseMoveOverStage_.remove($bind(this,this.mouseMoveHandler));
	}
	,mouseDownHandler: function(e) {
		this.moving_ = true;
		this.mouseUpOverStage_.add($bind(this,this.mouseUpHandler));
		this.mouseMoveOverStage_.add($bind(this,this.mouseMoveHandler));
		this.mouseMoveHandler(e);
	}
	,set_enabled: function(c) {
		return this.enabled_ = false;
	}
	,configureDispatchers: function() {
		RCControl.prototype.configureDispatchers.call(this);
		this.valueChanged = new RCSignal();
		this.mouseUpOverStage_ = new EVMouse("mouseup",RCWindow.sharedWindow().stage,{ fileName : "RCSlider.hx", lineNumber : 95, className : "RCSlider", methodName : "configureDispatchers"});
		this.mouseMoveOverStage_ = new EVMouse("mousemove",RCWindow.sharedWindow().stage,{ fileName : "RCSlider.hx", lineNumber : 96, className : "RCSlider", methodName : "configureDispatchers"});
	}
	,viewDidAppear_: function() {
		this.sliderNormal = this.skin.normal.background;
		if(this.sliderNormal == null) this.sliderNormal = new JSView(0,0);
		this.sliderNormal.set_width(this.size.width);
		this.sliderHighlighted = this.skin.highlighted.background;
		if(this.sliderHighlighted == null) this.sliderHighlighted = new JSView(0,0);
		this.sliderHighlighted.set_width(this.size.width);
		this.scrubber = this.skin.normal.otherView;
		if(this.scrubber == null) this.scrubber = new JSView(0,0);
		this.scrubber.set_y(Math.round((this.size.height - this.scrubber.get_height()) / 2));
		this.addChild(this.sliderNormal);
		this.addChild(this.sliderHighlighted);
		this.addChild(this.scrubber);
		this.press.add($bind(this,this.mouseDownHandler));
		this.over.add($bind(this,this.rollOverHandler));
		this.out.add($bind(this,this.rollOutHandler));
		this.init_ = true;
		this.set_value(this.value_);
	}
	,valueChanged: null
	,maximumValueImage: null
	,minimumValueImage: null
	,maxValue: null
	,minValue: null
	,scrubber: null
	,sliderHighlighted: null
	,sliderNormal: null
	,skin: null
	,mouseMoveOverStage_: null
	,mouseUpOverStage_: null
	,direction_: null
	,moving_: null
	,maxValue_: null
	,minValue_: null
	,value_: null
	,init_: null
	,__class__: RCSlider
	,__properties__: $extend(RCControl.prototype.__properties__,{set_minValue:"set_minValue",set_maxValue:"set_maxValue",set_value:"set_value",get_value:"get_value",set_minimumValueImage:"set_minimumValueImage",set_maximumValueImage:"set_maximumValueImage"})
});
var _RCSliderSync = {}
_RCSliderSync.Direction = $hxClasses["_RCSliderSync.Direction"] = { __ename__ : ["_RCSliderSync","Direction"], __constructs__ : ["HORIZONTAL","VERTICAL"] }
_RCSliderSync.Direction.HORIZONTAL = ["HORIZONTAL",0];
_RCSliderSync.Direction.HORIZONTAL.toString = $estr;
_RCSliderSync.Direction.HORIZONTAL.__enum__ = _RCSliderSync.Direction;
_RCSliderSync.Direction.VERTICAL = ["VERTICAL",1];
_RCSliderSync.Direction.VERTICAL.toString = $estr;
_RCSliderSync.Direction.VERTICAL.__enum__ = _RCSliderSync.Direction;
_RCSliderSync.DecelerationRate = $hxClasses["_RCSliderSync.DecelerationRate"] = { __ename__ : ["_RCSliderSync","DecelerationRate"], __constructs__ : ["RCScrollViewDecelerationRateNormal","RCScrollViewDecelerationRateFast"] }
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateNormal = ["RCScrollViewDecelerationRateNormal",0];
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateNormal.toString = $estr;
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateNormal.__enum__ = _RCSliderSync.DecelerationRate;
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateFast = ["RCScrollViewDecelerationRateFast",1];
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateFast.toString = $estr;
_RCSliderSync.DecelerationRate.RCScrollViewDecelerationRateFast.__enum__ = _RCSliderSync.DecelerationRate;
var RCSliderSync = function(target,contentView,slider,valueMax,direction) {
	this.target = target;
	this.contentView = contentView;
	this.slider = slider;
	this.direction = direction == "horizontal"?_RCSliderSync.Direction.HORIZONTAL:_RCSliderSync.Direction.VERTICAL;
	this.valueMax_ = Math.round(valueMax);
	this.valueStart_ = Math.round(this.getContentPosition());
	this.valueFinal_ = this.valueStart;
	this.f = 1;
	this.valueChanged = new RCSignal();
	this.ticker = new EVLoop({ fileName : "RCSliderSync.hx", lineNumber : 63, className : "RCSliderSync", methodName : "new"});
	this.mouseWheel = new EVMouse("mousewheel",target,{ fileName : "RCSliderSync.hx", lineNumber : 64, className : "RCSliderSync", methodName : "new"});
	this.resume();
};
$hxClasses["RCSliderSync"] = RCSliderSync;
RCSliderSync.__name__ = ["RCSliderSync"];
RCSliderSync.prototype = {
	destroy: function() {
		this.hold();
		this.valueChanged.destroy({ fileName : "RCSliderSync.hx", lineNumber : 171, className : "RCSliderSync", methodName : "destroy"});
		this.ticker.destroy();
		this.mouseWheel.destroy({ fileName : "RCSliderSync.hx", lineNumber : 173, className : "RCSliderSync", methodName : "destroy"});
	}
	,set_valueStart: function(value) {
		return this.valueStart_ = value;
	}
	,set_valueFinal: function(value) {
		return this.valueFinal_ = value;
	}
	,set_valueMax: function(value) {
		return this.valueMax_ = value;
	}
	,getContentSize: function() {
		return this.direction == _RCSliderSync.Direction.HORIZONTAL?this.contentView.get_width():this.contentView.get_height();
	}
	,getContentPosition: function() {
		return this.direction == _RCSliderSync.Direction.HORIZONTAL?this.contentView.get_x():this.contentView.get_y();
	}
	,moveContentTo: function(next_value) {
		if(this.direction == _RCSliderSync.Direction.HORIZONTAL) this.contentView.set_x(Math.round(next_value)); else this.contentView.set_y(Math.round(next_value));
	}
	,loop: function() {
		var next_value = (this.valueFinal - this.getContentPosition()) / 3;
		if(Math.abs(next_value) < 1) {
			this.ticker.set_run(null);
			this.moveContentTo(this.valueFinal);
		} else this.moveContentTo(this.getContentPosition() + next_value);
		this.valueChanged.dispatch(this,null,null,null,{ fileName : "RCSliderSync.hx", lineNumber : 135, className : "RCSliderSync", methodName : "loop"});
	}
	,startLoop: function() {
		if(this.valueFinal > this.valueStart) this.set_valueFinal(this.valueStart);
		if(this.valueFinal < this.valueStart + this.valueMax - this.getContentSize()) this.set_valueFinal(Math.round(this.valueStart + this.valueMax - this.getContentSize()));
		this.ticker.set_run($bind(this,this.loop));
	}
	,sliderChangedHandler: function(e) {
		this.set_valueFinal(Zeta.lineEquationInt(this.valueStart,this.valueStart + this.valueMax - this.getContentSize(),e.get_value(),0,100));
		this.startLoop();
	}
	,wheelHandler: function(e) {
		var _g = this;
		_g.set_valueFinal(_g.valueFinal + e.delta);
		this.startLoop();
		this.slider.set_value(Zeta.lineEquationInt(0,100,this.valueFinal,this.valueStart,this.valueStart + this.valueMax - this.getContentSize()));
		if(e.delta < 0) this.onScrollRight(); else this.onScrollLeft();
	}
	,resume: function() {
		this.mouseWheel.add($bind(this,this.wheelHandler));
		this.slider.valueChanged.add($bind(this,this.sliderChangedHandler));
	}
	,hold: function() {
		this.mouseWheel.remove($bind(this,this.wheelHandler));
		this.slider.valueChanged.remove($bind(this,this.sliderChangedHandler));
	}
	,onScrollRight: function() {
	}
	,onScrollLeft: function() {
	}
	,contentValueChanged: null
	,valueChanged: null
	,valueFinal: null
	,valueStart: null
	,valueMax: null
	,valueFinal_: null
	,valueStart_: null
	,valueMax_: null
	,mouseWheel: null
	,ticker: null
	,decelerationRate: null
	,f: null
	,direction: null
	,slider: null
	,contentView: null
	,target: null
	,__class__: RCSliderSync
	,__properties__: {set_valueMax:"set_valueMax",set_valueStart:"set_valueStart",set_valueFinal:"set_valueFinal"}
}
var RCStats = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	RCRectangle.call(this,x,y,152,18,16777215,0.9,16);
	this.addChild(new RCRectangle(1,1,150,16,16777215,0.8,16));
	var f = RCFont.systemFontOfSize(12);
	f.color = 0;
	this.txt = new RCTextView(6,3,null,20,"Calculating...",f);
	this.addChild(this.txt);
	this.last = new Date().getTime();
	this.e = new EVLoop({ fileName : "RCStats.hx", lineNumber : 38, className : "RCStats", methodName : "new"});
	this.e.set_run($bind(this,this.loop));
};
$hxClasses["RCStats"] = RCStats;
RCStats.__name__ = ["RCStats"];
RCStats.__super__ = RCRectangle;
RCStats.prototype = $extend(RCRectangle.prototype,{
	destroy: function() {
		this.e.destroy();
		this.txt.removeFromSuperview();
		this.txt.destroy();
		this.e = null;
		this.txt = null;
		RCRectangle.prototype.destroy.call(this);
	}
	,loop: function() {
		this.ticks++;
		this.now = new Date().getTime();
		this.delta = this.now - this.last;
		if(this.delta >= 1000) {
			this.fps = Math.round(this.ticks / this.delta * 1000);
			this.ticks = 0;
			this.last = this.now;
			this.txt.set_text(this.fps + " FPS,  " + this.currMemory + " Mbytes");
		}
	}
	,e: null
	,txt: null
	,currMemory: null
	,fps: null
	,ticks: null
	,delta: null
	,now: null
	,last: null
	,__class__: RCStats
});
var RCStringTools = function() { }
$hxClasses["RCStringTools"] = RCStringTools;
RCStringTools.__name__ = ["RCStringTools"];
RCStringTools.add0 = function(nr) {
	return Std.string((nr >= 10?"":"0") + nr);
}
RCStringTools.formatTime = function(t) {
	var m = Math.floor(t / 60);
	var s = Math.round(t - m * 60);
	return RCStringTools.add0(m) + ":" + RCStringTools.add0(s);
}
RCStringTools.cutString = function(str,limit) {
	var fin = str.length > limit?"...":"";
	return HxOverrides.substr(str,0,limit) + fin;
}
RCStringTools.cutStringAtLine = function(textfield,line) {
	return textfield.get_text();
}
RCStringTools.stringWithFormat = function(str,arr) {
	var str_arr = str.split("%@");
	var str_buf = new StringBuf();
	var _g1 = 0, _g = str_arr.length;
	while(_g1 < _g) {
		var i = _g1++;
		str_buf.b += Std.string(str_arr[i]);
		if(arr[i] != null) str_buf.b += Std.string(arr[i]);
	}
	return str_buf.b;
}
RCStringTools.toTitleCase = function(str) {
	return HxOverrides.substr(str,0,1).toUpperCase() + HxOverrides.substr(str,1,null).toLowerCase();
}
RCStringTools.addSlash = function(str) {
	str = StringTools.trim(str);
	return StringTools.endsWith(str,"/")?str:str + "/";
}
RCStringTools.validateEmail = function(email) {
	return email.indexOf(".") > 0 && email.indexOf("@") > 1;
}
RCStringTools.encodeEmail = function(email,replacement) {
	if(replacement == null) replacement = "[-AT-]";
	return StringTools.replace(email,"@",replacement);
}
RCStringTools.decodeEmail = function(email,replacement) {
	if(replacement == null) replacement = "[-AT-]";
	return StringTools.replace(email,replacement,"@");
}
RCStringTools.parseLinks = function(str) {
	var str_arr = str.split(" ");
	var str_buf = new StringBuf();
	var _g = 0;
	while(_g < str_arr.length) {
		var word = str_arr[_g];
		++_g;
		if(word.indexOf("@") > 1 && word.indexOf(".") > 0 && word.indexOf("mailto:") == -1) str_buf.b += Std.string("<a href='mailto:" + word.toLowerCase() + "' target='_blank'>" + word + "</a>"); else if(word.indexOf("http://") == 0) str_buf.b += Std.string("<a href='" + word.toLowerCase() + "' target='_blank'>" + word + "</a>"); else if(word.indexOf("www.") == 0) str_buf.b += Std.string("<a href='http://" + word.toLowerCase() + "' target='_blank'>" + word + "</a>"); else str_buf.b += Std.string(word);
		str_buf.b += " ";
	}
	return str_buf.b;
}
RCStringTools.removeLinks = function(str) {
	var r1 = new EReg("<b>","g");
	var r2 = new EReg("</b>","g");
	var r3 = new EReg("<a.*?\">","g");
	var r4 = new EReg("</a>","g");
	var s = r1.replace(str,"");
	s = r2.replace(s,"");
	s = r3.replace(s,"");
	s = r4.replace(s,"");
	return s;
}
var RCSwf = function(x,y,URL,newDomain) {
	if(newDomain == null) newDomain = true;
	this.newDomain = newDomain;
	this.id_ = "swf_" + HxOverrides.dateStr(new Date());
	RCImage.call(this,x,y,URL);
};
$hxClasses["RCSwf"] = RCSwf;
RCSwf.__name__ = ["RCSwf"];
RCSwf.__super__ = RCImage;
RCSwf.prototype = $extend(RCImage.prototype,{
	destroy: function() {
		this.removeListeners();
		try {
			this.loader.contentLoaderInfo.content.destroy();
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "RCSwf.hx", lineNumber : 88, className : "RCSwf", methodName : "destroy"});
			var stack = haxe.CallStack.exceptionStack();
			haxe.Log.trace(haxe.CallStack.toString(stack),{ fileName : "RCSwf.hx", lineNumber : 90, className : "RCSwf", methodName : "destroy"});
		}
	}
	,callMethod: function(method,params) {
		return Reflect.field(this.target,method).apply(this.target,params);
	}
	,completeHandler: function(e) {
		haxe.Log.trace(e,{ fileName : "RCSwf.hx", lineNumber : 59, className : "RCSwf", methodName : "completeHandler"});
		this.isLoaded = true;
		this.onComplete();
	}
	,initWithContentsOfFile: function(URL) {
		this.isLoaded = false;
		this.percentLoaded = 0;
		this.layer.id = this.id_;
		this.layer.appendChild(this.layer);
	}
	,id_: null
	,newDomain: null
	,event: null
	,target: null
	,__class__: RCSwf
});
var RCSwitch = function(x,y,w,h) {
	RCControl.call(this,x,y,w,h);
};
$hxClasses["RCSwitch"] = RCSwitch;
RCSwitch.__name__ = ["RCSwitch"];
RCSwitch.__super__ = RCControl;
RCSwitch.prototype = $extend(RCControl.prototype,{
	setOn: function(on,animated) {
		if(animated == null) animated = true;
		this.on = on;
	}
	,on: null
	,__class__: RCSwitch
});
var RCTabBar = function(x,y,w,h,constructor2_) {
	this.constructor2_ = constructor2_;
	this.selectedIndex_ = -1;
	this.didSelectItem = new RCSignal();
	RCGroup.call(this,x,y,2,null,$bind(this,this.constructButton));
	this.size.width = w;
	this.size.height = h;
	this.background = new RCRectangle(0,0,this.size.width,this.size.height,2236962);
	this.background.addChild(new RCRectangle(0,this.size.height / 2,this.size.width,this.size.height / 2,0));
	this.addChild(this.background);
};
$hxClasses["RCTabBar"] = RCTabBar;
RCTabBar.__name__ = ["RCTabBar"];
RCTabBar.__super__ = RCGroup;
RCTabBar.prototype = $extend(RCGroup.prototype,{
	toString: function() {
		return "[RCTabBar selectedIndex:" + this.selectedIndex_ + "]";
	}
	,keepItemsArranged: function() {
		this.gapX = Math.round(this.size.width / this.items.length);
		var _g1 = 0, _g = this.items.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.items[i].set_x(i * this.gapX);
			this.items[i].set_y(2);
		}
		this.update.dispatch(null,null,null,null,{ fileName : "RCTabBar.hx", lineNumber : 79, className : "RCTabBar", methodName : "keepItemsArranged"});
	}
	,disable: function(i) {
		this.items[i].set_enabled(false);
		this.items[i].set_alpha(0.4);
	}
	,enable: function(i) {
		this.items[i].set_enabled(true);
		this.items[i].set_alpha(1);
	}
	,set_selectedIndex: function(i) {
		haxe.Log.trace(this.items,{ fileName : "RCTabBar.hx", lineNumber : 50, className : "RCTabBar", methodName : "set_selectedIndex"});
		if(this.items == null) return this.selectedIndex_;
		haxe.Log.trace("setIndex " + i,{ fileName : "RCTabBar.hx", lineNumber : 52, className : "RCTabBar", methodName : "set_selectedIndex"});
		haxe.Log.trace(this.selectedIndex_,{ fileName : "RCTabBar.hx", lineNumber : 52, className : "RCTabBar", methodName : "set_selectedIndex"});
		if(this.selectedIndex_ > -1) this.items[this.selectedIndex_].untoggle();
		this.selectedIndex_ = i;
		this.items[this.selectedIndex_].toggle();
		return this.selectedIndex_;
	}
	,get_selectedIndex: function() {
		return this.selectedIndex_;
	}
	,clickHandler: function(s) {
		this.selectedItem = s.target;
		this.didSelectItem.dispatch(this.selectedItem,null,null,null,{ fileName : "RCTabBar.hx", lineNumber : 43, className : "RCTabBar", methodName : "clickHandler"});
	}
	,constructButton: function(indexPath) {
		var but = this.constructor2_(indexPath.row);
		but.click.add($bind(this,this.clickHandler));
		return but;
	}
	,background: null
	,selectedIndex_: null
	,constructor2_: null
	,didSelectItem: null
	,selectedItem: null
	,__class__: RCTabBar
	,__properties__: $extend(RCGroup.prototype.__properties__,{set_selectedIndex:"set_selectedIndex",get_selectedIndex:"get_selectedIndex"})
});
var RCTabBarController = function(x,y,w,h,constructor_) {
	JSView.call(this,x,y,w,h);
	this.constructor_ = constructor_ == null?$bind(this,this.constructButton):constructor_;
	this.viewControllers = new Array();
	this.didSelectViewController = new RCSignal();
	this.placeholder = new JSView(0,0);
	this.addChild(this.placeholder);
};
$hxClasses["RCTabBarController"] = RCTabBarController;
RCTabBarController.__name__ = ["RCTabBarController"];
RCTabBarController.__super__ = JSView;
RCTabBarController.prototype = $extend(JSView.prototype,{
	setViewController: function(i,view) {
		if(this.viewControllers[i] == null) this.viewControllers[i] = view;
	}
	,getViewController: function(i) {
		return this.viewControllers[i];
	}
	,disable: function(i) {
		this.tabBar.disable(i);
	}
	,enable: function(i) {
		this.tabBar.enable(i);
	}
	,set_selectedIndex: function(i) {
		haxe.Log.trace("setIndex " + i,{ fileName : "RCTabBarController.hx", lineNumber : 84, className : "RCTabBarController", methodName : "set_selectedIndex"});
		if(this.tabBar.get_selectedIndex() == i) return i;
		this.tabBar.set_selectedIndex(i);
		var view = this.getViewController(i);
		if(view == null) try {
			view = Type.createInstance(this.controllers[i],[]);
			this.setViewController(i,view);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "RCTabBarController.hx", lineNumber : 94, className : "RCTabBarController", methodName : "set_selectedIndex"});
			Fugu.stack();
		}
		Fugu.safeRemove(this.viewControllers);
		this.placeholder.addChild(view);
		this.didSelectViewController.dispatch(view,null,null,null,{ fileName : "RCTabBarController.hx", lineNumber : 98, className : "RCTabBarController", methodName : "set_selectedIndex"});
		return i;
	}
	,get_selectedIndex: function() {
		return this.tabBar.get_selectedIndex();
	}
	,didSelectItemHandler: function(item) {
		var i = 0;
		var _g = 0, _g1 = this.tabBar.items;
		while(_g < _g1.length) {
			var it = _g1[_g];
			++_g;
			if(it == item) break;
			i++;
		}
		this.set_selectedIndex(i);
	}
	,constructButton: function(i) {
		var s = new ios.SKTabBarItem(this.labels[i],this.symbols[i]);
		var b = new RCTabBarItem(0,0,s);
		return b;
	}
	,initWithLabels: function(labels,symbols,controllers) {
		this.labels = labels;
		this.symbols = symbols;
		this.controllers = controllers;
		this.tabBar = new RCTabBar(0,this.size.height - 50,this.size.width,50,this.constructor_);
		this.addChild(this.tabBar);
		this.tabBar.add(labels);
		this.tabBar.didSelectItem.add($bind(this,this.didSelectItemHandler));
	}
	,didSelectViewController: null
	,viewControllers: null
	,tabBar: null
	,placeholder: null
	,constructor_: null
	,controllers: null
	,symbols: null
	,labels: null
	,__class__: RCTabBarController
	,__properties__: $extend(JSView.prototype.__properties__,{set_selectedIndex:"set_selectedIndex",get_selectedIndex:"get_selectedIndex"})
});
var RCTabBarItem = function(x,y,skin) {
	RCButtonRadio.call(this,x,y,skin);
};
$hxClasses["RCTabBarItem"] = RCTabBarItem;
RCTabBarItem.__name__ = ["RCTabBarItem"];
RCTabBarItem.__super__ = RCButtonRadio;
RCTabBarItem.prototype = $extend(RCButtonRadio.prototype,{
	toString: function() {
		return "[RCTabBarItem ]";
	}
	,set_badgeValue: function(value) {
		this.badgeValue = value;
		return value;
	}
	,_unselectedImage: null
	,_selectedImage: null
	,_image: null
	,_title: null
	,badgeValue: null
	,__class__: RCTabBarItem
	,__properties__: $extend(RCButtonRadio.prototype.__properties__,{set_badgeValue:"set_badgeValue"})
});
var RCTableView = function(x,y,w,h,cellForRowAtIndexPath,numberOfRowsInSection) {
	JSView.call(this,x,y,w,h);
	this.cellForRowAtIndexPath = cellForRowAtIndexPath;
	this.numberOfRowsInSection = numberOfRowsInSection;
	this.indexPath = new RCIndexPath(0,0);
	this.inertia = 0.95;
	this.dragging = false;
	this.vy = 0;
	this.oldY = 0;
	this.cell_min_h = Math.POSITIVE_INFINITY;
	this.backgroundView = new JSView(0,0,w,h);
	this.addChild(this.backgroundView);
	this.contentView = new JSView(1,1,w - 2,h - 2);
	this.addChild(this.contentView);
	this.contentView.set_clipsToBounds(true);
	this.scrollView = new JSView(0,0);
	this.contentView.addChild(this.scrollView);
	this.scrollIndicator = new RCRectangle(w - 10,1,6,50,16777215,.6,6);
	this.scrollIndicator.set_alpha(0);
	this.addChild(this.scrollIndicator);
	this.cells = [];
	this.mousePress_ = new EVMouse("mousedown",this.scrollView,{ fileName : "RCTableView.hx", lineNumber : 72, className : "RCTableView", methodName : "new"});
	this.mouseMove_ = new EVMouse("mousemove",this,{ fileName : "RCTableView.hx", lineNumber : 73, className : "RCTableView", methodName : "new"});
	this.mouseUp_ = new EVMouse("mouseup",RCWindow.sharedWindow().stage,{ fileName : "RCTableView.hx", lineNumber : 74, className : "RCTableView", methodName : "new"});
};
$hxClasses["RCTableView"] = RCTableView;
RCTableView.__name__ = ["RCTableView"];
RCTableView.__super__ = JSView;
RCTableView.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.stopLoop();
		Fugu.safeDestroy(this.cells,null,{ fileName : "RCTableView.hx", lineNumber : 241, className : "RCTableView", methodName : "destroy"});
		Fugu.safeDestroy([this.backgroundView,this.contentView,this.scrollIndicator,this.mousePress_,this.mouseMove_,this.mouseUp_],null,{ fileName : "RCTableView.hx", lineNumber : 242, className : "RCTableView", methodName : "destroy"});
		this.cells = null;
		this.backgroundView = null;
		this.contentView = null;
		this.scrollIndicator = null;
		this.mousePress_ = null;
		this.mouseMove_ = null;
		this.mouseUp_ = null;
		JSView.prototype.destroy.call(this);
	}
	,loop: function() {
		this.scrollIndicator.set_alpha(1);
		this.scrollView.set_y(Math.round(this.scrollView.get_y() + this.vy));
		if(this.cells[0].get_y() + this.scrollView.get_y() > 1) {
			if(this.cells[0].indexPath.row > 0) {
				var cell = this.cells.pop();
				this.cells.unshift(cell);
				cell.indexPath.row = this.cells[1].indexPath.row - 1;
				this.indexPath = cell.indexPath;
				this.cells[0].set_y(Math.round(this.cells[1].get_y() - this.cells[0].get_height()));
				cell = this.cellForRowAtIndexPath(cell.indexPath,cell);
			} else if(!this.dragging) this.vy *= -0.5;
		} else if(this.cells[0].get_y() + this.scrollView.get_y() < -this.cells[0].get_height() - 1) {
			if(this.indexPath.row < this.numberOfRowsInSection(0) - 1) {
				var cell = this.cells.shift();
				this.cells.push(cell);
				cell.indexPath.row = this.cells[this.cells.length - 2].indexPath.row + 1;
				cell = this.cellForRowAtIndexPath(cell.indexPath,cell);
				cell.set_y(Math.round(this.cells[this.cells.length - 2].get_y() + this.cells[this.cells.length - 2].get_height()));
				this.indexPath = cell.indexPath;
				this.loop();
			} else if(!this.dragging) this.vy *= -0.5;
		}
		this.vy *= this.inertia;
		if(!this.dragging && Math.abs(this.vy) < 1) {
			this.stopLoop();
			this.scrollIndicator.set_alpha(0);
		}
		this.scrollIndicator.set_y(Zeta.lineEquationInt(0,this.size.height - this.scrollIndicator.get_height(),this.indexPath.row,0,this.numberOfRowsInSection(0)));
	}
	,stopLoop: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
	}
	,startLoop: function() {
		if(this.timer == null) {
			this.timer = new haxe.Timer(10);
			this.timer.run = $bind(this,this.loop);
		}
	}
	,mouseWheel: function(delta) {
		this.vy = delta;
		if(this.vy > this.cell_min_h) this.vy = this.cell_min_h;
		if(this.vy < -this.cell_min_h) this.vy = -this.cell_min_h;
		this.startLoop();
	}
	,mouseMoveHandler: function(e) {
		if(this.dragging) {
			this.vy = this.get_mouseY() - this.oldY;
			this.oldY = this.get_mouseY();
			if(this.vy > this.cell_min_h) this.vy = this.cell_min_h;
			if(this.vy < -this.cell_min_h) this.vy = -this.cell_min_h;
			if(this.scrollView.get_y() > 0) this.vy = this.vy * 0.24; else if(this.scrollView.get_y() < this.size.height - this.numberOfRowsInSection(0) * this.cell_min_h) {
				this.scrollView.set_y(this.size.height - this.numberOfRowsInSection(0) * this.cell_min_h);
				this.vy = 0;
			}
		}
	}
	,stopDragCells: function(e) {
		this.dragging = false;
		this.mouseMove_.enabled = false;
		this.mouseUp_.enabled = false;
		haxe.Log.trace("stop scrollView " + this.scrollView.get_y(),{ fileName : "RCTableView.hx", lineNumber : 131, className : "RCTableView", methodName : "stopDragCells"});
		if(this.scrollView.get_y() > 0) {
			this.anim = new CATween(this.scrollView,{ y : 0},0.5,0,eq.Cubic.OUT,{ fileName : "RCTableView.hx", lineNumber : 134, className : "RCTableView", methodName : "stopDragCells"});
			RCAnimation.add(this.anim);
			this.vy = 0;
			this.stopLoop();
		}
	}
	,startDragCells: function(e) {
		this.dragging = true;
		this.mouseMove_.enabled = true;
		this.mouseUp_.enabled = true;
		this.oldY = this.get_mouseY();
		this.vy = 0;
		this.startLoop();
	}
	,scrollToRowAtIndexPath: function(indexPath,cellPosition) {
		if(cellPosition == null) cellPosition = 0;
	}
	,reloadData: function() {
		var _g = 0, _g1 = this.cells;
		while(_g < _g1.length) {
			var cell = _g1[_g];
			++_g;
			this.cellForRowAtIndexPath(cell.indexPath,cell);
		}
	}
	,init: function() {
		var max_h = 0.0, i = 0, rows = this.numberOfRowsInSection(0);
		while(max_h < this.size.height && i < rows) {
			var cell = this.cellForRowAtIndexPath(new RCIndexPath(0,i),null);
			cell.indexPath = new RCIndexPath(0,i);
			cell.set_y(max_h);
			this.cells.push(cell);
			this.scrollView.addChild(cell);
			max_h += cell.get_height();
			if(cell.get_height() < this.cell_min_h) this.cell_min_h = cell.get_height();
			i++;
		}
		this.mousePress_.add($bind(this,this.startDragCells));
		this.mouseMove_.add($bind(this,this.mouseMoveHandler));
		this.mouseUp_.add($bind(this,this.stopDragCells));
		this.mouseMove_.enabled = false;
		this.mouseUp_.enabled = false;
	}
	,cell_min_h: null
	,mouseUp_: null
	,mouseMove_: null
	,mousePress_: null
	,timer: null
	,changeOrder: null
	,inertia: null
	,dragging: null
	,oldY: null
	,vy: null
	,numberOfRowsInSection: null
	,cellForRowAtIndexPath: null
	,cells: null
	,anim: null
	,indexPath: null
	,scrollIndicator: null
	,scrollView: null
	,contentView: null
	,backgroundView: null
	,__class__: RCTableView
});
var RCTableViewCell = function(w,h) {
	RCControl.call(this,0,0,w,h);
	this.init();
	this.setup();
};
$hxClasses["RCTableViewCell"] = RCTableViewCell;
RCTableViewCell.__name__ = ["RCTableViewCell"];
RCTableViewCell.__super__ = RCControl;
RCTableViewCell.prototype = $extend(RCControl.prototype,{
	toString: function() {
		return "[RCTableViewCell indexPath=" + Std.string(this.indexPath) + "]";
	}
	,destroy: function() {
		Fugu.safeDestroy([this.backgroundView,this.separatorView,this.titleView],null,{ fileName : "RCTableViewCell.hx", lineNumber : 55, className : "RCTableViewCell", methodName : "destroy"});
		this.backgroundView = null;
		this.separatorView = null;
		this.titleView = null;
		RCControl.prototype.destroy.call(this);
	}
	,rollOutHandler: function(e) {
		if(this.backgroundView != null) {
			this.backgroundView.color.fillColor = 16777215;
			this.backgroundView.redraw();
		}
		RCControl.prototype.rollOutHandler.call(this,e);
	}
	,rollOverHandler: function(e) {
		if(this.backgroundView != null) {
			this.backgroundView.color.fillColor = 5737675;
			this.backgroundView.redraw();
		}
		RCControl.prototype.rollOverHandler.call(this,e);
	}
	,setup: function() {
		this.backgroundView = new RCRectangle(0,0,this.size.width,this.size.height - 1,16777215,1);
		this.addChild(this.backgroundView);
		this.separatorView = new RCRectangle(0,this.size.height - 1,this.size.width,1,10066329);
		this.addChild(this.separatorView);
		this.titleView = new RCTextView(10,6,null,null," ",RCFont.systemFontOfSize(12));
		this.titleView.set_y(Math.round((this.size.height - this.titleView.get_height()) / 2));
		this.addChild(this.titleView);
	}
	,titleView: null
	,separatorView: null
	,backgroundView: null
	,indexPath: null
	,__class__: RCTableViewCell
});
var RCTableViewInterface = function() { }
$hxClasses["RCTableViewInterface"] = RCTableViewInterface;
RCTableViewInterface.__name__ = ["RCTableViewInterface"];
RCTableViewInterface.prototype = {
	didSelectRowAtIndexPath: null
	,numberOfRowsInSection: null
	,dataForCell: null
	,cellForRowAtIndexPath: null
	,__class__: RCTableViewInterface
}
var RCTextInput = function(x,y,w,h,str,rcfont) {
	RCControl.call(this,w,y,w,h);
	this.textView = new RCTextView(x,y,w,h,str,rcfont);
	this.addChild(this.textView);
	this.textView.target.layer.contentEditable = "true";
};
$hxClasses["RCTextInput"] = RCTextInput;
RCTextInput.__name__ = ["RCTextInput"];
RCTextInput.__super__ = RCControl;
RCTextInput.prototype = $extend(RCControl.prototype,{
	destroy: function() {
		this.editingDidBegin.destroy({ fileName : "RCTextInput.hx", lineNumber : 138, className : "RCTextInput", methodName : "destroy"});
		this.editingChanged.destroy({ fileName : "RCTextInput.hx", lineNumber : 139, className : "RCTextInput", methodName : "destroy"});
		this.editingDidEnd.destroy({ fileName : "RCTextInput.hx", lineNumber : 140, className : "RCTextInput", methodName : "destroy"});
		this.editingDidEndOnExit.destroy({ fileName : "RCTextInput.hx", lineNumber : 141, className : "RCTextInput", methodName : "destroy"});
		RCControl.prototype.destroy.call(this);
	}
	,set_selectable: function(t) {
		return t;
	}
	,set_password: function(t) {
		return true;
	}
	,clickHandler: function(e) {
		this.editingDidBegin.dispatch(this,null,null,null,{ fileName : "RCTextInput.hx", lineNumber : 94, className : "RCTextInput", methodName : "clickHandler"});
		RCControl.prototype.clickHandler.call(this,e);
	}
	,set_enabled: function(c) {
		RCControl.prototype.set_enabled.call(this,c);
		return c;
	}
	,configureDispatchers: function() {
		RCControl.prototype.configureDispatchers.call(this);
		this.editingDidBegin = new RCSignal();
		this.editingChanged = new RCSignal();
		this.editingDidEnd = new RCSignal();
		this.editingDidEndOnExit = new RCSignal();
	}
	,set_text: function(str) {
		this.textView.set_text(str);
		return str;
	}
	,get_text: function() {
		return this.textView.get_text();
	}
	,textView: null
	,selectable: null
	,password: null
	,__class__: RCTextInput
	,__properties__: $extend(RCControl.prototype.__properties__,{set_password:"set_password",set_selectable:"set_selectable",set_text:"set_text",get_text:"get_text"})
});
var RCTextRoll = function(x,y,w,h,str,properties) {
	JSView.call(this,x,y,w,h);
	this.continuous = true;
	this.txt1 = new RCTextView(0,0,null,h,str,properties);
	this.addChild(this.txt1);
	this.viewDidAppear.add($bind(this,this.viewDidAppear_));
};
$hxClasses["RCTextRoll"] = RCTextRoll;
RCTextRoll.__name__ = ["RCTextRoll"];
RCTextRoll.__super__ = JSView;
RCTextRoll.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.stop();
		JSView.prototype.destroy.call(this);
	}
	,reset: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
		this.txt1.set_x(0);
		this.txt2.set_x(Math.round(this.txt1.get_width() + 20));
	}
	,loop: function() {
		var _g = this.txt1, _g1 = _g.get_x();
		_g.set_x(_g1 - 1);
		_g1;
		var _g = this.txt2, _g1 = _g.get_x();
		_g.set_x(_g1 - 1);
		_g1;
		if(!this.continuous && this.txt2.get_x() <= 0) {
			this.stop();
			this.timer = haxe.Timer.delay($bind(this,this.startRolling),3000);
		}
		if(this.txt1.get_x() < -this.txt1.get_contentSize().width) this.txt1.set_x(Math.round(this.txt2.get_x() + this.txt2.get_contentSize().width + 20));
		if(this.txt2.get_x() < -this.txt2.get_contentSize().width) this.txt2.set_x(Math.round(this.txt1.get_x() + this.txt1.get_contentSize().width + 20));
	}
	,startRolling: function() {
		this.stopRolling({ fileName : "RCTextRoll.hx", lineNumber : 81, className : "RCTextRoll", methodName : "startRolling"});
		this.timerLoop = new haxe.Timer(20);
		this.timerLoop.run = $bind(this,this.loop);
	}
	,stopRolling: function(pos) {
		if(this.timerLoop != null) this.timerLoop.stop();
		this.timerLoop = null;
	}
	,stop: function() {
		if(this.txt2 == null) return;
		this.stopRolling({ fileName : "RCTextRoll.hx", lineNumber : 71, className : "RCTextRoll", methodName : "stop"});
		this.reset();
	}
	,start: function() {
		if(this.txt2 == null) return;
		if(this.continuous) this.startRolling(); else this.timer = haxe.Timer.delay($bind(this,this.startRolling),3000);
	}
	,set_text: function(str) {
		return str;
	}
	,get_text: function() {
		return this.txt1.get_text();
	}
	,viewDidAppear_: function() {
		this.size.height = this.txt1.get_contentSize().height;
		if(this.txt1.get_contentSize().width > this.size.width) {
			if(this.txt2 != null) return;
			this.txt2 = new RCTextView(Math.round(this.txt1.get_contentSize().width + 20),0,null,null,this.get_text(),this.txt1.rcfont);
			this.addChild(this.txt2);
			this.set_clipsToBounds(true);
		}
	}
	,continuous: null
	,timerLoop: null
	,timer: null
	,txt2: null
	,txt1: null
	,__class__: RCTextRoll
	,__properties__: $extend(JSView.prototype.__properties__,{set_text:"set_text",get_text:"get_text"})
});
var RCTextView = function(x,y,w,h,str,rcfont) {
	JSView.call(this,Math.round(x),Math.round(y),w,h);
	this.rcfont = rcfont.copy();
	this.set_width(this.size.width);
	this.set_height(this.size.height);
	this.viewDidAppear.add($bind(this,this.viewDidAppear_));
	this.init();
	this.set_text(str);
};
$hxClasses["RCTextView"] = RCTextView;
RCTextView.__name__ = ["RCTextView"];
RCTextView.__super__ = JSView;
RCTextView.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.target = null;
		this.rcfont = null;
		JSView.prototype.destroy.call(this);
	}
	,set_text: function(str) {
		if(this.rcfont.html) this.layer.innerHTML = str; else this.layer.innerHTML = str;
		this.size.width = this.contentSize_.width;
		return str;
	}
	,get_text: function() {
		return this.layer.innerHTML;
	}
	,viewDidAppear_: function() {
		this.size.width = this.contentSize_.width;
	}
	,redraw: function() {
		var wrap = this.size.width != 0;
		var multiline = this.size.height != 0;
		this.layer.style.whiteSpace = wrap?"normal":"nowrap";
		this.layer.style.wordWrap = wrap?"break-word":"normal";
		var style = this.rcfont.selectable?"text":"none";
		this.layer.style.WebkitUserSelect = style;
		this.layer.style.MozUserSelect = style;
		this.layer.style.lineHeight = this.rcfont.leading + this.rcfont.size + "px";
		this.layer.style.fontFamily = this.rcfont.font;
		this.layer.style.fontSize = this.rcfont.size + "px";
		this.layer.style.fontWeight = this.rcfont.bold?"bold":"normal";
		this.layer.style.fontStyle = this.rcfont.italic?"italic":"normal";
		this.layer.style.letterSpacing = this.rcfont.letterSpacing + "px";
		this.layer.style.textAlign = this.rcfont.align;
		this.layer.style.color = RCColor.HEXtoString(this.rcfont.color);
		this.layer.style.contentEditable = "true";
		if(this.rcfont.autoSize) {
			this.layer.style.width = multiline?this.size.width + "px":"auto";
			this.layer.style.height = "auto";
		} else {
			this.layer.style.width = this.size.width + "px";
			this.layer.style.height = this.size.height + "px";
		}
		if(this.size.width != 0) this.set_width(this.size.width);
	}
	,init: function() {
		JSView.prototype.init.call(this);
		this.redraw();
	}
	,rcfont: null
	,target: null
	,__class__: RCTextView
	,__properties__: $extend(JSView.prototype.__properties__,{set_text:"set_text",get_text:"get_text"})
});
var RCTextureAtlas = function(texture,atlas) {
	this._textures = new haxe.ds.StringMap();
	this._texture = texture;
	if(atlas.indexOf("{\"frames\":") == 0) this.parseJSON(atlas); else this.parse(Xml.parse(atlas));
};
$hxClasses["RCTextureAtlas"] = RCTextureAtlas;
RCTextureAtlas.__name__ = ["RCTextureAtlas"];
RCTextureAtlas.textures = null;
RCTextureAtlas.set = function(key,texture) {
	if(RCTextureAtlas.textures == null) RCTextureAtlas.textures = new haxe.ds.StringMap();
	RCTextureAtlas.textures.set(key,texture);
}
RCTextureAtlas.get = function(key) {
	if(RCTextureAtlas.textures == null) return null;
	return RCTextureAtlas.textures.get(key);
}
RCTextureAtlas.prototype = {
	destroy: function() {
		this._texture.destroy();
		this._texture = null;
		this._textures = null;
	}
	,imagesWithPrefix: function(prefix) {
		if(prefix == null) prefix = "";
		var textures = new Array();
		var names = new Array();
		var $it0 = this._textures.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			if(name.indexOf(prefix) == 0) names.push(name);
		}
		Zeta.sort(names,"ascending");
		var _g = 0;
		while(_g < names.length) {
			var name = names[_g];
			++_g;
			textures.push(this.imageNamed(name,{ fileName : "RCTextureAtlas.hx", lineNumber : 181, className : "RCTextureAtlas", methodName : "imagesWithPrefix"}));
		}
		return textures;
	}
	,imageNamed: function(name,pos) {
		if(!this._textures.exists(name)) name = name + ".png";
		var texture_data = this._textures.get(name);
		if(texture_data != null) return RCImage.imageWithRegionOfImage(this._texture,texture_data.sourceSize,texture_data.frame,texture_data.sourceColorRect);
		haxe.Log.trace("err: imageNamed '" + name + "' does not exist in the texture. Called from " + Std.string(pos),{ fileName : "RCTextureAtlas.hx", lineNumber : 164, className : "RCTextureAtlas", methodName : "imageNamed"});
		return null;
	}
	,parseJSON: function(json) {
	}
	,parseXml: function(xml) {
		var scale = 1;
		var frame_data = null;
		var x;
		var y;
		var width;
		var height;
		var frameX;
		var frameY;
		var frameWidth;
		var frameHeight;
		var $it0 = xml.elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			x = Std.parseFloat(element.get("x")) / scale;
			y = Std.parseFloat(element.get("y")) / scale;
			width = Std.parseFloat(element.get("width")) / scale;
			height = Std.parseFloat(element.get("height")) / scale;
			frameX = Std.parseFloat(element.get("frameX")) / scale;
			frameY = Std.parseFloat(element.get("frameY")) / scale;
			frameWidth = Std.parseFloat(element.get("frameWidth")) / scale;
			frameHeight = Std.parseFloat(element.get("frameHeight")) / scale;
			frame_data = { frame : new RCRect(x,y,width,height), offset : null, rotated : false, sourceColorRect : new RCRect(-frameX,-frameY,width,height), sourceSize : new RCSize(frameWidth,frameHeight)};
			this._textures.set(element.get("name"),frame_data);
		}
	}
	,parsePlist: function(xmlPlist) {
		var key_type = null;
		var $it0 = xmlPlist.firstElement().elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(element.get_nodeName() == "key") key_type = element.firstChild().get_nodeValue(); else if(element.get_nodeName() == "dict") switch(key_type) {
			case "frames":
				var frame_name = null;
				var frame_data = null;
				var $it1 = element.elements();
				while( $it1.hasNext() ) {
					var element2 = $it1.next();
					var _g = element2.get_nodeName();
					switch(_g) {
					case "key":
						frame_name = element2.firstChild().get_nodeValue();
						frame_data = { frame : null, offset : null, rotated : false, sourceColorRect : null, sourceSize : null};
						break;
					case "dict":
						var current_key = null;
						var $it2 = element2.elements();
						while( $it2.hasNext() ) {
							var element3 = $it2.next();
							var _g1 = element3.get_nodeName();
							switch(_g1) {
							case "key":
								current_key = element3.firstChild().get_nodeValue();
								break;
							case "string":
								var current_value = null;
								var arr = element3.firstChild().get_nodeValue().split("{").join("").split("}").join("").split(",");
								switch(current_key) {
								case "frame":case "sourceColorRect":
									current_value = new RCRect(Std.parseFloat(arr[0]),Std.parseFloat(arr[1]),Std.parseFloat(arr[2]),Std.parseFloat(arr[3]));
									break;
								case "offset":
									current_value = new RCPoint(Std.parseFloat(arr[0]),Std.parseFloat(arr[1]));
									break;
								case "sourceSize":
									current_value = new RCSize(Std.parseFloat(arr[0]),Std.parseFloat(arr[1]));
									break;
								}
								frame_data[current_key] = current_value;
								break;
							case "false":
								frame_data[current_key] = "false";
								break;
							case "true":
								frame_data[current_key] = "true";
								break;
							default:
								haxe.Log.trace("Unmatched value type",{ fileName : "RCTextureAtlas.hx", lineNumber : 91, className : "RCTextureAtlas", methodName : "parsePlist"});
							}
						}
						this._textures.set(frame_name,frame_data);
						break;
					}
				}
				break;
			case "metadata":
				break;
			}
		}
	}
	,parse: function(xml) {
		var _g = xml.firstElement().get_nodeName();
		switch(_g) {
		case "plist":
			this.parsePlist(xml.firstElement());
			break;
		case "TextureAtlas":
			this.parseXml(xml.firstElement());
			break;
		}
	}
	,_textures: null
	,_texture: null
	,__class__: RCTextureAtlas
}
var RCToolTip = function(skin) {
	JSView.call(this,0,0);
	this.skin = skin;
};
$hxClasses["RCToolTip"] = RCToolTip;
RCToolTip.__name__ = ["RCToolTip"];
RCToolTip.__super__ = JSView;
RCToolTip.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.stopFollow();
		JSView.prototype.destroy.call(this);
	}
	,dragHandler: function(e) {
		if(this.target == null) return;
		this.set_x(this.target.mouseX);
		this.set_y(this.target.mouseY);
	}
	,stopFollow: function() {
		this.targetMoveSignal.destroy({ fileName : "RCToolTip.hx", lineNumber : 29, className : "RCToolTip", methodName : "stopFollow"});
	}
	,followMouse: function(parent) {
		if(parent == null) return;
		this.target = parent;
		this.targetMoveSignal = new EVMouse("mousemove",this.target,{ fileName : "RCToolTip.hx", lineNumber : 24, className : "RCToolTip", methodName : "followMouse"});
		this.targetMoveSignal.add($bind(this,this.dragHandler));
	}
	,targetMoveSignal: null
	,target: null
	,skin: null
	,__class__: RCToolTip
});
var SharedObject = function(identifier) {
	this.identifier = identifier;
	this.data = { };
	var $it0 = js.Cookie.all().keys();
	while( $it0.hasNext() ) {
		var key = $it0.next();
		if(key.indexOf(identifier) == 0) this.data[HxOverrides.substr(key,identifier.length,null)] = haxe.Unserializer.run(js.Cookie.get(key));
	}
};
$hxClasses["SharedObject"] = SharedObject;
SharedObject.__name__ = ["SharedObject"];
SharedObject.getLocal = function(identifier) {
	var so = new SharedObject(identifier);
	return so;
}
SharedObject.prototype = {
	flush: function() {
		var _g = 0, _g1 = Reflect.fields(this.data);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			var value = Reflect.field(this.data,key);
			if(value != null) js.Cookie.set(this.identifier + key,haxe.Serializer.run(value),31536000); else js.Cookie.remove(this.identifier + key);
		}
	}
	,data: null
	,identifier: null
	,__class__: SharedObject
}
var RCUserDefaults = function() { }
$hxClasses["RCUserDefaults"] = RCUserDefaults;
RCUserDefaults.__name__ = ["RCUserDefaults"];
RCUserDefaults.sharedObject = null;
RCUserDefaults.init = function(identifier) {
	if(identifier == null) identifier = "com.ralcr";
	if(RCUserDefaults.sharedObject == null) RCUserDefaults.sharedObject = SharedObject.getLocal(identifier);
}
RCUserDefaults.objectForKey = function(key) {
	RCUserDefaults.init();
	return Reflect.field(RCUserDefaults.sharedObject.data,key);
}
RCUserDefaults.arrayForKey = function(key) {
	return RCUserDefaults.objectForKey(key);
}
RCUserDefaults.boolForKey = function(key) {
	return RCUserDefaults.objectForKey(key) == true;
}
RCUserDefaults.stringForKey = function(key) {
	return RCUserDefaults.objectForKey(key);
}
RCUserDefaults.intForKey = function(key) {
	return RCUserDefaults.objectForKey(key);
}
RCUserDefaults.floatForKey = function(key) {
	return RCUserDefaults.objectForKey(key);
}
RCUserDefaults.set = function(key,value) {
	RCUserDefaults.init();
	try {
		RCUserDefaults.sharedObject.data[key] = value;
		RCUserDefaults.sharedObject.flush();
	} catch( e ) {
		haxe.Log.trace("Error setting a SharedObject {" + Std.string(e) + "}",{ fileName : "RCUserDefaults.hx", lineNumber : 94, className : "RCUserDefaults", methodName : "set"});
	}
	return value;
}
RCUserDefaults.removeObjectForKey = function(key) {
	RCUserDefaults.set(key,null);
}
RCUserDefaults.removeAllObjects = function() {
	var _g = 0, _g1 = Reflect.fields(RCUserDefaults.sharedObject.data);
	while(_g < _g1.length) {
		var key = _g1[_g];
		++_g;
		Reflect.deleteField(RCUserDefaults.sharedObject.data,key);
	}
	RCUserDefaults.sharedObject.flush();
}
var RCVector = function(x,y,z) {
	if(z == null) z = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
	this.z = z;
};
$hxClasses["RCVector"] = RCVector;
RCVector.__name__ = ["RCVector"];
RCVector.lerp = function(from,to,amount) {
	return new RCVector();
}
RCVector.addVectors = function(v1,v2,target) {
	if(target == null) return new RCVector(v1.x + v2.x,v1.y + v2.y,v1.z + v2.z);
	target.copyXYZ(v1.x + v2.x,v1.y + v2.y,v1.z + v2.z);
	return target;
}
RCVector.subTo = function(v1,v2,target) {
	if(target == null) return new RCVector(v1.x - v2.x,v1.y - v2.y,v1.z - v2.z);
	target.copyXYZ(v1.x - v2.x,v1.y - v2.y,v1.z - v2.z);
	return target;
}
RCVector.multTo = function(v,n,target) {
	if(target == null) return new RCVector(v.x * n,v.y * n,v.z * n);
	target.copyXYZ(v.x * n,v.y * n,v.z * n);
	return target;
}
RCVector.multVecTo = function(v1,v2,target) {
	if(target == null) return target = new RCVector(v1.x * v2.x,v1.y * v2.y,v1.z * v2.z);
	target.copyXYZ(v1.x * v2.x,v1.y * v2.y,v1.z * v2.z);
	return target;
}
RCVector.div_ = function(v,n) {
	return RCVector.divTo(v,n,null);
}
RCVector.divTo = function(v,n,target) {
	if(target == null) return new RCVector(v.x / n,v.y / n,v.z / n);
	target.copyXYZ(v.x / n,v.y / n,v.z / n);
	return target;
}
RCVector.divVecTo = function(v1,v2,target) {
	if(target == null) return new RCVector(v1.x / v2.x,v1.y / v2.y,v1.z / v2.z);
	target.copyXYZ(v1.x / v2.x,v1.y / v2.y,v1.z / v2.z);
	return target;
}
RCVector.distanceBetween = function(v1,v2) {
	var dx = v1.x - v2.x;
	var dy = v1.y - v2.y;
	var dz = v1.z - v2.z;
	return Math.sqrt(dx * dx + dy * dy + dz * dz);
}
RCVector.dotVec_ = function(v1,v2) {
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}
RCVector.cross_ = function(v1,v2,target) {
	var crossX = v1.y * v2.z - v2.y * v1.z;
	var crossY = v1.z * v2.x - v2.z * v1.x;
	var crossZ = v1.x * v2.y - v2.x * v1.y;
	if(target == null) return new RCVector(crossX,crossY,crossZ);
	target.copyXYZ(crossX,crossY,crossZ);
	return target;
}
RCVector.angleBetween = function(v1,v2) {
	var dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
	var v1mag = Math.sqrt(v1.x * v1.x + v1.y * v1.y + v1.z * v1.z);
	var v2mag = Math.sqrt(v2.x * v2.x + v2.y * v2.y + v2.z * v2.z);
	var amt = dot / (v1mag * v2mag);
	if(amt <= -1) return Math.PI; else if(amt >= 1) return 0;
	return Math.acos(amt);
}
RCVector.random = function(from,to) {
	if(from >= to) return from;
	var diff = to - from;
	return Math.random() * diff + from;
}
RCVector.prototype = {
	toArray: function(array) {
		if(array == null) array = [];
		array[0] = this.x;
		array[1] = this.y;
		array[2] = this.z;
		return array;
	}
	,toString: function() {
		return "[RCVector x:" + this.x + ", y:" + this.y + ", z:" + this.z + "]";
	}
	,cloneToArray: function(target) {
		if(target == null) return [this.x,this.y,this.z];
		if(target.length >= 2) {
			target[0] = this.x;
			target[1] = this.y;
		}
		if(target.length >= 3) target[2] = this.z;
		return target;
	}
	,clone: function() {
		return new RCVector(this.x,this.y,this.z);
	}
	,getArea: function(v1,v2) {
		return Math.abs(0.5 * (v1.x * v2.y + v2.x * this.y + this.x * v1.y - v2.x * v1.y - this.x * v2.y - v1.x * this.y));
	}
	,distanceToLine: function(v1,v2) {
		if(v1.x == v2.x && v1.y == v2.y && v1.z == v2.z) return this.distanceToVector(v1);
		return Math.abs(0.5 * (v1.x * v2.y + v2.x * this.y + this.x * v1.y - v2.x * v1.y - this.x * v2.y - v1.x * this.y)) / v1.distanceToVector(v2) * 2;
	}
	,distanceToVector: function(v) {
		return Math.sqrt(this.squaredDistanceToVector(v));
	}
	,squaredDistanceToVector: function(v) {
		var dx = this.x - v.x;
		var dy = this.y - v.y;
		return dx * dx + dy * dy;
	}
	,equals: function(obj) {
		return this.x == obj.x && this.y == obj.y && this.z == obj.z;
	}
	,heading2D: function() {
		return Math.atan2(-this.y,this.x) * -1;
	}
	,limit: function(max) {
		if(Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z) > max) {
			this.normalize();
			this.mult(max);
		}
	}
	,normalizeTo: function(target) {
		if(target == null) target = new RCVector(0,0);
		var m = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
		if(m > 0) target.copyXYZ(this.x / m,this.y / m,this.z / m); else target.copyXYZ(this.x,this.y,this.z);
		return target;
	}
	,normalize: function() {
		var m = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
		if(m != 0 && m != 1) this.div(m);
	}
	,crossTo: function(v,target) {
		var crossX = this.y * v.z - v.y * this.z;
		var crossY = this.z * v.x - v.z * this.x;
		var crossZ = this.x * v.y - v.x * this.y;
		if(target == null) return new RCVector(crossX,crossY,crossZ);
		target.copyXYZ(crossX,crossY,crossZ);
		return target;
	}
	,cross: function(v) {
		return this.crossTo(v,null);
	}
	,dot: function(x,y,z) {
		return this.x * x + this.y * y + this.z * z;
	}
	,dotVec: function(v) {
		return this.x * v.x + this.y * v.y + this.z * v.z;
	}
	,distanceTo: function(v) {
		var dx = this.x - v.x;
		var dy = this.y - v.y;
		var dz = this.z - v.z;
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}
	,divVec: function(v) {
		this.x /= v.x;
		this.y /= v.y;
		this.z /= v.z;
	}
	,div: function(n) {
		this.x /= n;
		this.y /= n;
		this.z /= n;
	}
	,multVec: function(v) {
		this.x *= v.x;
		this.y *= v.y;
		this.z *= v.z;
	}
	,mult: function(n) {
		this.x *= n;
		this.y *= n;
		this.z *= n;
	}
	,subXYZ: function(x,y,z) {
		this.x -= x;
		this.y -= y;
		this.z -= z;
	}
	,subVec: function(v) {
		this.x -= v.x;
		this.y -= v.y;
		this.z -= v.z;
	}
	,addXYZ: function(x,y,z) {
		this.x += x;
		this.y += y;
		this.z += z;
	}
	,addVector: function(v) {
		this.x += v.x;
		this.y += v.y;
		this.z += v.z;
	}
	,mag: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	,copyArray: function(source) {
		if(source.length >= 2) {
			this.x = source[0];
			this.y = source[1];
		}
		if(source.length >= 3) this.z = source[2];
	}
	,copyVector: function(v) {
		this.x = v.x;
		this.y = v.y;
		this.z = v.z;
	}
	,copyXYZ: function(x,y,z) {
		if(z == null) z = 0;
		this.x = x;
		this.y = y;
		this.z = z;
	}
	,z: null
	,y: null
	,x: null
	,__class__: RCVector
}
var RCWebView = function(x,y,w,h,url) {
	this.didFinishLoad = new RCSignal();
	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;
	this.url = url;
};
$hxClasses["RCWebView"] = RCWebView;
RCWebView.__name__ = ["RCWebView"];
RCWebView.prototype = {
	destroy: function() {
		if(this.didFinishLoad != null) {
			this.didFinishLoad.destroy({ fileName : "RCWebView.hx", lineNumber : 54, className : "RCWebView", methodName : "destroy"});
			this.didFinishLoad = null;
		}
	}
	,webViewDidFinishLoad: function(url) {
		if(this.didFinishLoad != null) this.didFinishLoad.dispatch(url,null,null,null,{ fileName : "RCWebView.hx", lineNumber : 45, className : "RCWebView", methodName : "webViewDidFinishLoad"});
	}
	,init: function() {
	}
	,url: null
	,h: null
	,w: null
	,y: null
	,x: null
	,didFinishWithError: null
	,didFinishLoad: null
	,__class__: RCWebView
}
var RCWindow = function(id) {
	if(RCWindow.sharedWindow_ != null) {
		var err = "RCWindow is a singletone, create and access it with RCWindow.sharedWindow(?id)";
		haxe.Log.trace(err,{ fileName : "RCWindow.hx", lineNumber : 60, className : "RCWindow", methodName : "new"});
		throw err;
	}
	JSView.call(this,0.0,0.0,0.0,0.0);
	this.stage = js.Browser.document.body;
	this.setTarget(id);
	this.SCREEN_W = js.Browser.window.screen.width;
	this.SCREEN_H = js.Browser.window.screen.height;
	RCNotificationCenter.addObserver("resize",$bind(this,this.resizeHandler));
};
$hxClasses["RCWindow"] = RCWindow;
RCWindow.__name__ = ["RCWindow"];
RCWindow.sharedWindow_ = null;
RCWindow.sharedWindow = function(id) {
	if(RCWindow.sharedWindow_ == null) RCWindow.sharedWindow_ = new RCWindow(id);
	return RCWindow.sharedWindow_;
}
RCWindow.__super__ = JSView;
RCWindow.prototype = $extend(JSView.prototype,{
	toString: function() {
		return "[RCWindow target=" + Std.string(this.target) + "]";
	}
	,getCenterY: function(h) {
		return Math.round(this.get_height() / 2 - h / RCDevice.currentDevice().dpiScale / 2);
	}
	,getCenterX: function(w) {
		return Math.round(this.get_width() / 2 - w / RCDevice.currentDevice().dpiScale / 2);
	}
	,destroyModalViewController: function() {
		this.modalView.removeFromSuperview();
		this.modalView.destroy();
		this.modalView = null;
	}
	,dismissModalViewController: function() {
		if(this.modalView == null) return;
		this.modalView.modalViewWillDisappear();
		var anim = new CATween(this.modalView,{ y : this.get_height()},0.3,0,eq.Cubic.IN,{ fileName : "RCWindow.hx", lineNumber : 257, className : "RCWindow", methodName : "dismissModalViewController"});
		anim.animationDidStop = $bind(this,this.destroyModalViewController);
		RCAnimation.add(anim);
	}
	,initModalViewController: function() {
		this.modalView.modalViewDidAppear();
	}
	,addModalViewController: function(view) {
		if(this.modalView != null) return;
		this.modalView = view;
		var anim = new CATween(this.modalView,{ y : { fromValue : this.get_height(), toValue : 0}},0.5,0,eq.Cubic.IN_OUT,{ fileName : "RCWindow.hx", lineNumber : 242, className : "RCWindow", methodName : "addModalViewController"});
		anim.animationDidStop = $bind(this,this.initModalViewController);
		RCAnimation.add(anim);
		this.addChild(this.modalView);
	}
	,supportsFullScreen: function() {
		if(Reflect.field(this.target,"cancelFullScreen") != null) return true; else {
			var _g = 0, _g1 = ["webkit","moz","o","ms","khtml"];
			while(_g < _g1.length) {
				var prefix = _g1[_g];
				++_g;
				if(Reflect.field(js.Browser.document,prefix + "CancelFullScreen") != null) {
					this.fsprefix = prefix;
					return true;
				}
			}
		}
		return false;
		return false;
	}
	,isFullScreen: function() {
		if(this.supportsFullScreen()) {
			var _g = this;
			switch(_g.fsprefix) {
			case "":
				return this.target.fullScreen;
			case "webkit":
				return this.target.webkitIsFullScreen;
			default:
				return Reflect.field(this.target,this.fsprefix + "FullScreen");
			}
		}
		return false;
	}
	,normal: function() {
		if(this.supportsFullScreen()) {
			if(this.fsprefix == "") "cancelFullScreen".apply(this.target,[]); else Reflect.field(this.target,this.fsprefix + "CancelFullScreen").apply(this.target,[]);
		}
	}
	,fullscreen: function() {
		if(this.supportsFullScreen()) {
			if(this.fsprefix == null) "requestFullScreen".apply(this.target,[]); else Reflect.field(this.target,this.fsprefix + "RequestFullScreen").apply(this.target,[]);
		}
	}
	,fsprefix: null
	,set_backgroundColor: function(color) {
		if(color == null) this.target.style.background = null; else {
			var red = (color & 16711680) >> 16;
			var green = (color & 65280) >> 8;
			var blue = color & 255;
			var alpha = 1;
			this.target.style.background = "rgba(" + red + "," + green + "," + blue + "," + alpha + ")";
		}
		return color;
	}
	,setTarget: function(id) {
		if(id != null) this.target = js.Browser.document.getElementById(id); else {
			this.target = js.Browser.document.body;
			this.target.style.margin = "0px 0px 0px 0px";
			this.target.style.overflow = "hidden";
			if(RCDevice.currentDevice().userAgent == RCUserAgent.MSIE) {
				this.target.style.width = js.Browser.document.documentElement.clientWidth + "px";
				this.target.style.height = js.Browser.document.documentElement.clientHeight + "px";
			} else {
				this.target.style.width = js.Browser.window.innerWidth + "px";
				this.target.style.height = js.Browser.window.innerHeight + "px";
			}
		}
		this.size.width = this.target.scrollWidth;
		this.size.height = this.target.scrollHeight;
		haxe.Log.trace(this.size,{ fileName : "RCWindow.hx", lineNumber : 129, className : "RCWindow", methodName : "setTarget"});
		this.target.appendChild(this.layer);
	}
	,resizeHandler: function(w,h) {
		this.size.width = w;
		this.size.height = h;
	}
	,modalView: null
	,SCREEN_H: null
	,SCREEN_W: null
	,stage: null
	,target: null
	,__class__: RCWindow
});
var RGBColor = function(r,g,b,a) {
	if(a == null) a = 1.0;
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
};
$hxClasses["RGBColor"] = RGBColor;
RGBColor.__name__ = ["RGBColor"];
RGBColor.prototype = {
	a: null
	,b: null
	,g: null
	,r: null
	,__class__: RGBColor
}
var Reflect = function() { }
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && v.__enum__ == null || t == "function" && (v.__name__ || v.__ename__) != null;
}
Reflect.isEnumValue = function(v) {
	return v != null && v.__enum__ != null;
}
Reflect.deleteField = function(o,field) {
	if(!Reflect.hasField(o,field)) return false;
	delete(o[field]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
var ReversedIntIter = function(max,min) {
	this.min = min;
	this.max = max;
};
$hxClasses["ReversedIntIter"] = ReversedIntIter;
ReversedIntIter.__name__ = ["ReversedIntIter"];
ReversedIntIter.prototype = {
	next: function() {
		return this.max--;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: ReversedIntIter
}
var Std = function() { }
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return x <= 0?0:Math.floor(Math.random() * x);
}
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += len == null?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,get_length: function() {
		return this.b.length;
	}
	,b: null
	,__class__: StringBuf
	,__properties__: {get_length:"get_length"}
}
var StringTools = function() { }
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	return quotes?s.split("\"").join("&quot;").split("'").join("&#039;"):s;
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&quot;").join("\"").split("&#039;").join("'").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = c + s;
	return s;
}
StringTools.rpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = s + c;
	return s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
}
StringTools.isEof = function(c) {
	return c != c;
}
var TEA = function() { }
$hxClasses["TEA"] = TEA;
TEA.__name__ = ["TEA"];
TEA.encrypt = function(src,key) {
	var v = TEA.charsToLongs(TEA.strToChars(src));
	var k = TEA.charsToLongs(TEA.strToChars(key));
	var n = v.length;
	var p = 0;
	if(n == 0) return "";
	if(n == 1) v[n++] = 0;
	var z = v[n - 1], y = v[0];
	var mx, e, q = Math.floor(6 + 52 / n), sum = 0;
	while(q-- > 0) {
		sum += -1640531527;
		e = sum >>> 2 & 3;
		var _g1 = 0, _g = n - 1;
		while(_g1 < _g) {
			var i = _g1++;
			p = i;
			y = v[p + 1];
			mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
			z = v[p] += mx;
		}
		p++;
		y = v[0];
		mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
		z = v[n - 1] += mx;
	}
	return TEA.charsToHex(TEA.longsToChars(v));
}
TEA.decrypt = function(src,key) {
	var v = TEA.charsToLongs(TEA.hexToChars(src));
	var k = TEA.charsToLongs(TEA.strToChars(key));
	var n = v.length;
	var p;
	if(n == 0) return "";
	var z = v[n - 1], y = v[0];
	var mx, e, q = Math.floor(6 + 52 / n);
	var sum = q * -1640531527;
	while(sum != 0) {
		e = sum >>> 2 & 3;
		p = n - 1;
		while(p > 0) {
			z = v[p - 1];
			mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
			y = v[p] -= mx;
			p--;
		}
		z = v[n - 1];
		mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
		y = v[0] -= mx;
		sum -= -1640531527;
	}
	return TEA.charsToStr(TEA.longsToChars(v));
}
TEA.charsToLongs = function(chars) {
	var temp = new Array();
	var _g1 = 0, _g = Math.ceil(chars.length / 4);
	while(_g1 < _g) {
		var i = _g1++;
		temp[i] = chars[i * 4] + (chars[i * 4 + 1] << 8) + (chars[i * 4 + 2] << 16) + (chars[i * 4 + 3] << 24);
	}
	return temp;
}
TEA.longsToChars = function(longs) {
	var codes = new Array();
	var _g1 = 0, _g = longs.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes.push(longs[i] & 255);
		codes.push(longs[i] >>> 8 & 255);
		codes.push(longs[i] >>> 16 & 255);
		codes.push(longs[i] >>> 24 & 255);
	}
	return codes;
}
TEA.longToChars = function(longs) {
	return [longs & 255,longs >>> 8 & 255,longs >>> 16 & 255,longs >>> 24 & 255];
}
TEA.charsToHex = function(chars) {
	var result = "";
	var hexes = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
	var _g = 0;
	while(_g < chars.length) {
		var $char = chars[_g];
		++_g;
		result += hexes[$char >> 4] + hexes[$char & 15];
	}
	return result;
}
TEA.hexToChars = function(hex) {
	var codes = new Array();
	var i = HxOverrides.substr(hex,0,2) == "0x"?2:0;
	while(i < hex.length) {
		codes.push(Std.parseInt("0x" + HxOverrides.substr(hex,i,2)));
		i += 2;
	}
	return codes;
}
TEA.charsToStr = function(chars) {
	var result = new StringBuf();
	var _g = 0;
	while(_g < chars.length) {
		var $char = chars[_g];
		++_g;
		if($char > 0) result.b += String.fromCharCode($char);
	}
	return result.b;
}
TEA.strToChars = function(str) {
	var codes = new Array();
	var _g1 = 0, _g = str.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes.push(HxOverrides.cca(str,i));
	}
	return codes;
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
var XXTea = function() { }
$hxClasses["XXTea"] = XXTea;
XXTea.__name__ = ["XXTea"];
XXTea.encrypt = function(data,key) {
	var dataArray = new Array();
	while(data.length % 4 != 0) data += String.fromCharCode(0);
	var _g1 = 0, _g = data.length >> 2;
	while(_g1 < _g) {
		var i = _g1++;
		dataArray.push(HxOverrides.cca(data,i * 4) << 24 | HxOverrides.cca(data,i * 4 + 1) << 16 | HxOverrides.cca(data,i * 4 + 2) << 8 | HxOverrides.cca(data,i * 4 + 3));
	}
	var hashedKey = haxe.crypto.Md5.encode(key);
	var keyArray = new Array();
	var _g = 0;
	while(_g < 4) {
		var i = _g++;
		keyArray.push(Std.parseInt("0x" + HxOverrides.substr(hashedKey,i * 8,8)));
	}
	XXTea.btea(dataArray,dataArray.length,keyArray);
	var out = "";
	var _g = 0;
	while(_g < dataArray.length) {
		var i = dataArray[_g];
		++_g;
		var a = i >> 24 & 255;
		var b = i >> 16 & 255;
		var c = i >> 8 & 255;
		var d = i & 255;
		out += "-" + StringTools.hex(i);
	}
	return HxOverrides.substr(out,1,null);
}
XXTea.decrypt = function(data,key) {
	var dataArray = new Array();
	var dataStringArray = data.split("-");
	var _g1 = 0, _g = dataStringArray.length;
	while(_g1 < _g) {
		var i = _g1++;
		dataArray.push(XXTea.b32(Std.parseInt("0x" + dataStringArray[i])));
	}
	var hashedKey = haxe.crypto.Md5.encode(key);
	var keyArray = new Array();
	var _g = 0;
	while(_g < 4) {
		var i = _g++;
		keyArray.push(Std.parseInt("0x" + HxOverrides.substr(hashedKey,i * 8,8)));
	}
	XXTea.btea(dataArray,-dataArray.length,keyArray);
	var out = "";
	var _g = 0;
	while(_g < dataArray.length) {
		var i = dataArray[_g];
		++_g;
		var a = i >> 24 & 255;
		var b = i >> 16 & 255;
		var c = i >> 8 & 255;
		var d = i & 255;
		out += String.fromCharCode(a) + String.fromCharCode(b) + String.fromCharCode(c) + String.fromCharCode(d);
	}
	return out;
}
XXTea.btea = function(v,n,k) {
	var z;
	var y = 0;
	var sum;
	var p = 0;
	var rounds;
	var e;
	if(n > 1) {
		rounds = 6 + Math.floor(52 / n);
		sum = 0;
		z = v[n - 1];
		do {
			sum = XXTea.b32(sum + XXTea.DELTA);
			e = sum >>> 2 & 3;
			p = 0;
			while(p < n - 1) {
				y = v[p + 1];
				v[p] = XXTea.b32(v[p] + (XXTea.b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ XXTea.b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
				z = v[p];
				p++;
			}
			y = v[0];
			v[n - 1] = XXTea.b32(v[n - 1] + (XXTea.b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ XXTea.b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
			z = v[n - 1];
		} while(--rounds != 0);
	} else if(n < -1) {
		n = -n;
		rounds = 6 + Math.floor(52 / n);
		sum = XXTea.b32(rounds * XXTea.DELTA);
		y = v[0];
		do {
			e = sum >>> 2 & 3;
			p = n - 1;
			while(p > 0) {
				z = v[p - 1];
				v[p] = XXTea.b32(v[p] - (XXTea.b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ XXTea.b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
				y = v[p];
				p--;
			}
			z = v[n - 1];
			v[0] = XXTea.b32(v[0] - (XXTea.b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ XXTea.b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
			y = v[0];
		} while((sum = XXTea.b32(sum - XXTea.DELTA)) != 0);
	}
}
XXTea.b32 = function(value) {
	return value;
}
var XmlType = $hxClasses["XmlType"] = { __ename__ : ["XmlType"], __constructs__ : [] }
var Xml = function() {
};
$hxClasses["Xml"] = Xml;
Xml.__name__ = ["Xml"];
Xml.Element = null;
Xml.PCData = null;
Xml.CData = null;
Xml.Comment = null;
Xml.DocType = null;
Xml.ProcessingInstruction = null;
Xml.Document = null;
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
}
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new haxe.ds.StringMap();
	r.set_nodeName(name);
	return r;
}
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.set_nodeValue(data);
	return r;
}
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.set_nodeValue(data);
	return r;
}
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.set_nodeValue(data);
	return r;
}
Xml.createProcessingInstruction = function(data) {
	var r = new Xml();
	r.nodeType = Xml.ProcessingInstruction;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
}
Xml.prototype = {
	toString: function() {
		if(this.nodeType == Xml.PCData) return StringTools.htmlEscape(this._nodeValue);
		if(this.nodeType == Xml.CData) return "<![CDATA[" + this._nodeValue + "]]>";
		if(this.nodeType == Xml.Comment) return "<!--" + this._nodeValue + "-->";
		if(this.nodeType == Xml.DocType) return "<!DOCTYPE " + this._nodeValue + ">";
		if(this.nodeType == Xml.ProcessingInstruction) return "<?" + this._nodeValue + "?>";
		var s = new StringBuf();
		if(this.nodeType == Xml.Element) {
			s.b += "<";
			s.b += Std.string(this._nodeName);
			var $it0 = this._attributes.keys();
			while( $it0.hasNext() ) {
				var k = $it0.next();
				s.b += " ";
				s.b += Std.string(k);
				s.b += "=\"";
				s.b += Std.string(this._attributes.get(k));
				s.b += "\"";
			}
			if(this._children.length == 0) {
				s.b += "/>";
				return s.b;
			}
			s.b += ">";
		}
		var $it1 = this.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			s.b += Std.string(x.toString());
		}
		if(this.nodeType == Xml.Element) {
			s.b += "</";
			s.b += Std.string(this._nodeName);
			s.b += ">";
		}
		return s.b;
	}
	,insertChild: function(x,pos) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.splice(pos,0,x);
	}
	,removeChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		var b = HxOverrides.remove(this._children,x);
		if(b) x._parent = null;
		return b;
	}
	,addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,firstElement: function() {
		if(this._children == null) throw "bad nodetype";
		var cur = 0;
		var l = this._children.length;
		while(cur < l) {
			var n = this._children[cur];
			if(n.nodeType == Xml.Element) return n;
			cur++;
		}
		return null;
	}
	,firstChild: function() {
		if(this._children == null) throw "bad nodetype";
		return this._children[0];
	}
	,elementsNamed: function(name) {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				if(n.nodeType == Xml.Element && n._nodeName == name) break;
				k++;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k++;
				if(n.nodeType == Xml.Element && n._nodeName == name) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,elements: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				if(this.x[k].nodeType == Xml.Element) break;
				k += 1;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k += 1;
				if(n.nodeType == Xml.Element) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,iterator: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			return this.cur < this.x.length;
		}, next : function() {
			return this.x[this.cur++];
		}};
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.keys();
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,remove: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.remove(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,get_parent: function() {
		return this._parent;
	}
	,set_nodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,get_nodeValue: function() {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue;
	}
	,set_nodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,get_nodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,_parent: null
	,_children: null
	,_attributes: null
	,_nodeValue: null
	,_nodeName: null
	,parent: null
	,nodeType: null
	,__class__: Xml
	,__properties__: {set_nodeName:"set_nodeName",get_nodeName:"get_nodeName",set_nodeValue:"set_nodeValue",get_nodeValue:"get_nodeValue",get_parent:"get_parent"}
}
var Zeta = function() { }
$hxClasses["Zeta"] = Zeta;
Zeta.__name__ = ["Zeta"];
Zeta.isIn = function(search_this,in_this,pos) {
	if(pos == null) pos = "fit";
	if(search_this == null || in_this == null) return false;
	var arr1 = js.Boot.__instanceof(search_this,Array)?search_this:[search_this];
	var arr2 = js.Boot.__instanceof(in_this,Array)?in_this:[in_this];
	var _g = 0;
	while(_g < arr1.length) {
		var a1 = arr1[_g];
		++_g;
		var _g1 = 0;
		while(_g1 < arr2.length) {
			var a2 = arr2[_g1];
			++_g1;
			var _g2 = pos.toLowerCase();
			switch(_g2) {
			case "anywhere":
				if(a1.toLowerCase().indexOf(a2.toLowerCase()) != -1) return true;
				break;
			case "end":
				if(a1.toLowerCase().substr(a1.length - a2.length) == a2.toLowerCase()) return true;
				break;
			case "fit":
				if(a1 == a2) return true;
				break;
			case "lowercase":
				if(a1.toLowerCase() == a2.toLowerCase()) return true;
				break;
			default:
				haxe.Log.trace("Position in string not implemented",{ fileName : "Zeta.hx", lineNumber : 49, className : "Zeta", methodName : "isIn"});
				return false;
			}
		}
	}
	return false;
}
Zeta.concatObjects = function(objs) {
	var finalObject = { };
	var _g = 0;
	while(_g < objs.length) {
		var currentObject = objs[_g];
		++_g;
		var _g1 = 0, _g2 = Reflect.fields(currentObject);
		while(_g1 < _g2.length) {
			var prop = _g2[_g1];
			++_g1;
			if(Reflect.field(currentObject,prop) != null) finalObject[prop] = Reflect.field(currentObject,prop);
		}
	}
	return finalObject;
}
Zeta.sort = function(array,sort_type,sort_array) {
	if(sort_type.toLowerCase() == "lastmodifieddescending") return array;
	if(sort_type.toLowerCase() == "lastmodifiedascending") sort_type = "reverse";
	if(sort_type.toLowerCase() == "customascending" && sort_array != null) sort_type = "custom";
	if(sort_type.toLowerCase() == "customdescending" && sort_array != null) {
		sort_array.reverse();
		sort_type = "custom";
	}
	var _g = sort_type.toLowerCase();
	switch(_g) {
	case "reverse":
		array.reverse();
		break;
	case "ascending":
		array.sort(Zeta.ascendingSort);
		break;
	case "descending":
		array.sort(Zeta.descendingSort);
		break;
	case "random":
		array.sort(Zeta.randomSort);
		break;
	case "custom":
		var arr = new Array();
		var _g1 = 0;
		while(_g1 < sort_array.length) {
			var a = sort_array[_g1];
			++_g1;
			var _g2 = 0;
			while(_g2 < array.length) {
				var b = array[_g2];
				++_g2;
				if(a == b) {
					arr.push(a);
					HxOverrides.remove(array,a);
					break;
				}
			}
		}
		return arr.concat(array);
	default:
		array.sortOn(sort_type,Array.NUMERIC);
	}
	return array;
}
Zeta.randomSort = function(a,b) {
	return -1 + Std.random(3);
}
Zeta.ascendingSort = function(a,b) {
	return Std.string(a) > Std.string(b)?1:-1;
}
Zeta.descendingSort = function(a,b) {
	return Std.string(a) > Std.string(b)?-1:1;
}
Zeta.array = function(len,zeros) {
	if(zeros == null) zeros = false;
	var a = new Array();
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		a.push(zeros?0:i);
	}
	return a;
}
Zeta.duplicateArray = function(arr) {
	var newArr = new Array();
	var _g = 0;
	while(_g < arr.length) {
		var a = arr[_g];
		++_g;
		newArr.push(a);
	}
	return newArr;
}
Zeta.lineEquation = function(x1,x2,y0,y1,y2) {
	return (x2 - x1) * (y0 - y1) / (y2 - y1) + x1;
}
Zeta.lineEquationInt = function(x1,x2,y0,y1,y2) {
	return Math.round((x2 - x1) * (y0 - y1) / (y2 - y1) + x1);
}
Zeta.limits = function(val,min,max) {
	return val < min?min:val > max?max:val;
}
Zeta.limitsInt = function(val,min,max) {
	return Math.round(val < min?min:val > max?max:val);
}
eq.Back = function() { }
$hxClasses["eq.Back"] = eq.Back;
eq.Back.__name__ = ["eq","Back"];
eq.Back.IN = function(t,b,c,d,p_params) {
	var s = Reflect.field(p_params,"overshoot") == null?1.70158:Reflect.field(p_params,"overshoot");
	return c * (t /= d) * t * ((s + 1) * t - s) + b;
}
eq.Back.OUT = function(t,b,c,d,p_params) {
	var s = Reflect.field(p_params,"overshoot") == null?1.70158:Reflect.field(p_params,"overshoot");
	return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
}
eq.Back.IN_OUT = function(t,b,c,d,p_params) {
	var s = Reflect.field(p_params,"overshoot") == null?1.70158:Reflect.field(p_params,"overshoot");
	if((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
	return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
}
eq.Back.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Back.OUT(t * 2,b,c / 2,d,p_params);
	return eq.Back.IN(t * 2 - d,b + c / 2,c / 2,d,p_params);
}
eq.Bounce = function() { }
$hxClasses["eq.Bounce"] = eq.Bounce;
eq.Bounce.__name__ = ["eq","Bounce"];
eq.Bounce.IN = function(t,b,c,d,p_params) {
	return c - eq.Bounce.OUT(d - t,0,c,d,null) + b;
}
eq.Bounce.OUT = function(t,b,c,d,p_params) {
	if((t /= d) < 1 / 2.75) return c * (7.5625 * t * t) + b; else if(t < 2 / 2.75) return c * (7.5625 * (t -= 1.5 / 2.75) * t + .75) + b; else if(t < 2.5 / 2.75) return c * (7.5625 * (t -= 2.25 / 2.75) * t + .9375) + b; else return c * (7.5625 * (t -= 2.625 / 2.75) * t + .984375) + b;
}
eq.Bounce.IN_OUT = function(t,b,c,d,p_params) {
	if(t < d / 2) return (c - eq.Bounce.OUT(d - t * 2,0,c,d,null)) * .5 + b; else return eq.Bounce.OUT(t * 2 - d,0,c,d,null) * .5 + c * .5 + b;
}
eq.Bounce.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Bounce.OUT(t * 2,b,c / 2,d,null);
	return eq.Bounce.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Circ = function() { }
$hxClasses["eq.Circ"] = eq.Circ;
eq.Circ.__name__ = ["eq","Circ"];
eq.Circ.IN = function(t,b,c,d,p_params) {
	return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
}
eq.Circ.OUT = function(t,b,c,d,p_params) {
	return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
}
eq.Circ.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
	return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
}
eq.Circ.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Circ.OUT(t * 2,b,c / 2,d,null);
	return eq.Circ.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Cubic = function() { }
$hxClasses["eq.Cubic"] = eq.Cubic;
eq.Cubic.__name__ = ["eq","Cubic"];
eq.Cubic.IN = function(t,b,c,d,p_params) {
	return c * (t /= d) * t * t + b;
}
eq.Cubic.OUT = function(t,b,c,d,p_params) {
	return c * ((t = t / d - 1) * t * t + 1) + b;
}
eq.Cubic.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return c / 2 * t * t * t + b;
	return c / 2 * ((t -= 2) * t * t + 2) + b;
}
eq.Cubic.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Cubic.OUT(t * 2,b,c / 2,d,null);
	return eq.Cubic.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Elastic = function() { }
$hxClasses["eq.Elastic"] = eq.Elastic;
eq.Elastic.__name__ = ["eq","Elastic"];
eq.Elastic.IN = function(t,b,c,d,p_params) {
	if(t == 0) return b;
	if((t /= d) == 1) return b + c;
	var p = Reflect.field(p_params,"period") == null?d * .3:Reflect.field(p_params,"period");
	var s;
	var a = Std.parseFloat(Reflect.field(p_params,"amplitude"));
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else s = p / (2 * Math.PI) * Math.asin(c / a);
	return -(a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
}
eq.Elastic.OUT = function(t,b,c,d,p_params) {
	if(t == 0) return b;
	if((t /= d) == 1) return b + c;
	var p = Reflect.field(p_params,"period") == null?d * .3:Reflect.field(p_params,"period");
	var s;
	var a = Reflect.field(p_params,"amplitude");
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else s = p / (2 * Math.PI) * Math.asin(c / a);
	return a * Math.pow(2,-10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
}
eq.Elastic.IN_OUT = function(t,b,c,d,p_params) {
	if(t == 0) return b;
	if((t /= d / 2) == 2) return b + c;
	var p = Reflect.field(p_params,"period") == null?d * (.3 * 1.5):Reflect.field(p_params,"period");
	var s;
	var a = Reflect.field(p_params,"amplitude");
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else s = p / (2 * Math.PI) * Math.asin(c / a);
	if(t < 1) return -0.5 * (a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
	return a * Math.pow(2,-10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
}
eq.Elastic.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Elastic.OUT(t * 2,b,c / 2,d,p_params);
	return eq.Elastic.IN(t * 2 - d,b + c / 2,c / 2,d,p_params);
}
eq.Expo = function() { }
$hxClasses["eq.Expo"] = eq.Expo;
eq.Expo.__name__ = ["eq","Expo"];
eq.Expo.IN = function(t,b,c,d,p_params) {
	return t == 0?b:c * Math.pow(2,10 * (t / d - 1)) + b - c * 0.001;
}
eq.Expo.OUT = function(t,b,c,d,p_params) {
	return t == d?b + c:c * 1.001 * (-Math.pow(2,-10 * t / d) + 1) + b;
}
eq.Expo.IN_OUT = function(t,b,c,d,p_params) {
	if(t == 0) return b;
	if(t == d) return b + c;
	if((t /= d / 2) < 1) return c / 2 * Math.pow(2,10 * (t - 1)) + b - c * 0.0005;
	return c / 2 * 1.0005 * (-Math.pow(2,-10 * --t) + 2) + b;
}
eq.Expo.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Expo.OUT(t * 2,b,c / 2,d,null);
	return eq.Expo.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Quad = function() { }
$hxClasses["eq.Quad"] = eq.Quad;
eq.Quad.__name__ = ["eq","Quad"];
eq.Quad.IN = function(t,b,c,d,p_params) {
	return c * (t /= d) * t + b;
}
eq.Quad.OUT = function(t,b,c,d,p_params) {
	return -c * (t /= d) * (t - 2) + b;
}
eq.Quad.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return c / 2 * t * t + b;
	return -c / 2 * (--t * (t - 2) - 1) + b;
}
eq.Quad.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Quad.OUT(t * 2,b,c / 2,d,null);
	return eq.Quad.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Quart = function() { }
$hxClasses["eq.Quart"] = eq.Quart;
eq.Quart.__name__ = ["eq","Quart"];
eq.Quart.IN = function(t,b,c,d,p_params) {
	return c * (t /= d) * t * t * t + b;
}
eq.Quart.OUT = function(t,b,c,d,p_params) {
	return -c * ((t = t / d - 1) * t * t * t - 1) + b;
}
eq.Quart.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
	return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
}
eq.Quart.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Quart.OUT(t * 2,b,c / 2,d,null);
	return eq.Quart.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Quint = function() { }
$hxClasses["eq.Quint"] = eq.Quint;
eq.Quint.__name__ = ["eq","Quint"];
eq.Quint.IN = function(t,b,c,d,p_params) {
	return c * (t /= d) * t * t * t * t + b;
}
eq.Quint.OUT = function(t,b,c,d,p_params) {
	return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
}
eq.Quint.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
	return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
}
eq.Quint.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return eq.Quint.OUT(t * 2,b,c / 2,d,null);
	return eq.Quint.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
eq.Sine = function() { }
$hxClasses["eq.Sine"] = eq.Sine;
eq.Sine.__name__ = ["eq","Sine"];
eq.Sine.IN = function(t,b,c,d,p_params) {
	return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
}
eq.Sine.OUT = function(t,b,c,d,p_params) {
	return c * Math.sin(t / d * (Math.PI / 2)) + b;
}
eq.Sine.IN_OUT = function(t,b,c,d,p_params) {
	return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
}
eq.Sine.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return c / 2 * Math.sin(t * 2 / d * (Math.PI / 2)) + b;
	return eq.Sine.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.CallStack = function() { }
$hxClasses["haxe.CallStack"] = haxe.CallStack;
haxe.CallStack.__name__ = ["haxe","CallStack"];
haxe.CallStack.callStack = function() {
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe.StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe.StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe.CallStack.makeStack(new Error().stack);
	a.shift();
	Error.prepareStackTrace = oldValue;
	return a;
}
haxe.CallStack.exceptionStack = function() {
	return [];
}
haxe.CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe.CallStack.itemToString(b,s);
	}
	return b.b;
}
haxe.CallStack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = $e[2];
		b.b += "module ";
		b.b += Std.string(m);
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.CallStack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += Std.string(file);
		b.b += " line ";
		b.b += Std.string(line);
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b += Std.string(cname);
		b.b += ".";
		b.b += Std.string(meth);
		break;
	case 4:
		var n = $e[2];
		b.b += "local function #";
		b.b += Std.string(n);
		break;
	}
}
haxe.CallStack.makeStack = function(s) {
	if(typeof(s) == "string") {
		var stack = s.split("\n");
		var m = [];
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			m.push(haxe.StackItem.Module(line));
		}
		return m;
	} else return s;
}
haxe.Http = function(url) {
	this.url = url;
	this.headers = new haxe.ds.StringMap();
	this.params = new haxe.ds.StringMap();
	this.async = true;
};
$hxClasses["haxe.Http"] = haxe.Http;
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.requestUrl = function(url) {
	var h = new haxe.Http(url);
	h.async = false;
	var r = null;
	h.onData = function(d) {
		r = d;
	};
	h.onError = function(e) {
		throw e;
	};
	h.request(false);
	return r;
}
haxe.Http.prototype = {
	onStatus: function(status) {
	}
	,onError: function(msg) {
	}
	,onData: function(data) {
	}
	,request: function(post) {
		var me = this;
		me.responseData = null;
		var r = js.Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s = (function($this) {
				var $r;
				try {
					$r = r.status;
				} catch( e ) {
					$r = null;
				}
				return $r;
			}(this));
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) me.onData(me.responseData = r.responseText); else if(s == null) me.onError("Failed to connect or resolve host"); else switch(s) {
			case 12029:
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.onError("Unknown host");
				break;
			default:
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.keys();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += StringTools.urlEncode(p) + "=" + StringTools.urlEncode(this.params.get(p));
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e ) {
			this.onError(e.toString());
			return;
		}
		if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.keys();
		while( $it1.hasNext() ) {
			var h = $it1.next();
			r.setRequestHeader(h,this.headers.get(h));
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,setPostData: function(data) {
		this.postData = data;
		return this;
	}
	,setParameter: function(param,value) {
		this.params.set(param,value);
		return this;
	}
	,setHeader: function(header,value) {
		this.headers.set(header,value);
		return this;
	}
	,params: null
	,headers: null
	,postData: null
	,async: null
	,responseData: null
	,url: null
	,__class__: haxe.Http
}
haxe.Json = function() {
};
$hxClasses["haxe.Json"] = haxe.Json;
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.stringify = function(value,replacer) {
	return new haxe.Json().toString(value,replacer);
}
haxe.Json.prototype = {
	parseNumber: function(c) {
		var start = this.pos - 1;
		var minus = c == 45, digit = !minus, zero = c == 48;
		var point = false, e = false, pm = false, end = false;
		while(true) {
			c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 48:
				if(zero && !point) this.invalidNumber(start);
				if(minus) {
					minus = false;
					zero = true;
				}
				digit = true;
				break;
			case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:
				if(zero && !point) this.invalidNumber(start);
				if(minus) minus = false;
				digit = true;
				zero = false;
				break;
			case 46:
				if(minus || point) this.invalidNumber(start);
				digit = false;
				point = true;
				break;
			case 101:case 69:
				if(minus || zero || e) this.invalidNumber(start);
				digit = false;
				e = true;
				break;
			case 43:case 45:
				if(!e || pm) this.invalidNumber(start);
				digit = false;
				pm = true;
				break;
			default:
				if(!digit) this.invalidNumber(start);
				this.pos--;
				end = true;
			}
			if(end) break;
		}
		var f = Std.parseFloat(HxOverrides.substr(this.str,start,this.pos - start));
		var i = f | 0;
		return i == f?i:f;
	}
	,invalidNumber: function(start) {
		throw "Invalid number at position " + start + ": " + HxOverrides.substr(this.str,start,this.pos - start);
	}
	,parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.addSub(this.str,start,this.pos - start - 1);
				c = this.str.charCodeAt(this.pos++);
				switch(c) {
				case 114:
					buf.b += "\r";
					break;
				case 110:
					buf.b += "\n";
					break;
				case 116:
					buf.b += "\t";
					break;
				case 98:
					buf.b += "";
					break;
				case 102:
					buf.b += "";
					break;
				case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + HxOverrides.substr(this.str,this.pos,4));
					this.pos += 4;
					buf.b += String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.addSub(this.str,start,this.pos - start - 1);
		return buf.b;
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				return this.parseNumber(c);
			default:
				this.invalidChar();
			}
		}
	}
	,nextChar: function() {
		return this.str.charCodeAt(this.pos++);
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
	}
	,doParse: function(str) {
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,quote: function(s) {
		this.buf.b += "\"";
		var i = 0;
		while(true) {
			var c = s.charCodeAt(i++);
			if(c != c) break;
			switch(c) {
			case 34:
				this.buf.b += "\\\"";
				break;
			case 92:
				this.buf.b += "\\\\";
				break;
			case 10:
				this.buf.b += "\\n";
				break;
			case 13:
				this.buf.b += "\\r";
				break;
			case 9:
				this.buf.b += "\\t";
				break;
			case 8:
				this.buf.b += "\\b";
				break;
			case 12:
				this.buf.b += "\\f";
				break;
			default:
				this.buf.b += String.fromCharCode(c);
			}
		}
		this.buf.b += "\"";
	}
	,toStringRec: function(k,v) {
		if(this.replacer != null) v = this.replacer(k,v);
		var _g = Type["typeof"](v);
		var $e = (_g);
		switch( $e[1] ) {
		case 8:
			this.buf.b += "\"???\"";
			break;
		case 4:
			this.objString(v);
			break;
		case 1:
			var v1 = v;
			this.buf.b += Std.string(v1);
			break;
		case 2:
			this.buf.b += Std.string(Math.isFinite(v)?v:"null");
			break;
		case 5:
			this.buf.b += "\"<fun>\"";
			break;
		case 6:
			var c = $e[2];
			if(c == String) this.quote(v); else if(c == Array) {
				var v1 = v;
				this.buf.b += "[";
				var len = v1.length;
				if(len > 0) {
					this.toStringRec(0,v1[0]);
					var i = 1;
					while(i < len) {
						this.buf.b += ",";
						this.toStringRec(i,v1[i++]);
					}
				}
				this.buf.b += "]";
			} else if(c == haxe.ds.StringMap) {
				var v1 = v;
				var o = { };
				var $it0 = v1.keys();
				while( $it0.hasNext() ) {
					var k1 = $it0.next();
					o[k1] = v1.get(k1);
				}
				this.objString(o);
			} else this.objString(v);
			break;
		case 7:
			var i = Type.enumIndex(v);
			var v1 = i;
			this.buf.b += Std.string(v1);
			break;
		case 3:
			var v1 = v;
			this.buf.b += Std.string(v1);
			break;
		case 0:
			this.buf.b += "null";
			break;
		}
	}
	,objString: function(v) {
		this.fieldsString(v,Reflect.fields(v));
	}
	,fieldsString: function(v,fields) {
		var first = true;
		this.buf.b += "{";
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var value = Reflect.field(v,f);
			if(Reflect.isFunction(value)) continue;
			if(first) first = false; else this.buf.b += ",";
			this.quote(f);
			this.buf.b += ":";
			this.toStringRec(f,value);
		}
		this.buf.b += "}";
	}
	,toString: function(v,replacer) {
		this.buf = new StringBuf();
		this.replacer = replacer;
		this.toStringRec("",v);
		return this.buf.b;
	}
	,replacer: null
	,pos: null
	,str: null
	,buf: null
	,__class__: haxe.Json
}
haxe.Log = function() { }
$hxClasses["haxe.Log"] = haxe.Log;
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.SKScrollBar = function(colors) {
	RCSkin.call(this,colors);
	var w = 8, h = 8;
	this.normal.background = new RCRectangle(0,0,w,h,10066329,0.6,8);
	this.normal.otherView = new RCRectangle(0,0,w,h,3355443,1,8);
	this.hit = new RCRectangle(0,0,w,h,6710886,0);
};
$hxClasses["haxe.SKScrollBar"] = haxe.SKScrollBar;
haxe.SKScrollBar.__name__ = ["haxe","SKScrollBar"];
haxe.SKScrollBar.__super__ = RCSkin;
haxe.SKScrollBar.prototype = $extend(RCSkin.prototype,{
	__class__: haxe.SKScrollBar
});
haxe.SKSlider = function(colors) {
	RCSkin.call(this,colors);
	var w = 160;
	var h = 8;
	this.normal.background = new RCRectangle(0,0,w,h,7829367,1,8);
	this.normal.otherView = new RCEllipse(0,0,h * 2,h * 2,3355443);
	this.normal.otherView.addChild(new RCEllipse(1,1,h * 2 - 2,h * 2 - 2,16763904));
	this.highlighted.background = new RCRectangle(0,0,w,h,0,1,8);
	this.hit = new JSView(0,0);
};
$hxClasses["haxe.SKSlider"] = haxe.SKSlider;
haxe.SKSlider.__name__ = ["haxe","SKSlider"];
haxe.SKSlider.__super__ = RCSkin;
haxe.SKSlider.prototype = $extend(RCSkin.prototype,{
	__class__: haxe.SKSlider
});
haxe.Serializer = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new haxe.ds.StringMap();
	this.scount = 0;
};
$hxClasses["haxe.Serializer"] = haxe.Serializer;
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype = {
	serializeException: function(e) {
		this.buf.b += "x";
		this.serialize(e);
	}
	,serialize: function(v) {
		var _g = Type["typeof"](v);
		var $e = (_g);
		switch( $e[1] ) {
		case 0:
			this.buf.b += "n";
			break;
		case 1:
			if(v == 0) {
				this.buf.b += "z";
				return;
			}
			this.buf.b += "i";
			this.buf.b += Std.string(v);
			break;
		case 2:
			if(Math.isNaN(v)) this.buf.b += "k"; else if(!Math.isFinite(v)) this.buf.b += Std.string(v < 0?"m":"p"); else {
				this.buf.b += "d";
				this.buf.b += Std.string(v);
			}
			break;
		case 3:
			this.buf.b += Std.string(v?"t":"f");
			break;
		case 6:
			var c = $e[2];
			if(c == String) {
				this.serializeString(v);
				return;
			}
			if(this.useCache && this.serializeRef(v)) return;
			switch(c) {
			case Array:
				var ucount = 0;
				this.buf.b += "a";
				var l = v.length;
				var _g1 = 0;
				while(_g1 < l) {
					var i = _g1++;
					if(v[i] == null) ucount++; else {
						if(ucount > 0) {
							if(ucount == 1) this.buf.b += "n"; else {
								this.buf.b += "u";
								this.buf.b += Std.string(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) this.buf.b += "n"; else {
						this.buf.b += "u";
						this.buf.b += Std.string(ucount);
					}
				}
				this.buf.b += "h";
				break;
			case List:
				this.buf.b += "l";
				var v1 = v;
				var $it0 = v1.iterator();
				while( $it0.hasNext() ) {
					var i = $it0.next();
					this.serialize(i);
				}
				this.buf.b += "h";
				break;
			case Date:
				var d = v;
				this.buf.b += "v";
				this.buf.b += Std.string(HxOverrides.dateStr(d));
				break;
			case haxe.ds.StringMap:
				this.buf.b += "b";
				var v1 = v;
				var $it1 = v1.keys();
				while( $it1.hasNext() ) {
					var k = $it1.next();
					this.serializeString(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.IntMap:
				this.buf.b += "q";
				var v1 = v;
				var $it2 = v1.keys();
				while( $it2.hasNext() ) {
					var k = $it2.next();
					this.buf.b += ":";
					this.buf.b += Std.string(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.ObjectMap:
				this.buf.b += "M";
				var v1 = v;
				var $it3 = v1.keys();
				while( $it3.hasNext() ) {
					var k = $it3.next();
					var id = Reflect.field(k,"__id__");
					Reflect.deleteField(k,"__id__");
					this.serialize(k);
					k.__id__ = id;
					this.serialize(v1.h[k.__id__]);
				}
				this.buf.b += "h";
				break;
			case haxe.io.Bytes:
				var v1 = v;
				var i = 0;
				var max = v1.length - 2;
				var charsBuf = new StringBuf();
				var b64 = haxe.Serializer.BASE64;
				while(i < max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					var b3 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt((b2 << 2 | b3 >> 6) & 63));
					charsBuf.b += Std.string(b64.charAt(b3 & 63));
				}
				if(i == max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt(b2 << 2 & 63));
				} else if(i == max + 1) {
					var b1 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt(b1 << 4 & 63));
				}
				var chars = charsBuf.b;
				this.buf.b += "s";
				this.buf.b += Std.string(chars.length);
				this.buf.b += ":";
				this.buf.b += Std.string(chars);
				break;
			default:
				this.cache.pop();
				if(v.hxSerialize != null) {
					this.buf.b += "C";
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					v.hxSerialize(this);
					this.buf.b += "g";
				} else {
					this.buf.b += "c";
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					this.serializeFields(v);
				}
			}
			break;
		case 4:
			if(this.useCache && this.serializeRef(v)) return;
			this.buf.b += "o";
			this.serializeFields(v);
			break;
		case 7:
			var e = $e[2];
			if(this.useCache && this.serializeRef(v)) return;
			this.cache.pop();
			this.buf.b += Std.string(this.useEnumIndex?"j":"w");
			this.serializeString(Type.getEnumName(e));
			if(this.useEnumIndex) {
				this.buf.b += ":";
				this.buf.b += Std.string(v[1]);
			} else this.serializeString(v[0]);
			this.buf.b += ":";
			var l = v.length;
			this.buf.b += Std.string(l - 2);
			var _g1 = 2;
			while(_g1 < l) {
				var i = _g1++;
				this.serialize(v[i]);
			}
			this.cache.push(v);
			break;
		case 5:
			throw "Cannot serialize function";
			break;
		default:
			throw "Cannot serialize " + Std.string(v);
		}
	}
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.b += "g";
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0, _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += "r";
				this.buf.b += Std.string(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += "R";
			this.buf.b += Std.string(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += "y";
		s = StringTools.urlEncode(s);
		this.buf.b += Std.string(s.length);
		this.buf.b += ":";
		this.buf.b += Std.string(s);
	}
	,toString: function() {
		return this.buf.b;
	}
	,useEnumIndex: null
	,useCache: null
	,scount: null
	,shash: null
	,cache: null
	,buf: null
	,__class__: haxe.Serializer
}
haxe.Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
$hxClasses["haxe.Unserializer"] = haxe.Unserializer;
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	unserialize: function() {
		var _g = this.buf.charCodeAt(this.pos++);
		switch(_g) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			var p1 = this.pos;
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = HxOverrides.substr(this.buf,this.pos,len);
			this.pos += len;
			s = StringTools.urlDecode(s);
			this.scache.push(s);
			return s;
		case 107:
			return Math.NaN;
		case 109:
			return Math.NEGATIVE_INFINITY;
		case 112:
			return Math.POSITIVE_INFINITY;
		case 97:
			var buf = this.buf;
			var a = new Array();
			this.cache.push(a);
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n = this.readDigits();
			if(n < 0 || n >= this.cache.length) throw "Invalid reference";
			return this.cache[n];
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
			return this.scache[n];
		case 120:
			throw this.unserialize();
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 119:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new haxe.ds.StringMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new haxe.ds.IntMap();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.charCodeAt(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.charCodeAt(this.pos++);
			}
			if(c != 104) throw "Invalid IntMap format";
			return h;
		case 77:
			var h = new haxe.ds.ObjectMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 118:
			var d = HxOverrides.strDate(HxOverrides.substr(this.buf,this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
			var codes = haxe.Unserializer.CODES;
			if(codes == null) {
				codes = haxe.Unserializer.initCodes();
				haxe.Unserializer.CODES = codes;
			}
			var i = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i + (len - rest);
			var bytes = haxe.io.Bytes.alloc(size);
			var bpos = 0;
			while(i < max) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				var c3 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				var c4 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c3 << 6 | c4) & 255;
			}
			if(rest >= 2) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				if(rest == 3) {
					var c3 = codes[buf.charCodeAt(i++)];
					bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.buf.charCodeAt(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.charCodeAt(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!js.Boot.__instanceof(k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,get: function(p) {
		return this.buf.charCodeAt(p);
	}
	,getResolver: function() {
		return this.resolver;
	}
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,resolver: null
	,scache: null
	,cache: null
	,length: null
	,pos: null
	,buf: null
	,__class__: haxe.Unserializer
}
haxe.crypto = {}
haxe.crypto.Md5 = function() {
};
$hxClasses["haxe.crypto.Md5"] = haxe.crypto.Md5;
haxe.crypto.Md5.__name__ = ["haxe","crypto","Md5"];
haxe.crypto.Md5.encode = function(s) {
	var m = new haxe.crypto.Md5();
	var h = m.doEncode(haxe.crypto.Md5.str2blks(s));
	return m.hex(h);
}
haxe.crypto.Md5.make = function(b) {
	var h = new haxe.crypto.Md5().doEncode(haxe.crypto.Md5.bytes2blks(b));
	var out = haxe.io.Bytes.alloc(16);
	var p = 0;
	var _g = 0;
	while(_g < 4) {
		var i = _g++;
		out.b[p++] = h[i] & 255 & 255;
		out.b[p++] = h[i] >> 8 & 255 & 255;
		out.b[p++] = h[i] >> 16 & 255 & 255;
		out.b[p++] = h[i] >>> 24 & 255;
	}
	return out;
}
haxe.crypto.Md5.bytes2blks = function(b) {
	var nblk = (b.length + 8 >> 6) + 1;
	var blks = new Array();
	var blksSize = nblk * 16;
	var _g = 0;
	while(_g < blksSize) {
		var i = _g++;
		blks[i] = 0;
	}
	var i = 0;
	while(i < b.length) {
		blks[i >> 2] |= b.b[i] << (((b.length << 3) + i & 3) << 3);
		i++;
	}
	blks[i >> 2] |= 128 << (b.length * 8 + i) % 4 * 8;
	var l = b.length * 8;
	var k = nblk * 16 - 2;
	blks[k] = l & 255;
	blks[k] |= (l >>> 8 & 255) << 8;
	blks[k] |= (l >>> 16 & 255) << 16;
	blks[k] |= (l >>> 24 & 255) << 24;
	return blks;
}
haxe.crypto.Md5.str2blks = function(str) {
	var nblk = (str.length + 8 >> 6) + 1;
	var blks = new Array();
	var blksSize = nblk * 16;
	var _g = 0;
	while(_g < blksSize) {
		var i = _g++;
		blks[i] = 0;
	}
	var i = 0;
	while(i < str.length) {
		blks[i >> 2] |= HxOverrides.cca(str,i) << (str.length * 8 + i) % 4 * 8;
		i++;
	}
	blks[i >> 2] |= 128 << (str.length * 8 + i) % 4 * 8;
	var l = str.length * 8;
	var k = nblk * 16 - 2;
	blks[k] = l & 255;
	blks[k] |= (l >>> 8 & 255) << 8;
	blks[k] |= (l >>> 16 & 255) << 16;
	blks[k] |= (l >>> 24 & 255) << 24;
	return blks;
}
haxe.crypto.Md5.prototype = {
	doEncode: function(x) {
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var step;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			step = 0;
			a = this.ff(a,b,c,d,x[i],7,-680876936);
			d = this.ff(d,a,b,c,x[i + 1],12,-389564586);
			c = this.ff(c,d,a,b,x[i + 2],17,606105819);
			b = this.ff(b,c,d,a,x[i + 3],22,-1044525330);
			a = this.ff(a,b,c,d,x[i + 4],7,-176418897);
			d = this.ff(d,a,b,c,x[i + 5],12,1200080426);
			c = this.ff(c,d,a,b,x[i + 6],17,-1473231341);
			b = this.ff(b,c,d,a,x[i + 7],22,-45705983);
			a = this.ff(a,b,c,d,x[i + 8],7,1770035416);
			d = this.ff(d,a,b,c,x[i + 9],12,-1958414417);
			c = this.ff(c,d,a,b,x[i + 10],17,-42063);
			b = this.ff(b,c,d,a,x[i + 11],22,-1990404162);
			a = this.ff(a,b,c,d,x[i + 12],7,1804603682);
			d = this.ff(d,a,b,c,x[i + 13],12,-40341101);
			c = this.ff(c,d,a,b,x[i + 14],17,-1502002290);
			b = this.ff(b,c,d,a,x[i + 15],22,1236535329);
			a = this.gg(a,b,c,d,x[i + 1],5,-165796510);
			d = this.gg(d,a,b,c,x[i + 6],9,-1069501632);
			c = this.gg(c,d,a,b,x[i + 11],14,643717713);
			b = this.gg(b,c,d,a,x[i],20,-373897302);
			a = this.gg(a,b,c,d,x[i + 5],5,-701558691);
			d = this.gg(d,a,b,c,x[i + 10],9,38016083);
			c = this.gg(c,d,a,b,x[i + 15],14,-660478335);
			b = this.gg(b,c,d,a,x[i + 4],20,-405537848);
			a = this.gg(a,b,c,d,x[i + 9],5,568446438);
			d = this.gg(d,a,b,c,x[i + 14],9,-1019803690);
			c = this.gg(c,d,a,b,x[i + 3],14,-187363961);
			b = this.gg(b,c,d,a,x[i + 8],20,1163531501);
			a = this.gg(a,b,c,d,x[i + 13],5,-1444681467);
			d = this.gg(d,a,b,c,x[i + 2],9,-51403784);
			c = this.gg(c,d,a,b,x[i + 7],14,1735328473);
			b = this.gg(b,c,d,a,x[i + 12],20,-1926607734);
			a = this.hh(a,b,c,d,x[i + 5],4,-378558);
			d = this.hh(d,a,b,c,x[i + 8],11,-2022574463);
			c = this.hh(c,d,a,b,x[i + 11],16,1839030562);
			b = this.hh(b,c,d,a,x[i + 14],23,-35309556);
			a = this.hh(a,b,c,d,x[i + 1],4,-1530992060);
			d = this.hh(d,a,b,c,x[i + 4],11,1272893353);
			c = this.hh(c,d,a,b,x[i + 7],16,-155497632);
			b = this.hh(b,c,d,a,x[i + 10],23,-1094730640);
			a = this.hh(a,b,c,d,x[i + 13],4,681279174);
			d = this.hh(d,a,b,c,x[i],11,-358537222);
			c = this.hh(c,d,a,b,x[i + 3],16,-722521979);
			b = this.hh(b,c,d,a,x[i + 6],23,76029189);
			a = this.hh(a,b,c,d,x[i + 9],4,-640364487);
			d = this.hh(d,a,b,c,x[i + 12],11,-421815835);
			c = this.hh(c,d,a,b,x[i + 15],16,530742520);
			b = this.hh(b,c,d,a,x[i + 2],23,-995338651);
			a = this.ii(a,b,c,d,x[i],6,-198630844);
			d = this.ii(d,a,b,c,x[i + 7],10,1126891415);
			c = this.ii(c,d,a,b,x[i + 14],15,-1416354905);
			b = this.ii(b,c,d,a,x[i + 5],21,-57434055);
			a = this.ii(a,b,c,d,x[i + 12],6,1700485571);
			d = this.ii(d,a,b,c,x[i + 3],10,-1894986606);
			c = this.ii(c,d,a,b,x[i + 10],15,-1051523);
			b = this.ii(b,c,d,a,x[i + 1],21,-2054922799);
			a = this.ii(a,b,c,d,x[i + 8],6,1873313359);
			d = this.ii(d,a,b,c,x[i + 15],10,-30611744);
			c = this.ii(c,d,a,b,x[i + 6],15,-1560198380);
			b = this.ii(b,c,d,a,x[i + 13],21,1309151649);
			a = this.ii(a,b,c,d,x[i + 4],6,-145523070);
			d = this.ii(d,a,b,c,x[i + 11],10,-1120210379);
			c = this.ii(c,d,a,b,x[i + 2],15,718787259);
			b = this.ii(b,c,d,a,x[i + 9],21,-343485551);
			a = this.addme(a,olda);
			b = this.addme(b,oldb);
			c = this.addme(c,oldc);
			d = this.addme(d,oldd);
			i += 16;
		}
		return [a,b,c,d];
	}
	,ii: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(c,this.bitOR(b,~d)),a,b,x,s,t);
	}
	,hh: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(this.bitXOR(b,c),d),a,b,x,s,t);
	}
	,gg: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,d),this.bitAND(c,~d)),a,b,x,s,t);
	}
	,ff: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,c),this.bitAND(~b,d)),a,b,x,s,t);
	}
	,cmn: function(q,a,b,x,s,t) {
		return this.addme(this.rol(this.addme(this.addme(a,q),this.addme(x,t)),s),b);
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,hex: function(a) {
		var str = "";
		var hex_chr = "0123456789abcdef";
		var _g = 0;
		while(_g < a.length) {
			var num = a[_g];
			++_g;
			var _g1 = 0;
			while(_g1 < 4) {
				var j = _g1++;
				str += hex_chr.charAt(num >> j * 8 + 4 & 15) + hex_chr.charAt(num >> j * 8 & 15);
			}
		}
		return str;
	}
	,addme: function(x,y) {
		var lsw = (x & 65535) + (y & 65535);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return msw << 16 | lsw & 65535;
	}
	,bitAND: function(a,b) {
		var lsb = a & 1 & (b & 1);
		var msb31 = a >>> 1 & b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitXOR: function(a,b) {
		var lsb = a & 1 ^ b & 1;
		var msb31 = a >>> 1 ^ b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitOR: function(a,b) {
		var lsb = a & 1 | b & 1;
		var msb31 = a >>> 1 | b >>> 1;
		return msb31 << 1 | lsb;
	}
	,__class__: haxe.crypto.Md5
}
haxe.ds.BalancedTree = function() {
};
$hxClasses["haxe.ds.BalancedTree"] = haxe.ds.BalancedTree;
haxe.ds.BalancedTree.__name__ = ["haxe","ds","BalancedTree"];
haxe.ds.BalancedTree.prototype = {
	toString: function() {
		return "{" + this.root.toString() + "}";
	}
	,compare: function(k1,k2) {
		return Reflect.compare(k1,k2);
	}
	,balance: function(l,k,v,r) {
		var hl = l == null?0:l._height;
		var hr = r == null?0:r._height;
		return hl > hr + 2?(function($this) {
			var $r;
			var _this = l.left;
			$r = _this == null?0:_this._height;
			return $r;
		}(this)) >= (function($this) {
			var $r;
			var _this = l.right;
			$r = _this == null?0:_this._height;
			return $r;
		}(this))?new haxe.ds.TreeNode(l.left,l.key,l.value,new haxe.ds.TreeNode(l.right,k,v,r)):new haxe.ds.TreeNode(new haxe.ds.TreeNode(l.left,l.key,l.value,l.right.left),l.right.key,l.right.value,new haxe.ds.TreeNode(l.right.right,k,v,r)):hr > hl + 2?(function($this) {
			var $r;
			var _this = r.right;
			$r = _this == null?0:_this._height;
			return $r;
		}(this)) > (function($this) {
			var $r;
			var _this = r.left;
			$r = _this == null?0:_this._height;
			return $r;
		}(this))?new haxe.ds.TreeNode(new haxe.ds.TreeNode(l,k,v,r.left),r.key,r.value,r.right):new haxe.ds.TreeNode(new haxe.ds.TreeNode(l,k,v,r.left.left),r.left.key,r.left.value,new haxe.ds.TreeNode(r.left.right,r.key,r.value,r.right)):new haxe.ds.TreeNode(l,k,v,r,(hl > hr?hl:hr) + 1);
	}
	,removeMinBinding: function(t) {
		return t.left == null?t.right:this.balance(this.removeMinBinding(t.left),t.key,t.value,t.right);
	}
	,minBinding: function(t) {
		return t == null?(function($this) {
			var $r;
			throw "Not_found";
			return $r;
		}(this)):t.left == null?t:this.minBinding(t.left);
	}
	,merge: function(t1,t2) {
		if(t1 == null) return t2;
		if(t2 == null) return t1;
		var t = this.minBinding(t2);
		return this.balance(t1,t.key,t.value,this.removeMinBinding(t2));
	}
	,keysLoop: function(node,acc) {
		if(node != null) {
			this.keysLoop(node.left,acc);
			acc.push(node.key);
			this.keysLoop(node.right,acc);
		}
	}
	,iteratorLoop: function(node,acc) {
		if(node != null) {
			this.iteratorLoop(node.left,acc);
			acc.push(node.value);
			this.iteratorLoop(node.right,acc);
		}
	}
	,removeLoop: function(k,node) {
		if(node == null) throw "Not_found";
		var c = this.compare(k,node.key);
		return c == 0?this.merge(node.left,node.right):c < 0?this.balance(this.removeLoop(k,node.left),node.key,node.value,node.right):this.balance(node.left,node.key,node.value,this.removeLoop(k,node.right));
	}
	,setLoop: function(k,v,node) {
		if(node == null) return new haxe.ds.TreeNode(null,k,v,null);
		var c = this.compare(k,node.key);
		return c == 0?new haxe.ds.TreeNode(node.left,k,v,node.right,node == null?0:node._height):c < 0?(function($this) {
			var $r;
			var nl = $this.setLoop(k,v,node.left);
			$r = $this.balance(nl,node.key,node.value,node.right);
			return $r;
		}(this)):(function($this) {
			var $r;
			var nr = $this.setLoop(k,v,node.right);
			$r = $this.balance(node.left,node.key,node.value,nr);
			return $r;
		}(this));
	}
	,keys: function() {
		var ret = [];
		this.keysLoop(this.root,ret);
		return HxOverrides.iter(ret);
	}
	,iterator: function() {
		var ret = [];
		this.iteratorLoop(this.root,ret);
		return HxOverrides.iter(ret);
	}
	,exists: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) return true; else if(c < 0) node = node.left; else node = node.right;
		}
		return false;
	}
	,remove: function(key) {
		try {
			this.root = this.removeLoop(key,this.root);
			return true;
		} catch( e ) {
			if( js.Boot.__instanceof(e,String) ) {
				return false;
			} else throw(e);
		}
	}
	,get: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) return node.value;
			if(c < 0) node = node.left; else node = node.right;
		}
		return null;
	}
	,set: function(key,value) {
		this.root = this.setLoop(key,value,this.root);
	}
	,root: null
	,__class__: haxe.ds.BalancedTree
}
haxe.ds.TreeNode = function(l,k,v,r,h) {
	if(h == null) h = -1;
	this.left = l;
	this.key = k;
	this.value = v;
	this.right = r;
	if(h == -1) this._height = ((function($this) {
		var $r;
		var _this = $this.left;
		$r = _this == null?0:_this._height;
		return $r;
	}(this)) > (function($this) {
		var $r;
		var _this = $this.right;
		$r = _this == null?0:_this._height;
		return $r;
	}(this))?(function($this) {
		var $r;
		var _this = $this.left;
		$r = _this == null?0:_this._height;
		return $r;
	}(this)):(function($this) {
		var $r;
		var _this = $this.right;
		$r = _this == null?0:_this._height;
		return $r;
	}(this))) + 1; else this._height = h;
};
$hxClasses["haxe.ds.TreeNode"] = haxe.ds.TreeNode;
haxe.ds.TreeNode.__name__ = ["haxe","ds","TreeNode"];
haxe.ds.TreeNode.prototype = {
	toString: function() {
		return (this.left == null?"":this.left.toString() + ", ") + ("" + Std.string(this.key) + "=" + Std.string(this.value)) + (this.right == null?"":", " + this.right.toString());
	}
	,_height: null
	,value: null
	,key: null
	,right: null
	,left: null
	,__class__: haxe.ds.TreeNode
}
haxe.ds.EnumValueMap = function() {
	haxe.ds.BalancedTree.call(this);
};
$hxClasses["haxe.ds.EnumValueMap"] = haxe.ds.EnumValueMap;
haxe.ds.EnumValueMap.__name__ = ["haxe","ds","EnumValueMap"];
haxe.ds.EnumValueMap.__interfaces__ = [IMap];
haxe.ds.EnumValueMap.__super__ = haxe.ds.BalancedTree;
haxe.ds.EnumValueMap.prototype = $extend(haxe.ds.BalancedTree.prototype,{
	compareArgs: function(a1,a2) {
		var ld = a1.length - a2.length;
		if(ld != 0) return ld;
		var _g1 = 0, _g = a1.length;
		while(_g1 < _g) {
			var i = _g1++;
			var v1 = a1[i], v2 = a2[i];
			var d = Reflect.isEnumValue(v1) && Reflect.isEnumValue(v2)?this.compare(v1,v2):Reflect.compare(v1,v2);
			if(d != 0) return d;
		}
		return 0;
	}
	,compare: function(k1,k2) {
		var d = k1[1] - k2[1];
		if(d != 0) return d;
		var p1 = k1.slice(2);
		var p2 = k2.slice(2);
		if(p1.length == 0 && p2.length == 0) return 0;
		return this.compareArgs(p1,p2);
	}
	,__class__: haxe.ds.EnumValueMap
});
haxe.ds._HashMap = {}
haxe.ds._HashMap.HashMap_Impl_ = function() { }
$hxClasses["haxe.ds._HashMap.HashMap_Impl_"] = haxe.ds._HashMap.HashMap_Impl_;
haxe.ds._HashMap.HashMap_Impl_.__name__ = ["haxe","ds","_HashMap","HashMap_Impl_"];
haxe.ds._HashMap.HashMap_Impl_._new = function() {
	return { keys : new haxe.ds.IntMap(), values : new haxe.ds.IntMap()};
}
haxe.ds._HashMap.HashMap_Impl_.set = function(this1,k,v) {
	this1.keys.set(k.hashCode(),k);
	this1.values.set(k.hashCode(),v);
}
haxe.ds._HashMap.HashMap_Impl_.get = function(this1,k) {
	return this1.values.get(k.hashCode());
}
haxe.ds._HashMap.HashMap_Impl_.exists = function(this1,k) {
	return this1.values.exists(k.hashCode());
}
haxe.ds._HashMap.HashMap_Impl_.remove = function(this1,k) {
	this1.values.remove(k.hashCode());
	return this1.keys.remove(k.hashCode());
}
haxe.ds._HashMap.HashMap_Impl_.keys = function(this1) {
	return this1.keys.iterator();
}
haxe.ds._HashMap.HashMap_Impl_.iterator = function(this1) {
	return this1.values.iterator();
}
haxe.ds.IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe.ds.IntMap;
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += " => ";
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += ", ";
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,h: null
	,__class__: haxe.ds.IntMap
}
haxe.ds.ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
$hxClasses["haxe.ds.ObjectMap"] = haxe.ds.ObjectMap;
haxe.ds.ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe.ds.ObjectMap.__interfaces__ = [IMap];
haxe.ds.ObjectMap.assignId = function(obj) {
	return obj.__id__ = ++haxe.ds.ObjectMap.count;
}
haxe.ds.ObjectMap.getId = function(obj) {
	return obj.__id__;
}
haxe.ds.ObjectMap.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(Std.string(i));
			s.b += " => ";
			s.b += Std.string(Std.string(this.h[i.__id__]));
			if(it.hasNext()) s.b += ", ";
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i.__id__];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		var id = key.__id__;
		if(!this.h.hasOwnProperty(id)) return false;
		delete(this.h[id]);
		delete(this.h.__keys__[id]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key.__id__);
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,set: function(key,value) {
		var id = key.__id__ != null?key.__id__:key.__id__ = ++haxe.ds.ObjectMap.count;
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,h: null
	,__class__: haxe.ds.ObjectMap
}
haxe.ds.WeakMap = function() {
	throw "Not implemented for this platform";
};
$hxClasses["haxe.ds.WeakMap"] = haxe.ds.WeakMap;
haxe.ds.WeakMap.__name__ = ["haxe","ds","WeakMap"];
haxe.ds.WeakMap.__interfaces__ = [IMap];
haxe.ds.WeakMap.prototype = {
	toString: function() {
		return null;
	}
	,iterator: function() {
		return null;
	}
	,keys: function() {
		return null;
	}
	,remove: function(key) {
		return false;
	}
	,exists: function(key) {
		return false;
	}
	,get: function(key) {
		return null;
	}
	,set: function(key,value) {
	}
	,__class__: haxe.ds.WeakMap
}
haxe.io = {}
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
$hxClasses["haxe.io.Bytes"] = haxe.io.Bytes;
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0, _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.charCodeAt(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.fastGet = function(b,pos) {
	return b[pos];
}
haxe.io.Bytes.prototype = {
	getData: function() {
		return this.b;
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g1 = 0, _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length?this.length:other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,get: function(pos) {
		return this.b[pos];
	}
	,b: null
	,length: null
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
haxe.xml = {}
haxe.xml.Parser = function() { }
$hxClasses["haxe.xml.Parser"] = haxe.xml.Parser;
haxe.xml.Parser.__name__ = ["haxe","xml","Parser"];
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
}
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start));
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				next = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.get_nodeName()) throw "Expected </" + parent.get_nodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var i = s.charCodeAt(1) == 120?Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)):Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += Std.string(String.fromCharCode(i));
				} else if(!haxe.xml.Parser.escapes.exists(s)) buf.b += Std.string("&" + s + ";"); else buf.b += Std.string(haxe.xml.Parser.escapes.get(s));
				start = p + 1;
				state = next;
			}
			break;
		}
		c = str.charCodeAt(++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
}
haxe.xml.Parser.isValidChar = function(c) {
	return c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45;
}
var ios = {}
ios.SKSegment = function(label,w,h,buttonPosition,colors) {
	RCSkin.call(this,colors);
	var segmentLeft;
	var segmentMiddle;
	var segmentRight;
	var segmentLeftSelected;
	var segmentMiddleSelected;
	var segmentRightSelected;
	switch(buttonPosition) {
	case "left":
		segmentLeft = "LL";
		segmentMiddle = "M";
		segmentRight = "M";
		segmentLeftSelected = "LL";
		segmentMiddleSelected = "M";
		segmentRightSelected = "LR";
		break;
	case "right":
		segmentLeft = "M";
		segmentMiddle = "M";
		segmentRight = "RR";
		segmentLeftSelected = "RL";
		segmentMiddleSelected = "M";
		segmentRightSelected = "RR";
		break;
	default:
		segmentLeft = "M";
		segmentMiddle = "M";
		segmentRight = "M";
		segmentLeftSelected = "RL";
		segmentMiddleSelected = "M";
		segmentRightSelected = "LR";
	}
	var hd = RCDevice.currentDevice().dpiScale == 2?"@2x":"";
	var sl = "Resources/ios/RCSegmentedControl/" + segmentLeft + hd + ".png";
	var sm = "Resources/ios/RCSegmentedControl/" + segmentMiddle + hd + ".png";
	var sr = "Resources/ios/RCSegmentedControl/" + segmentRight + hd + ".png";
	this.normal.background = new RCImageStretchable(0,0,sl,sm,sr);
	this.normal.background.set_width(w);
	var slh = "Resources/ios/RCSegmentedControl/" + segmentLeftSelected + "Selected" + hd + ".png";
	var smh = "Resources/ios/RCSegmentedControl/" + segmentMiddleSelected + "Selected" + hd + ".png";
	var srh = "Resources/ios/RCSegmentedControl/" + segmentRightSelected + "Selected" + hd + ".png";
	this.highlighted.background = new RCImageStretchable(0,0,slh,smh,srh);
	this.highlighted.background.set_width(w);
	var font = RCFont.boldSystemFontOfSize(13);
	font.align = "center";
	font.color = 3355443;
	this.normal.label = new RCTextView(0,0,w,null,label,font);
	this.normal.label.set_y(Math.round((h - 20) / 2));
	font.color = 16777215;
	this.highlighted.label = new RCTextView(0,0,w,null,label,font);
	this.highlighted.label.set_y(Math.round((h - 20) / 2));
	this.hit = new RCRectangle(0,0,w,h,0);
};
$hxClasses["ios.SKSegment"] = ios.SKSegment;
ios.SKSegment.__name__ = ["ios","SKSegment"];
ios.SKSegment.__super__ = RCSkin;
ios.SKSegment.prototype = $extend(RCSkin.prototype,{
	__class__: ios.SKSegment
});
ios.SKSlider = function() {
	RCSkin.call(this,null);
	var hd = RCDevice.currentDevice().dpiScale == 2?"@2x":"";
	var sl = "Resources/ios/RCSlider/L" + hd + ".png";
	var sm = "Resources/ios/RCSlider/M" + hd + ".png";
	var sr = "Resources/ios/RCSlider/R" + hd + ".png";
	var ss = "Resources/ios/RCSlider/Scrubber" + hd + ".png";
	this.normal.background = new RCImageStretchable(0,0,sl,sm,sr);
	this.normal.otherView = new RCImage(0,0,ss);
	var sls = "Resources/ios/RCSlider/LSelected" + hd + ".png";
	var sms = "Resources/ios/RCSlider/MSelected" + hd + ".png";
	var srs = "Resources/ios/RCSlider/RSelected" + hd + ".png";
	var sss = "Resources/ios/RCSlider/ScrubberSelected" + hd + ".png";
	this.highlighted.background = new RCImageStretchable(0,0,sls,sms,srs);
	this.highlighted.otherView = new RCImage(0,0,sss);
	this.hit = new JSView(0,0);
};
$hxClasses["ios.SKSlider"] = ios.SKSlider;
ios.SKSlider.__name__ = ["ios","SKSlider"];
ios.SKSlider.__super__ = RCSkin;
ios.SKSlider.prototype = $extend(RCSkin.prototype,{
	__class__: ios.SKSlider
});
ios.SKTabBarItem = function(label,linkage,colors) {
	RCSkin.call(this,colors);
	this.normal.background = new JSView(0,0,80,50);
	var sn = RCAssets.getFileWithKey(linkage);
	sn.set_x(25);
	sn.set_y(3);
	this.normal.background.addChild(sn);
	this.normal.label = new RCTextView(0,30,78,null,label,RCFontManager.getFont("regular",{ color : 13421772, align : "center"}));
	this.highlighted.background = new JSView(0,0);
	this.highlighted.background.addChild(new RCRectangle(0,0,78,45,16777215,0.2,6));
	var sh = RCAssets.getFileWithKey(linkage + "Selected");
	sh.set_x(25);
	sh.set_y(3);
	this.highlighted.background.addChild(sh);
	this.highlighted.label = new RCTextView(0,30,78,null,label,RCFontManager.getFont("regular",{ color : 16777215, align : "center"}));
	this.hit = new RCRectangle(0,0,78,45,3355443,0);
};
$hxClasses["ios.SKTabBarItem"] = ios.SKTabBarItem;
ios.SKTabBarItem.__name__ = ["ios","SKTabBarItem"];
ios.SKTabBarItem.__super__ = RCSkin;
ios.SKTabBarItem.prototype = $extend(RCSkin.prototype,{
	__class__: ios.SKTabBarItem
});
var js = {}
js.Boot = function() { }
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0, _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js.Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Browser = function() { }
$hxClasses["js.Browser"] = js.Browser;
js.Browser.__name__ = ["js","Browser"];
js.Browser.getLocalStorage = function() {
	try {
		var s = js.Browser.window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
}
js.Browser.getSessionStorage = function() {
	try {
		var s = js.Browser.window.sessionStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
}
js.Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw "Unable to create XMLHttpRequest object.";
}
js.Cookie = function() { }
$hxClasses["js.Cookie"] = js.Cookie;
js.Cookie.__name__ = ["js","Cookie"];
js.Cookie.set = function(name,value,expireDelay,path,domain) {
	var s = name + "=" + StringTools.urlEncode(value);
	if(expireDelay != null) {
		var d = DateTools.delta(new Date(),expireDelay * 1000);
		s += ";expires=" + d.toGMTString();
	}
	if(path != null) s += ";path=" + path;
	if(domain != null) s += ";domain=" + domain;
	js.Browser.document.cookie = s;
}
js.Cookie.all = function() {
	var h = new haxe.ds.StringMap();
	var a = js.Browser.document.cookie.split(";");
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		e = StringTools.ltrim(e);
		var t = e.split("=");
		if(t.length < 2) continue;
		h.set(t[0],StringTools.urlDecode(t[1]));
	}
	return h;
}
js.Cookie.get = function(name) {
	return js.Cookie.all().get(name);
}
js.Cookie.exists = function(name) {
	return js.Cookie.all().exists(name);
}
js.Cookie.remove = function(name,path,domain) {
	js.Cookie.set(name,"",-10,path,domain);
}
js.Lib = function() { }
$hxClasses["js.Lib"] = js.Lib;
js.Lib.__name__ = ["js","Lib"];
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib["eval"] = function(code) {
	return eval(code);
}
js.html = {}
js.html._CanvasElement = {}
js.html._CanvasElement.CanvasUtil = function() { }
$hxClasses["js.html._CanvasElement.CanvasUtil"] = js.html._CanvasElement.CanvasUtil;
js.html._CanvasElement.CanvasUtil.__name__ = ["js","html","_CanvasElement","CanvasUtil"];
js.html._CanvasElement.CanvasUtil.getContextWebGL = function(canvas,attribs) {
	var _g = 0, _g1 = ["webgl","experimental-webgl"];
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		var ctx = canvas.getContext(name,attribs);
		if(ctx != null) return ctx;
	}
	return null;
}
var pathfinding = {}
pathfinding.GKAstar = function(n_graph,src,tar) {
	this.graph = n_graph;
	this.source = src;
	this.target = tar;
	this.SPT = new Array();
	this.G_Cost = new Array();
	this.F_Cost = new Array();
	this.SF = new Array();
	this.search();
};
$hxClasses["pathfinding.GKAstar"] = pathfinding.GKAstar;
pathfinding.GKAstar.__name__ = ["pathfinding","GKAstar"];
pathfinding.GKAstar.prototype = {
	getPath: function() {
		var path = new Array();
		var nodes = new Array();
		if(this.target < 0) return nodes;
		var nd = this.target;
		path.push(nd);
		while(nd != this.source && this.SPT[nd] != null) {
			nd = this.SPT[nd].from;
			path.push(nd);
		}
		path.reverse();
		var _g1 = 0, _g = path.length;
		while(_g1 < _g) {
			var i = _g1++;
			nodes.push(this.graph.getNode(path[i]));
		}
		return nodes;
	}
	,search: function() {
		var pq = new pathfinding.IndexedPriorityQ(this.F_Cost);
		pq.insert(this.source);
		while(!pq.isEmpty()) {
			var NCN = pq.pop();
			this.SPT[NCN] = this.SF[NCN];
			if(NCN == this.target) return;
			var edges = this.graph.getEdges(NCN);
			var _g = 0;
			while(_g < edges.length) {
				var edge = edges[_g];
				++_g;
				var Hcost = RCVector.distanceBetween(this.graph.getNode(edge.to).pos,this.graph.getNode(this.target).pos);
				var Gcost = this.G_Cost[NCN] + edge.cost;
				var to = edge.to;
				if(this.SF[edge.to] == null) {
					this.F_Cost[edge.to] = Gcost + Hcost;
					this.G_Cost[edge.to] = Gcost;
					pq.insert(edge.to);
					this.SF[edge.to] = edge;
				} else if(Gcost < this.G_Cost[edge.to] && this.SPT[edge.to] == null) {
					this.F_Cost[edge.to] = Gcost + Hcost;
					this.G_Cost[edge.to] = Gcost;
					pq.reorderUp();
					this.SF[edge.to] = edge;
				}
			}
		}
	}
	,target: null
	,source: null
	,SF: null
	,F_Cost: null
	,G_Cost: null
	,SPT: null
	,graph: null
	,__class__: pathfinding.GKAstar
}
pathfinding.GKEdge = function(n_From,n_To,n_Cost) {
	if(n_Cost == null) n_Cost = 1.0;
	this.from = n_From;
	this.to = n_To;
	this.cost = n_Cost;
};
$hxClasses["pathfinding.GKEdge"] = pathfinding.GKEdge;
pathfinding.GKEdge.__name__ = ["pathfinding","GKEdge"];
pathfinding.GKEdge.prototype = {
	cost: null
	,to: null
	,from: null
	,__class__: pathfinding.GKEdge
}
pathfinding.GKGraph = function() {
	this.nodes = new Array();
	this.edges = new Array();
};
$hxClasses["pathfinding.GKGraph"] = pathfinding.GKGraph;
pathfinding.GKGraph.__name__ = ["pathfinding","GKGraph"];
pathfinding.GKGraph.getNextIndex = function() {
	return pathfinding.GKGraph.nextIndex;
}
pathfinding.GKGraph.prototype = {
	numNodes: function() {
		return this.nodes.length;
	}
	,validIndex: function(idx) {
		return idx >= 0 && idx <= pathfinding.GKGraph.nextIndex;
	}
	,getEdges: function(node) {
		return this.edges[node];
	}
	,addEdge: function(edge) {
		if(this.validIndex(edge.to) && this.validIndex(edge.from)) {
			if(this.getEdge(edge.from,edge.to) == null) this.edges[edge.from].push(edge);
		}
	}
	,addNode: function(node) {
		if(this.validIndex(node.index)) {
			this.nodes.push(node);
			this.edges.push(new Array());
			pathfinding.GKGraph.nextIndex++;
		}
		return 0;
	}
	,getEdge: function(from,to) {
		var fromEdges = this.edges[from];
		var _g1 = 0, _g = fromEdges.length;
		while(_g1 < _g) {
			var a = _g1++;
			if(fromEdges[a].to == to) return fromEdges[a];
		}
		return null;
	}
	,getNode: function(idx) {
		return this.nodes[idx];
	}
	,edges: null
	,nodes: null
	,__class__: pathfinding.GKGraph
}
pathfinding.GKGrapher = function(cells,n_graph,valuesToIgnore) {
	this.cells = cells;
	var cellsX = cells.length;
	var cellsY = cells.length;
	var dx = 1;
	var dy = 1;
	var _g = 0;
	while(_g < cellsX) {
		var x = _g++;
		var _g1 = 0;
		while(_g1 < cellsY) {
			var y = _g1++;
			var node = new pathfinding.GKNode(pathfinding.GKGraph.getNextIndex(),new RCVector(x * dx,y * dy));
			n_graph.addNode(node);
		}
	}
	var _g = 0;
	while(_g < cellsX) {
		var node_x = _g++;
		var _g1 = 0;
		while(_g1 < cellsY) {
			var node_y = _g1++;
			var cell = cells[node_y][node_x];
			if(cell < 0 || cell == 20) this.addNeighbours(n_graph,node_y,node_x,cellsX,cellsY);
		}
	}
};
$hxClasses["pathfinding.GKGrapher"] = pathfinding.GKGrapher;
pathfinding.GKGrapher.__name__ = ["pathfinding","GKGrapher"];
pathfinding.GKGrapher.prototype = {
	addNeighbours: function(n_graph,row,col,cellsX,cellsY) {
		var cc = this.cells[row][col];
		var _g = -1;
		while(_g < 1) {
			var i = _g++;
			var _g1 = -1;
			while(_g1 < 1) {
				var j = _g1++;
				var nodeY = row + j;
				var nodeX = col + i;
				if(i == 0 && j == 0) continue;
				if(nodeX >= 0 && nodeX < cellsX && nodeY >= 0 && nodeY < cellsY) {
					var nc = this.cells[nodeY][nodeX];
					if(nc >= 0 && nc != 20) continue;
					if(cc == -6 && i == -1 && j == 1) continue;
					if(cc == -7 && i == 1 && j == 1) continue;
					if(cc == -8 && i == 1 && j == -1) continue;
					if(nc == -6 && i == 1 && j == -1) continue;
					if(nc == -7 && i == -1 && j == -1) continue;
					if(nc == -8 && i == -1 && j == 1) continue;
					var nodeIdx = Math.round(col * cellsY + row);
					var nIdx = Math.round(nodeX * cellsY + nodeY);
					var nodePos = n_graph.getNode(nodeIdx).pos;
					var neighbourPos = n_graph.getNode(nIdx).pos;
					var cost = RCVector.distanceBetween(nodePos,neighbourPos);
					var edge = new pathfinding.GKEdge(nodeIdx,nIdx,cost);
					n_graph.addEdge(edge);
				}
			}
		}
	}
	,valuesToIgnore: null
	,cells: null
	,__class__: pathfinding.GKGrapher
}
pathfinding.GKNode = function(idx,n_Pos) {
	this.index = idx;
	this.pos = n_Pos;
};
$hxClasses["pathfinding.GKNode"] = pathfinding.GKNode;
pathfinding.GKNode.__name__ = ["pathfinding","GKNode"];
pathfinding.GKNode.prototype = {
	pos: null
	,index: null
	,__class__: pathfinding.GKNode
}
pathfinding.IndexedPriorityQ = function(n_keys) {
	this.keys = n_keys;
	this.data = new Array();
};
$hxClasses["pathfinding.IndexedPriorityQ"] = pathfinding.IndexedPriorityQ;
pathfinding.IndexedPriorityQ.__name__ = ["pathfinding","IndexedPriorityQ"];
pathfinding.IndexedPriorityQ.prototype = {
	isEmpty: function() {
		return this.data.length == 0;
	}
	,reorderDown: function() {
		var _g1 = 0, _g = this.data.length - 1;
		while(_g1 < _g) {
			var a = _g1++;
			if(this.keys[this.data[a]] > this.keys[this.data[a + 1]]) {
				var tmp = this.data[a];
				this.data[a] = this.data[a + 1];
				this.data[a + 1] = tmp;
			} else return;
		}
	}
	,reorderUp: function() {
		var a = this.data.length - 1;
		while(a > 0) if(this.keys[this.data[a]] < this.keys[this.data[a - 1]]) {
			var tmp = this.data[a];
			this.data[a] = this.data[a - 1];
			this.data[a - 1] = tmp;
			a--;
		} else return;
	}
	,pop: function() {
		var rtn = this.data[0];
		this.data[0] = this.data[this.data.length - 1];
		this.data.pop();
		this.reorderDown();
		return rtn;
	}
	,insert: function(idx) {
		this.data[this.data.length] = idx;
		this.reorderUp();
	}
	,data: null
	,keys: null
	,__class__: pathfinding.IndexedPriorityQ
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
var Void = $hxClasses.Void = { __ename__ : ["Void"]};
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0, _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
if(Array.prototype.filter == null) Array.prototype.filter = function(f) {
	var a = [];
	var _g1 = 0, _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		var e = this[i];
		if(f(e)) a.push(e);
	}
	return a;
};
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.ProcessingInstruction = "processingInstruction";
Xml.Document = "document";
if(typeof(JSON) != "undefined") haxe.Json = JSON;
ColorMatrix.LENGTH = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1.0].length;
Csv.DEFAULT_SPLITTER = ",";
Csv.LINE_SPLITTER = "\n";
Csv.T_SPLITTER = "\t";
DateTools.DAYS_OF_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31];
EVLoop.FPS = 60;
EVMouse.UP = "mouseup";
EVMouse.DOWN = "mousedown";
EVMouse.OVER = "mouseover";
EVMouse.OUT = "mouseout";
EVMouse.MOVE = "mousemove";
EVMouse.CLICK = "mouseclick";
EVMouse.DOUBLE_CLICK = "mousedoubleclick";
EVMouse.WHEEL = "mousewheel";
EVTouch.DOWN = "touchstart";
EVTouch.UP = "touchend";
EVTouch.MOVE = "touchmove";
EVTouch.OVER = "touchenter";
EVTouch.OUT = "touchleave";
EVTouch.CANCEL = "touchcancel";
EVTouch.TAP = "touchtap";
Facebook.GRAPH_URL = "https://graph.facebook.com";
Facebook.API_URL = "https://api.facebook.com";
Facebook.AUTH_URL_SECURE = "https://graph.facebook.com/oauth/authorize";
Facebook.LOGIN_URL = "http://m.facebook.com/login.php";
Facebook.LOGIN_URL_SECURE = "https://login.facebook.com/login.php";
Facebook.AUTH_URL_CANCEL = "https://graph.facebook.com/oauth/authorize_cancel";
Facebook.LOGOUT_URL = "http://m.facebook.com/logout.php";
Facebook.LOGIN_SUCCESS_URL = "http://www.facebook.com/connect/login_success.html";
Facebook.LOGIN_SUCCESS_SECUREURL = "https://www.facebook.com/connect/login_success.html";
Facebook.LOGIN_FAIL_URL = "http://www.facebook.com/connect/login_success.html?error_reason";
Facebook.LOGIN_FAIL_SECUREURL = "https://www.facebook.com/connect/login_success.html?error_reason";
GKSprite.GRAVITY = 0.98;
JSExternalInterface.available = true;
HXAddress._init = false;
HXAddress._initChange = false;
HXAddress._initChanged = false;
HXAddress._strict = true;
HXAddress._value = "";
HXAddress._queue = new Array();
HXAddress._availability = JSExternalInterface.available;
HXAddress._initializer = HXAddress._initialize();
JSAudio.DISPLAY_TIMER_UPDATE_DELAY = 1000;
JSVideo.BUFFER_TIME = 2;
JSVideo.DEFAULT_VOLUME = 0.8;
JSVideo.DISPLAY_TIMER_UPDATE_DELAY = 1000;
RCAnimation.defaultTimingFunction = eq.Linear.NONE;
RCAnimation.defaultDuration = 0.8;
RCColor.BLACK = 0;
RCColor.WHITE = 16777215;
RCColor.RED = 16711680;
RCColor.GREEN = 65280;
RCColor.BLUE = 255;
RCColor.CYAN = 65535;
RCColor.YELLOW = 16776960;
_RCDraw.LineScaleMode.NONE = null;
RCGestureRecognizer.DELAY_BEFORE_CHANGING_DIRECTION = 10;
Keyboard.LEFT = 37;
Keyboard.RIGHT = 39;
Keyboard.UP = 38;
Keyboard.DOWN = 40;
Keyboard.ENTER = 13;
Keyboard.SPACE = 32;
Keyboard.ESCAPE = 27;
RCLog.ALLOW_TRACES_FROM = [];
RCLog.lastMethod = "";
RCStringTools.DIGITS = "0123456789abcdefghijklmnopqrstuvwxyz";
RCTextRoll.GAP = 20;
TEA.DELTA = -1640531527;
XXTea.DELTA = -1640531527;
Zeta.FIT = "fit";
Zeta.END = "end";
Zeta.ANYWHERE = "anywhere";
Zeta.LOWERCASE = "lowercase";
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
haxe.ds.ObjectMap.count = 0;
haxe.xml.Parser.escapes = (function($this) {
	var $r;
	var h = new haxe.ds.StringMap();
	h.set("lt","<");
	h.set("gt",">");
	h.set("amp","&");
	h.set("quot","\"");
	h.set("apos","'");
	h.set("nbsp",String.fromCharCode(160));
	$r = h;
	return $r;
}(this));
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
js.Browser.location = typeof window != "undefined" ? window.location : null;
js.Browser.navigator = typeof window != "undefined" ? window.navigator : null;
pathfinding.GKGraph.nextIndex = 0;
Main.main();
})();
