//
//  GKScore.hx
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKScore {
	
	var obj :CAObject;
	public var score :Int;// The current score. Can be animated
	public var bestScore :Int;// Store the best score
	public var totalScore :Int;// The score towards where score will animate
	public var speed :Float;// The speed at which the score is changing
	public var ups :Int;
	public var downs :Int;
	
	dynamic public function onChange () :Void {}
	
	
	public function new () {
		reset();
	}
	
	
	/**
	 *  Reset score and maxScore
	 **/
	public function reset () :Void {
		RCAnimation.remove ( obj );
		score = 0;
		totalScore = 0;
		bestScore = 0;
		speed = 1;
		ups = 0;
		downs = 0;
	}
	
	/**
	 *  Push 's' units to the total amount
	 **/
	public function push (s:Int) :Int {
		ups ++;
		return set (totalScore + s);
	}
	
	/**
	 *  Remove 's' units from the total ammount
	 **/
	public function remove (s:Int) :Int {
		downs ++;
		return set (totalScore - s);
	}
	
	/**
	 *  Set the score to 's'
	 **/
	public function set (s:Int) :Int {
		
		totalScore = s;
		if (score > bestScore) {
			bestScore = score;
		}
		
		RCAnimation.remove ( obj );
		obj = new CATCallFunc (update, {value:{fromValue:score, toValue:totalScore}}, speed, 0, eq.Cubic.IN_OUT);
		RCAnimation.add ( obj );
		
		return totalScore;
	}
	
	// This function is updated by RCAnimation
	function update (v:Float) {
		score = Math.round(v);
		onChange();
	}
	
	public function destroy () :Void {
		RCAnimation.remove ( obj );
		obj = null;
	}
}
