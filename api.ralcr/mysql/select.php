<?php
// http://www.tonymarston.net/php-mysql/domxml.html
// $_POST['distinct'] = "";
// $_POST['select_list'] = "*";
// $_POST['table_list'] = "useri";
// $_POST['where_list'] = "oras=bucuresti";
// $_POST['order_by'] = "";
// $_POST['order_rule'] = "";
// $_POST['limit'] = "0, 20";

// escape quotes and apostrophes if magic_quotes_gpc off
foreach($_POST as $key=>$value) {
	if (!get_magic_quotes_gpc()) {
		$temp = addslashes($value);
		$_POST[$key] = $temp;
	}
}

// Create variables
$distinct = $_POST['distinct'];
$select_list = $_POST['select_list'];
$table_list = $_POST['table_list'];
$where_list_temp = explode(", ", $_POST['where_list']);
$order_by = $_POST['order_by'];
$order_rule = $_POST['order_rule'];
$limit = $_POST['limit'];
$explode_by = "=";//$_POST['explode_by'];


// Check that correct variables have been received through the POST array
if ( isset($_POST['select_list']) && isset($_POST['table_list'])) {
	
	// Instantiate the database 
	require_once('../../config.php');
	require_once("../classes/database_php$php_version.php");
	$db = new Database ($db_host, $db_user, $db_pass, $db_name, 1);
	
	
	// Create sql string
	// extract conditions
	foreach ($where_list_temp as $w) {
		$e = explode($explode_by, $w);
		$where_arr[] = "`".$e[0]."`".$explode_by."'".$e[1]."'";
	}
	$where_list = implode(" AND ", $where_arr);
	
	// create sql string
	$sql_string = "SELECT";
	if ($distinct != "") $sql_string = $sql_string." DISTINCT";
	$sql_string = $sql_string." ".$select_list." FROM ".$table_list;
	if ($_POST['where_list'] != "") $sql_string = $sql_string." WHERE ".$where_list;
	if ($order_by != "") $sql_string = $sql_string." ORDER BY ".$order_by." ".$order_rule;
	if ($limit != "") $sql_string = $sql_string." LIMIT ".$limit;
	
	
	
	// Extract data from database
	$sql = mysql_query($sql_string) or die ('error::'.mysql_error());
	
	//if a match is found
	if (mysql_num_rows($sql) > 0) {
		require_once("../xml/createXml$php_version.php");
		
		$xml_string = createXml($sql);
		echo $xml_string;
	}
	else {
		echo 'error::No fields found';
	}
}
else {
	echo 'error::Invalid POST data';
}