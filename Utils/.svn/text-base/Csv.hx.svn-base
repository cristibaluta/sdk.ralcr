/**
 * Excel CSV
 * @author クジラ飛行机(http://kujirahand.com)
 *
 *  http://www.gdal.org/ogr/drv_csv.html
 *  
 * @see http://www.libspark.org/wiki/kujirahand/CSVUtils WIKI
 * @see http://www.libspark.org/browser/as3/CSVUtils/src/com/kujirahand/CSVUtils.as 最新版ダウンロード(SVNリポジトリ)
 * @see http://kujirahand.com/as3/com/kujirahand/CSVUtils.html ASDoc
 */
//import mx.collections.ArrayCollection;


class Csv<T> implements ArrayAccess<T> {
	
	inline static var DEFAULT_SPLITTER = ",";
	inline static var LINE_SPLITTER = "\n";
	inline static var T_SPLITTER = "\t";
	
	var csv_str :String;
	var splitter :String;
	var index :Int;
	var source :Array<Array<String>>;
	
	
	public function new () {
		index = 0;
		source = new Array<Array<String>>();
	}
	
	public function initWithCsv (csv_str:String) :Void {
		source = split (csv_str, DEFAULT_SPLITTER);
	}
	public function initWithTsv (tsv_str:String) :Void {
		source = split (tsv_str, T_SPLITTER);
	}
	public function initWithArray (	csv_arr:Array<Array<String>>,
									splitter:String=DEFAULT_SPLITTER,
									use_escape:Bool=false) :Void {
		source = csv_arr;
	}
	
	
	
	public function getCsv (splitter:String=DEFAULT_SPLITTER, use_escape:Bool=false) :String {
		var res:String = "";
		
		for (row in 0...source.length) {
			var cols:Array<String> = source[row];
			
			for (col in 0...cols.length) {
				var cell:String = cols[col];
				
				if (use_escape || hasEscapeChar (cell, splitter))
					cell = escapeCell ( cell );
				
				res += cell + splitter;
			}
			if (cols.length > 0)
				res = res.substr (0, res.length -1);
				res += LINE_SPLITTER;
		}
		
		if (source.length > 0)
			res = res.substr (0, res.length - 1);
			
		return res;
	}
	
	public function getArray () :Array<Array<String>> {
		return source;
	}
	
	
	
	
	
	function split (csv_str:String, splitter:String) :Array<Array<String>> {
		
		csv_str = replaceStr (csv_str, "\r\n", LINE_SPLITTER);
		csv_str = replaceStr (csv_str, "\r", LINE_SPLITTER);
		
		this.csv_str = csv_str;
		this.splitter = splitter;trace("split "+csv_str);
		
		var result = new Array<Array<String>>();
		while (csv_str.length > 0)
			result.push ( getCols() );
		return result;
	}
	
	
	function getCols () :Array<String> {
		var cols = new Array<String>();
		index = 0;
		while (index < csv_str.length) {
			var c:String = csv_str.charAt ( index );
			var col:String;
			if (c == LINE_SPLITTER) {
				index++;
				break;
			}
			col = (c == '"') ? getColStr() : getColSimple();
			skipSpace();
			cols.push ( col );
			trace(col);
		}
		
		csv_str = csv_str.substr ( index );trace("fin");
		return cols;
	}
	function getColSimple () :String {
		var col = "";
		while (index < csv_str.length) {
			if (csv_str.substr (index, 2) == '""') {
				col += '"';
				index += 2;
				continue;
			}
			var c:String = csv_str.charAt ( index );
			if (c == splitter) {
				index++;
				break;
			}
			if (c == LINE_SPLITTER)
				break;
			
			col += c;
			index++;				
		}
		return col;
	}
	function getColStr () :String {
		// "str" の文字列
		index++; // skip '"'
		var col = "";
		while (index < csv_str.length) {
			if (csv_str.substr (index, 2) == '""') {
				col += '"';
				index += 2;
				continue;
			}
			var c:String = csv_str.charAt ( index );
			if (c == '"') {
				index++;
				skipSpace();
				
				if (csv_str.charAt ( index ) == ",")
					index++;
				break;
			}
			col += c;
			index++;				
		}
		return col;
	}
	
	function skipSpace () :Void {
		if (csv_str.charAt ( index ) == " ")
			index++;
	}
	
	
	
	// Utils
	function hasEscapeChar (cell:String, splitter:String) :Bool {
		for (split in ['"', "\n", "\r", "\t", " ", splitter])
			if (cell.indexOf ( split ) >= 0)
				return true;
				return false;
	}
	
	inline function escapeCell (cell:String) :String {
		cell = replaceStr (cell, '"', '""');
		cell = '"' + cell + '"';
		return cell;
	}
	
	inline function replaceStr (str:String, a:String, b:String) :String {
		var o:Array<String> = str.split ( a );
		return o.join ( b );
	}
	
}
