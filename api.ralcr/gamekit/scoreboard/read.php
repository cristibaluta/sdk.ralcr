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
$min_timestamp = $_GET['timestamp'];
$timestamp = date_timestamp_get(date_create());
echo $timestamp;


if (isset($_GET['userId']) || isset($_GET['ids'])) {
	// Instantiate the database 
	require_once('../../config.php');
	require_once("../../classes/database_php$php_version.php");
	$db = new Database ($db_host, $db_user, $db_pass, $db_name, 1);
}
if ( isset($_GET['userId']) ) {
	
	$sql_string = "SELECT * FROM scoreboard INNER JOIN friends ON ($userId = friends.user_id) 
					WHERE friends.friend_id = scoreboard.user_id AND scoreboard.timestamp >= $timestamp 
					ORDER BY scoreboard.score DESC
					LIMIT 15";
	
	// Extract data from database
	$sql = $db->query($sql_string);
	
	//if a match is found
	if ($sql->num_rows > 0) {
		$arr = array();
		while ($row = $sql->fetch_assoc()) {
			array_push($arr, "{\"id\": \"".$row["user_id"]."\", \"score:\": \"".$row["score"]."\"}");
		}
		
		echo implode (", ", $arr);
	}
	else {
		echo 'error::No fields found';
	}
}
else {
	echo 'error::Invalid GET data';
}