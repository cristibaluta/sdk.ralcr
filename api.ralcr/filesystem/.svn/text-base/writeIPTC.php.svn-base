<?php

session_start();
if ($_SESSION['hash'] != $_POST['hash']) die("error::Session expired!");

// $_POST["caption"]="Test caption";
// $_POST["city"]="city";
// $_POST["location"]="25346526876976";

$caption = $_POST["caption"];//$iptc["2#120"][0];// 2000 chars
$city = $_POST["city"];//$iptc["2#090"][0];// 32 chars
$location = $_POST["location"];//$iptc["2#092"][0];//
$path = "../../".$_POST["path"];
//"../../../photos/Portraits/20090408-2.jpg";//20090704_003129.jpg";//


DEFINE('IPTC_CITY', '090');
DEFINE('IPTC_GLOBAL_POSITION', '092');
DEFINE('IPTC_CAPTION', '120');

include "iptc.php";

$i = new iptc( $path );
$i->set(IPTC_CAPTION, $caption);
$i->set(IPTC_CITY, $city);
$i->set(IPTC_GLOBAL_POSITION, $location);
echo $i->write();
