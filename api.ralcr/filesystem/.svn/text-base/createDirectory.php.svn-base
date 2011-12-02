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

include("../others/checkPassword.php");
// If the file executed correctly go further

$path = $_POST["path"];

echo mkdir("../../".$path, 0777);// "" or "1"
//chmod("../../".$path, 4777);//on localhost will create a 
