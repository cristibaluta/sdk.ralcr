var $hxClasses = $hxClasses || {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var CADelegate = $hxClasses["CADelegate"] = function() {
	this.startPointPassed = false;
	this.kenBurnsPointInPassed = false;
	this.kenBurnsPointOutPassed = false;
};
CADelegate.__name__ = ["CADelegate"];
CADelegate.prototype = {
	kbOut: function() {
		this.kenBurnsPointOutPassed = true;
		if(Reflect.isFunction(this.kenBurnsBeginsFadingOut)) try {
			this.kenBurnsBeginsFadingOut.apply(null,this.kenBurnsArgs);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 66, className : "CADelegate", methodName : "kbOut"});
		}
	}
	,kbIn: function() {
		this.kenBurnsPointInPassed = true;
		if(Reflect.isFunction(this.kenBurnsDidFadedIn)) try {
			this.kenBurnsDidFadedIn.apply(null,this.kenBurnsArgs);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 60, className : "CADelegate", methodName : "kbIn"});
		}
	}
	,repeat: function() {
		if(Reflect.isFunction(this.animationDidReversed)) try {
			this.animationDidReversed.apply(null,this.arguments);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 54, className : "CADelegate", methodName : "repeat"});
		}
	}
	,stop: function() {
		if(Reflect.isFunction(this.animationDidStop)) try {
			this.animationDidStop.apply(null,this.arguments);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 44, className : "CADelegate", methodName : "stop"});
			haxe.Log.trace(this.pos.className + " -> " + this.pos.methodName + " -> " + this.pos.lineNumber,{ fileName : "CADelegate.hx", lineNumber : 45, className : "CADelegate", methodName : "stop"});
			var stack = haxe.Stack.exceptionStack();
			haxe.Log.trace(haxe.Stack.toString(stack),{ fileName : "CADelegate.hx", lineNumber : 47, className : "CADelegate", methodName : "stop"});
		}
	}
	,start: function() {
		this.startPointPassed = true;
		if(Reflect.isFunction(this.animationDidStart)) try {
			this.animationDidStart.apply(null,this.arguments);
		} catch( e ) {
			haxe.Log.trace(e,{ fileName : "CADelegate.hx", lineNumber : 38, className : "CADelegate", methodName : "start"});
		}
	}
	,pos: null
	,kenBurnsPointOut: null
	,kenBurnsPointIn: null
	,kenBurnsPointOutPassed: null
	,kenBurnsPointInPassed: null
	,startPointPassed: null
	,kenBurnsArgs: null
	,kenBurnsBeginsFadingOut: null
	,kenBurnsDidFadedIn: null
	,arguments: null
	,animationDidReversed: null
	,animationDidStop: null
	,animationDidStart: null
	,__class__: CADelegate
}
var CAObject = $hxClasses["CAObject"] = function(target,properties,duration,delay,Eq,pos) {
	this.target = target;
	this.properties = properties;
	this.repeatCount = 0;
	this.autoreverses = false;
	this.fromTime = new Date().getTime();
	this.duration = duration == null?CoreAnimation.defaultDuration:duration <= 0?0.001:duration;
	this.delay = delay == null || delay < 0?0:delay;
	if(Eq == null) this.timingFunction = CoreAnimation.defaultTimingFunction; else this.timingFunction = Eq;
	this.delegate = new CADelegate();
	this.delegate.pos = pos;
	this.fromValues = { };
	this.toValues = { };
};
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
	}
	,initTime: function() {
		this.fromTime = new Date().getTime();
		this.duration = this.duration * 1000;
		this.delay = this.delay * 1000;
	}
	,animate: function(time_diff) {
		throw "CAObject should be extended, use a CATransition (" + Std.string(this.delegate.pos) + ")";
	}
	,init: function() {
		throw "CAObject should be extended, use a CATransition (" + Std.string(this.delegate.pos) + ")";
	}
	,delegate: null
	,constraintBounds: null
	,timingFunction: null
	,autoreverses: null
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
var CATransitionInterface = $hxClasses["CATransitionInterface"] = function() { }
CATransitionInterface.__name__ = ["CATransitionInterface"];
CATransitionInterface.prototype = {
	animate: null
	,init: null
	,__class__: CATransitionInterface
}
var CATween = $hxClasses["CATween"] = function(target,properties,duration,delay,Eq,pos) {
	CAObject.call(this,target,properties,duration,delay,Eq,pos);
};
CATween.__name__ = ["CATween"];
CATween.__interfaces__ = [CATransitionInterface];
CATween.__super__ = CAObject;
CATween.prototype = $extend(CAObject.prototype,{
	animate: function(time_diff) {
		var _g = 0, _g1 = Reflect.fields(this.toValues);
		while(_g < _g1.length) {
			var prop = _g1[_g];
			++_g;
			try {
				var setter = "set" + HxOverrides.substr(prop,0,1).toUpperCase() + HxOverrides.substr(prop,1,null);
				if(setter != null) Reflect.field(this.target,setter).apply(this.target,[this.timingFunction(time_diff,Reflect.field(this.fromValues,prop),Reflect.field(this.toValues,prop) - Reflect.field(this.fromValues,prop),this.duration,null)]);
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 51, className : "CATween", methodName : "animate"});
			}
		}
	}
	,init: function() {
		var _g = 0, _g1 = Reflect.fields(this.properties);
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(js.Boot.__instanceof(Reflect.field(this.properties,p),Int) || js.Boot.__instanceof(Reflect.field(this.properties,p),Float)) {
				var getter = "get" + HxOverrides.substr(p,0,1).toUpperCase() + HxOverrides.substr(p,1,null);
				if(getter == null) this.fromValues[p] = Reflect.field(this.target,p); else this.fromValues[p] = Reflect.field(this.target,getter).apply(this.target,[]);
				this.toValues[p] = Reflect.field(this.properties,p);
			} else try {
				this.fromValues[p] = Reflect.field(Reflect.field(this.properties,p),"fromValue");
				this.target[p] = Reflect.field(this.fromValues,p);
				this.toValues[p] = Reflect.field(Reflect.field(this.properties,p),"toValue");
			} catch( e ) {
				haxe.Log.trace(e,{ fileName : "CATween.hx", lineNumber : 32, className : "CATween", methodName : "init"});
			}
		}
	}
	,__class__: CATween
});
var caequations = caequations || {}
caequations.Linear = $hxClasses["caequations.Linear"] = function() { }
caequations.Linear.__name__ = ["caequations","Linear"];
caequations.Linear.NONE = function(t,b,c,d,p_params) {
	return c * t / d + b;
}
var CoreAnimation = $hxClasses["CoreAnimation"] = function() { }
CoreAnimation.__name__ = ["CoreAnimation"];
CoreAnimation.latest = null;
CoreAnimation.ticker = null;
CoreAnimation.add = function(obj) {
	if(obj == null) return;
	if(obj.target == null) return;
	var a = CoreAnimation.latest;
	var prev = CoreAnimation.latest;
	if(prev != null) prev.next = obj;
	obj.prev = prev;
	CoreAnimation.latest = obj;
	obj.init();
	obj.initTime();
	if(CoreAnimation.ticker == null) {
		CoreAnimation.ticker = new EVLoop();
		CoreAnimation.ticker.setFuncToCall(CoreAnimation.updateAnimations);
	}
}
CoreAnimation.remove = function(obj) {
	if(obj == null) return;
	var a = CoreAnimation.latest;
	while(a != null) {
		if(a.target == obj) CoreAnimation.removeCAObject(a);
		a = a.prev;
	}
}
CoreAnimation.removeCAObject = function(a) {
	if(a.prev != null) a.prev.next = a.next;
	if(a.next != null) a.next.prev = a.prev;
	if(CoreAnimation.latest == a) CoreAnimation.latest = a.prev != null?a.prev:null;
	CoreAnimation.removeTimer();
	a = null;
}
CoreAnimation.removeTimer = function() {
	if(CoreAnimation.latest == null && CoreAnimation.ticker != null) {
		CoreAnimation.ticker.destroy();
		CoreAnimation.ticker = null;
	}
}
CoreAnimation.destroy = function() {
	CoreAnimation.latest = null;
	CoreAnimation.removeTimer();
}
CoreAnimation.updateAnimations = function() {
	var current_time = new Date().getTime();
	var time_diff = 0.0;
	var a = CoreAnimation.latest;
	while(a != null) {
		if(a.target == null) {
			a = a.prev;
			CoreAnimation.removeCAObject(a);
			break;
		}
		time_diff = current_time - a.fromTime - a.delay;
		if(time_diff >= a.duration) time_diff = a.duration;
		if(time_diff > 0) {
			a.animate(time_diff);
			if(time_diff > 0 && !a.delegate.startPointPassed) a.delegate.start();
			if(time_diff >= a.duration) {
				if(a.repeatCount > 0) {
					a.repeat();
					a.delegate.repeat();
				} else {
					CoreAnimation.removeCAObject(a);
					a.delegate.stop();
				}
			}
			if(a.delegate.kenBurnsPointIn != null) {
				if(time_diff > a.delegate.kenBurnsPointIn && !a.delegate.kenBurnsPointInPassed) a.delegate.kbIn();
				if(time_diff > a.delegate.kenBurnsPointOut && !a.delegate.kenBurnsPointOutPassed) a.delegate.kbOut();
			}
		}
		a = a.prev;
	}
}
CoreAnimation.timestamp = function() {
	return new Date().getTime();
}
var RCSignal = $hxClasses["RCSignal"] = function() {
	this.enabled = true;
	this.removeAll();
};
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
var EVFullScreen = $hxClasses["EVFullScreen"] = function() {
	RCSignal.call(this);
};
EVFullScreen.__name__ = ["EVFullScreen"];
EVFullScreen.__super__ = RCSignal;
EVFullScreen.prototype = $extend(RCSignal.prototype,{
	__class__: EVFullScreen
});
var EVLoop = $hxClasses["EVLoop"] = function() {
};
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
		if(this.run != null) this.run();
	}
	,setFuncToCall: function(func) {
		this.stop();
		this.run = func;
		this.ticker = new haxe.Timer(Math.round(1 / EVLoop.FPS * 1000));
		this.ticker.run = $bind(this,this.loop);
		return func;
	}
	,run: null
	,ticker: null
	,__class__: EVLoop
	,__properties__: {set_run:"setFuncToCall"}
}
var EVResize = $hxClasses["EVResize"] = function() {
	RCSignal.call(this);
	js.Lib.window.onresize = $bind(this,this.resizeHandler);
};
EVResize.__name__ = ["EVResize"];
EVResize.__super__ = RCSignal;
EVResize.prototype = $extend(RCSignal.prototype,{
	resizeHandler: function(e) {
		var w = js.Lib.window.innerWidth;
		var h = js.Lib.window.innerHeight;
		this.dispatch(w,h,null,null,{ fileName : "EVResize.hx", lineNumber : 34, className : "EVResize", methodName : "resizeHandler"});
	}
	,__class__: EVResize
});
var Fugu = $hxClasses["Fugu"] = function() { }
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
			haxe.Log.trace(Fugu.stack(),{ fileName : "Fugu.hx", lineNumber : 29, className : "Fugu", methodName : "safeDestroy"});
		}
		if(js.Boot.__instanceof(o,JSView)) (js.Boot.__cast(o , JSView)).removeFromSuperView(); else {
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
Fugu.align = function(obj,alignment,constraint_w,constraint_h,obj_w,obj_h,delay_x,delay_y) {
	if(delay_y == null) delay_y = 0;
	if(delay_x == null) delay_x = 0;
	if(obj == null) return;
	var arr = alignment.toLowerCase().split(",");
	if(obj_w == null) obj_w = obj.getWidth();
	if(obj_h == null) obj_h = obj.getHeight();
	obj.setX((function($this) {
		var $r;
		switch(arr[0]) {
		case "l":
			$r = delay_x;
			break;
		case "m":
			$r = Math.round((constraint_w - obj_w) / 2);
			break;
		case "r":
			$r = Math.round(constraint_w - obj_w - delay_x);
			break;
		default:
			$r = Std.parseInt(arr[0]);
		}
		return $r;
	}(this)));
	obj.setY((function($this) {
		var $r;
		switch(arr[1]) {
		case "t":
			$r = delay_y;
			break;
		case "m":
			$r = Math.round((constraint_h - obj_h) / 2);
			break;
		case "b":
			$r = Math.round(constraint_h - obj_h - delay_y);
			break;
		default:
			$r = Std.parseInt(arr[1]);
		}
		return $r;
	}(this)));
}
Fugu.stack = function() {
	var stack = haxe.Stack.exceptionStack();
	haxe.Log.trace(haxe.Stack.toString(stack),{ fileName : "Fugu.hx", lineNumber : 161, className : "Fugu", methodName : "stack"});
}
var HxOverrides = $hxClasses["HxOverrides"] = function() { }
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
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIter
}
var JSCanvas = $hxClasses["JSCanvas"] = function() { }
JSCanvas.__name__ = ["JSCanvas"];
var RCDisplayObject = $hxClasses["RCDisplayObject"] = function() {
	this.viewWillAppear = new RCSignal();
	this.viewWillDisappear = new RCSignal();
	this.viewDidAppear = new RCSignal();
	this.viewDidDisappear = new RCSignal();
};
RCDisplayObject.__name__ = ["RCDisplayObject"];
RCDisplayObject.prototype = {
	toString: function() {
		return "[RCView bounds:" + this.getBounds().origin.x + "x" + this.getBounds().origin.x + "," + this.getBounds().size.width + "x" + this.getBounds().size.height + "]";
	}
	,destroy: function() {
		CoreAnimation.remove(this.caobj);
		this.size = null;
	}
	,addAnimation: function(obj) {
		CoreAnimation.add(this.caobj = obj);
	}
	,removeChild: function(child) {
	}
	,addChildAt: function(child,index) {
	}
	,addChild: function(child) {
	}
	,getMouseY: function() {
		return 0;
	}
	,getMouseX: function() {
		return 0;
	}
	,resetScale: function() {
		this.setWidth(this.originalSize.width);
		this.setHeight(this.originalSize.height);
	}
	,scale: function(sx,sy) {
	}
	,scaleToFill: function(w,h) {
		if(w / this.originalSize.width > h / this.originalSize.height) {
			this.setWidth(w);
			this.setHeight(w * this.originalSize.height / this.originalSize.width);
		} else {
			this.setHeight(h);
			this.setWidth(h * this.originalSize.width / this.originalSize.height);
		}
	}
	,scaleToFit: function(w,h) {
		if(this.size.width / w > this.size.height / h && this.size.width > w) {
			this.setWidth(w);
			this.setHeight(w * this.originalSize.height / this.originalSize.width);
		} else if(this.size.height > h) {
			this.setHeight(h);
			this.setWidth(h * this.originalSize.width / this.originalSize.height);
		} else if(this.size.width > this.originalSize.width && this.size.height > this.originalSize.height) {
			this.setWidth(this.size.width);
			this.setHeight(this.size.height);
		} else this.resetScale();
	}
	,setCenter: function(pos) {
		this.center = pos;
		this.setX(pos.x - this.size.width / 2 | 0);
		this.setY(pos.y - this.size.height / 2 | 0);
		return this.center;
	}
	,setBackgroundColor: function(color) {
		return color;
	}
	,setClipsToBounds: function(clip) {
		return clip;
	}
	,setScaleY: function(sy) {
		this.scaleY_ = sy;
		this.scale(this.scaleX_,this.scaleY_);
		return this.scaleY_;
	}
	,getScaleY: function() {
		return this.scaleY_;
	}
	,setScaleX: function(sx) {
		this.scaleX_ = sx;
		this.scale(this.scaleX_,this.scaleY_);
		return this.scaleX_;
	}
	,getScaleX: function() {
		return this.scaleX_;
	}
	,setBounds: function(b) {
		this.setX(b.origin.x);
		this.setY(b.origin.y);
		this.setWidth(b.size.width);
		this.setHeight(b.size.height);
		return b;
	}
	,getBounds: function() {
		return new RCRect(this.x_,this.y_,this.size.width,this.size.height);
	}
	,getRotation: function() {
		return this.rotation;
	}
	,setRotation: function(r) {
		return this.rotation = r;
	}
	,setContentSize: function(s) {
		return this.contentSize = s;
	}
	,getContentSize: function() {
		return this.size;
	}
	,setHeight: function(h) {
		return this.size.height = h;
	}
	,getHeight: function() {
		return this.size.height;
	}
	,setWidth: function(w) {
		return this.size.width = w;
	}
	,getWidth: function() {
		return this.size.width;
	}
	,setY: function(y) {
		return this.y_ = y;
	}
	,getY: function() {
		return this.y_;
	}
	,setX: function(x) {
		return this.x_ = x;
	}
	,getX: function() {
		return this.x_;
	}
	,setAlpha: function(a) {
		return this.alpha = a;
	}
	,getAlpha: function() {
		return this.alpha;
	}
	,setVisible: function(v) {
		return this.visible = v;
	}
	,init: function() {
	}
	,caobj: null
	,originalSize: null
	,contentSize_: null
	,scaleY_: null
	,scaleX_: null
	,y_: null
	,x_: null
	,parent: null
	,mouseY: null
	,mouseX: null
	,visible: null
	,rotation: null
	,alpha: null
	,scaleY: null
	,scaleX: null
	,height: null
	,width: null
	,y: null
	,x: null
	,backgroundColor: null
	,clipsToBounds: null
	,center: null
	,contentSize: null
	,size: null
	,bounds: null
	,viewDidDisappear: null
	,viewDidAppear: null
	,viewWillDisappear: null
	,viewWillAppear: null
	,__class__: RCDisplayObject
	,__properties__: {set_bounds:"setBounds",get_bounds:"getBounds",set_contentSize:"setContentSize",get_contentSize:"getContentSize",set_center:"setCenter",set_clipsToBounds:"setClipsToBounds",set_backgroundColor:"setBackgroundColor",set_x:"setX",get_x:"getX",set_y:"setY",get_y:"getY",set_width:"setWidth",get_width:"getWidth",set_height:"setHeight",get_height:"getHeight",set_scaleX:"setScaleX",get_scaleX:"getScaleX",set_scaleY:"setScaleY",get_scaleY:"getScaleY",set_alpha:"setAlpha",get_alpha:"getAlpha",set_rotation:"setRotation",get_rotation:"getRotation",set_visible:"setVisible",get_mouseX:"getMouseX",get_mouseY:"getMouseY"}
}
var JSView = $hxClasses["JSView"] = function(x,y,w,h) {
	RCDisplayObject.call(this);
	this.size = new RCSize(w,h);
	this.contentSize_ = this.size.copy();
	this.scaleX_ = 1;
	this.scaleY_ = 1;
	this.alpha_ = 1;
	this.layer = js.Lib.document.createElement("div");
	this.layer.style.position = "absolute";
	this.layer.style.margin = "0px 0px 0px 0px";
	this.layer.style.width = "auto";
	this.layer.style.height = "auto";
	this.setX(x);
	this.setY(y);
};
JSView.__name__ = ["JSView"];
JSView.__super__ = RCDisplayObject;
JSView.prototype = $extend(RCDisplayObject.prototype,{
	getMouseY: function() {
		if(this.parent == null) return this.mouseY;
		return this.parent.getMouseY() - this.getY();
	}
	,getMouseX: function() {
		return this.layer.clientX;
		if(this.parent == null) return this.mouseX;
		return this.parent.getMouseX() - this.getX();
	}
	,stopDrag: function() {
	}
	,startDrag: function(lockCenter,rect) {
	}
	,setRotation: function(r) {
		this.layer.style[this.getTransformProperty()] = "rotate(" + r + "deg)";
		return RCDisplayObject.prototype.setRotation.call(this,r);
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
	,getContentSize: function() {
		this.contentSize_.width = this.layer.scrollWidth;
		this.contentSize_.height = this.layer.scrollHeight;
		return this.contentSize_;
	}
	,setHeight: function(h) {
		this.layer.style.height = h + "px";
		return RCDisplayObject.prototype.setHeight.call(this,h);
	}
	,setWidth: function(w) {
		this.layer.style.width = w + "px";
		return RCDisplayObject.prototype.setWidth.call(this,w);
	}
	,setY: function(y) {
		this.layer.style.top = Std.string(y * RCDevice.currentDevice().dpiScale) + "px";
		return RCDisplayObject.prototype.setY.call(this,y);
	}
	,setX: function(x) {
		this.layer.style.left = Std.string(x * RCDevice.currentDevice().dpiScale) + "px";
		return RCDisplayObject.prototype.setX.call(this,x);
	}
	,setAlpha: function(a) {
		if(RCDevice.currentDevice().userAgent == RCUserAgent.MSIE) {
			this.layer.style.msFilter = "progid:DXImageTransform.Microsoft.Alpha(Opacity=" + Std.string(a * 100) + ")";
			this.layer.style.filter = "alpha(opacity=" + Std.string(a * 100) + ")";
		} else this.layer.style.opacity = Std.string(a);
		return RCDisplayObject.prototype.setAlpha.call(this,a);
	}
	,setVisible: function(v) {
		this.layer.style.visibility = v?"visible":"hidden";
		return RCDisplayObject.prototype.setVisible.call(this,v);
	}
	,setClipsToBounds: function(clip) {
		if(clip) {
			this.layer.style.overflow = "hidden";
			this.layerScrollable = js.Lib.document.createElement("div");
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
	,setBackgroundColor: function(color) {
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
	,removeFromSuperView: function() {
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
	,alpha_: null
	,graphics: null
	,layerScrollable: null
	,layer: null
	,__class__: JSView
});
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
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
		s.b += Std.string("{");
		while(l != null) {
			if(first) first = false; else s.b += Std.string(", ");
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += Std.string("}");
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
var RCAppDelegate = $hxClasses["RCAppDelegate"] = function() {
	RCWindow.sharedWindow();
	JSView.call(this,0,0);
	RCNotificationCenter.addObserver("resize",$bind(this,this.resize));
	RCNotificationCenter.addObserver("fullscreen",$bind(this,this.fullscreen));
	this.applicationDidFinishLaunching();
};
RCAppDelegate.__name__ = ["RCAppDelegate"];
RCAppDelegate.__super__ = JSView;
RCAppDelegate.prototype = $extend(JSView.prototype,{
	fullscreen: function(b) {
	}
	,resize: function(w,h) {
	}
	,applicationWillTerminate: function() {
		haxe.Log.trace("applicationWillTerminate",{ fileName : "RCAppDelegate.hx", lineNumber : 34, className : "RCAppDelegate", methodName : "applicationWillTerminate"});
	}
	,applicationWillEnterForeground: function() {
	}
	,applicationDidBecomeActive: function() {
	}
	,applicationDidFinishLaunching: function() {
	}
	,__class__: RCAppDelegate
});
var Main = $hxClasses["Main"] = function() {
	RCAppDelegate.call(this);
	this.heart1();
	RCWindow.sharedWindow().addChild(new RCStats());
};
Main.__name__ = ["Main"];
Main.main = function() {
	haxe.Firebug.redirectTraces();
	RCWindow.sharedWindow();
}
Main.__super__ = RCAppDelegate;
Main.prototype = $extend(RCAppDelegate.prototype,{
	log10: function(val) {
		return Math.log(val) * 0.434294481904;
	}
	,logx: function(val,base) {
		if(base == null) base = 10;
		return Math.log(val) / Math.log(base);
	}
	,drawParticle2: function(i) {
		var scale = 20;
		var t = i / (200 / 60);
		var a = 0.01 * (-t * t + 40 * t + 1200);
		var x = a * Math.sin(Math.PI * t / 180);
		var y = a * Math.cos(Math.PI * t / 180);
		var p1 = new Particle(800 - x * scale,400 - y * scale,t,-1);
		var p2 = new Particle(800 - x * scale,400 - y * scale,t,1);
		RCWindow.sharedWindow().addChild(p1);
		RCWindow.sharedWindow().addChild(p2);
	}
	,heart2: function() {
		var iterator = new RCIterator(4,0,200,1);
		iterator.run = $bind(this,this.drawParticle2);
		iterator.start();
	}
	,drawParticle: function(i) {
		var t = i / 200;
		var p1 = new Particle(400,400,t,-1);
		var p2 = new Particle(400,400,t,1);
		RCWindow.sharedWindow().addChild(p1);
		RCWindow.sharedWindow().addChild(p2);
	}
	,heart1: function() {
		var _g = 0;
		while(_g < 200) {
			var i = _g++;
			this.drawParticle(i);
		}
	}
	,__class__: Main
});
var Particle = $hxClasses["Particle"] = function(x,y,t,s) {
	JSView.call(this,x,y);
	this.o_x = x;
	this.o_y = y;
	this.theta = t;
	this.f_x = x;
	this.f_y = y;
	this.current_theta = 0.001;
	this.sign = s;
	this.addChild(new RCRectangle(0,0,1,1,0));
	this.loopEvent = new EVLoop();
	this.loopEvent.setFuncToCall($bind(this,this.loopTheta));
	this.timer = new haxe.Timer(40);
	this.timer.run = $bind(this,this.advanceTheta);
};
Particle.__name__ = ["Particle"];
Particle.__super__ = JSView;
Particle.prototype = $extend(JSView.prototype,{
	loop: function() {
		var _g = this;
		_g.setX(_g.getX() + (this.f_x - this.getX()) / 3);
		var _g = this;
		_g.setY(_g.getY() + (this.f_y - this.getY()) / 3);
		if(Math.abs(this.getX() - this.f_x) < 1) this.changeDirection();
	}
	,loopTheta: function() {
		this.setX(this.o_x - this.f_x * 500 * this.sign);
		this.setY(this.o_y - this.f_y * 500);
	}
	,changeDirection: function() {
		this.f_x = this.o_x + 6 - Math.random() * 12;
		this.f_y = this.o_y + 6 - Math.random() * 12;
	}
	,fxy: function() {
		this.f_x = Math.sin(this.current_theta) * Math.cos(this.current_theta) * Math.log(Math.abs(this.current_theta));
		this.f_y = Math.sqrt(Math.abs(this.current_theta)) * Math.cos(this.current_theta);
	}
	,advanceTheta: function() {
		this.current_theta += (this.theta - this.current_theta) / 5;
		this.fxy();
		if(Math.abs(this.current_theta - this.theta) <= 0.001) {
			this.current_theta = this.theta;
			this.timer.stop();
			this.loopEvent.stop();
			this.fxy();
			this.o_x = this.o_x - this.f_x * 500 * this.sign;
			this.o_y = this.o_y - this.f_y * 500;
			this.changeDirection();
			this.loopEvent.setFuncToCall($bind(this,this.loop));
		}
	}
	,sign: null
	,current_theta: null
	,theta: null
	,f_y: null
	,f_x: null
	,o_y: null
	,o_x: null
	,loopEvent: null
	,timer: null
	,__class__: Particle
});
var RCColor = $hxClasses["RCColor"] = function(fillColor,strokeColor,a) {
	this.fillColor = fillColor;
	this.strokeColor = strokeColor;
	this.alpha = a == null?1.0:a;
	this.redComponent = (fillColor >> 16 & 255) / 255;
	this.greenComponent = (fillColor >> 8 & 255) / 255;
	this.blueComponent = (fillColor & 255) / 255;
	this.fillColorStyle = RCColor.HEXtoString(fillColor);
	this.strokeColorStyle = RCColor.HEXtoString(strokeColor);
};
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
var RCDeviceType = $hxClasses["RCDeviceType"] = { __ename__ : ["RCDeviceType"], __constructs__ : ["IPhone","IPad","IPod","Android","WebOS","Mac","Flash","Playstation","Other"] }
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
RCDeviceType.Flash = ["Flash",6];
RCDeviceType.Flash.toString = $estr;
RCDeviceType.Flash.__enum__ = RCDeviceType;
RCDeviceType.Playstation = ["Playstation",7];
RCDeviceType.Playstation.toString = $estr;
RCDeviceType.Playstation.__enum__ = RCDeviceType;
RCDeviceType.Other = ["Other",8];
RCDeviceType.Other.toString = $estr;
RCDeviceType.Other.__enum__ = RCDeviceType;
var RCUserAgent = $hxClasses["RCUserAgent"] = { __ename__ : ["RCUserAgent"], __constructs__ : ["MSIE","MSIE9","GECKO","WEBKIT","OTHER"] }
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
RCUserAgent.OTHER = ["OTHER",4];
RCUserAgent.OTHER.toString = $estr;
RCUserAgent.OTHER.__enum__ = RCUserAgent;
var RCDevice = $hxClasses["RCDevice"] = function() {
	this.dpiScale = 1;
	this.userAgent = this.detectUserAgent();
	this.userInterfaceIdiom = this.detectUserInterfaceIdiom();
};
RCDevice.__name__ = ["RCDevice"];
RCDevice._currentDevice = null;
RCDevice.currentDevice = function() {
	if(RCDevice._currentDevice == null) RCDevice._currentDevice = new RCDevice();
	return RCDevice._currentDevice;
}
RCDevice.prototype = {
	detectUserInterfaceIdiom: function() {
		var agent = js.Lib.window.navigator.userAgent.toLowerCase();
		if(agent.indexOf("iphone") > -1) return RCDeviceType.IPhone;
		if(agent.indexOf("ipad") > -1) return RCDeviceType.IPad;
		if(agent.indexOf("ipod") > -1) return RCDeviceType.IPod;
		if(agent.indexOf("playstation") > -1) return RCDeviceType.Playstation;
		return RCDeviceType.Other;
	}
	,detectUserAgent: function() {
		var agent = js.Lib.window.navigator.userAgent.toLowerCase();
		if(agent.indexOf("msie") > -1) return RCUserAgent.MSIE;
		if(agent.indexOf("msie 9.") > -1) return RCUserAgent.MSIE9;
		if(agent.indexOf("webkit") > -1) return RCUserAgent.WEBKIT;
		if(agent.indexOf("gecko") > -1) return RCUserAgent.GECKO;
		return RCUserAgent.OTHER;
	}
	,userAgent: null
	,dpiScale: null
	,uniqueIdentifier: null
	,userInterfaceIdiom: null
	,orientation: null
	,systemVersion: null
	,systemName: null
	,model: null
	,name: null
	,__class__: RCDevice
}
var _RCDraw = _RCDraw || {}
_RCDraw.LineScaleMode = $hxClasses["_RCDraw.LineScaleMode"] = function() { }
_RCDraw.LineScaleMode.__name__ = ["_RCDraw","LineScaleMode"];
var RCDraw = $hxClasses["RCDraw"] = function(x,y,w,h,color,alpha) {
	if(alpha == null) alpha = 1.0;
	JSView.call(this,x,y,w,h);
	this.setAlpha(alpha);
	this.borderThickness = 1;
	try {
		this.graphics = this.layer;
	} catch( e ) {
		haxe.Log.trace(e,{ fileName : "RCDraw.hx", lineNumber : 37, className : "RCDraw", methodName : "new"});
	}
	if(js.Boot.__instanceof(color,RCColor) || js.Boot.__instanceof(color,RCGradient)) this.color = color; else if(js.Boot.__instanceof(color,Int) || js.Boot.__instanceof(color,Int)) this.color = new RCColor(color); else if(js.Boot.__instanceof(color,Array)) this.color = new RCColor(color[0],color[1]); else this.color = new RCColor(0);
};
RCDraw.__name__ = ["RCDraw"];
RCDraw.__super__ = JSView;
RCDraw.prototype = $extend(JSView.prototype,{
	frame: function() {
		return new RCRect(this.getX(),this.getY(),this.size.width,this.size.height);
	}
	,configure: function() {
		if(js.Boot.__instanceof(this.color,RCColor)) {
			if(this.color.fillColor != null) this.graphics.beginFill(this.color.fillColor,this.color.alpha);
			if(this.color.strokeColor != null) {
				var pixelHinting = true;
				var scaleMode = _RCDraw.LineScaleMode.NONE;
				var caps = null;
				var joints = null;
				var miterLimit = 3;
				this.graphics.lineStyle(this.borderThickness,this.color.strokeColor,this.color.alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
			}
		}
	}
	,borderThickness: null
	,color: null
	,__class__: RCDraw
});
var RCDrawInterface = $hxClasses["RCDrawInterface"] = function() { }
RCDrawInterface.__name__ = ["RCDrawInterface"];
RCDrawInterface.prototype = {
	redraw: null
	,configure: null
	,__class__: RCDrawInterface
}
var RCFont = $hxClasses["RCFont"] = function() {
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
	getStyleSheet: function() {
		return this.style;
	}
	,getFormat: function() {
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
		this.format.tabStops = this.tabStops;
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
	,__properties__: {get_format:"getFormat",get_style:"getStyleSheet"}
}
var RCGradient = $hxClasses["RCGradient"] = function(colors,alphas,linear) {
	if(linear == null) linear = true;
	this.gradientColors = colors;
	this.gradientAlphas = alphas == null?[1.0,1.0]:alphas;
	this.gradientRatios = [0,255];
	this.focalPointRatio = 0;
	this.tx = 0;
	this.ty = 0;
	this.matrixRotation = Math.PI * 0.5;
};
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
var RCIterator = $hxClasses["RCIterator"] = function(interval,min,max,step) {
	this.interval = interval;
	this.min = min;
	this.max = max;
	this.step = step;
	this.timer = new haxe.Timer(interval);
};
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
var RCNotification = $hxClasses["RCNotification"] = function(name,functionToCall) {
	this.name = name;
	this.functionToCall = functionToCall;
};
RCNotification.__name__ = ["RCNotification"];
RCNotification.prototype = {
	toString: function() {
		return "[RCNotification with name: '" + this.name + "', functionToCall: " + Std.string(this.functionToCall) + "]";
	}
	,functionToCall: null
	,name: null
	,__class__: RCNotification
}
var RCNotificationCenter = $hxClasses["RCNotificationCenter"] = function() { }
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
var RCPoint = $hxClasses["RCPoint"] = function(x,y) {
	this.x = x == null?0:x;
	this.y = y == null?0:y;
};
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
var RCRect = $hxClasses["RCRect"] = function(x,y,w,h) {
	this.origin = new RCPoint(x,y);
	this.size = new RCSize(w,h);
};
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
var RCRectangle = $hxClasses["RCRectangle"] = function(x,y,w,h,color,alpha,r) {
	if(alpha == null) alpha = 1.0;
	RCDraw.call(this,x,y,w,h,color,alpha);
	this.roundness = r;
	this.redraw();
};
RCRectangle.__name__ = ["RCRectangle"];
RCRectangle.__interfaces__ = [RCDrawInterface];
RCRectangle.__super__ = RCDraw;
RCRectangle.prototype = $extend(RCDraw.prototype,{
	setHeight: function(h) {
		this.size.height = h;
		this.redraw();
		return h;
	}
	,setWidth: function(w) {
		this.size.width = w;
		this.redraw();
		return w;
	}
	,redraw: function() {
		var fillColorStyle = this.color.fillColorStyle;
		var strokeColorStyle = this.color.strokeColorStyle;
		this.layer.style.margin = "0px 0px 0px 0px";
		this.layer.style.width = this.size.width * RCDevice.currentDevice().dpiScale + "px";
		this.layer.style.height = this.size.height * RCDevice.currentDevice().dpiScale + "px";
		this.layer.style.backgroundColor = fillColorStyle;
		if(strokeColorStyle != null) {
			this.layer.style.borderStyle = "solid";
			this.layer.style.borderWidth = this.borderThickness + "px";
			this.layer.style.borderColor = strokeColorStyle;
		}
		if(this.roundness != null) {
			this.layer.style.MozBorderRadius = this.roundness * RCDevice.currentDevice().dpiScale / 2 + "px";
			this.layer.style.borderRadius = this.roundness * RCDevice.currentDevice().dpiScale / 2 + "px";
		}
	}
	,roundness: null
	,__class__: RCRectangle
});
var RCSize = $hxClasses["RCSize"] = function(w,h) {
	this.width = w == null?0:w;
	this.height = h == null?0:h;
};
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
var RCStats = $hxClasses["RCStats"] = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	RCRectangle.call(this,x,y,152,18,16777215,0.9,16);
	this.addChild(new RCRectangle(1,1,150,16,3355443,0.3,16));
	var f = RCFont.systemFontOfSize(12);
	f.color = 16777215;
	this.txt = new RCTextView(6,3,null,20,"Calculating...",f);
	this.addChild(this.txt);
	this.last = new Date().getTime();
	this.e = new EVLoop();
	this.e.setFuncToCall($bind(this,this.loop));
};
RCStats.__name__ = ["RCStats"];
RCStats.__super__ = RCRectangle;
RCStats.prototype = $extend(RCRectangle.prototype,{
	destroy: function() {
		this.e.destroy();
		this.txt.destroy();
		RCRectangle.prototype.destroy.call(this);
	}
	,loop: function() {
		this.ticks++;
		var now = new Date().getTime();
		var delta = now - this.last;
		if(delta >= 1000) {
			this.fps = Math.round(this.ticks / delta * 1000);
			this.ticks = 0;
			this.last = now;
			this.txt.setText(this.fps + " FPS,  " + this.currMemory + " Mbytes");
		}
	}
	,e: null
	,txt: null
	,currMemory: null
	,fps: null
	,ticks: null
	,last: null
	,__class__: RCStats
});
var RCTextView = $hxClasses["RCTextView"] = function(x,y,w,h,str,rcfont) {
	JSView.call(this,Math.round(x),Math.round(y),w,h);
	this.rcfont = rcfont.copy();
	this.setWidth(this.size.width);
	this.setHeight(this.size.height);
	this.viewDidAppear.add($bind(this,this.viewDidAppear_));
	this.init();
	this.setText(str);
};
RCTextView.__name__ = ["RCTextView"];
RCTextView.__super__ = JSView;
RCTextView.prototype = $extend(JSView.prototype,{
	destroy: function() {
		this.target = null;
		JSView.prototype.destroy.call(this);
	}
	,setText: function(str) {
		if(this.rcfont.html) this.layer.innerHTML = str; else this.layer.innerHTML = str;
		this.size.width = this.getContentSize().width;
		return str;
	}
	,getText: function() {
		return this.layer.innerHTML;
	}
	,viewDidAppear_: function() {
		this.size.width = this.getContentSize().width;
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
		if(this.size.width != 0) this.setWidth(this.size.width);
	}
	,init: function() {
		JSView.prototype.init.call(this);
		this.redraw();
	}
	,text: null
	,rcfont: null
	,target: null
	,__class__: RCTextView
	,__properties__: $extend(JSView.prototype.__properties__,{set_text:"setText",get_text:"getText"})
});
var RCWindow = $hxClasses["RCWindow"] = function(id) {
	if(RCWindow.sharedWindow_ != null) {
		var err = "RCWindow is a singletone, create and access it with RCWindow.sharedWindow(?id)";
		haxe.Log.trace(err,{ fileName : "RCWindow.hx", lineNumber : 55, className : "RCWindow", methodName : "new"});
		throw err;
	}
	JSView.call(this,0.0,0.0,0.0,0.0);
	this.stage = js.Lib.document;
	this.setTarget(id);
	this.SCREEN_W = js.Lib.window.screen.width;
	this.SCREEN_H = js.Lib.window.screen.height;
	RCNotificationCenter.addObserver("resize",$bind(this,this.resizeHandler));
};
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
		return Math.round(this.getHeight() / 2 - h / RCDevice.currentDevice().dpiScale / 2);
	}
	,getCenterX: function(w) {
		return Math.round(this.getWidth() / 2 - w / RCDevice.currentDevice().dpiScale / 2);
	}
	,destroyModalViewController: function() {
		this.modalView.destroy();
		this.modalView = null;
	}
	,dismissModalViewController: function() {
		if(this.modalView == null) return;
		var anim = new CATween(this.modalView,{ y : this.getHeight()},0.3,0,caequations.Cubic.IN,{ fileName : "RCWindow.hx", lineNumber : 238, className : "RCWindow", methodName : "dismissModalViewController"});
		anim.delegate.animationDidStop = $bind(this,this.destroyModalViewController);
		CoreAnimation.add(anim);
	}
	,addModalViewController: function(view) {
		this.modalView = view;
		this.modalView.setX(0);
		CoreAnimation.add(new CATween(this.modalView,{ y : { fromValue : this.getHeight(), toValue : 0}},0.5,0,caequations.Cubic.IN_OUT,{ fileName : "RCWindow.hx", lineNumber : 233, className : "RCWindow", methodName : "addModalViewController"}));
		this.addChild(this.modalView);
	}
	,supportsFullScreen: function() {
		if(Reflect.field(this.target,"cancelFullScreen") != null) return true; else {
			var _g = 0, _g1 = ["webkit","moz","o","ms","khtml"];
			while(_g < _g1.length) {
				var prefix = _g1[_g];
				++_g;
				if(Reflect.field(js.Lib.document,prefix + "CancelFullScreen") != null) {
					this.fsprefix = prefix;
					return true;
				}
			}
		}
		return false;
		return false;
	}
	,isFullScreen: function() {
		if(this.supportsFullScreen()) switch(this.fsprefix) {
		case "":
			return this.target.fullScreen;
		case "webkit":
			return this.target.webkitIsFullScreen;
		default:
			return Reflect.field(this.target,this.fsprefix + "FullScreen");
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
	,setBackgroundColor: function(color) {
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
		if(id != null) this.target = js.Lib.document.getElementById(id); else {
			this.target = js.Lib.document.body;
			this.target.style.margin = "0px 0px 0px 0px";
			this.target.style.overflow = "hidden";
			if(RCDevice.currentDevice().userAgent == RCUserAgent.MSIE) {
				this.target.style.width = js.Lib.document.documentElement.clientWidth + "px";
				this.target.style.height = js.Lib.document.documentElement.clientHeight + "px";
			} else {
				this.target.style.width = js.Lib.window.innerWidth + "px";
				this.target.style.height = js.Lib.window.innerHeight + "px";
			}
		}
		this.size.width = this.target.scrollWidth;
		this.size.height = this.target.scrollHeight;
		haxe.Log.trace(this.size,{ fileName : "RCWindow.hx", lineNumber : 120, className : "RCWindow", methodName : "setTarget"});
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
var Reflect = $hxClasses["Reflect"] = function() { }
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
		if(hasOwnProperty.call(o,f)) a.push(f);
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
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && (v.__name__ || v.__ename__);
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
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
var Std = $hxClasses["Std"] = function() { }
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
	return Math.floor(Math.random() * x);
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
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
	return c >= 9 && c <= 13 || c == 32;
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
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
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
StringTools.isEOF = function(c) {
	return c != c;
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
var Type = $hxClasses["Type"] = function() { }
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
	switch(typeof(v)) {
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
caequations.Cubic = $hxClasses["caequations.Cubic"] = function() { }
caequations.Cubic.__name__ = ["caequations","Cubic"];
caequations.Cubic.IN = function(t,b,c,d,p_params) {
	return c * (t /= d) * t * t + b;
}
caequations.Cubic.OUT = function(t,b,c,d,p_params) {
	return c * ((t = t / d - 1) * t * t + 1) + b;
}
caequations.Cubic.IN_OUT = function(t,b,c,d,p_params) {
	if((t /= d / 2) < 1) return c / 2 * t * t * t + b;
	return c / 2 * ((t -= 2) * t * t + 2) + b;
}
caequations.Cubic.OUT_IN = function(t,b,c,d,p_params) {
	if(t < d / 2) return caequations.Cubic.OUT(t * 2,b,c / 2,d,null);
	return caequations.Cubic.IN(t * 2 - d,b + c / 2,c / 2,d,null);
}
var haxe = haxe || {}
haxe.Firebug = $hxClasses["haxe.Firebug"] = function() { }
haxe.Firebug.__name__ = ["haxe","Firebug"];
haxe.Firebug.detect = function() {
	try {
		return console != null && console.error != null;
	} catch( e ) {
		return false;
	}
}
haxe.Firebug.redirectTraces = function() {
	haxe.Log.trace = haxe.Firebug.trace;
	js.Lib.onerror = haxe.Firebug.onError;
}
haxe.Firebug.onError = function(err,stack) {
	var buf = err + "\n";
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		buf += "Called from " + s + "\n";
	}
	haxe.Firebug.trace(buf,null);
	return true;
}
haxe.Firebug.trace = function(v,inf) {
	var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
	if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
	console[type]((inf == null?"":inf.fileName + ":" + inf.lineNumber + " : ") + Std.string(v));
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = $hxClasses["haxe.Stack"] = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
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
	var a = haxe.Stack.makeStack(new Error().stack);
	a.shift();
	Error.prepareStackTrace = oldValue;
	return a;
}
haxe.Stack.exceptionStack = function() {
	return [];
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += Std.string("\nCalled from ");
		haxe.Stack.itemToString(b,s);
	}
	return b.b;
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b += Std.string("a C function");
		break;
	case 1:
		var m = $e[2];
		b.b += Std.string("module ");
		b.b += Std.string(m);
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b += Std.string(" (");
		}
		b.b += Std.string(file);
		b.b += Std.string(" line ");
		b.b += Std.string(line);
		if(s1 != null) b.b += Std.string(")");
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b += Std.string(cname);
		b.b += Std.string(".");
		b.b += Std.string(meth);
		break;
	case 4:
		var n = $e[2];
		b.b += Std.string("local function #");
		b.b += Std.string(n);
		break;
	}
}
haxe.Stack.makeStack = function(s) {
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
haxe.Timer = $hxClasses["haxe.Timer"] = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
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
		window.clearInterval(this.id);
		this.id = null;
	}
	,id: null
	,__class__: haxe.Timer
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
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
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.document = null;
js.Lib.window = null;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
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
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
CoreAnimation.defaultTimingFunction = caequations.Linear.NONE;
CoreAnimation.defaultDuration = 0.8;
EVLoop.FPS = 60;
Main.PARTICLES = 200;
RCColor.BLACK = 0;
RCColor.WHITE = 16777215;
RCColor.RED = 16711680;
RCColor.GREEN = 65280;
RCColor.BLUE = 255;
RCColor.CYAN = 65535;
RCColor.YELLOW = 16776960;
_RCDraw.LineScaleMode.NONE = null;
js.Lib.onerror = null;
Main.main();
