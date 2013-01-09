//
//  CATimingFunction its a shortcut to the Robert Penner equations
//
//  Created by Baluta Cristian on 2009-03-22.
//  Copyright (c) 2009 http://ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

typedef Eq = Float -> Float -> Float -> Float -> Dynamic -> Float;

class CATimingFunction {
	
	inline public static var Linear : Eq = caequations.Linear.NONE;
	
	inline public static var BackIn : Eq = caequations.Back.IN;
	inline public static var BackOut : Eq = caequations.Back.OUT;
	inline public static var BackInOut : Eq = caequations.Back.IN_OUT;
	inline public static var BackOutIn : Eq = caequations.Back.OUT_IN;
	
	inline public static var BounceIn : Eq = caequations.Bounce.IN;
	inline public static var BounceOut : Eq = caequations.Bounce.OUT;
	inline public static var BounceInOut : Eq = caequations.Bounce.IN_OUT;
	inline public static var BounceOutIn : Eq = caequations.Bounce.OUT_IN;
	
	inline public static var CircIn : Eq = caequations.Circ.IN;
	inline public static var CircOut : Eq = caequations.Circ.OUT;
	inline public static var CircInOut : Eq = caequations.Circ.IN_OUT;
	inline public static var CircOutIn : Eq = caequations.Circ.OUT_IN;
	
	inline public static var CubicIn : Eq = caequations.Cubic.IN;
	inline public static var CubicOut : Eq = caequations.Cubic.OUT;
	inline public static var CubicInOut : Eq = caequations.Cubic.IN_OUT;
	inline public static var CubicOutIn : Eq = caequations.Cubic.OUT_IN;
	
	inline public static var ElasticIn : Eq = caequations.Elastic.IN;
	inline public static var ElasticOut : Eq = caequations.Elastic.OUT;
	inline public static var ElasticInOut : Eq = caequations.Elastic.IN_OUT;
	inline public static var ElasticOutIn : Eq = caequations.Elastic.OUT_IN;
	
	inline public static var ExpoIn : Eq = caequations.Expo.IN;
	inline public static var ExpoOut : Eq = caequations.Expo.OUT;
	inline public static var ExpoInOut : Eq = caequations.Expo.IN_OUT;
	inline public static var ExpoOutIn : Eq = caequations.Expo.OUT_IN;
	
	inline public static var QuadIn : Eq = caequations.Quad.IN;
	inline public static var QuadOut : Eq = caequations.Quad.OUT;
	inline public static var QuadInOut : Eq = caequations.Quad.IN_OUT;
	inline public static var QuadOutIn : Eq = caequations.Quad.OUT_IN;
	
	inline public static var QuartIn : Eq = caequations.Quart.IN;
	inline public static var QuartOut : Eq = caequations.Quart.OUT;
	inline public static var QuartInOut : Eq = caequations.Quart.IN_OUT;
	inline public static var QuartOutIn : Eq = caequations.Quart.OUT_IN;
	
	inline public static var QuintIn : Eq = caequations.Quint.IN;
	inline public static var QuintOut : Eq = caequations.Quint.OUT;
	inline public static var QuintInOut : Eq = caequations.Quint.IN_OUT;
	inline public static var QuintOutIn : Eq = caequations.Quint.OUT_IN;
	
	inline public static var SineIn : Eq = caequations.Sine.IN;
	inline public static var SineOut : Eq = caequations.Sine.OUT;
	inline public static var SineInOut : Eq = caequations.Sine.IN_OUT;
	inline public static var SineOutIn : Eq = caequations.Sine.OUT_IN;
}
