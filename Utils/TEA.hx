/**
* Encrypts and decrypts text with the TEA (Block) algorithm.
* @authors Mika Palmu
* @authors - ported to haXe from AS3 by Baluta Cristian: http://ralcr.com
* @version 2.0
*
* Original Javascript implementation:
* Chris Veness, Movable Type Ltd: www.movable-type.co.uk
* Algorithm: David Wheeler & Roger Needham, Cambridge University Computer Lab
* See http://www.movable-type.co.uk/scripts/TEAblock.html
*/

class TEA {
	
	inline public static var DELTA:UInt = 0x9E3779B9;
	
	/**
	* Encrypts a string with the specified key.
	*/
	public static function encrypt (src:String, key:String) :String {
		var v:Array<Null<Int>> = charsToLongs ( strToChars ( src ) );
		var k:Array<Null<Int>> = charsToLongs ( strToChars ( key ) );
		var n:Int = v.length;
		var p:Int = 0;
		
		if (n == 0) return "";
		if (n == 1) v[n++] = 0;
		
		var z:UInt = v[n-1], y:UInt = v[0];
		var mx:Int, e:Int, q:Int = Math.floor(6+52/n), sum:UInt = 0;
		
		while (q-- > 0) {
			sum += DELTA;
			e = sum>>>2 & 3;
			for (i in 0...(n-1)) {
				p = i;
				y = v[p+1];
				mx = (z>>>5^y<<2) + (y>>>3^z<<4)^(sum^y) + (k[p&3^e]^z);
				z = v[p] += mx;
			}
			p++;
			y = v[0];
			mx = (z>>>5^y<<2) + (y>>>3^z<<4)^(sum^y) + (k[p&3^e]^z);
			z = v[n-1] += mx;
		}
		return charsToHex ( longsToChars(v) );
	}
	
	/**
	* Decrypts a string with the specified key.
	*/
	public static function decrypt (src:String, key:String) :String {
		var v:Array<Null<Int>> = charsToLongs ( hexToChars ( src ) );
		var k:Array<Null<Int>> = charsToLongs ( strToChars ( key ) );
		var n:Int = v.length;
		var p:Int;
		
		if (n == 0) return "";
		
		var z:Int = v[n-1], y:Int = v[0];
		var mx:Int, e:Int, q:Int = Math.floor(6 + 52/n);
		var sum:UInt = q*DELTA;
		
		while (sum != 0) {
			e = sum>>>2 & 3;
			p = n-1;
			while (p > 0) {
				z = v[p-1];
				mx = (z>>>5^y<<2) + (y>>>3^z<<4)^(sum^y) + (k[p&3^e]^z);
				y = v[p] -= mx;
				p--;
			}
			
			z = v[n-1];
			mx = (z>>>5^y<<2) + (y>>>3^z<<4)^(sum^y) + (k[p&3^e]^z);
			y = v[0] -= mx;
			sum -= DELTA;
		}
		
		return charsToStr ( longsToChars( v ) );
	}
	
	/**
	* Private methods.
	*/
	static function charsToLongs (chars:Array<Int>) :Array<Int> {
		var temp = new Array<Int>();
		for (i in 0...Math.ceil(chars.length/4)) {
			temp[i] = chars[i*4] + (chars[i*4+1]<<8) + (chars[i*4+2]<<16) + (chars[i*4+3]<<24);
		}
		return temp;
	}
	static function longsToChars (longs:Array<Null<Int>>) :Array<Int> {
		var codes = new Array<Int>();
		for (i in 0...longs.length) {
			codes.push ( longs[i] & 0xFF );
			codes.push ( longs[i]>>>8  & 0xFF );
			codes.push ( longs[i]>>>16 & 0xFF );
			codes.push ( longs[i]>>>24 & 0xFF );
		}
		return codes;
	}
	static function longToChars (longs:Int) :Array<Int> {
		return [longs & 0xFF, longs>>>8 & 0xFF, longs>>>16 & 0xFF, longs>>>24 & 0xFF];
	}
	static function charsToHex (chars:Array<Int>) :String {
		var result = "";
		var hexes = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
		for (char in chars) {
			result += hexes[char >> 4] + hexes[char & 0xf];
		}
		return result;
	}
	static function hexToChars (hex:String) :Array<Null<Int>> {
		var codes = new Array<Null<Int>>();
		var i = (hex.substr(0, 2) == "0x") ? 2 : 0;
		while (i < hex.length) {
			codes.push ( Std.parseInt ("0x"+hex.substr(i, 2)/*, 16*/) );
			i+=2;
		}
		return codes;
	}
	static function charsToStr (chars:Array<Int>) :String {
		var result = new StringBuf();
		for (char in chars)
			if (char > 0) result.addChar ( char );
		return result.toString();
	}
	static function strToChars (str:String) :Array<Int> {
		var codes = new Array<Int>();
		for (i in 0...str.length)
			codes.push ( str.charCodeAt ( i ) );
		return codes;
	}
	
}
