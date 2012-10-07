<?php
// Reading EXIF data:
// $exif = exif_read_data('dummyimage.jpg',0,TRUE);
// 
// Degrees:
// $deg=$exif["GPS"]["GPSLatitude"][0];
// 
// Minutes:
// $min=$exif["GPS"]["GPSLatitude"][1];
// 
// Seconds:
// $sec=$exif["GPS"]["GPSLatitude"][2];
// 
// Hemisphere (N, S, W ou E):
// $hem=$exif["GPS"]["GPSLatitudeRef"];
// 
// Altitude:
// $alt=$exif["GPS"]["GPSAltitude"][0];

//ini_set('exif.encode_unicode', 'UTF-8');

class exif {
	var $meta=Array();
	
	function exif($filename) {
		$this->meta = exif_read_data ($filename, 0, TRUE);
	}
	function getEXIF($tag) {
		return isset (	$this->meta["EXIF"]["$tag"])
						? $this->meta["EXIF"]["$tag"]
						: false;
	}
	function getDividedEXIF($tag) {
		return isset (	$this->meta["EXIF"]["$tag"])
						? $this->divide ( $this->meta["EXIF"]["$tag"] )
						: false;
	}
	function getGPS($tag, $tag_ref) {
		//http:/maps.google.com/maps?q=51°22%2749.03%22N+7°47%2712.04%22E
		return isset (	$this->meta["GPS"]["$tag"])
						? (	$this->divide ( $this->meta["GPS"]["$tag"][0] ) . "°" .
							$this->divide ( $this->meta["GPS"]["$tag"][1] ) . "%27" .
							$this->divide ( $this->meta["GPS"]["$tag"][2] ) . "%22" .
							$this->meta["GPS"]["$tag_ref"]
						  )
						: false;
	}
	function divide($d) {
		// Geodata numbers are received as division, so we need to calculate them
		$o = explode("/", $d);
		if ($o[0] == "" || $o[1] == "" || $o[0] == "0" || $o[1] == "0")
			return "0";
			return round($o[0] / $o[1], 2);
	}
};