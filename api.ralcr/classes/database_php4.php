<?php
class Database {

	var $host;
	var $user;
	var $pwd;
	var $dbName;
	var $flash;
	var $dbLink;
	var $result;
	var $resultObj;
	
	function Database($host, $user, $pwd, $dbName, $flash=1){
		$this->host = $host;
		$this->user = $user;
		$this->pwd = $pwd;
		$this->dbName = $dbName;
		$this->flash = $flash;
		$this->connect();
	}

	// Connect to the mySQL Server and Select the database
	function connect() {
		$this->dbLink = @mysql_pconnect($this->host, $this->user, $this->pwd);
		if (!$this->dbLink) {
			$error = 'Couldn\'t connect to mySQL Server';
			echo $this->flash ? 'error::'.urlencode($error) : $error;
			exit();
		}
		if (!mysql_select_db($this->dbName, $this->dbLink)) { 
			$error = 'Couldn\'t open Database: '. $this->dbName;
			echo $this->flash ? 'error::'.urlencode($error) : $error;
			exit();
		}
		return $this->dbLink;		
	}

	// Execute an SQL query
	function query($query) {
		$this->result = mysql_query($query, $this->dbLink);
		if (!$this->result) {
			$error = 'MySQL Error: ' . mysql_error();
			echo $this->flash ? 'error::'.urlencode($error) : $error;
			exit();
		}		
		// store result in new object to emulate mysqli OO interface
		$this->resultObj = new MyResult($this->result);
		return $this->resultObj;
	}

	function close(){
		// Close MySQL Connection
		mysql_close($this->dbLink);
	}
}



class MyResult {

	var $theResult;
	var $num_rows;
  
	function MyResult(&$r) {
		if (is_bool($r)) {
			$this->num_rows = 0;
		}
		else {
			$this->theResult = $r;
			// get number of records found
			$this->num_rows = mysql_num_rows($r);
		}
	}

	// fetch associative array of result (works on one row at a time) 
	function fetch_assoc() {
		$newRow = mysql_fetch_assoc($this->theResult);
		return $newRow;
	}
}