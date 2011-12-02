<?php
$path = "../../".$_POST["path"];

$dir_handle = opendir($path) or die("error::Can't read directory");

while ($filename = readdir($dir_handle)){
	if ($filename != "." && $filename != ".." && $filename != ".DS_Store" && $filename != "Thumbs.db") {
		$files_arr[] = $filename;
	}
}

closedir($dir_handle);

if (sizeof($files_arr) > 0)
	echo "[FILES::".implode("*", $files_arr)."::FILES]";
else
	echo "";