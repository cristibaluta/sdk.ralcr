<?php
$path = "../../".$_POST["path"];
$fh = fopen($path, 'r');
$data = fread($fh, filesize($path));
fclose($fh);
echo $data;