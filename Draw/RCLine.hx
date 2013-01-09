//
//  Draws a line from x1,y1, to x2,y2
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008-2011 ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
class RCLine extends RCDraw, implements RCDrawInterface {
	
	public var lineWeight :Int;
	
	/**
	 *	Draws a line of lineWeight px from x1, y1 to x2, y2
	 */
	public function new (x1:Float, y1:Float, x2:Float, y2:Float, color:Int, ?alpha:Float=1.0, ?lineWeight:Int=1) {
		super (x1, y1, x2-x1, y2-y1, color, alpha);
		
		this.lineWeight = lineWeight;
		this.redraw();
	}
	
	public function redraw () :Void {
#if (flash || nme)
		layer.graphics.clear();
		layer.graphics.lineStyle (lineWeight, color.fillColor);
		layer.graphics.moveTo (0, 0);
		layer.graphics.lineTo (size.width, size.height);
#elseif js
		layer.innerHTML = "";
		drawLine (0, 0, Math.round(size.width), Math.round(size.height));
#end
	}

#if js
	//Draw Line between the 2 specified points based on Mid point Algorithm.
	function drawLine (x0:Int, y0:Int, x1:Int, y1:Int) {
		var hexColor = cast (color, RCColor).fillColorStyle;
   	 	//For Horizontal line
	 	if(y0==y1) {
	 		if(x0<=x1)
				layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y0 + "px;width:" + (x1-x0+1) + "px;height:" + lineWeight + ";background-color:" + hexColor + "\"></DIV>";
	 		else if(x0>x1)
				layer.innerHTML = "<DIV style=\"position:absolute;overflow:hidden;left:" + x1 + "px;top:" + y0 + "px;width:" + (x0-x1+1) + "px;height:" + lineWeight + ";background-color:" + hexColor + "\"></DIV>";
	 		return layer;
	 	}
	 	
	 	//For Vertical line
	 	if(x0==x1) {
	 		if(y0<=y1)
		 		layer.innerHTML="<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y0 + "px;width:" + lineWeight + ";height:" + (y1-y0+1) + "px;background-color:" + hexColor + "\"></DIV>";
	 		else if(y0>y1)
		 		layer.innerHTML="<DIV style=\"position:absolute;overflow:hidden;left:" + x0 + "px;top:" + y1 + "px;width:" + lineWeight + ";height:" + (y0-y1+1) + "px;background-color:" + hexColor + "\"></DIV>";
		 		
	 		return layer;
	 	}
		
	    var iHtml=new Array<String>();
	 	var yArray=new Array<String>();
	 	
	 	///Pixel Height Width Start
		var dx = Math.abs(x1-x0);
	 	var dy = Math.abs(y1-y0);
	 	var pixHeight = Math.round(Math.sqrt((lineWeight*lineWeight)/((dy*dy)/(dx*dx)+1)));
	 	var pixWidth = Math.round(Math.sqrt(lineWeight*lineWeight-pixHeight*pixHeight));
	
	 	if(pixWidth==0) {
	 		pixWidth=1;
	 	}
	 	if(pixHeight==0) {
	 		pixHeight=1;
	 	}
	 	///Pixel Height Width End

		var steep = Math.abs(y1 - y0) > Math.abs(x1 - x0); 
		if (steep) {
			// swap   
			var tmp=x0;
			x0=y0;
			y0=tmp;
			tmp=x1;
			x1=y1;
			y1=tmp;
		}

		if (x0 > x1) {
			// swap   
			var tmp=x0;
			x0=x1;
			x1=tmp;
			tmp=y0;
			y0=y1;
			y1=tmp;
		}
		
		var deltax = x1 - x0;
		var deltay = Math.abs(y1 - y0);
		var error  = deltax/2;
		var ystep;
		var y = y0;
		
		ystep = (y0<y1) ? 1 : -1; 
		
		var xp = 0;
		var yp = 0;
		var divWidth=0;
		var divHeight=0;
		if(steep) {
			divWidth=pixWidth;
		}
		else {
			divHeight=pixHeight;
		}
		for (x in x0...(x1+1)){
			if (steep) {
				if(x==x0) {
					xp=y;
					yp=x;
				}
				else {
					if(y==xp) {
						divHeight=divHeight+ 1;
					}
   					else {
   						divHeight=divHeight+pixHeight;
						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
 						divHeight=0;		
 						xp=y;
	   					yp=x;		
 					}
 				}
 				
 				if(x==x1) {
 					if(divHeight!=0) {
 						divHeight=divHeight+pixHeight;
 						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
 					}
 					else {
 						divHeight=pixHeight;
						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + y + "px;top:" + x + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
 					}
 				}
 			}
			else { 
				if(x==x0) {
   					xp=x;
   					yp=y;
   				}
   				else {
   					if(y==yp) {
   						divWidth=divWidth + 1;
   					}
   					else {
   						divWidth=divWidth+pixWidth;
						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
	 					divWidth=0;
 						xp=x;
 						yp=y;			
 					}
 				}	
 				if(x==x1)
 				{
 					if(divWidth!=0)
 					{
   						divWidth=divWidth+pixWidth;
						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xp + "px;top:" + yp + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
 					}
 					else
 					{
 						divWidth=pixWidth;
						iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + x + "px;top:" + y + "px;width:" + divWidth+ "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
 					}
 				}
 			}

			error = error - deltay;
			if (error < 0) {
				y = y + ystep;
				error = error + deltax;
			}
		}
 		
		layer.innerHTML=iHtml.join("");
		return layer;
	}
#end
}
