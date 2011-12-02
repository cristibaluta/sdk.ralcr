<?php
switch ($_POST["format"])
{
	case 'jpg':
	header('Content-Type: image/jpeg');
	break;
	
	case 'png':
	header('Content-Type: image/png');
	break;
}

if ($_POST['action'] == 'prompt')
{
	header("Content-Disposition: attachment; filename=".$_POST['fileName']);
}

echo base64_decode($_POST["image"]);
?>