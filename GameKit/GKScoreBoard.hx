//
//  GKScoreBoard.hx
//
//  Created by Cristi Baluta
//  Copyright (c) 2013 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class GKScoreBoard extends RCRequest {
	
	var apiPath :String;
	var userId :String;
	
	
	/**
	 *  @param api - the path to the serverside API
	 *  @param userId - Your user id
	 **/
	public function new (apiPath:String, userId:String) {
		this.userId = userId;
		this.apiPath = apiPath;
		if (apiPath != "" && ! StringTools.endsWith (apiPath, "/"))
			this.apiPath += "/";
		super();
	}
	
	// Friends relation
	
	/**
	*  Write a relation between you and your facebook friends
	*/
	public function writeFriends (ids:Array<String>) {
		var vars = {
			userId : userId,
			friends : ids.join(",")
		}
		load (apiPath + "gamekit/friends/write.php", createVariables ( vars ), "POST");
	}
	
	
	// Scores
	
	/**
	 *  Read your top scores
	 *  @param minDate - The date to read scores onward
	 **/
	public function requestYourTopScore (?minDate:Date) {
		var vars = {
			userId : userId,
			timestamp : minDate != null ? minDate.getTime() : Date.now().getTime()
		}
		load (apiPath + "gamekit/scoreboard/read.php", createVariables ( vars ), "GET");
	}
	
	/**
	 *  Read the score
	 *  @param ids - An array with userIds to get top scores for
	 *  @param minDate - Read the scores from this date onwards
	 **/
	public function requestTopScoreForIds (ids:Array<String>, ?minDate:Date) {
		var vars = {
			ids : ids.join("*"),
			timestamp : minDate != null ? minDate.getTime() : Date.now().getTime()
		}
		load (apiPath + "gamekit/scoreboard/read.php", createVariables ( vars ), "GET");
	}
	
	/**
	 *  Read the score
	 *  @param minDate - Read the scores from this date onwards
	 **/
	public function requestTopScoreForAll (?minDate:Date) {
		var vars = {
			timestamp : minDate != null ? minDate.getTime() : Date.now().getTime()
		}
		load (apiPath + "gamekit/scoreboard/read.php", createVariables ( vars ), "GET");
	}
	public function writeScore (score:Int) {
		var vars = {
			userId : userId,
			score : score
		}
		load (apiPath + "gamekit/scoreboard/write.php", createVariables ( vars ), "POST");
	}
	
	
	// Achievements
	
	/**
	 *  Request an Array<Int> with achievements ids. 
	 *  Listen for onComplete and read the result
	 **/
	public function requestAchievements () {
		var vars = {
			userId : userId
		}
		load (apiPath + "gamekit/achievements/read.php", createVariables ( vars ), "GET");
	}
	
	/**
	 *  Write an achievement id for your userId
	 *  @param achievementId - Is your responsability to generate ids and associate them with achievement names
	 **/
	public function writeAchievement (achievementId:Int, value:String) {
		var vars = {
			userId : userId,
			achievementId :achievementId,
			value :value
		}
		load (apiPath + "gamekit/achievements/write.php", createVariables ( vars ), "POST");
	}
}
