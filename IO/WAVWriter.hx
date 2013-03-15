/**
 * @author Bernard Visscher [bernard at debit dot nl]
 *  Ported to Haxe by Baluta Cristian
 */
#if flash
import flash.utils.Endian;
import flash.utils.ByteArray;


class WAVWriter {
	
	public var samples :ByteArray;
	
	
	public function new () {
		samples = new ByteArray();
		samples.endian = Endian.LITTLE_ENDIAN;
	}
	
	/**
	 * The samples given are of the type float, which is the type extracted from the Sound object.
	 */
	public function writeSamples (ba:ByteArray) :Void {
		ba.position = 0;
		while (ba.bytesAvailable > 0) {
			var l_r = Math.round (ba.readFloat() * 0x7FFF); // * 0x7FFF, because wav samples when 16bits have a value of -2^15 till 2^15
			samples.writeShort ( l_r );
			samples.writeShort ( l_r );
		}
	}
	public function writeFloat (sample:Float) :Void {
		var sampleInt :Int = Math.round (sample * 0x7FFF);
			samples.writeShort ( sampleInt );
			samples.writeShort ( sampleInt );
	}
	
	
	/**
	 *  Return the WAVE bytes
	 */
	public function getWAV () :ByteArray {
		samples.position = 0;
		
		var wav = new ByteArray();
			wav.endian = Endian.BIG_ENDIAN;
			wav.writeUTFBytes ("RIFF");
			
			wav.endian = Endian.LITTLE_ENDIAN;
			wav.writeUnsignedInt ( samples.bytesAvailable + 36 );
			
			wav.endian = Endian.BIG_ENDIAN;
			wav.writeUTFBytes ("WAVE");
			
			//subchunk 1
			wav.writeUTFBytes ("fmt ");
			
			wav.endian = Endian.LITTLE_ENDIAN;
			wav.writeInt ( 16 ); //Subchunk1Size    16 for PCM.  This is the size of the rest of the Subchunk which follows this number.
			wav.writeShort ( 1 ); // AudioFormat      PCM = 1
			wav.writeShort ( 2 ); // NumChannels      Mono = 1, Stereo = 2, etc.
			wav.writeUnsignedInt ( 44100 ); //  SampleRate       8000, 44100, etc.
			wav.writeUnsignedInt ( Math.round(44100 * 2 * 16 / 8) ); //ByteRate         == SampleRate * NumChannels * BitsPerSample/8
			wav.writeShort ( Math.round(2 * 16 / 8) ); // BlockAlign       == NumChannels * BitsPerSample/8
			wav.writeShort ( 16 ); //Bits per sample
			
			//data chunk
			wav.endian = Endian.BIG_ENDIAN;
			wav.writeUTFBytes ("data");
			
			wav.endian = Endian.LITTLE_ENDIAN;
			wav.writeUnsignedInt ( samples.bytesAvailable );
			wav.writeBytes ( samples );
			
			wav.position = 0;
			
		return wav;
	}
}
#end