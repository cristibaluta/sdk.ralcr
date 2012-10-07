import js.Dom;

class JSCanvas {
	// Drawing
	/*
	static inline function COL( color : Int ) {
		return "rgb("+(color>>16)+","+((color>>8)&0xFF)+","+(color&0xFF)+")";
	}

	public inline function clear() {
		graphics.clearRect (0, 0, graphics.canvas.width, graphics.canvas.height);
	}

	public function lineStyle( ?width : Float, ?color : Int ) {
		if( width == null ) return;
		graphics.lineWidth = width;
		graphics.strokeStyle = COL(color);
	}

	public inline function beginFill( color : Int, alpha : Float ) {
		graphics.fillStyle = COL(color);
		graphics.beginPath();
	}

	public inline function endFill() {
		graphics.fill();
		graphics.stroke();
	}

	public inline function drawCircle( x : Float, y : Float, radius : Float ) {
		graphics.arc(x,y,radius,0,6.29,true);
	}

	public inline function drawRect( x : Float, y : Float, w : Float, h : Float ) {
		graphics.rect(x,y,w,h);
	}

	public inline function moveTo( x : Float, y : Float ) {
		graphics.moveTo(x,y);
	}

	public inline function lineTo( x : Float, y : Float ) {
		graphics.lineTo(x,y);
		}*/
	
}

typedef CanvasContext = {

	var canvas(default,null) : {> HtmlDom, width : Int, height : Int };

	function save() : Void;
	function restore() : Void;
	function clear () :Void;

	// transformations (default transform is the identity matrix)
	function scale( x : Float, y : Float ) : Void;
	function rotate( r : Float ) : Void;
	function translate( x : Float, y : Float ) : Void;
	function transform( m11 : Float, m12 : Float, m21 : Float, m22 : Float, dx : Float, dy : Float ) : Void;
	function setTransform( m11 : Float, m12 : Float, m21 : Float, m22 : Float, dx : Float, dy : Float ) : Void;

	var globalAlpha : Float;
	var globalCompositeOperation : String;
	var strokeStyle : String;
	var fillStyle : String;

	// colors and styles
	/*CanvasGradient createLinearGradient(in float x0, in float y0, in float x1, in float y1);
	CanvasGradient createRadialGradient(in float x0, in float y0, in float r0, in float x1, in float y1, in float r1);
	CanvasPattern createPattern(in HTMLImageElement image, in DOMString repetition);
	CanvasPattern createPattern(in HTMLCanvasElement image, in DOMString repetition);*/

	// line caps/joins
	var lineWidth : Float;
	var lineCap : String;
	var lineJoin : String;
	var miterLimit : Float;

	// shadows
	var shadowOffsetX : Float;
	var shadowOffsetY : Float;
	var shadowBlur : Float;
	var shadowColor : String;

	// rects
	function clearRect( x : Float, y : Float, w : Float, h : Float ) : Void;
	function fillRect( x : Float, y : Float, w : Float, h : Float ) : Void;
	function strokeRect( x : Float, y : Float, w : Float, h : Float ) : Void;

	// path API
	function beginPath() : Void;
	function closePath() : Void;
	function moveTo( x : Float, y : Float ) : Void;
	function lineTo( x : Float, y : Float ) : Void;
	function quadraticCurveTo( cpx : Float, cpy : Float, x : Float, y : Float ) : Void;
	function bezierCurveTo( cp1x : Float, cp1y : Float, cp2x : Float, cp2y : Float, x : Float, y : Float ) : Void;
	function arcTo( x1 : Float, y1 : Float, x2 : Float, y2 : Float, radius : Float ) : Void;
	function rect( x : Float, y : Float, w : Float, h : Float ) : Void;
	function arc( x : Float, y : Float, radius : Float, startAngle : Float, endAngle : Float, anticlockwise : Bool ) : Void;
	function fill() : Void;
	function stroke() : Void;
	function clip() : Void;
	function isPointInPath( x : Float, y : Float ) : Bool;
	
	function beginFill(color:Int, alpha:Float) : Void;
	function beginGradientFill(color:Int, alpha:Float) : Void;
	function endFill() : Void;
	function lineStyle( ?borderThickness:Float, ?borderColor:Int, ?alpha:Float, ?pixelHinting:Dynamic, ?scaleMode:Dynamic, ?caps:Dynamic, ?joints:Dynamic, ?miterLimit:Dynamic ) :Void;
	function drawRect( x : Float, y : Float, w : Float, h : Float ) :Void;
	function drawRoundRect( x : Float, y : Float, w : Float, h : Float, r : Float ) :Void;
	
	// drawing images
/*	void drawImage(in HTMLImageElement image, in float dx, in float dy);
	void drawImage(in HTMLImageElement image, in float dx, in float dy, in float dw, in float dh);
	void drawImage(in HTMLImageElement image, in float sx, in float sy, in float sw, in float sh, in float dx, in float dy, in float dw, in float dh);
	void drawImage(in HTMLCanvasElement image, in float dx, in float dy);
	void drawImage(in HTMLCanvasElement image, in float dx, in float dy, in float dw, in float dh);
	void drawImage(in HTMLCanvasElement image, in float sx, in float sy, in float sw, in float sh, in float dx, in float dy, in float dw, in float dh);*/

	// pixel manipulation
/*	ImageData createImageData(in float sw, in float sh);
	ImageData getImageData(in float sx, in float sy, in float sw, in float sh);
	void putImageData(in ImageData imagedata, in float dx, in float dy);
	void putImageData(in ImageData imagedata, in float dx, in float dy, in float dirtyX, in float dirtyY, in float dirtyWidth, in float dirtyHeight);*/

};
