//
//  Deezer
//
//  Created by Baluta Cristian on 2008-06-06.
//  Copyright (c) 2008 http://ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.events.Event;
import flash.events.ProgressEvent;


class Deezer extends Sprite {
	
	var loader :Loader;
	var but_close :RCButton;
	var but_sound :RCGroupButtons<RCButton>;
	
	dynamic public function onClose():Void {}
	
	
	public function new (idSong:String, autoplay:Bool=false) {
		super();
		
		var background = new draw.Rectangle(0,0, 250, 100, 0x000000, 1, Vars.ROUNDNESS);
		this.addChild ( background );
		//Fugu.glow (background, 0x000000, 1, 12);
		
		loader = new Loader();
		loader.x = 14;
		loader.y = 12;
		this.addChild ( loader );
		
		
		var variables = new URLVariables();
		variables.idSong = idSong;
		variables.colorBackground = "0x555552";
		variables.textColor1 = "0xFFFFFF";
		variables.colorVolume = "0xff3300";
		variables.autoplay = autoplay ? "1" : "0";
		
		var request = new URLRequest ("http://www.deezer.com/embedded/small-widget-v2.swf");
		request.data = variables;
		request.method = URLRequestMethod.GET;
		
		loader.load ( request );
		
		
		// Add close button
		but_close = cast (constructButton ("Close"), RCButton);
		but_close.x = 14;
		but_close.y = 80;
		but_close.onClick = onCloseHandler;
		this.addChild ( but_close );
		
		
		but_sound = new RCGroupButtons<RCButton>(115, 80, -4, null, constructButton);
		but_sound.add ( ["Enabled", "Disabled"] );
		but_sound.addEventListener (GroupEvent.CLICK, clickSoundHandler);
		this.addChild ( but_sound );
		// set the first state of the sound button
		var state = Shared.set ("sound", Shared.get("sound") ? true : false);
		but_sound.select (state ? "Enabled" : "Disabled");
	}
	
	function constructButton (label:String) :RCButtonEvents {
		var s = new SKRoundedButtonWithText (label, [0x333333, 0x333333, 0xffffff, 0xff3300]);
		var b = new RCButton (0, 0, s);
		return b;
	}
	
	
	function clickSoundHandler (e:GroupEvent) :Void {
		
		but_sound.select ( e.label );
		
		switch (e.label) {
			case "Enabled":		Shared.set("sound", true);	MusicManager.dispatchEvents();
			case "Disabled":	Shared.set("sound", false);	MusicManager.dispatchEvents();
		}
	}
	
	function onCloseHandler () :Void {
		onClose();
	}
	
	
	public function destroy. () :Void {
		loader.unload();
		loader = null;
	}
}
