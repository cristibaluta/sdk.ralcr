//
//  GKScore
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import Shortcuts;
import haxe.Timer;


class GKScore {
	
	var timer :Timer;
	var obj :CAObject;
	public var score :Int;
	public var totalScore :Int;
	
	
	dynamic public function onChange () :Void {}
	
	
	public function new () {
		init();
	}
	
	public function init () :Void {
		score = 0;
		totalScore = 0;
		//fade = new Fade();
	}
	
	public function add (s:Int) :Int {
		totalScore += s;
		
		CoreAnimation.remove ( obj );
		obj = new CATHaxeGetSet (this, {modifierFunction:update, val:{fromValue:score, toValue:totalScore}}, 1, 0, caequations.Cubic.IN_OUT);
		CoreAnimation.add ( obj );
		
		return totalScore;
	}
	
	function update (v:Float) {
		score = Math.round(v);
		onChange();
	}
	
	public function destroy () :Void {
		
	}
}