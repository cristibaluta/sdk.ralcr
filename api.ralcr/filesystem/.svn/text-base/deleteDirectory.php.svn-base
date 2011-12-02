<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

// Emulate register_globals on
if (!ini_get('register_globals')) {
    $superglobals = array($_SERVER, $_ENV, $_FILES, $_COOKIE, $_POST, $_GET);
    if (isset($_SESSION)) {
        array_unshift($superglobals, $_SESSION);
    }
    foreach ($superglobals as $superglobal) {
        extract($superglobal, EXTR_SKIP);
    }
    ini_set('register_globals', true);
}


$dir = "../../".$_POST["path"];
$dir = (substr($dir, -1) == "/") ? substr($dir, 0, -1) : $dir;

function unlinkRecursive($dir) {
	if (!$dh = @opendir($dir))
		return "error::This is not a directory!";

	while (false !== ($obj = readdir($dh))) {
		if($obj == '.' || $obj == '..')
			continue;

		if (!@unlink($dir.'/'.$obj))
			unlinkRecursive($dir.'/'.$obj);
	}

	closedir($dh);
	@rmdir($dir);

	return true; 
}

echo unlinkRecursive( $dir );