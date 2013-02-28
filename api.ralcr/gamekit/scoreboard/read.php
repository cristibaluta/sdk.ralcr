<?php

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_GET as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_GET[$key] = $temp;
	}
}

// Create variables
$userId = $_GET['userId'];
$includeFriends = $_GET['includeFriends'];
$min_timestamp = $_GET['timestamp'];
$timestamp = time() - 1000*30*24*60*60;
//echo $timestamp;


// Instantiate the database 
require_once('../../config.php');
require_once("../../classes/database_php$php_version.php");
$db = new Database ($db_host, $db_user, $db_pass, $db_name, 1);

// Return friends top score
if (isset($_GET['userId']) && isset($_GET['includeFriends'])) {
	
	$sql_string = "SELECT * FROM scoreboard INNER JOIN friends ON ($userId = friends.user_id) 
					WHERE (friends.friend_id = scoreboard.user_id) AND scoreboard.timestamp >= $timestamp AND friends.friend_id != friends.user_id
					ORDER BY scoreboard.score DESC
					LIMIT 15";// OR $userId = scoreboard.user_id
}
// Return only your scores
else if (isset($_GET['userId'])) {
	
	$sql_string = "SELECT * FROM scoreboard INNER JOIN friends ON ($userId = friends.friend_id) 
					WHERE scoreboard.user_id = $userId AND scoreboard.timestamp >= $timestamp AND friends.friend_id != friends.user_id
					ORDER BY scoreboard.score DESC
					LIMIT 15";
}
// Return all users top score
else {
	
	$sql_string = "SELECT *
					FROM (select * from scoreboard ORDER BY score DESC) as sb INNER JOIN friends
					WHERE friends.friend_id = sb.user_id AND friends.friend_id != friends.user_id
					GROUP BY sb.user_id order by score desc
					LIMIT 15";
}



// Extract data from database
$sql = $db->query($sql_string);

//if a match is found
if ($sql->num_rows > 0) {
	$arr = array();
	while ($row = $sql->fetch_assoc()) {
		array_push($arr, "{\"name\": \"".$row["friend_name"]."\", \"score\": \"".$row["score"]."\"}");
	}
		
	echo "[".implode (", ", $arr)."]";
}
else {
	echo 'error::No fields found';
}