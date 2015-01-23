//
//  SKSimpleButtonWithImage
//
//  Created by Baluta Cristian on 2013-12-18.
//  Copyright (c) 2013 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

class SKSimpleButtonWithImage extends RCSkin {
	
	public function new (imagePath:String, secondaryImagePath:String) {
		
		super ( null );
		
		var image = new RCImage (0, 0, imagePath);
		image.onComplete = loadComplete;
		
		normal.label = image;
		
		if (secondaryImagePath != null)
		highlighted.label = new RCImage (0, 0, secondaryImagePath);
		
		// Creates a transparent background for mouse hit area
		normal.background = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
		hit = new RCRectangle (0, 0, normal.label.width, normal.label.height, 0xFFFFFF, 0);
	}
	function loadComplete () {
		
	}
}
