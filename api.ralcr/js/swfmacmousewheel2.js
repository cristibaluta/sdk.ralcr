/**
 * SWFMacMouseWheel v2.0: Mac Mouse Wheel functionality in flash - http://blog.pixelbreaker.com/
 *
 * SWFMacMouseWheel is (c) 2007 Gabriel Bucknall and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Dependencies: 
 * SWFObject v2.0 rc2 <http://code.google.com/p/swfobject/>
 * Copyright (c) 2007 Geoff Stearns, Michael Williams, and Bobby van der Sluis
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
var swfmacmousewheel=function(){if(!swfobject)return null;var u=navigator.userAgent.toLowerCase();var p=navigator.platform.toLowerCase();var d=p?/mac/.test(p):/mac/.test(u);if(!d)return null;var k=[];var r=function(event){var o=0;if(event.wheelDelta){o=event.wheelDelta/120;if(window.opera)o= -o;}else if(event.detail){o= -event.detail;}if(event.preventDefault)event.preventDefault();return o;};var l=function(event){var o=r(event);var c;for(var i=0;i<k.length;i++){c=swfobject.getObjectById(k[i]);if(typeof(c.externalMouseEvent)=='function')c.externalMouseEvent(o);}};if(window.addEventListener)window.addEventListener('DOMMouseScroll',l,false);window.onmousewheel=document.onmousewheel=l;return{registerObject:function(m){k[k.length]=m;}};}();