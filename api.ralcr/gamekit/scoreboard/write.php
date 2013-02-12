<?php

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// Create variables
$userId = $_POST['userId'];
$score = $_POST['score'];
$table = "scoreboard";
// For testing purpose
// $userId ="4353245";
// $score = "555";
$timestamp = time();

// check correct variables have been received through the POST array
if (isset($_POST['userId']) && isset($_POST['score'])) {
	// include the Database classes
	require_once('../../config.php');
	require_once("../../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	
	// Create columns and values to insert
	$db->query("INSERT INTO $table (user_id, score) VALUES ($userId, $score)");
	
	echo $score." points added successfuly to user_id ".$userId;
}
else {
	echo "error::POST data is invalid!";
}
