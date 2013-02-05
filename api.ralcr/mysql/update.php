<?php
// $_POST['table'] = "events";
// $_POST['values_list'] = "client=cristi::detalii=a12bd2f4d96724f38bb98d7e850f3762";
// $_POST['where_list'] = "eveniment=Hotel Campari";
// Syntax:
// UPDATE table_name SET col_name = value [, col_name = value] [WHERE where_expression]

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// create variables
$table = $_POST['table'];
$values_list_temp = explode("-->", $_POST['values_list']);
$where_list_temp = explode("-->", $_POST['where_list']);


// check correct variables have been received through the POST array
if (isset($_POST['table']) && isset($_POST['values_list'])) {
	// include the Database classes
	require_once('../../config.php');
	require_once("../classes/database_php$php_version.php");
	$db = new Database($db_host, $db_user, $db_pass, $db_name, 1);
	
	// create SET (values to update)
	foreach ($values_list_temp as $v) {
		$e = explode("=", $v);
		if ($e[1] == "") continue;
		$values_arr[] = "`".$e[0]."`='".$e[1]."'";
	}
	$values_list = implode(", ", $values_arr);
	
	// create WHERE
	foreach ($where_list_temp as $w) {
		$e = explode("=", $w);
		$where_arr[] = "`".$e[0]."`='".$e[1]."'";
	}
	$where_list = implode(" AND ", $where_arr);
	
	
	// create sql string
	$sql_string = "UPDATE $table SET $values_list";
	if ($_POST['where_list'] != "") $sql_string = $sql_string." WHERE ".$where_list;
	
	// Query the database
	$result = $db->query($sql_string);
	echo $result;
}