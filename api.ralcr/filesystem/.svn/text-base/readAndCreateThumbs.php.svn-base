<?php

$path = "../../".$_POST["path"];
$sort = isset($_POST["sort"]) ? $_POST["sort"] : "LastModifiedDescending";
$w = $_POST['w'];
$h = $_POST['h'];
$resize = $_POST['resize'];// fill, fit

$allowed_to_resize = array('jpg', 'jpeg', 'png');
$not_allowed_to_read = array('.', '..', '.DS_Store', '_vti_cnf', 'Thumbs.db', '_thumb.jpg', '_sort.txt');
$thumb_sufix = ".th.";
$sort_data = "";

// Read Directory
$dir = opendir($path) or die("error::Unable to open directory: $path");

while ($filename = readdir($dir)) {
	if (in_array($filename, array("_sort.txt"))) {
		// Read the custom sort file
		// Read the file that sorts the files
		$handle = fopen($path."_sort.txt", 'r');
		$sort_data = fread($handle, filesize($path."_sort.txt"));
		$sort_data = str_replace("\n", "*", $sort_data);
		fclose($handle);
		continue;
	}
	else if (in_array($filename, $not_allowed_to_read)) continue;
	
	if (strpos($filename, $thumb_sufix) === false) {
		// Any file wich not a thumb
		$LastModified = filemtime($path.$filename);
		$files_arr[] = array($filename, $LastModified);
	}
	else {
		// Create an array with existing thumbs so we do not resize them again
		$thumbs_arr[] = $filename;
	}
}
closedir($dir);

// Sort Files
include "sort.php";
usort($files_arr, $sort);


// Extract only the filenames from the files array
// Originaly they are stored into a multidimensional array with [filename, last modified date]
foreach ($files_arr as $filename)
	$filenames_arr[] = $filename[0];



// Make Thumbs
if (function_exists("imageCreateFromJpeg") && function_exists("imageCreateTrueColor") &&
	($resize=="fit" || $resize=="fill") && isset($w) && isset($h))
{
	
	include "resize.php";
	
	foreach ($filenames_arr as $filename) {
		$f = explode(".", $filename);
		$extension = (sizeof($f) > 1) ? array_pop($f) : "";
		
		if (in_array(strtolower($extension), $allowed_to_resize)) {
			// if the extension is allowed to resize, continue
			$thumb_name = implode(".", $f).".th.".$extension;
			
			if (!in_array($thumb_name, $thumbs_arr)) {
				// original name, new name, width, height, kind of resize: "fit", "fill"
				resize ($path.$filename, $path.$thumb_name, $w, $h, $resize);
			}
		}
	}
	
}

echo "[FILES::".implode("*", $filenames_arr)."->".$sort_data."::FILES]";
