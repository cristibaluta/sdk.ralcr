<?php

if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {

	$im = imagecreatefromstring ($GLOBALS["HTTP_RAW_POST_DATA"]);
	
	header('Content-Type: image/jpeg');
	header("Content-Disposition: attachment; filename=".$_GET['name']);
	imagepng($im);
	
}
else echo 'An error occured.';