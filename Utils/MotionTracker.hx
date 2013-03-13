/**		
 * 
 *	MotionTracker
 *	
 *	@version 1.00 | Apr 2, 2008
 *	@author Justin Windle
 *	
 *	MotionTracker is a very simple but fast approach to basic motion tracking 
 *	using a webcam as input. For more information, please visit my blog:
 *	
 *	http://blog.soulwire.co.uk/code/actionscript-3/webcam-motion-detection-tracking
 *  
 **/
#if flash
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Video;


class MotionTracker extends Point {
	
	inline static var DEFAULT_AREA :Int = 10;
	inline static var DEFAULT_BLUR :Int = 20;
	inline static var DEFAULT_BRIGHTNESS :Int = 20;
	inline static var DEFAULT_CONTRAST :Int = 150;
	
	var _src :Video;
	var _now :BitmapData;
	var _old :BitmapData;

	var _blr :BlurFilter;
	var _cmx :ColorMatrix;
	var _col :ColorMatrixFilter;
	var _box :Rectangle;
	var _act :Bool;
	var _mtx :Matrix;
	var _min :UInt;

	var _brightness :Float;
	var _contrast :Float;
	
	public var minArea (get_minArea, set_minArea) :UInt;
	public var input (get_input, set_input) :Video;
	public var flipInput (get_flipInput, set_flipInput) :Bool;
	public var blur (get_blur, set_blur) :Float;
	public var brightness (get_brightness, set_brightness) :Float;
	public var contrast (get_contrast, set_contrast) :Float;

	/**
	 * The MotionTracker class will track the movement within video data
	 * 
	 * @param	source	A video object which will be used to track motion
	 */

	public function new (source:Video) {
		super();
		
		_brightness = 0.0;
		_contrast = 0.0;
		
		input = source;
		
		_cmx = new ColorMatrix();
		_blr = new BlurFilter();
		
		set_blur ( DEFAULT_BLUR );
		set_minArea ( DEFAULT_AREA );
		set_contrast ( DEFAULT_CONTRAST );
		set_brightness ( DEFAULT_BRIGHTNESS );
		
		applyColorMatrix();
	}
	
	
	/**
	 * Track movement within the source Video object.
	 */
	public function track() :Void {
		
		_now.draw (_src, _mtx);
		_now.draw (_old, null, null, BlendMode.DIFFERENCE);
		
		_now.applyFilter (_now, _now.rect, new Point(), _col);
		_now.applyFilter (_now, _now.rect, new Point(), _blr);
		
		_now.threshold (_now, _now.rect, new Point(), '>', 0xFF333333, 0xFFFFFFFF);
		_old.draw (_src, _mtx);
		
		var area :Rectangle = _now.getColorBoundsRect (0xFFFFFFFF, 0xFFFFFFFF, true);
		_act = ( area.width > ( _src.width / 100) * _min || area.height > (_src.height / 100) * _min );
		
		if (_act) {
			_box = area;
			x = _box.x + (_box.width / 2);
			y = _box.y + (_box.width / 2);
		}
	}
	
	
	function applyColorMatrix() :Void {
		_cmx.reset();
		_cmx.adjustContrast ( _contrast );
		_cmx.adjustBrightness ( _brightness );
		_col = new ColorMatrixFilter ( _cmx.toArray() );
	}
	
	
	/**
	 * The image the MotionTracker is working from
	 */
	public function get_trackingImage() :BitmapData { 
		return _now; 
	}

	/**
	 * The area of the image the MotionTracker is working from
	 */
	public function get_trackingArea() :Rectangle { 
		return new Rectangle (_src.x, _src.y, _src.width, _src.height); 
	}

	/**
	 * Whether or not movement is currently being detected
	 */
	public function get_hasMovement() : Bool	{ 
		return _act; 
	}
	
	/**
	 * The area in which movement is being detected
	 */
	public function get_motionArea() :Rectangle { 
		return _box; 
	}
	
	
	/**
	 * The video (usualy created from a Camera) used to track motion
	 */
	public function get_input() :Video { 
		return _src; 
	}
	
	public function set_input (v:Video) :Video {
		_src = v;
		if (_now != null) { 
			_now.dispose(); 
			_old.dispose(); 
		}
		_now = new BitmapData (Math.round(v.width), Math.round(v.height), false, 0);
		_old = new BitmapData (Math.round(v.width), Math.round(v.height), false, 0);
		return v;
	}
	
	
	/**
	 * the blur being applied to the input in order to improve accuracy
	 */
	public function get_blur() :Float { 
		return _blr.blurX; 
	}
	
	public function set_blur (n:Float) :Float { 
		return _blr.blurX = _blr.blurY = n;
	}
	
	
	/**
	 * The brightness filter being applied to the input
	 */
	public function get_brightness() :Float { 
		return _brightness; 
	}	
	public function set_brightness (n:Float) :Float {
		_brightness = n;
		applyColorMatrix();
		return n;
	}
	
	
	/**
	 * The contrast filter being applied to the input
	 */
	public function get_contrast() :Float { 
		return _contrast; 
	}	
	public function set_contrast (n:Float) :Float {
		_contrast = n;
		applyColorMatrix();
		return n;
	}
	
	
	/**
	 * The minimum area (percent of the input dimensions) of movement to be considered movement
	 */
	public function get_minArea() :UInt { 
		return _min; 
	}	
	public function set_minArea (n:UInt) :UInt {
		return _min = n;
	}
	
	
	/**
	 * Whether or not to flip the input for mirroring
	 */
	public function get_flipInput () :Bool { 
		return _mtx.a < 1; 
	}
	
	public function set_flipInput (b:Bool) :Bool {
		_mtx = new Matrix();
		if (b) { 
			_mtx.translate (-_src.width, 0); 
			_mtx.scale (-1, 1); 
		}
		return b;
	}
}
#end