<?php

session_start();

if (!exists($_SESSION['hash'])) $_SESSION['hash'] = rand(0, 5000000);

echo $_SESSION['hash'];