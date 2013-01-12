/*
 * Yuichi Tateno. <hotchpotch@N0!spam@gmail.com>
 * http://rails2u.com/
 * 
 * The MIT License
 * --------
 * Copyright (c) 2007 Yuichi Tateno.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

var JSTweener = {
    looping: false,
    frameRate: 60,
    objects: [],
    defaultOptions: {
        time: 1,
        transition: 'easeoutexpo',
        delay: 0,
        prefix: {},
        suffix: {},
        onStart: undefined,
        onStartParams: undefined,
        onUpdate: undefined,
        onUpdateParams: undefined,
        onComplete: undefined,
        onCompleteParams: undefined
    },
    inited: false,
    easingFunctionsLowerCase: {},
    init: function() {
        this.inited = true;
        for (var key in JSTweener.easingFunctions) {
            this.easingFunctionsLowerCase[key.toLowerCase()] = JSTweener.easingFunctions[key];
        }
    },
    toNumber: function(value, prefix, suffix) {
        // for style
        if (!suffix) suffix = 'px';

        return value.toString().match(/[0-9]/) ? Number(value.toString().replace(
                                                        new RegExp(suffix + '$'), ''
                                                       ).replace(
                                                        new RegExp('^' + (prefix ? prefix : '')), ''
                                                       ))
                                               : 0;
    },
    addTween: function(obj, options) {
        var self = this;
        if (!this.inited) this.init();
        var o = {};
        o.target = obj;
        o.targetPropeties = {};
        
        for (var key in this.defaultOptions) {
            if (typeof options[key] != 'undefined') {
                o[key] = options[key];
                delete options[key];
            } else {
                o[key] = this.defaultOptions[key];
            }
        }

        if (typeof o.transition == 'function') {
            o.easing = o.transition;
        } else {
            o.easing = this.easingFunctionsLowerCase[o.transition.toLowerCase()];
        }

        for (var key in options) {
            if (!o.prefix[key]) o.prefix[key] = '';
            if (!o.suffix[key]) o.suffix[key] = '';
            var sB = this.toNumber(obj[key], o.prefix[key],  o.suffix[key]);
            o.targetPropeties[key] = {
                b: sB,
                c: options[key] - sB
            };
        }

        setTimeout(function() {
            o.startTime = (new Date() - 0);
            o.endTime = o.time * 1000 + o.startTime;

            if (typeof o.onStart == 'function') {
                if (o.onStartParams) {
                    o.onStart.apply(o, o.onStartParams);
                } else {
                    o.onStart();
                }
            }

            self.objects.push(o);
            if (!self.looping) { 
                self.looping = true;
                self.eventLoop.call(self);
            }
        }, o.delay * 1000);
    },
    eventLoop: function() {
        var now = (new Date() - 0);
        for (var i = 0; i < this.objects.length; i++) {
            var o = this.objects[i];
            var t = now - o.startTime;
            var d = o.endTime - o.startTime;

            if (t >= d) {
                for (var property in o.targetPropeties) {
                    var tP = o.targetPropeties[property];
                    try {
                        o.target[property] = o.prefix[property] + (tP.b + tP.c) + o.suffix[property];
                    } catch(e) {}
                }
                this.objects.splice(i, 1);

                if (typeof o.onUpdate == 'function') {
                    if (o.onUpdateParams) {
                        o.onUpdate.apply(o, o.onUpdateParams);
                    } else {
                        o.onUpdate();
                    }
                }

                if (typeof o.onComplete == 'function') {
                    if (o.onCompleteParams) {
                        o.onComplete.apply(o, o.onCompleteParams);
                    } else {
                        o.onComplete();
                    }
                }
            } else {
                for (var property in o.targetPropeties) {
                    var tP = o.targetPropeties[property];
                    var val = o.easing(t, tP.b, tP.c, d);
                    try {
                        // FIXME:For IE. A Few times IE (style.width||style.height) = value is throw error...
                        o.target[property] = o.prefix[property] + val + o.suffix[property];
                    } catch(e) {}
                }

                if (typeof o.onUpdate == 'function') {
                    if (o.onUpdateParams) {
                        o.onUpdate.apply(o, o.onUpdateParams);
                    } else {
                        o.onUpdate();
                    }
                }
            }
        }

        if (this.objects.length > 0) {
            var self = this;
            setTimeout(function() { self.eventLoop() }, 1000/self.frameRate);
        } else {
            this.looping = false;
        }
    }
};

JSTweener.Utils = {
    bezier2: function(t, p0, p1, p2) {
         return (1-t) * (1-t) * p0 + 2 * t * (1-t) * p1 + t * t * p2;
    },
    bezier3: function(t, p0, p1, p2, p3) {
         return Math.pow(1-t, 3) * p0 + 3 * t * Math.pow(1-t, 2) * p1 + 3 * t * t * (1-t) * p2 + t * t * t * p3;
    },
    allSetStyleProperties: function(element) {
         var css;
         if (document.defaultView && document.defaultView.getComputedStyle) {
             css = document.defaultView.getComputedStyle(element, null);
         } else {
             css = element.currentStyle
         }
         for (var key in css) {
             if (!key.match(/^\d+$/)) {
                 try {
                 element.style[key] = css[key];
                 } catch(e) {};
             }
         }
    }
}

/*
 * JSTweener.easingFunctions is
 * Tweener's easing functions (Penner's Easing Equations) porting to JavaScript.
 * http://code.google.com/p/tweener/
 */

JSTweener.easingFunctions = {
    easeNone: function(t, b, c, d) {
        return c*t/d + b;
    },    
    easeInQuad: function(t, b, c, d) {
        return c*(t/=d)*t + b;
    },    
    easeOutQuad: function(t, b, c, d) {
        return -c *(t/=d)*(t-2) + b;
    },    
    easeInOutQuad: function(t, b, c, d) {
        if((t/=d/2) < 1) return c/2*t*t + b;
        return -c/2 *((--t)*(t-2) - 1) + b;
    },    
    easeInCubic: function(t, b, c, d) {
        return c*(t/=d)*t*t + b;
    },    
    easeOutCubic: function(t, b, c, d) {
        return c*((t=t/d-1)*t*t + 1) + b;
    },    
    easeInOutCubic: function(t, b, c, d) {
        if((t/=d/2) < 1) return c/2*t*t*t + b;
        return c/2*((t-=2)*t*t + 2) + b;
    },    
    easeOutInCubic: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutCubic(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInCubic((t*2)-d, b+c/2, c/2, d);
    },    
    easeInQuart: function(t, b, c, d) {
        return c*(t/=d)*t*t*t + b;
    },    
    easeOutQuart: function(t, b, c, d) {
        return -c *((t=t/d-1)*t*t*t - 1) + b;
    },    
    easeInOutQuart: function(t, b, c, d) {
        if((t/=d/2) < 1) return c/2*t*t*t*t + b;
        return -c/2 *((t-=2)*t*t*t - 2) + b;
    },    
    easeOutInQuart: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutQuart(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInQuart((t*2)-d, b+c/2, c/2, d);
    },    
    easeInQuint: function(t, b, c, d) {
        return c*(t/=d)*t*t*t*t + b;
    },    
    easeOutQuint: function(t, b, c, d) {
        return c*((t=t/d-1)*t*t*t*t + 1) + b;
    },    
    easeInOutQuint: function(t, b, c, d) {
        if((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
        return c/2*((t-=2)*t*t*t*t + 2) + b;
    },    
    easeOutInQuint: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutQuint(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInQuint((t*2)-d, b+c/2, c/2, d);
    },    
    easeInSine: function(t, b, c, d) {
        return -c * Math.cos(t/d *(Math.PI/2)) + c + b;
    },    
    easeOutSine: function(t, b, c, d) {
        return c * Math.sin(t/d *(Math.PI/2)) + b;
    },    
    easeInOutSine: function(t, b, c, d) {
        return -c/2 *(Math.cos(Math.PI*t/d) - 1) + b;
    },    
    easeOutInSine: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutSine(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInSine((t*2)-d, b+c/2, c/2, d);
    },    
    easeInExpo: function(t, b, c, d) {
        return(t==0) ? b : c * Math.pow(2, 10 *(t/d - 1)) + b - c * 0.001;
    },    
    easeOutExpo: function(t, b, c, d) {
        return(t==d) ? b+c : c * 1.001 *(-Math.pow(2, -10 * t/d) + 1) + b;
    },    
    easeInOutExpo: function(t, b, c, d) {
        if(t==0) return b;
        if(t==d) return b+c;
        if((t/=d/2) < 1) return c/2 * Math.pow(2, 10 *(t - 1)) + b - c * 0.0005;
        return c/2 * 1.0005 *(-Math.pow(2, -10 * --t) + 2) + b;
    },    
    easeOutInExpo: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutExpo(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInExpo((t*2)-d, b+c/2, c/2, d);
    },    
    easeInCirc: function(t, b, c, d) {
        return -c *(Math.sqrt(1 -(t/=d)*t) - 1) + b;
    },    
    easeOutCirc: function(t, b, c, d) {
        return c * Math.sqrt(1 -(t=t/d-1)*t) + b;
    },    
    easeInOutCirc: function(t, b, c, d) {
        if((t/=d/2) < 1) return -c/2 *(Math.sqrt(1 - t*t) - 1) + b;
        return c/2 *(Math.sqrt(1 -(t-=2)*t) + 1) + b;
    },    
    easeOutInCirc: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutCirc(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInCirc((t*2)-d, b+c/2, c/2, d);
    },    
    easeInElastic: function(t, b, c, d, a, p) {
        var s;
        if(t==0) return b;  if((t/=d)==1) return b+c;  if(!p) p=d*.3;
        if(!a || a < Math.abs(c)) { a=c; s=p/4; } else s = p/(2*Math.PI) * Math.asin(c/a);
        return -(a*Math.pow(2,10*(t-=1)) * Math.sin((t*d-s)*(2*Math.PI)/p )) + b;
    },    
    easeOutElastic: function(t, b, c, d, a, p) {
        var s;
        if(t==0) return b;  if((t/=d)==1) return b+c;  if(!p) p=d*.3;
        if(!a || a < Math.abs(c)) { a=c; s=p/4; } else s = p/(2*Math.PI) * Math.asin(c/a);
        return(a*Math.pow(2,-10*t) * Math.sin((t*d-s)*(2*Math.PI)/p ) + c + b);
    },    
    easeInOutElastic: function(t, b, c, d, a, p) {
        var s;
        if(t==0) return b;  if((t/=d/2)==2) return b+c;  if(!p) p=d*(.3*1.5);
        if(!a || a < Math.abs(c)) { a=c; s=p/4; }       else s = p/(2*Math.PI) * Math.asin(c/a);
        if(t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin((t*d-s)*(2*Math.PI)/p )) + b;
        return a*Math.pow(2,-10*(t-=1)) * Math.sin((t*d-s)*(2*Math.PI)/p )*.5 + c + b;
    },    
    easeOutInElastic: function(t, b, c, d, a, p) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutElastic(t*2, b, c/2, d, a, p);
        return JSTweener.easingFunctions.easeInElastic((t*2)-d, b+c/2, c/2, d, a, p);
    },    
    easeInBack: function(t, b, c, d, s) {
        if(s == undefined) s = 1.70158;
        return c*(t/=d)*t*((s+1)*t - s) + b;
    },    
    easeOutBack: function(t, b, c, d, s) {
        if(s == undefined) s = 1.70158;
        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
    },    
    easeInOutBack: function(t, b, c, d, s) {
        if(s == undefined) s = 1.70158;
        if((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
        return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
    },    
    easeOutInBack: function(t, b, c, d, s) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutBack(t*2, b, c/2, d, s);
        return JSTweener.easingFunctions.easeInBack((t*2)-d, b+c/2, c/2, d, s);
    },    
    easeInBounce: function(t, b, c, d) {
        return c - JSTweener.easingFunctions.easeOutBounce(d-t, 0, c, d) + b;
    },    
    easeOutBounce: function(t, b, c, d) {
        if((t/=d) <(1/2.75)) {
            return c*(7.5625*t*t) + b;
        } else if(t <(2/2.75)) {
            return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
        } else if(t <(2.5/2.75)) {
            return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
        } else {
            return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
        }
    },    
    easeInOutBounce: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeInBounce(t*2, 0, c, d) * .5 + b;
        else return JSTweener.easingFunctions.easeOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
    },    
    easeOutInBounce: function(t, b, c, d) {
        if(t < d/2) return JSTweener.easingFunctions.easeOutBounce(t*2, b, c/2, d);
        return JSTweener.easingFunctions.easeInBounce((t*2)-d, b+c/2, c/2, d);
    }
};
JSTweener.easingFunctions.linear = JSTweener.easingFunctions.easeNone;

