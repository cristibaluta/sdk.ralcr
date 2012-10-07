<?php

$to = $_POST["to"];
$subject = $_POST["subject"];
$message = $_POST["message"];
$from = $_POST["from"];

function safe( $name ) {
   return str_replace (array ("\r", "\n", "%0a", "%0d", "Content-Type:", "bcc:","to:","cc:"), "", $name);
}

$emailPattern = '/^[^@\s]+@([-a-z0-9]+\.)+[a-z]{2,}$/i';

if (preg_match($emailPattern, $to) && preg_match($emailPattern, $from))
	echo mail ($to, safe($subject), $message, "From:".safe($from));
else
	echo 'error::Wrong e-mail format!';