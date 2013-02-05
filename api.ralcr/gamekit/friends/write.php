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
$friends_list = explode(",", $_POST['friends']);
$table = "friends";
// For testing purpose
// $userId = "11117";
// $friends_list = explode(",", "1,2,3,4,5,6,54,65,6,3,4,6666,23,32,5,2222,54,6,6");

// check correct variables have been received through the POST array
if (isset($_POST['userId']) && isset($_POST['friends'])) {
	// include the Database classes
	require_once('../../config.php');
	require_once("../../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	$friendsAdded = 0;
	
	// Create columns and values to insert
	// Extract values for columns that should be checked for duplication
	foreach ($friends_list as $f_id) {
		
		// Search for duplicates
		$sql = $db->query("SELECT * FROM ".$table." WHERE user_id='".$userId."' AND friend_id='".$f_id."'");
		
		//echo $sql->num_rows;
		if ($sql->num_rows == 0) {
			// Insert new friend into table
			$db->query("INSERT INTO $table (user_id, friend_id) VALUES ($userId, $f_id)");
			$friendsAdded ++;
		}
	}
	echo $friendsAdded." new friends added successfuly!";
}
else {
	echo "error::POST data is invalid!";
}