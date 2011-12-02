//
//  Sound
//
//  Created by Cristi Baluta on 2010-05-27.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.media.SoundTransform;


class CATSound extends CAObject, implements CATransitionInterface {
	
	override public function init () :Void {
		
		var fromVolume = 1.;
		var toVolume = 1.;
		var volume :Dynamic = Reflect.field (properties, "volume");
		
		if (volume != null) {
			if (Std.is (volume, Int) || Std.is (volume, Float)) {
				
				fromVolume = target.soundTransform.volume;
				toVolume = volume;
			}
			else {
				var _fromValue	:Null<Float> = Reflect.field (volume, "fromValue");
				var _toValue	:Null<Float> = Reflect.field (volume, "toValue");
				
				if (_fromValue != null) fromVolume = _fromValue;
				if (_toValue != null)	toVolume = _toValue;
			}
		}
		
		fromValues = { volume : fromVolume };
		toValues = { volume : toVolume };
	}
	
	override public function animate (time_diff:Float) :Void {
		setVolume (target, calculate (time_diff, "volume"));
	}
	
	public function setVolume (soundObject:Dynamic, volume:Float) :Void {
		var sndTransform :SoundTransform = soundObject.soundTransform;
			sndTransform.volume = volume;
		soundObject.soundTransform = sndTransform;
	}
}
