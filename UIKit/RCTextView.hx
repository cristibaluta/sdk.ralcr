//
//  RCText2
//
//  Created by Cristi Baluta on 2011-02-01.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;
import flash.events.MouseEvent;


class RCTextView extends RCView {
	
	public var target :TextField;
	public var properties :RCFont;
	public var text (getText, setText) :String;
	
	
	public function new (x:Float, y:Float, w:Null<Float>, h:Null<Float>, str:String, properties:RCFont) {
		
		super (Math.round(x), Math.round(y));
		size.width = w;
		size.height = h;
		
		init ( properties );
		setText ( str );
	}
	
	public function init (properties:RCFont) :Void {
		// Duplicate the properties RCFont and apply exceptions
		this.properties = properties;
		redraw();
		//target.addEventListener (MouseEvent.MOUSE_WHEEL, wheelHandler);
	}
	
	public function redraw () :Void {
		
		// Remove the previous textfield
		if (target != null)
		if (this.view.contains ( target ))
			this.view.removeChild ( target );
		
		// Create a new textfield
		target = new TextField();
		target.embedFonts = properties.embedFonts;
		target.type = properties.type;
		target.autoSize = properties.autoSize;
		target.antiAliasType = properties.antiAliasType;
		target.wordWrap = (size.width == null) ? false : true;
		target.multiline = (size.height == 0) ? false : true;
		target.sharpness = properties.sharpness;
		target.selectable = properties.selectable;
		target.border = false;
		
		if (size.width != null)							target.width = size.width;
		if (size.height != null && size.height != 0)	target.height = size.height;
		
		if (properties.format != null) target.defaultTextFormat = properties.format;
		//if (properties.format != null) target.setTextFormat ( properties.format );
		if (properties.style  != null) target.styleSheet = properties.style;
		
		view.addChild ( target );
	}
	
	
	public function getText() :String {
		return target.text;
	}
	
	public function setText (str:String) :String {
		if (properties.html) {
			target.htmlText = str;
		}
		else {
			target.text = str;
		}
		return str;
	}
	function wheelHandler (e:MouseEvent) :Void {
		//trace(target.maxScrollV +", "+target.scrollV);
		if (target.maxScrollV == 2)
			target.scrollV = 0;
	}
	
	override public function destroy () :Void {
		target.removeEventListener (MouseEvent.MOUSE_WHEEL, wheelHandler);
		target = null;
		super.destroy();
	}
}


//Draw text string at specified point with specified color,font,width & alignment	
/*function drawText(text,point,font,color,width,align)
{
	//Check arguments for null values        
	if(!text || !point)
		return false;
		
	phPoint=logicalToPhysicalPoint(point);
	
	if(width!=null)
	    width=Math.round(width*scale) + "px";
	
    var textDiv=canvasDiv.appendChild(document.createElement("div"));

    textDiv.style.position="absolute";
    textDiv.style.left=phPoint.x + "px";
    textDiv.style.top=phPoint.y + "px";
    
    if(color)
        textDiv.style.color=color.getHex();
            
    //set font
    if(font)
    {
    	if(font.family)
        	textDiv.style.fontFamily=font.family;

        if(font.weight)
	        textDiv.style.fontWeight=font.weight;
    
    	if(font.size)
        	textDiv.style.fontSize=font.size;
    
        if(font.style)
	        textDiv.style.fontStyle=font.style;
    
    	if(font.variant)
        	textDiv.style.fontVariant=font.variant;
	}
	
    if(width)
        textDiv.style.width=width;

    if(align) 
        textDiv.style.textAlign=align;

    textDiv.innerHTML=text;
    
    return textDiv;
}*/