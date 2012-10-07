<?php

// This script will return to flash an XML with some IPTC and EXIF fields

DEFINE('IPTC_CAPTION', '120');// 2000 chars
DEFINE('IPTC_CITY', '090');// 32 chars
DEFINE('IPTC_GLOBAL_POSITION', '092'); // improvisation for wikimapia geodata
DEFINE('EXIF_GEO_LAT', 'GPSLatitude');
DEFINE('EXIF_GEO_LAT_REF', 'GPSLatitudeRef');
DEFINE('EXIF_GEO_LON', 'GPSLongitude');
DEFINE('EXIF_GEO_LON_REF', 'GPSLongitudeRef');
DEFINE('EXIF_EXPOSURE', 'ExposureTime');
DEFINE('EXIF_APERTURE', 'FNumber');
DEFINE('EXIF_FOCAL_LENGTH', 'FocalLength');
DEFINE('EXIF_ISO', 'ISOSpeedRatings');

include "iptc.php";
include "exif.php";

$path = "../../".$_POST['path'];
$i = new iptc( $path );
$e = new exif( $path );

echo 	"<?xml version=\"1.0\" encoding=\"UTF-8\"?><info>" .
			"<caption><![CDATA[" . $i->get ( IPTC_CAPTION ) . "]]></caption>" .
			"<city><![CDATA[" . $i->get ( IPTC_CITY ) . "]]></city>" .
			"<location><![CDATA[" . $i->get ( IPTC_GLOBAL_POSITION ) . "]]></location>" .
			"<geodata>" . $e->getGPS ( EXIF_GEO_LAT, EXIF_GEO_LAT_REF ) . "+" .
						  $e->getGPS ( EXIF_GEO_LON, EXIF_GEO_LON_REF ) . "</geodata>" .
			"<exposure>" . $e->getEXIF ( EXIF_EXPOSURE ) . "</exposure>" .
			"<aperture>" . $e->getDividedEXIF ( EXIF_APERTURE ) . "</aperture>" .
			"<focallength>" . $e->getDividedEXIF ( EXIF_FOCAL_LENGTH ) . "</focallength>" .
			"<iso>" . $e->getEXIF ( EXIF_ISO ) . "</iso>" .
		"</info>";