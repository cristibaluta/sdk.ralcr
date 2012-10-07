//
//  Elasticity
//
//  Created by Cristi Baluta on 2010-10-20.
//  Copyright (c) 2010 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
import Shortcuts;


class Elasticity extends RCView {
	
	
	//elastic force, lies parallel to spring f = -kd
	
	inline public static function f (k, d) :Float {
		return - k * d;
	}
	//elastic potential energy	U = kx^2 / 2
	inline public static function U (k, x) :Float {
		return k*x*x / 2;
	}
	
	//elastic work, positive when relaxes	W = − kΔ(x2) / 2
	inline public static function W () :Float {
		
	}
}