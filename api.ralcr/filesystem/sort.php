<?php
function LastModifiedAscending($a, $b) {
	return ($a[1] < $b[1]) ? -1:1;
}
function LastModifiedDescending($a, $b) {
	return ($a[1] > $b[1]) ? -1:1;
}
function Ascending($a, $b) {
	return ($a[0] < $b[0]) ? -1:1;
}
function Descending($a, $b) {
	return ($a[0] > $b[0]) ? -1:1;
}

// function Custom($a, $b) {
// 	// 
// 	var ab = array();
// 	
// 	foreach ($b as $sortfilename) {
// 		foreach ($a as $filename) {
// 			
// 		}
// 	}
// }