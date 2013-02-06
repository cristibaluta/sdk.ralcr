<?php

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// For testing purpose
//$_POST['userId'] = "0";
//$_POST['friends'] = "1->eu,2->tu,3->el,4->ea";

// Create variables
$userId = $_POST['userId'];
$friends_list = explode(",", $_POST['friends']);
$table = "friends";

// check correct variables have been received through the POST array
if (isset($_POST['userId']) && isset($_POST['friends'])) {
	
	// include the Database classes
	require_once('../../config.php');
	require_once("../../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	$friendsAdded = 0;
	
	// Create columns and values to insert
	// Extract values for columns that should be checked for duplication
	foreach ($friends_list as $f) {
		
		$friend_details = explode("->", $f);
		$fi = mysql_real_escape_string($friend_details[0]);
		$fn = mysql_real_escape_string($friend_details[1]);
		
		// Search for duplicates
		$sql = $db->query("SELECT * FROM ".$table." WHERE user_id='$userId' AND friend_id='$fi'");
		
		//echo $sql->num_rows;
		if ($sql->num_rows == 0) {
			// Insert new friend into table
			$sql_str = "INSERT INTO $table (user_id, friend_id, friend_name) VALUES ($userId, '$fi', '$fn')";
			//print_r($sql_str);
			$db->query($sql_str);
			$friendsAdded ++;
		}
	}
	echo $friendsAdded." new friends added successfuly!";
}
else {
	echo "error::POST data is invalid!";
}