//
//  GKScoreBoard.hx
//
//  Created by Cristi Baluta on 2010-10-26.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKScoreBoard extends RCRequest {
	
	/**
	 *  @param api - the path to the serverside API
	 *  @param userId - Your user id
	 **/
	public function new (api:String, userId:String) {
		super();
	}
	
	// Scores
	
	/**
	 *  Read your top scores
	 *  @param minDate - The date to read scores onward
	 **/
	public function requestYourTopScore (?minDate:Date) {
	
	}
	
	/**
	 *  Read the score
	 *  @param ids - An array if userIds to get top scores for
	 *  @param minDate - The date to read scores 
	 **/
	public function requestTopScoreForIds (ids:Array<String>, ?minDate:Date) {
	
	}
	
	/**
	 *  Read the score
	 *  @param minDate - The date to read scores 
	 **/
	public function requestTopScoreForAll (?minDate:Date) {
	
	}
	public function writeScore (score:Int) {
	
	}
	
	
	// Achievements
	
	/**
	 *  Request an Array<Int> with achievements ids. 
	 *  Listen for onComplete and read the result
	 **/
	public function requestAchievements () {
	
	}
	
	/**
	 *  Write an achievement id for your userId
	 *  @param achievementId - Is your responsability to generate ids and associate them with achievement names
	 **/
	public function writeAchievement (achievementId:Int) {
	
	}
}
