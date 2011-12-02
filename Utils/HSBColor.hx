//
//	HSBColor
//
//	Created by Cristi Baluta on 2011-03-04.
//	Copyright (c) 2011 ralcr.com. All rights reserved.
//
class HSBColor {
	
	public Float h;// Hue
	public Float s;// Saturation
	public Float b;// Brightness
	public Float a;// Alpha
	
	
	public function new (h:Float, s:Float, b:Float, ?a:Float=1.0) {
		this.h = h;
		this.s = s;
		this.b = b;
		this.a = a;
	}
	
	public static function fromRGB (color:RGBColor) :HSBColor {
		
		var ret = new HSBColor (0, 0, 0, color.a);
		
		var r = color.r;
		var g = color.g;
		var b = color.b;
		
		var max = Math.max (r, Math.max(g, b));
		
		if (max <= 0) {
			return ret;
		}
		
		var min = Math.min(r, Math.min(g, b));
		var dif = max - min;

		if (max > min) {
			if (g == max) {
				ret.h = (b - r) / dif * 60 + 120;
			}
			else if (b == max) {
				ret.h = (r - g) / dif * 60 + 240;
			}
			else if (b > g) {
				ret.h = (g - b) / dif * 60 + 360;
			}
			else {
				ret.h = (g - b) / dif * 60;
			}
			if (ret.h < 0) {
				ret.h = ret.h + 360;
			}
		}
		else {
			ret.h = 0;
		}

		ret.h *= 1 / 360;
		ret.s = (dif / max) * 1.0;
		ret.b = max;

		return ret;
	}

	public static function toRGB (hsbColor:HSBColor) :RGBColor {
		
		var r = hsbColor.b;
		var g = hsbColor.b;
		var b = hsbColor.b;
		
		if (hsbColor.s != 0) {
			var max = hsbColor.b;
			var dif = hsbColor.b * hsbColor.s;
			var min = hsbColor.b - dif;

			var h = hsbColor.h * 360.0;

			if (h < 60) {
				r = max;
				g = h * dif / 60.0 + min;
				b = min;
			}
			else if (h < 120) {
				r = - (h - 120) * dif / 60 + min;
				g = max;
				b = min;
			}
			else if (h < 180) {
				r = min;
				g = max;
				b = (h - 120) * dif / 60 + min;
			}
			else if (h < 240) {
				r = min;
				g = - (h - 240) * dif / 60 + min;
				b = max;
			}
			else if (h < 300) {
				r = (h - 240) * dif / 60 + min;
				g = min;
				b = max;
			}
			else if (h <= 360) {
				r = max;
				g = min;
				b = - (h - 360) * dif / 60 + min;
			}
			else {
				r = 0;
				g = 0;
				b = 0;
			}
		}
		
		return new RGBColor (Math.Clamp01(r), Math.Clamp01(g), Math.Clamp01(b), hsbColor.a);
	}
	
	public function toString() :String {
		return "H:" + h + " S:" + s + " B:" + b;
	}
	
	public static function Lerp(HSBColor a, HSBColor b, float t) :HSBColor {
		float h,s;
		
		//check special case black (color.b==0): interpolate neither hue nor saturation!
		//check special case grey (color.s==0): don't interpolate hue!
		if(a.b==0){
			h=b.h;
			s=b.s;
		}else if(b.b==0){
			h=a.h;
			s=a.s;
		}else{
			if(a.s==0){
				h=b.h;
			}else if(b.s==0){
				h=a.h;
			}else{
				// works around bug with LerpAngle
				float angle = Mathf.LerpAngle(a.h * 360f, b.h * 360f, t);
				while (angle < 0f)
					angle += 360f;
				while (angle > 360f)
					angle -= 360f;
				h=angle/360f;
			}
			s=Mathf.Lerp(a.s,b.s,t);
		}
		return new HSBColor(h, s, Mathf.Lerp(a.b, b.b, t), Mathf.Lerp(a.a, b.a, t));
	}
	
	public static void Test()
	{
		HSBColor color;
		
		color = new HSBColor(Color.red);
		Debug.Log("red: " + color);
		
		color = new HSBColor(Color.green);
		Debug.Log("green: " + color);
		
		color = new HSBColor(Color.blue);
		Debug.Log("blue: " + color);
		
		color = new HSBColor(Color.grey);
		Debug.Log("grey: " + color);
		
		color = new HSBColor(Color.white);
		Debug.Log("white: " + color);
		
		color = new HSBColor(new RGBColor(0.4f, 1f, 0.84f, 1f));
		Debug.Log("0.4, 1f, 0.84: " + color);
		
		Debug.Log("164,82,84   .... 0.643137f, 0.321568f, 0.329411f	 :" + ToColor(new HSBColor(new Color(0.643137f, 0.321568f, 0.329411f))));
	}
	
	
	function hsv2rgb(hue, sat, val) {
	    var red, grn, blu, i, f, p, q, t;
	    hue%=360;
	    if(val==0) {return({r:0, g:0, v:0});}
	    sat/=100;
	    val/=100;
	    hue/=60;
	    i = Math.floor(hue);
	    f = hue-i;
	    p = val*(1-sat);
	    q = val*(1-(sat*f));
	    t = val*(1-(sat*(1-f)));
	    if (i==0) {red=val; grn=t; blu=p;}
	    else if (i==1) {red=q; grn=val; blu=p;}
	    else if (i==2) {red=p; grn=val; blu=t;}
	    else if (i==3) {red=p; grn=q; blu=val;}
	    else if (i==4) {red=t; grn=p; blu=val;}
	    else if (i==5) {red=val; grn=p; blu=q;}
	    red = Math.floor(red*255);
	    grn = Math.floor(grn*255);
	    blu = Math.floor(blu*255);
	    return ({r:red, g:grn, b:blu});
	}
	//
	function rgb2hsv(red, grn, blu) {
	    var x, val, f, i, hue, sat, val;
	    red/=255;
	    grn/=255;
	    blu/=255;
	    x = Math.min(Math.min(red, grn), blu);
	    val = Math.max(Math.max(red, grn), blu);
	    if (x==val){
	        return({h:undefined, s:0, v:val*100});
	    }
	    f = (red == x) ? grn-blu : ((grn == x) ? blu-red : red-grn);
	    i = (red == x) ? 3 : ((grn == x) ? 5 : 1);
	    hue = Math.floor((i-f/(val-x))*60)%360;
	    sat = Math.floor(((val-x)/val)*100);
	    val = Math.floor(val*100);
	    return({h:hue, s:sat, v:val});
	}
	//
	// Usage
	h = 360;
	s = 50;
	v = 25;
	trace("H"+h+" S"+s+" V"+v);
	trace ("Converts to");
	col = hsv2rgb(h, s, v);
	r = col.r;
	g = col.g;
	b = col.b;
	trace("R"+r+" G"+g+" B"+b);
	trace("");
	trace("R"+r+" G"+g+" B"+b);
	trace ("Converts to");
	col = rgb2hsv(r, g, b);
	h = col.h;
	s = col.s;
	v = col.v;
	trace ("H"+h+" S"+s+" V"+v);
}