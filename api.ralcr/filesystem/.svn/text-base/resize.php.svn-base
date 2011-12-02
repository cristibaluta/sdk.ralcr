<?php
/*
 original name
 final name
 new width
 new height
 kind of resize:"fill" (resize the image to fill the new width and new height)
				"fit" (resize the image to fit the new width and height.
						one of them might not be fill completely)
*/
function resize ($path, $new_path, $w, $h, $kindOfResize) {
	
	$extension = strtolower( array_pop( explode(".", $path)));
	
	if (preg_match("/jpg|jpeg/", $extension))	$src_img = imagecreatefromjpeg( $path );
	if (preg_match("/png/", $extension))		$src_img = imagecreatefrompng( $path );
	
	if (!isset($src_img)) return;
	
	
	$src_w = imageSX( $src_img );
	$src_h = imageSY( $src_img );
	$src_x = 0; // source x and y (fit: 0,0), (fill: recalculate to center)
	$src_y = 0;
	
	$dst_w = $w; // destination width and height
	$dst_h = $h;
	$dst_x = 0; // destination x and y: 0,0 all the time
	$dst_y = 0;
	
	
	// Resize only if original is bigger than the new desired size
	if ($src_w > $w || $src_h > $h) {
		
		if ($src_w / $w > $src_h / $h) {
			// larger on width axis
			if ($kindOfResize == "fill") {
				// resize then crop in center
				$org_w = $src_w;//original w,h use when calculating the new x,y with the new w,h
				$org_h = $src_h;
				//
				$src_h = $org_h;
				$src_w = $org_h * $dst_w / $dst_h;
			}
			else {
				// resize the image to fit the smaller border
				$dst_w = $w;
				$dst_h = $src_h * $w / $src_w;
			}
		}
		else {
			// larger on height axis
			if ($kindOfResize == "fill") {
				// resize then crop in center
				$org_w = $src_w;//original w,h use when calculating the new x,y with the new w,h
				$org_h = $src_h;
				//
				$src_w = $org_w;
				$src_h = $org_w * $dst_h / $dst_w;
			}
			else {
				$dst_h = $h;
				$dst_w = $src_w * $h / $src_h;
			}
		}
		
		// copy pixels from center
		if ($kindOfResize == "fill") {
			$src_x = ($org_w - $src_w) / 2;
			$src_y = ($org_h - $src_h) / 2;
		}
		
		
		$dst_img = ImageCreateTrueColor ($dst_w, $dst_h);
		// In other words, imagecopyresampled() will take an rectangular area from src_image of width src_w and height src_h at position (src_x ,src_y ) and place it in a rectangular area of dst_image of width dst_w and height dst_h at position (dst_x ,dst_y ).
		imagecopyresampled ($dst_img, $src_img, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h); 
		//imagejpeg($dst_img, $new_path, 90);
		
		if (preg_match("/png/", $extension))
			imagepng($dst_img, $new_path, 90);
		else
			imagejpeg($dst_img, $new_path, 90);
		
		imagedestroy ( $dst_img );
		imagedestroy ( $src_img );
	}
}
