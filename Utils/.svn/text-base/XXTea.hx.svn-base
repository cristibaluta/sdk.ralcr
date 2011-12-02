package;

import haxe.io.Bytes;
import haxe.Md5;
import haxe.Serializer;

/**
 * This file and the class 'Tea' that it contains are hereby released
 * into the public domain.
 * 
 * Anyone is free to copy, modify, publish, use, compile, sell, or
 * distribute this software, either in source code form or as a compiled
 * binary, for any purpose, commercial or non-commercial, and by any
 * means.
 * 
 * In jurisdictions that recognize copyright laws, the author or authors
 * of this software dedicate any and all copyright interest in the
 * software to the public domain. We make this dedication for the benefit
 * of the public at large and to the detriment of our heirs and
 * successors. We intend this dedication to be an overt act of
 * relinquishment in perpetuity of all present and future rights to this
 * software under copyright law.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author othrayte
 */

class XXTea {
	static var DELTA:Int = 0x9e3779b9;
	
	public static function encrypt(data:String, key:String) {
		var dataArray:Array<Int> = new Array();
		while (data.length % 4 != 0) data += String.fromCharCode(0);
		for (i in 0 ... data.length>>2) {
			dataArray.push(data.charCodeAt(i*4)<<24|data.charCodeAt(i*4+1)<<16|data.charCodeAt(i*4+2)<<8|data.charCodeAt(i*4+3));
		}
		var hashedKey:String = Md5.encode(key);
		var keyArray:Array<Int> = new Array();
		for (i in 0 ... 4) {
			keyArray.push(Std.parseInt("0x" + hashedKey.substr(i*8, 8)));
		}
		btea(dataArray, dataArray.length, keyArray);
		var out:String = "";
		for (i in dataArray) {
			var a = i >> 24 & 0xFF;
			var b = i >> 16 & 0xFF;
			var c = i >> 8 & 0xFF;
			var d = i & 0xFF;
			out += "-"+StringTools.hex(i);
		}
		return out.substr(1);
	}
	
	public static function decrypt(data:String, key:String) {
		var dataArray:Array<Int> = new Array();
		var dataStringArray:Array<String> = data.split("-");
		for (i in 0 ... dataStringArray.length) {
			dataArray.push(b32(Std.parseInt("0x" + dataStringArray[i])));
		}
		var hashedKey:String = Md5.encode(key);
		var keyArray:Array<Int> = new Array();
		for (i in 0 ... 4) {
			keyArray.push(Std.parseInt("0x" + hashedKey.substr(i*8, 8)));
		}
		btea(dataArray, -dataArray.length, keyArray);
		var out:String = "";
		for (i in dataArray) {
			var a = i >> 24 & 0xFF;
			var b = i >> 16 & 0xFF;
			var c = i >> 8 & 0xFF;
			var d = i & 0xFF;
			out += String.fromCharCode(a)+String.fromCharCode(b)+String.fromCharCode(c)+String.fromCharCode(d);
		}
		return out;
	}
	
	// v is n word vector, k is 4 word key, negative n is decode signal
	public static function btea(v:Array<Int>, n:Int, k:Array<Int>) {
		var z:Int;
		var y:Int=0;
		var sum:Int;
		var p:Int=0;
		var rounds:Int;
		var e:Int;
		
		if (n > 1) {          /* Coding Part */
			rounds = 6 + Math.floor(52/n);
			sum = 0;
			z = v[n-1];
			do {
				sum = b32(sum + DELTA);
				e = (sum >>> 2) & 3;
				p = 0;
				while (p < n-1) {
					y = v[p+1];
					v[p] = b32(v[p] + (b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ b32((sum ^ y) + (k[(p & 3) ^ e] ^ z))));
					z = v[p];
					p++;
				}
				y = v[0];
				v[n - 1] = b32(v[n - 1] + (b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ b32((sum ^ y) + (k[(p & 3) ^ e] ^ z))));
				z = v[n - 1];
			} while (--rounds != 0);
		} else if (n < -1) {  /* Decoding Part */
			n = -n;
			rounds = 6 + Math.floor(52/n);
			sum = b32(rounds*DELTA);
			y = v[0];
			do {
				e = (sum >>> 2) & 3;
				p = n-1;
				while (p>0) {
					z = v[p-1];
					v[p] = b32(v[p]-(b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
					y = v[p];
					p--;
				}
				z = v[n-1];
				v[0] = b32(v[0] - (b32((z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4)) ^ b32((sum ^ y) + (k[p & 3 ^ e] ^ z))));
				y = v[0];
			} while ((sum = b32(sum - DELTA)) != 0);
		}
	}
	
	static function b32(value):Int {
		#if php
		untyped __php__("return (int) $value");
		/*if ($value < -2147483648)  {
			return -(-($value) & 0xffffffff);
		} else if ($value > 2147483647) {
			return ($value & 0xffffffff);
		}");*/
		#end
		return value;
	}
}