//
//  GKScore.hx
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKScore {
	
	var obj :CAObject;
	public var score :Int;
	public var totalScore :Int;
	public var speed :Float;// The speed at which the score is changing
	
	dynamic public function onChange () :Void {}
	
	
	public function new () {
		init();
	}
	
	public function init () :Void {
		score = 0;
		totalScore = 0;
		speed = 1;
	}
	
	public function add (s:Int) :Int {
		return set (totalScore + s);
	}
	public function minus (s:Int) :Int {
		return set (totalScore - s);
	}
	public function set (s:Int) :Int {
		
		totalScore = s;
		
		CoreAnimation.remove ( obj );
		obj = new CATCallFunc (update, {value:{fromValue:score, toValue:totalScore}}, speed, 0, caequations.Cubic.IN_OUT);
		CoreAnimation.add ( obj );
		
		return totalScore;
	}
	
	
	function update (v:Float) {
		score = Math.round(v);
		onChange();
	}
	
	public function destroy () :Void {
		CoreAnimation.remove ( obj );
		obj = null;
	}
}
