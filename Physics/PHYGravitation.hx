//
//  Gravitation
//
//  Created by Cristi Baluta on 2010-10-20.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class Gravitation {
	
	inline public static var a = 9.81;
	
	inline public function f_G () :Float {
		return Gm1m2 / r*r;
	}
	
}
