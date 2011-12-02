package  {
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.Boot;
	public class RCGradient {
		public function RCGradient(colors : Array = null,alphas : Array = null,linear : Boolean = true) : void { if( !flash.Boot.skip_constructor ) {
			this.gradientColors = colors;
			this.gradientAlphas = ((alphas == null)?[1.0,1.0]:alphas);
			this.gradientRatios = [0,255];
			this.spreadMethod = flash.display.SpreadMethod.PAD;
			this.interpolationMethod = flash.display.InterpolationMethod.RGB;
			this.gradientType = ((linear)?flash.display.GradientType.LINEAR:flash.display.GradientType.RADIAL);
			this.focalPointRatio = 0;
			this.tx = 0;
			this.ty = 0;
			this.matrixRotation = Math.PI * 0.5;
		}}
		
		public var borderColor : *;
		public var gradientColors : Array;
		public var gradientAlphas : Array;
		public var gradientRatios : Array;
		public var spreadMethod : String;
		public var interpolationMethod : String;
		public var gradientType : String;
		public var focalPointRatio : Number;
		public var tx : int;
		public var ty : int;
		public var matrixRotation : Number;
	}
}
