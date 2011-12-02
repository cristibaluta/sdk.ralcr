import flash.filters.ColorMatrixFilter;
import flash.text.TextField;

class RCTextFieldColor {
	
	inline static var byteToPerc :Float = 1 / 0xff;

	public var textField :TextField;
	public var textColor :RCnt;
	public var selectedColor :RCnt;
	public var selectionColor :RCnt;
	var colorMatrixFilter :ColorMatrixFilter;
	
	public function new (textField:TextField,
						textColor:RCnt = 0x000000,
						selectionColor:RCnt = 0x000000,
						selectedColor:RCnt = 0x000000) {
		
		this.textField = textField;
		this.textColor = textColor;
		this.selectionColor = selectionColor;
		this.selectedColor = selectedColor;
		
		colorMatrixFilter = new ColorMatrixFilter();
		updateFilter();
	}
	
	public function setTextField (tf:TextField) :TextField {
		return textField = tf;
	}
	public function getTextField () :TextField {
		return textField;
	}
	public function setTextColor (c:RCnt) :RCnt {
		textColor = c;
		updateFilter();
		return textColor;
	}
	public function getTextColor () :RCnt {
		return textColor;
	}
	public function setSelectionColor (c:RCnt) :RCnt {
		selectionColor = c;
		updateFilter();
		return selectionColor;
	}
	public function getSelectionColor () :RCnt {
		return selectionColor;
	}
	public function setSelectedColor (c:RCnt) :RCnt {
		selectedColor = c;
		updateFilter();
		return selectedColor;
	}
	public function getSelectedColor () :RCnt {
		return selectedColor;
	}
	
	private function updateFilter () :Void {
		
		textField.textColor = 0xff0000;

		var o:Array<Int> = splitRGB (selectionColor);
		var r:Array<Int> = splitRGB (textColor);
		var g:Array<Int> = splitRGB (selectedColor);
		
		var ro:Int = o[0];
		var go:Int = o[1];
		var bo:Int = o[2];
		
		var rr:Float = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
		var rg:Float = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
		var rb:Float = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;

		var gr:Float = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
		var gg:Float = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
		var gb:Float = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
		
		colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
		
		textField.filters = [colorMatrixFilter];
		
	}
	
	static function splitRGB (color:RCnt) :Array<Int> {
		return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
	}
}