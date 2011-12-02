//
//  Ellipse
//
//  Created by Baluta Cristian on 2008-10-11.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
class RCEllipse extends RCDraw, implements RCDrawInterface {
		
	public function new (x, y, w, h, color:Dynamic, ?alpha:Float=1.0) {
		super (x, y, w, h, color, alpha);
		
		this.redraw();
	}
	
	public function redraw() :Void {

#if flash
		this.graphics.clear();
		this.configure();
		
		// Draw an elipse
		this.graphics.drawEllipse (0, 0, size.width, size.height);
		this.graphics.endFill();
#elseif js
		fillEllipse (0, 0, size.width, size.height);
#end
	}
	
#if js
	function fillEllipse(xc:Int, yc:Int, width:Float, height:Float)
    {
        var iHtml=new Array<String>();
	    var a=Math.round(width/2);
	    var b=Math.round(height/2);
	    var hexColor = color.hexFillColor();
    	
	    var x=0;
	    var y=b;
	    var a2=a*a;
	    var b2=b*b;
    	
	    var xp,yp;
    	
	    xp=1;
	    yp=y;
    	
	    //Upper and Lower portion of the ellipse
 	    while(b2*x < a2*y)
  	    {     
  		    x++;    
 		    if((b2*x*x + a2*(y-0.5)*(y-0.5) - a2*b2) >=0)  
 			    y--;    
     			
      	    if(x==1 && y!=yp) //Topmost and bottom most points, to be tested
      	    {
          	
      		    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc+yp-1) + "px;background-color:" + hexColor + "\"></DIV>";
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc-yp) + "px;background-color:" + hexColor + "\"></DIV>";

      	    }
		    if(y!=yp)
		    {
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc-x+1) + "px;top:" + (yc-yp) + "px;width:" + (2*x-1) + "px;background-color:" + hexColor + "\"></DIV>";
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc-x+1) + "px;top:" + (yc+yp) + "px;width:" + (2*x-1) + "px;background-color:" + hexColor + "\"></DIV>";

			    yp=y;
			    xp=x;		
		    }
    			
    		
		    //Last step in loop
		    if(b2*x >= a2*y)
		    {
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc-x) + "px;top:" + (yc-yp) + "px;width:" + (2*x+1) + "px;background-color:" + hexColor + "\"></DIV>";
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;height:1px;left:" + (xc-x) + "px;top:" + (yc+yp) + "px;width:" + (2*x+1) + "px;background-color:" + hexColor + "\"></DIV>";
		    }
	    }
    	  
	    xp=x;
	    yp=y;
	    var divHeight=1;

	    //Left and Right portion of the ellipse
	    while(y!=0)  
	    {     
		    y--;   
  		    if((b2*(x+0.5)*(x+0.5) + a2*y*y - a2*b2)<=0)   
     		    x++;
    		
		    if(x!=xp)
		    {
			    divHeight=yp-y;
    			
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc-yp) + "px;width:" + (2*xp+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc+y+1) + "px;width:" + (2*xp+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    			
			    xp=x;
			    yp=y;
		    }
    		
		    //Last step in loop
		    if(y==0)
		    {
			    divHeight=yp-y+1;
    			
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc-yp) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
			    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc+y) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
		    }
 	    }
     	
 	    view.innerHTML = iHtml.join("");
 	    return view;
    }
#end
/*	function drawEllipse(pen,center,width,height)
    {
        var iHtml=new Array();
        
        phCenter=logicalToPhysicalPoint(center);

	    var penWidth=parseInt(pen.width);
	    if(penWidth<=1)
	    {
		    return drawEllipseSingle(pen,phCenter,width,height);
	    }
    	
	    var hexColor=pen.color.getHex();
    	
	    var a=Math.round(width/2);
	    var b=Math.round(height/2);
	    var xc=phCenter.x;
	    var yc=phCenter.y;
    	
	    //For inner ellipse
	    var ai=a-penWidth + 1;
	    var bi=b-penWidth + 1;
    	
	    //For drawing ellipse having width more than 1px, inner ellipse is required to be considered
	    var res=getInnerEllipse(phCenter,ai*2,bi*2)
    	
	    var xArray=res[0];
	    var xArrayI=res[1];
    	
	    var yi=bi;
	    var ai2=ai*ai;
	    var bi2=bi*bi;
    	
	    var x=0;
	    var y=b;
	    var a2=a*a;
	    var b2=b*b;
    	
	    var xp,yp;
    	
	    xp=1;
	    yp=y;
	    var ypi=yi;
    	
	    var xT;
	    var divWidth;
	    var divHeight=1;
    	
 	    while(b2*x < a2*y)
  	    {     
  		    x++;    
 		    if((b2*x*x + a2*(y-0.5)*(y-0.5) - a2*b2) >=0)  
 			    y--;    
    		
		    if(y+1<bi)
		    {
 			    if(y!=yp)
			    {
				    xT=xc-x+1;
				    divWidth=(x-1)+1-xArray[yp];
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";

				    xT=xT+2*(x-1)+1-divWidth;
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				
				    yp=y;		
				    xp=x;
			    }
			    //Last step in loop
			    if(b2*x >= a2*y)
			    {
				    xT=xc-x;
				    divWidth=x+1-xArray[yp];
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				
				    xT=xT+2*x+1-divWidth;
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
			    }
		    }	 		
		    else
		    {
      		    if(x==1 && y!=yp) //Topmost and bottom most points, to be tested
      		    {
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc+yp-1) + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;width:1px;height:1px;left:" + xc + "px;top:" + (yc-yp) + "px;background-color:" + hexColor + "\"></DIV>";      		
			    }
			    if(y!=yp)
			    {
   				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x+1) + "px;top:" + (yc-yp) + "px;width:" + (2*(x-1)+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x+1) + "px;top:" + (yc+yp) + "px;width:" + (2*(x-1)+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    yp=y;
			    }
    					
			    //Last step in loop
			    if(y==bi || y==0)
			    {
  				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x) + "px;top:" + (yc-y) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x) + "px;top:" + (yc+y) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
			    }
		    }
	    }
    	  
	    xp=x;
	    yp=y;
	    divHeight=1;
	    var xpi=xArray[y];

	    while(y!=0)  
	    {     
		    y--;   
  		    if((b2*(x+0.5)*(x+0.5) + a2*y*y - a2*b2)<=0)   
     		    x++;
    		
			    if(y+1<bi)
			    {
				    if(x!=xp || xArray[y]!=xpi)
				    {
					    divHeight=yp-y;
    					
					    xT=xc-xp;
					    divWidth=xp+1-xArray[y+1];
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y+1) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				
					    xT=xT+2*xp+1-divWidth;
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y+1) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				
					    xp=x;
					    yp=y;
					    xpi=xArray[y];
				    }
    		
				    //Last step in loop
				    if(y==0)
				    {
					    divHeight=yp-y+1;

					    xT=xc-x;
					    divWidth=x+1-xArray[y];
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				
					    xT=xT+2*x+1-divWidth;
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc-yp) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + xT + "px;top:" + (yc+y) + "px;width:" + divWidth + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
        				
    				    xp=x;
					    yp=y;
					    xpi=xArray[y];
				    }
			    }
			    else
			    {
				    if(x!=xp)
				    {
					    divHeight=yp-y;
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc-yp) + "px;width:" + (2*xp+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-xp) + "px;top:" + (yc+y+1) + "px;width:" + (2*xp+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";

					    xp=x;
					    yp=y;
					    xpi=xArray[y];
				    }
    		
				    //Last step in loop
				    if(y==bi || y==0)
				    {
				        divHeight=yp-y+1;
    				    
					    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x) + "px;top:" + (yc-yp) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
    				    iHtml[iHtml.length]="<DIV style=\"position:absolute;overflow:hidden;left:" + (xc-x) + "px;top:" + (yc+y) + "px;width:" + (2*x+1) + "px;height:" + divHeight + "px;background-color:" + hexColor + "\"></DIV>";
        				
					    xp=x;
					    yp=y;
					    xpi=xArray[y];
				    }
			    }	
 		    }
     		
 		    view.innerHTML=iHtml.join("");
 		    return view;
    }
*/
    //For ellipse having width more than 1 px, get the coordinates for inner ellipse.
/*    function getInnerEllipse(center,w,h)
    {
	    var a=Math.round(w/2);
	    var b=Math.round(h/2);
	    var xc=center.x;
	    var yc=center.y;
    	
	    xArray=new Array();
	    xArrayI=new Array();

	    var x=0;
	    var y=b;
	    var a2=a*a;
	    var b2=b*b;
    	
	    xArray[y]=x;
	    xArrayI[y]=x;
    	
	    var divWidth;
	    var divHeight;
    	
	    //Upper and Lower portions of the ellipse
 	    while(b2*x < a2*y)
  	    {     
  		    x++;    
 		    if((b2*x*x + a2*(y-0.5)*(y-0.5) - a2*b2) >=0)  
 			    y--;    
      	    if(!xArray[y])
		    xArray[y]=x;
    		
		    xArrayI[y]=x;
	    }
    	
	    //Left and Right portions of the ellipse
	    while(y!=0)  
	    {     
		    y--;   
  		    if((b2*(x+0.5)*(x+0.5) + a2*y*y - a2*b2)<=0)   
     		    x++;

   		    xArray[y]=x;
   		    xArrayI[y]=x;
 	    }
 	    return [xArray, xArrayI];
    }
*/
	
}
