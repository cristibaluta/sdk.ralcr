/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
	Ported to haXe by Baluta Cristian (http://ralcr.com/jpgencoder/)
*/
import flash.display.BitmapData;
import flash.utils.ByteArray;
	
/**
 * Class that converts BitmapData into a valid JPEG
 */		
class JPGEncoder {
	// Static table initialization
	inline static var ZigZag :Array<Int> = [
			 0, 1, 5, 6,14,15,27,28,
			 2, 4, 7,13,16,26,29,42,
			 3, 8,12,17,25,30,41,43,
			 9,11,18,24,31,40,44,53,
			10,19,23,32,39,45,52,54,
			20,22,33,38,46,51,55,60,
			21,34,37,47,50,56,59,61,
			35,36,48,49,57,58,62,63
	];
			
	var YTable :Array<Int>;
	var UVTable :Array<Int>;
	var fdtbl_Y :Array<Float>;
	var fdtbl_UV :Array<Float>;
	
	/**
	 * Constructor for JPEGEncoder class
	 *
	 * @param quality The quality level between 1 and 100 that detrmines the
	 * level of compression used in the generated JPEG
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function new (?quality:Int = 80) {
		YTable = new Array<Int>();
		UVTable = new Array<Int>();
		fdtbl_Y = new Array<Float>();
		fdtbl_UV = new Array<Float>();
		
		if (quality <= 0) quality = 1;
		if (quality > 100) quality = 100;
		
		var sf :Int = 0;
		if (quality < 50)
			sf = Math.round (5000 / quality);
		else
			sf = Math.round (200 - quality*2);
			
		// Create tables
		initHuffmanTbl();
		initCategoryNumber();
		initQuantTables (sf);
	}
	
	
	/**
	 * Created a JPEG image from the specified BitmapData
	 *
	 * @param image The BitmapData that will be converted into the JPEG format.
	 * @return a ByteArray representing the JPEG encoded image data.
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function encode (image:BitmapData) :ByteArray {
		// Initialize bit writer
		byteout = new ByteArray();
		bytenew = 0;
		bytepos = 7;
		DU = new Array<Int>();
		
		// for RGB2YUB
		YDU = new Array<Float>();// 64
		UDU = new Array<Float>();
		VDU = new Array<Float>();

		// Add JPEG headers
		writeWord (0xFFD8); // SOI
		writeAPP0();
		writeDQT();
		writeSOF0 (image.width, image.height);
		writeDHT();
		writeSOS();


		// Encode 8x8 macroblocks
		var DCY :Int = 0;
		var DCU :Int = 0;
		var DCV :Int = 0;
		bytenew = 0;
		bytepos = 7;
		
		var ypos :Int = 0;
		while (ypos < image.height) {
			var xpos :Int = 0;
			while (xpos < image.width) {
				RGB2YUV (image, xpos, ypos);
				DCY = processDU (YDU, fdtbl_Y,  DCY, YDC_HT,  YAC_HT);
				DCU = processDU (UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
				DCV = processDU (VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
				xpos += 8;
			}
			ypos += 8;
		}

		// Do the bit alignment of the EOI marker
		if (bytepos >= 0) {
			var fillbits :BitString = new BitString();
			fillbits.len = bytepos+1;
			fillbits.val = (1<<(bytepos+1))-1;
			writeBits (fillbits);
		}

		writeWord (0xFFD9); //EOI
		return byteout;
	}
	
	
	function initQuantTables (sf:Int) :Void {
		var YQT :Array<Int> = [
			16, 11, 10, 16, 24, 40, 51, 61,
			12, 12, 14, 19, 26, 58, 60, 55,
			14, 13, 16, 24, 40, 57, 69, 56,
			14, 17, 22, 29, 51, 87, 80, 62,
			18, 22, 37, 56, 68,109,103, 77,
			24, 35, 55, 64, 81,104,113, 92,
			49, 64, 78, 87,103,121,120,101,
			72, 92, 95, 98,112,100,103, 99
		];
			
		for (i in 0...64) {
			var t :Int = Math.floor ((YQT[i]*sf+50)/100);
			if (t < 1)
				t = 1;
			else if (t > 255)
				t = 255;
				
			YTable[ZigZag[i]] = t;
		}
		
		var UVQT :Array<Int> = [
			17, 18, 24, 47, 99, 99, 99, 99,
			18, 21, 26, 66, 99, 99, 99, 99,
			24, 26, 56, 99, 99, 99, 99, 99,
			47, 66, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99
		];
			
		for (i in 0...64) {
			var t :Int = Math.floor ((UVQT[i]*sf+50)/100);
			if (t < 1)
				t = 1;
			else if (t > 255)
				t = 255;
			
			UVTable[ZigZag[i]] = t;
		}
		
		var aasf :Array<Float> = [
			1.0, 1.387039845, 1.306562965, 1.175875602,
			1.0, 0.785694958, 0.541196100, 0.275899379
		];
			
		var i :Int = 0;
		for (row in 0...8) {
			for (col in 0...8) {
				fdtbl_Y[i]  = (1.0 / (YTable [ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
				fdtbl_UV[i] = (1.0 / (UVTable[ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
				i++;
			}
		}
	}
	
	var YDC_HT :Array<BitString>;
	var UVDC_HT :Array<BitString>;
	var YAC_HT :Array<BitString>;
	var UVAC_HT :Array<BitString>;

	function computeHuffmanTbl (nrcodes:Array<Int>, std_table:Array<Int>) : Array<BitString> {
		var codevalue :Int = 0;
		var pos_in_table :Int = 0;
		var HT = new Array<BitString>();
		for (k in 1...17) {
			for (j in 1...nrcodes[k]+1) {
				HT[std_table[pos_in_table]] = new BitString();
				HT[std_table[pos_in_table]].val = codevalue;
				HT[std_table[pos_in_table]].len = k;
				pos_in_table++;
				codevalue++;
			}
			codevalue*=2;
		}
		return HT;
	}

	inline static var std_dc_luminance_nrcodes :Array<Int> = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
	inline static var std_dc_luminance_values :Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11];
	inline static var std_ac_luminance_nrcodes :Array<Int> = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,0x7d];
	inline static var std_ac_luminance_values :Array<Int> = [
		0x01,0x02,0x03,0x00,0x04,0x11,0x05,0x12,
		0x21,0x31,0x41,0x06,0x13,0x51,0x61,0x07,
		0x22,0x71,0x14,0x32,0x81,0x91,0xa1,0x08,
		0x23,0x42,0xb1,0xc1,0x15,0x52,0xd1,0xf0,
		0x24,0x33,0x62,0x72,0x82,0x09,0x0a,0x16,
		0x17,0x18,0x19,0x1a,0x25,0x26,0x27,0x28,
		0x29,0x2a,0x34,0x35,0x36,0x37,0x38,0x39,
		0x3a,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
		0x4a,0x53,0x54,0x55,0x56,0x57,0x58,0x59,
		0x5a,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
		0x6a,0x73,0x74,0x75,0x76,0x77,0x78,0x79,
		0x7a,0x83,0x84,0x85,0x86,0x87,0x88,0x89,
		0x8a,0x92,0x93,0x94,0x95,0x96,0x97,0x98,
		0x99,0x9a,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,
		0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,0xb5,0xb6,
		0xb7,0xb8,0xb9,0xba,0xc2,0xc3,0xc4,0xc5,
		0xc6,0xc7,0xc8,0xc9,0xca,0xd2,0xd3,0xd4,
		0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xe1,0xe2,
		0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,
		0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
		0xf9,0xfa
	];

	inline static var std_dc_chrominance_nrcodes :Array<Int> = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
	inline static var std_dc_chrominance_values :Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11];
	inline static var std_ac_chrominance_nrcodes :Array<Int> = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,0x77];
	inline static var std_ac_chrominance_values :Array<Int> = [
		0x00,0x01,0x02,0x03,0x11,0x04,0x05,0x21,
		0x31,0x06,0x12,0x41,0x51,0x07,0x61,0x71,
		0x13,0x22,0x32,0x81,0x08,0x14,0x42,0x91,
		0xa1,0xb1,0xc1,0x09,0x23,0x33,0x52,0xf0,
		0x15,0x62,0x72,0xd1,0x0a,0x16,0x24,0x34,
		0xe1,0x25,0xf1,0x17,0x18,0x19,0x1a,0x26,
		0x27,0x28,0x29,0x2a,0x35,0x36,0x37,0x38,
		0x39,0x3a,0x43,0x44,0x45,0x46,0x47,0x48,
		0x49,0x4a,0x53,0x54,0x55,0x56,0x57,0x58,
		0x59,0x5a,0x63,0x64,0x65,0x66,0x67,0x68,
		0x69,0x6a,0x73,0x74,0x75,0x76,0x77,0x78,
		0x79,0x7a,0x82,0x83,0x84,0x85,0x86,0x87,
		0x88,0x89,0x8a,0x92,0x93,0x94,0x95,0x96,
		0x97,0x98,0x99,0x9a,0xa2,0xa3,0xa4,0xa5,
		0xa6,0xa7,0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,
		0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xc2,0xc3,
		0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xd2,
		0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,
		0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,
		0xea,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
		0xf9,0xfa
	];

	function initHuffmanTbl () :Void {
		YDC_HT = computeHuffmanTbl (std_dc_luminance_nrcodes, std_dc_luminance_values);
		UVDC_HT = computeHuffmanTbl (std_dc_chrominance_nrcodes, std_dc_chrominance_values);
		YAC_HT = computeHuffmanTbl (std_ac_luminance_nrcodes, std_ac_luminance_values);
		UVAC_HT = computeHuffmanTbl (std_ac_chrominance_nrcodes, std_ac_chrominance_values);
	}

	var bitcode :Array<BitString>;//(65535);
	var category :Array<Int>;//(65535);

	function initCategoryNumber () :Void {
		var nrlower :Int = 1;
		var nrupper :Int = 2;
		bitcode = new Array<BitString>();
		category = new Array<Int>();
		
		for (cat in 1...16) {
			//Positive numbers
			for (nr in nrlower...nrupper) {
				category[32767+nr] = cat;
				bitcode[32767+nr] = new BitString();
				bitcode[32767+nr].len = cat;
				bitcode[32767+nr].val = nr;
			}
			//Negative numbers
			var nrneg :Int = -(nrupper-1);
			while (nrneg <= -nrlower) {
				category[32767+nrneg] = cat;
				bitcode[32767+nrneg] = new BitString();
				bitcode[32767+nrneg].len = cat;
				bitcode[32767+nrneg].val = nrupper-1+nrneg;
				nrneg++;
			}
			nrlower <<= 1;
			nrupper <<= 1;
		}
	}

	// IO functions

	var byteout :ByteArray;
	var bytenew :Int;//init them in constructor
	var bytepos :Int;

	function writeBits (bs:BitString) :Void {
		var value :Int = bs.val;
		var posval :Int = bs.len-1;
		
		while (posval >= 0) {
			if (value & (1 << posval) != 0) {
				bytenew |= (1 << bytepos);
			}
			posval--;
			bytepos--;
			if (bytepos < 0) {
				if (bytenew == 0xFF) {
					writeByte (0xFF);
					writeByte (0);
				}
				else {
					writeByte (bytenew);
				}
				bytepos=7;
				bytenew=0;
			}
		}
	}

	function writeByte (value:Int) :Void {
		byteout.writeByte (value);
	}

	function writeWord (value:Int) :Void {
		writeByte ((value>>8)&0xFF);
		writeByte ((value   )&0xFF);
	}

	// DCT & quantization core

	function fDCTQuant (data:Array<Float>, fdtbl:Array<Float>) :Array<Int> {
		var tmp0:Float, tmp1:Float, tmp2:Float, tmp3:Float, tmp4:Float, tmp5:Float, tmp6:Float, tmp7:Float;
		var tmp10:Float, tmp11:Float, tmp12:Float, tmp13:Float;
		var z1:Float, z2:Float, z3:Float, z4:Float, z5:Float, z11:Float, z13:Float;
		
		/* Pass 1: process rows. */
		var dataOff :Int = 0;
		for (i in 0...8) {
			tmp0 = data[dataOff+0] + data[dataOff+7];
			tmp7 = data[dataOff+0] - data[dataOff+7];
			tmp1 = data[dataOff+1] + data[dataOff+6];
			tmp6 = data[dataOff+1] - data[dataOff+6];
			tmp2 = data[dataOff+2] + data[dataOff+5];
			tmp5 = data[dataOff+2] - data[dataOff+5];
			tmp3 = data[dataOff+3] + data[dataOff+4];
			tmp4 = data[dataOff+3] - data[dataOff+4];

			/* Even part */
			tmp10 = tmp0 + tmp3;	/* phase 2 */
			tmp13 = tmp0 - tmp3;
			tmp11 = tmp1 + tmp2;
			tmp12 = tmp1 - tmp2;

			data[dataOff+0] = tmp10 + tmp11; /* phase 3 */
			data[dataOff+4] = tmp10 - tmp11;

			z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
			data[dataOff+2] = tmp13 + z1; /* phase 5 */
			data[dataOff+6] = tmp13 - z1;

			/* Odd part */
			tmp10 = tmp4 + tmp5; /* phase 2 */
			tmp11 = tmp5 + tmp6;
			tmp12 = tmp6 + tmp7;

			/* The rotator is modified from fig 4-8 to avoid extra negations. */
			z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
			z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
			z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
			z3 = tmp11 * 0.707106781; /* c4 */

			z11 = tmp7 + z3;	/* phase 5 */
			z13 = tmp7 - z3;

			data[dataOff+5] = z13 + z2;	/* phase 6 */
			data[dataOff+3] = z13 - z2;
			data[dataOff+1] = z11 + z4;
			data[dataOff+7] = z11 - z4;

			dataOff += 8; /* advance pointer to next row */
		}

		/* Pass 2: process columns. */
		dataOff = 0;
		for (i in 0...8) {
			tmp0 = data[dataOff+ 0] + data[dataOff+56];
			tmp7 = data[dataOff+ 0] - data[dataOff+56];
			tmp1 = data[dataOff+ 8] + data[dataOff+48];
			tmp6 = data[dataOff+ 8] - data[dataOff+48];
			tmp2 = data[dataOff+16] + data[dataOff+40];
			tmp5 = data[dataOff+16] - data[dataOff+40];
			tmp3 = data[dataOff+24] + data[dataOff+32];
			tmp4 = data[dataOff+24] - data[dataOff+32];

			/* Even part */
			tmp10 = tmp0 + tmp3;	/* phase 2 */
			tmp13 = tmp0 - tmp3;
			tmp11 = tmp1 + tmp2;
			tmp12 = tmp1 - tmp2;

			data[dataOff+ 0] = tmp10 + tmp11; /* phase 3 */
			data[dataOff+32] = tmp10 - tmp11;

			z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
			data[dataOff+16] = tmp13 + z1; /* phase 5 */
			data[dataOff+48] = tmp13 - z1;

			/* Odd part */
			tmp10 = tmp4 + tmp5; /* phase 2 */
			tmp11 = tmp5 + tmp6;
			tmp12 = tmp6 + tmp7;

			/* The rotator is modified from fig 4-8 to avoid extra negations. */
			z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
			z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
			z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
			z3 = tmp11 * 0.707106781; /* c4 */

			z11 = tmp7 + z3;	/* phase 5 */
			z13 = tmp7 - z3;

			data[dataOff+40] = z13 + z2; /* phase 6 */
			data[dataOff+24] = z13 - z2;
			data[dataOff+ 8] = z11 + z4;
			data[dataOff+56] = z11 - z4;

			dataOff++; /* advance pointer to next column */
		}

		// Quantize/descale the coefficients
		var data_temp = new Array<Int>();
		for (i in 0...64) {
			// Apply the quantization and scaling factor & Round to nearest integer
			data_temp[i] = Math.round ((data[i]*fdtbl[i]));
		}
		return data_temp;
	}

	// Chunk writing

	function writeAPP0 () :Void {
		writeWord (0xFFE0); // marker
		writeWord (16); // length
		writeByte (0x4A); // J
		writeByte (0x46); // F
		writeByte (0x49); // I
		writeByte (0x46); // F
		writeByte (0); // = "JFIF",'\0'
		writeByte (1); // versionhi
		writeByte (1); // versionlo
		writeByte (0); // xyunits
		writeWord (1); // xdensity
		writeWord (1); // ydensity
		writeByte (0); // thumbnwidth
		writeByte (0); // thumbnheight
	}

	function writeSOF0 (width:Int, height:Int) :Void {
		writeWord (0xFFC0); // marker
		writeWord (17);   // length, truecolor YUV JPG
		writeByte (8);    // precision
		writeWord (height);
		writeWord (width);
		writeByte (3);    // nrofcomponents
		writeByte (1);    // IdY
		writeByte (0x11); // HVY
		writeByte (0);    // QTY
		writeByte (2);    // IdU
		writeByte (0x11); // HVU
		writeByte (1);    // QTU
		writeByte (3);    // IdV
		writeByte (0x11); // HVV
		writeByte (1);    // QTV
	}

	function writeDQT () :Void {
		writeWord (0xFFDB); // marker
		writeWord (132);	// length
		writeByte (0);
		
		for (i in 0...64) writeByte (YTable[i]);
		writeByte (1);
		for (i in 0...64) writeByte (UVTable[i]);
	}

	function writeDHT () :Void {
		writeWord (0xFFC4); // marker
		writeWord (0x01A2); // length

		writeByte(0); // HTYDCinfo
		for (i in 0...16) writeByte (std_dc_luminance_nrcodes[i+1]);
		for (i in 0...12) writeByte (std_dc_luminance_values[i]);

		writeByte (0x10); // HTYACinfo
		for (i in 0...16) writeByte (std_ac_luminance_nrcodes[i+1]);
		for (i in 0...162) writeByte (std_ac_luminance_values[i]);

		writeByte (1); // HTUDCinfo
		for (i in 0...16) writeByte (std_dc_chrominance_nrcodes[i+1]);
		for (i in 0...12) writeByte (std_dc_chrominance_values[i]);

		writeByte (0x11); // HTUACinfo
		for (i in 0...16) writeByte (std_ac_chrominance_nrcodes[i+1]);
		for (i in 0...162) writeByte (std_ac_chrominance_values[i]);
	}

	function writeSOS () :Void {
		writeWord (0xFFDA); // marker
		writeWord (12); // length
		writeByte (3); // nrofcomponents
		writeByte (1); // IdY
		writeByte (0); // HTY
		writeByte (2); // IdU
		writeByte (0x11); // HTU
		writeByte (3); // IdV
		writeByte (0x11); // HTV
		writeByte (0); // Ss
		writeByte (0x3f); // Se
		writeByte (0); // Bf
	}

	// Core processing
	var DU :Array<Int>;

	function processDU (CDU:Array<Float>, fdtbl:Array<Float>, DC:Int, HTDC:Array<BitString>, HTAC:Array<BitString>) :Int {
		var EOB :BitString = HTAC[0x00];
		var M16zeroes :BitString = HTAC[0xF0];
		var DU_DCT :Array<Int> = fDCTQuant (CDU, fdtbl);
		
		//ZigZag reorder
		for (i in 0...64) DU[ZigZag[i]] = DU_DCT[i];
		
		var Diff :Int = DU[0] - DC;
		DC = DU[0];
		
		//Encode DC
		if (Diff == 0) {
			writeBits (HTDC[0]);
		}
		else {
			writeBits (HTDC[category[32767+Diff]]);
			writeBits (bitcode[32767+Diff]);
		}
		
		//Encode ACs
		var end0pos :Int = 63;
		while (end0pos>0 && DU[end0pos]==0) end0pos--;
		
		//end0pos = first element in reverse order !=0
		if (end0pos == 0) {
			writeBits (EOB);
			return DC;
		}
		
		var i :Int = 1;
		while (i <= end0pos) {
			var startpos :Int = i;
			while (DU[i]==0 && i<=end0pos) i++;
			
			var nrzeroes :Int = i-startpos;
			if (nrzeroes >= 16) {
				for (n in 0...nrzeroes>>4)
					writeBits (M16zeroes);
				nrzeroes = nrzeroes&0xF;
			}
			writeBits (HTAC[nrzeroes*16+category[32767+DU[i]]]);
			writeBits (bitcode[32767+DU[i]]);
			i++;
		}
		if (end0pos != 63) writeBits (EOB);
		return DC;
	}

	var YDU :Array<Float>;// 64
	var UDU :Array<Float>;
	var VDU :Array<Float>;

	function RGB2YUV (img:BitmapData, xpos:Int, ypos:Int) :Void {
		var pos :Int = 0;
		for (y in 0...8) {
			for (x in 0...8) {
				var P  :Int = img.getPixel32 (xpos+x, ypos+y);
				var R:Float = ((P>>16) & 0xFF);
				var G:Float = ((P>> 8) & 0xFF);
				var B:Float = ((P    ) & 0xFF);
				YDU[pos] = ((( 0.29900)*R + ( 0.58700)*G + ( 0.11400)*B)) - 128;
				UDU[pos] = (((-0.16874)*R + (-0.33126)*G + ( 0.50000)*B));
				VDU[pos] = ((( 0.50000)*R + (-0.41869)*G + (-0.08131)*B));
				pos++;
			}
		}
	}
}
