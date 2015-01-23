//
//  RCTextInput.hx
//
//  Created by Baluta Cristian on 2008-03-22.
//  Copyright (c) 2008-2012 www.ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if (flash || (openfl && (cpp || neko)))
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	#if flash
		import flash.text.AntiAliasType;
	#end
#elseif js
	import RCView;
	private typedef MouseEvent = js.html.Event;
	private typedef TextField = RCView;
#end


class RCTextInput extends RCControl {
	
	public var password (null, set) :Bool;
	public var selectable (null, set) :Bool;
	public var text (get, set) :String;
	public var textView :RCTextView;
	
	public function new (x:Float, y:Float, w:Null<Float>, h:Null<Float>, str:String, rcfont:RCFont) {
		
		super (x, y, w, h);
		
		textView = new RCTextView (0, 0, w, h, str, rcfont);
		textView.editable = true;
		addChild ( textView );
	}
	
	public function get_text() :String {
		return textView.text;
	}
	
	public function set_text (str:String) :String {
		textView.text = str;
		return str;
	}
	
	override function configureDispatchers () {
		super.configureDispatchers();
		
		editingDidBegin = new RCSignal<RCControl->Void>();
		editingChanged = new RCSignal<RCControl->Void>();
		editingDidEnd = new RCSignal<RCControl->Void>();
		editingDidEndOnEnter = new RCSignal<RCControl->Void>();
		
		//target.addEventListener (KeyboardEvent.KEY_UP, keyUpHandler);
		//target.addEventListener (MouseEvent.CLICK, clickHandler);
		//target.addEventListener (FocusEvent.FOCUS_IN, focusInHandler);
		//target.addEventListener (FocusEvent.FOCUS_OUT, focusOutHandler);
		
/*		if (size.width != null)							target.width = size.width;
		if (size.height != null && size.height != 0)	target.height = size.height;
		
		target.defaultTextFormat = rcfont.format;
		
		layer.addChild ( target );*/
	}
	
	override function set_enabled (c:Bool) :Bool {
		super.set_enabled ( c );
		return c;
	}
	
	
	// RCControl events
	override function clickHandler (e:EVMouse) :Void {
		//target.setSelection (0, target.length);
		editingDidBegin.dispatch ( this );
		super.clickHandler ( e );
	}
	
/*	function keyUpHandler (event:KeyboardEvent) :Void {
		trace(event);
		switch (event.charCode) {
			case 13: editingDidEndOnExit.dispatch ( this );
			default: editingChanged.dispatch ( this );
		}
	}*/
	
/*	function focusInHandler (e:FocusEvent) :Void {trace("in");
		onFocusIn();
	}
	function focusOutHandler (e:FocusEvent) :Void {trace("out");
		onFocusOut();
	}*/
	
	
/*	function setType (t:TextFieldType) :TextFieldType {
		return target.type = t;
	}*/
	
	function set_password (t:Bool) :Bool {
		#if (flash || (openfl && (cpp || neko)))
			return textView.target.displayAsPassword = t;
		#elseif js
			return true;
		#end
	}
	
	public function set_selectable (t:Bool) :Bool {
/*		if (t)
			target.addEventListener (MouseEvent.CLICK, clickHandler);
		else
			target.removeEventListener (MouseEvent.CLICK, clickHandler);*/
		return t;
	}
	
	
	// clean mess
	override public function destroy () :Void {
		
		editingDidBegin.destroy();
		editingChanged.destroy();
		editingDidEnd.destroy();
		editingDidEndOnEnter.destroy();
		
		super.destroy();
	}
}
