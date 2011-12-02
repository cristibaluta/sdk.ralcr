<?
$path = $_POST["path"];

if (!file_exists("../../".$path))
{
	require_once('../ftp_data.php');
	
	$FTP_Conn = ftp_connect($ftp_server, $ftp_port);
	ftp_login($FTP_Conn, $ftp_user, $ftp_pass);
	echo @ftp_mkdir($FTP_Conn, $ftp_directory.$path);
	
	// Set permissions to full write and read access
	$chmod_cmd = "CHMOD 0777 ".$ftp_directory.$path;
	$chmod = ftp_site($FTP_Conn, $chmod_cmd);
	ftp_close($FTP_Conn);
}