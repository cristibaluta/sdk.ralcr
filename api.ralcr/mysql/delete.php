<?php
// $_POST['table'] = "events";
// $_POST['where_list'] = "menu=events::categorie=creative brand events::eveniment=d";

// Syntax:
// DELETE table_name [WHERE where_expression]

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// create variables
$table = $_POST['table'];
$where_list_temp = explode("-->", $_POST['where_list']);

// check correct variables have been received through the POST array
if ( isset($_POST['table']) && isset($_POST['where_list']) ) {
	// include the Database classes
	require_once('../../config.php');
	require_once("../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	
	// Create WHERE conditions
	foreach ($where_list_temp as $w) {
		$e = explode("=", $w);
		$where_arr[] = "`".$e[0]."`='".$e[1]."'";
	}
	$where_list = implode(" AND ", $where_arr);
	
	
	// Create sql string
	$sql_string = "DELETE FROM $table";
	if ($_POST['where_list'] != "") $sql_string = $sql_string." WHERE ".$where_list;
	
	// Query the database
	$result = $db->query($sql_string);
	echo $result;
}