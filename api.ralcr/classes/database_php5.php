<?php
class Database {

	protected $host;
	protected $user;
	protected $pwd;
	protected $dbName;
	protected $flash;
	protected $dbLink;
	protected $result;
	protected $resultObj;

	function __construct($host, $user, $pwd, $dbName, $flash=1){
		$this->host = $host;
		$this->user = $user;
		$this->pwd = $pwd;
		$this->dbName = $dbName;
		$this->flash = $flash;
		$this->connect(); 
	}

	// connect to the MySQL server and select the database
	public function connect() {
		try {
			$this->dbLink = @mysql_pconnect($this->host, $this->user, $this->pwd);
			if (!$this->dbLink) {
				throw new Exception ("Couldn't connect $this->user to mySQL Server");
			}
			if (!mysql_select_db($this->dbName, $this->dbLink)) { 
				throw new Exception ('Couldn\'t open Database: '. $this->dbName);
			}
		}
		catch (Exception $e) {
			echo $this->flash ? 'error::'.urlencode($e->getMessage()) : $e->getMessage();
			exit();
		}
		return $this->dbLink;		
	}

	// execute an SQL query
	public function query($query) {
		try {
			$this->result = mysql_query($query, $this->dbLink);
			if (!$this->result) {
				throw new Exception ('MySQL Error: ' . mysql_error());
			}
		}
		catch (Exception $e) {
			echo $this->flash ? 'error::'.urlencode($e->getMessage()) : $e->getMessage();
			exit();
		}	  
		// store result in new object to emulate mysqli OO interface
		$this->resultObj = new MyResult($this->result);
		return $this->resultObj;
	}

	// Close MySQL Connection
	public function close(){
		mysql_close($this->dbLink);
	}	
}



class MyResult {

	protected $theResult;
	public $num_rows;
  
	function __construct($r) {
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
	public function fetch_assoc() {
		$newRow = mysql_fetch_assoc($this->theResult);
		return $newRow;
	}
}