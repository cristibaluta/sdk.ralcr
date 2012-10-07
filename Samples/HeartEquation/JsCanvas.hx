/*
 * Copyright (c) 2008, Nicolas Cannasse
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * This software is licenced under MIT.rmitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 * 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>ust reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
import js.Dom;

typedef CanvasContext = {

	var canvas(default,null) : {> HtmlDom, width : Int, height : Int };

	function save() : Void;
	function restore() : Void;

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

class JsCanvas {

	var ctx : CanvasContext;

	public function new( canvas : HtmlDom ) {
		ctx = untyped canvas.getContext('2d');
	}

	static inline function COL( color : Int ) {
		return "rgb("+(color>>16)+","+((color>>8)&0xFF)+","+(color&0xFF)+")";
	}

	public inline function clear() {
		ctx.clearRect(0,0,ctx.canvas.width,ctx.canvas.height);
	}

	public function lineStyle( ?width : Float, ?color : Int ) {
		if( width == null ) return;
		ctx.lineWidth = width;
		ctx.strokeStyle = COL(color);
	}

	public inline function beginFill( color : Int, alpha : Float ) {
		ctx.fillStyle = COL(color);
		ctx.beginPath();
	}

	public inline function endFill() {
		ctx.fill();
		ctx.stroke();
	}
	
	public inline function drawCircle( x : Float, y : Float, radius : Float ) {
		ctx.arc(x,y,radius,0,6.29,true);
	}

	public inline function drawRect( x : Float, y : Float, w : Float, h : Float ) {
		ctx.rect(x,y,w,h);
	}

	public inline function moveTo( x : Float, y : Float ) {
		ctx.moveTo(x,y);
	}

	public inline function lineTo( x : Float, y : Float ) {
		ctx.lineTo(x,y);
	}

}
