<?php

include("../../config.php");

$username = $_POST['username'];
$password = $_POST['password'];

$userFound = false;
$passwordFound = false;

foreach ($passwords as $user => $pass) {
	if ($user == $username) {
		$userFound = true;
		if ($pass == $password) {
			break;
		}
		else die ("error::Wrong password !");
	}
}

if ($userFound)
	echo "1";
else
	echo "error::Username not found !";