<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

// check the existence of the directory
// and create if not exists
include("createDirectory.php");


$MAXIMUM_FILESIZE = 1024 * 1024 * 20; // 20MB
$path = "../../".$_POST["path"];//with slash at the end
$name = $_POST["name"];
$w = $_POST["w"];
$h = $_POST["h"];
$resize = $_POST['resize'];// fill, fit


if ($_FILES['Filedata']['size'] < $MAXIMUM_FILESIZE) {
	// upload the file
	move_uploaded_file($_FILES['Filedata']['tmp_name'], $path.$_FILES['Filedata']['name'])
	or die ("error::Can't upload");
	
	// move and resize
	rename($path.$_FILES['Filedata']['name'], $path.$name)
	or die("error::You don't have permissions to access the folder");
	
	if (isset($w) && isset($h)) {
		require_once('resize.php');
		resize($path.$name, $path.$name, $w, $h, $resize);
	}
	
	echo "File transfer completed!";
}
else echo "error::File to big! 20MB max";