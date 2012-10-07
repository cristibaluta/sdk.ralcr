<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

$file = "../../".$_POST["path"];

$fh = fopen ($file, 'w') or die("error::Can't open file for writing!");
echo fwrite ($fh, stripslashes($_POST["raw_data"]));

fclose($fh);