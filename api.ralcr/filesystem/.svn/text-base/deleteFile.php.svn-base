<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

$path = "../../".$_POST["path"];
echo unlink($path);