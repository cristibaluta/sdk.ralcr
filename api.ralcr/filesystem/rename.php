<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

$old_name = "../../".$_POST["path"];
$new_name = "../../".$_POST["new_path"];

echo rename($old_name, $new_name);