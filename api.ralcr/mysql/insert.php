<?php
// http://www.tonymarston.net/php-mysql/domxml.html
//$_POST['table'] = "news";
//$_POST['values_list'] = "title=rrr-->data=2009";
//$_POST['search_duplicate'] = "title";

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// Create variables
$table = $_POST['table'];
$values_list_temp = explode("-->", $_POST['values_list']);
$search_duplicate = $_POST['search_duplicate']; // search if a column value from values_list already exists in database


// check correct variables have been received through the POST array
if (isset($_POST['table']) && isset($_POST['values_list'])) {
	// include the Database classes
	require_once('../../config.php');
	require_once("../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	
	// Create columns and values to insert
	// Extract values for columns that should be checked for duplication
	foreach ($values_list_temp as $v) {
		$e = explode("=", $v);
		$columns_arr[] = "`".$e[0]."`";
		$values_arr[] = "'".$e[1]."'";
		
		// Find duplicate field in e[0] then extract it's value to check in database
		if ($e[0] == $search_duplicate)
			$duplicate_arr[] = $e[0]."='".$e[1]."'";
	}
	$columns_list = "(".implode(", ", $columns_arr).")";
	$values_list = "(".implode(", ", $values_arr).")";
	$duplicate_list = implode(" AND ", $duplicate_arr);
	
	
	// select the duplicates
	if ($search_duplicate != "") {
		$result = $db->query("SELECT $search_duplicate FROM $table WHERE $duplicate_list");
		$numrows = $result->num_rows;
	}
	
	// if username already in use, send back error message
	if ($numrows > 0) {
		echo "error::Field $duplicate_list already in use!";
	} else {
		// Insert data into table
		$result = $db->query("INSERT INTO $table $columns_list VALUES $values_list");
		echo $result;
	}
}