package  {
	import flash.Boot;
	public class SKSimpleButtonWithText extends RCSkin {
		public function SKSimpleButtonWithText(label_str : String = null,colors : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			super(colors);
			this.up = new RCTextView(0,0,null,null,label_str,FontManager.getRCFont("system",{ embedFonts : false}));
			this.background = new RCRectangle(0,0,this.up.width,this.up.height,16777215,0);
			this.hit = new RCRectangle(0,0,this.up.width,this.up.height,16777215,0);
		}}
		
	}
}
