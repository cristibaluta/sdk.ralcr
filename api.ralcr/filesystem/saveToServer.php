<?php
if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {

	$im =  $GLOBALS["HTTP_RAW_POST_DATA"];
	
	$fp = fopen($_GET['name'], 'wb');	
	echo fwrite($fp, $im);
	fclose($fp);
	
	echo "Saved successfully: ".$_GET['name'];
}
else
	echo 'An error occured.';