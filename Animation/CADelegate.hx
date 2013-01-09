//
//  CADelegate.hx
//	Use this class to listen to events dispatches
//
//  Created by Baluta Cristian on 2009-03-22.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class CADelegate {
	
	public var animationDidStart :Dynamic;
	public var animationDidStop :Dynamic;
	public var animationDidReversed :Dynamic;
	public var arguments :Array<Dynamic>;// A list of objects to be passed when the animation state changes
	
	public var kenBurnsDidFadedIn :Dynamic;
	public var kenBurnsBeginsFadingOut :Dynamic;
	public var kenBurnsArgs :Array<Dynamic>;
	
	// For Ken Burns transition only
	public var startPointPassed :Bool;
	public var kenBurnsPointInPassed :Bool;
	public var kenBurnsPointOutPassed :Bool;
	public var kenBurnsPointIn :Null<Float>;// if not inited, they'll get some default values: 1/10 from total time
	public var kenBurnsPointOut :Null<Float>;
	public var pos :haxe.PosInfos;
	
	
	public function new () {
		startPointPassed = false;
		kenBurnsPointInPassed = false;
		kenBurnsPointOutPassed = false;
	}
	
	public function start () :Void {
		startPointPassed = true;
		if (Reflect.isFunction( animationDidStart ))
		try{ Reflect.callMethod (null, animationDidStart, arguments); }catch(e:Dynamic){trace(e);}
			//try{ animationDidStart/*.apply (null,*/ (arguments); }catch(e:Dynamic){trace(e);}
	}
	
	public function stop () :Void {
		// TODO: .apply is not working on Mac and ios with NME
		if (Reflect.isFunction( animationDidStop )) {
			try {
				//animationDidStop/*.apply (null,*/ (arguments);
				Reflect.callMethod (null, animationDidStop, arguments);
			}
			catch(e:Dynamic){
				trace(e);
				trace(pos.className + " -> " + pos.methodName + " -> " + pos.lineNumber);
				var stack = haxe.Stack.exceptionStack();
				trace(haxe.Stack.toString ( stack ));
			}
		}
	}
	
	public function repeat () :Void {
		if (Reflect.isFunction( animationDidReversed ))
			try{ Reflect.callMethod (null, animationDidReversed, arguments); }catch(e:Dynamic){trace(e);}
			//try{ animationDidReversed/*.apply (null,*/ (arguments); }catch(e:Dynamic){trace(e);}
	}
	
	public function kbIn () :Void {
		kenBurnsPointInPassed = true;
		if (Reflect.isFunction( kenBurnsDidFadedIn ))
			try{ Reflect.callMethod (null, kenBurnsDidFadedIn, arguments); }catch(e:Dynamic){trace(e);}
			//try{ kenBurnsDidFadedIn/*.apply (null,*/ (kenBurnsArgs); }catch(e:Dynamic){trace(e);}
	}
	
	public function kbOut () :Void {
		kenBurnsPointOutPassed = true;
		if (Reflect.isFunction( kenBurnsBeginsFadingOut ))
			try{ Reflect.callMethod (null, kenBurnsBeginsFadingOut, arguments); }catch(e:Dynamic){trace(e);}
			//try{ kenBurnsBeginsFadingOut/*.apply (null,*/ (kenBurnsArgs); }catch(e:Dynamic){trace(e);}
	}
}
