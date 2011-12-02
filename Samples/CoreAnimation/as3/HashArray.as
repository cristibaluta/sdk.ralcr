package  {
	import flash.Boot;
	public class HashArray extends Hash {
		public function HashArray() : void { if( !flash.Boot.skip_constructor ) {
			super();
			this.arr = new Array();
		}}
		
		public var arr : Array;
		public override function set(key : String,_tmp_value : *) : void {
			var value : * = _tmp_value;
			if(!super.exists(key)) this.arr.push(key);
			super.set(key,value);
		}
		
		public override function remove(key : String) : Boolean {
			this.arr.remove(key);
			return super.remove(key);
		}
		
		public function insert(pos : int,key : String,value : *) : void {
			if(super.exists(key)) return;
			this.arr.insert(pos,key);
			super.set(key,value);
		}
		
		public function array() : Array {
			return this.arr;
		}
		
	}
}
