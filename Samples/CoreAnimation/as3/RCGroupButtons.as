package  {
	import flash.Boot;
	public class RCGroupButtons extends RCView {
		public function RCGroupButtons(x : Number = NaN,y : Number = NaN,gapX : * = null,gapY : * = null,constructor : Function = null) : void { if( !flash.Boot.skip_constructor ) {
			super(x,y);
			this.gapX = gapX;
			this.gapY = gapY;
			this.constructButton = constructor;
			this.buttons_arr = new HashArray();
		}}
		
		public var gapX : *;
		public var gapY : *;
		protected var constructButton : Function;
		protected var buttons_arr : HashArray;
		public var onClick : Function = function() : void {
			null;
		}
		public var _label : String;
		public function add(labels : Array,constructor : Function = null) : void {
			var constructorNow : Function = this.constructButton;
			if(Reflect.isFunction(constructor)) {
				constructorNow = constructor;
			}
			if(!Reflect.isFunction(constructorNow)) return;
			{
				var _g : int = 0;
				while(_g < labels.length) {
					var _label : String = labels[_g];
					++_g;
					if(this.buttons_arr.exists(_label)) continue;
					var b : RCControl = constructorNow(_label);
					b.onClick = (function(f : Function,a1 : String) : Function {
						return function() : void {
							f(a1);
							return;
						}
					})(this.clickHandler,_label);
					b.setToggable(true);
					this.buttons_arr.set(_label,b);
					this.dispatchEvent(new GroupEvent("group_push",_label,this.getPositionForLabel(_label)));
				}
			}
			this.keepButtonsArranged();
		}
		
		public function remove(_label : String) : void {
			if(this.buttons_arr.exists(_label)) {
				Fugu.safeDestroy(this.buttons_arr.get(_label),null,{ fileName : "RCGroupButtons.hx", lineNumber : 68, className : "RCGroupButtons", methodName : "remove"});
				this.buttons_arr.remove(_label);
			}
			this.keepButtonsArranged();
			this.dispatchEvent(new GroupEvent("group_remove",_label,this.getPositionForLabel(_label)));
		}
		
		public function update(labels : Array,constructor : Function = null) : void {
			this.destroy();
			this.buttons_arr = new HashArray();
			this.add(labels,constructor);
		}
		
		public function keepButtonsArranged() : void {
			{
				var _g1 : int = 0, _g : int = this.buttons_arr.array().length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var newX : Number = 0.0, newY : Number = 0.0;
					var new_b : RCControl = this.buttons_arr.get(this.buttons_arr.array()[i]);
					var old_b : RCControl = this.buttons_arr.get(this.buttons_arr.array()[i - 1]);
					if(i != 0) {
						if(this.gapX != null) newX = old_b.x + old_b.width + this.gapX;
						if(this.gapY != null) newY = old_b.y + old_b.height + this.gapY;
					}
					new_b.x = newX;
					new_b.y = newY;
					this.addChild(new_b);
				}
			}
			this.dispatchEvent(new GroupEvent("group_updated",null,-1));
		}
		
		public function getPositionForLabel(_label : String) : int {
			{
				var _g1 : int = 0, _g : int = this.buttons_arr.arr.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(this.buttons_arr.arr[i] == _label) return i;
				}
			}
			return -1;
		}
		
		public function select(_label : String,can_unselect : Boolean = true) : void {
			this._label = _label;
			if(this.buttons_arr.exists(_label)) {
				this.buttons_arr.get(_label).toggle();
				if(can_unselect) this.buttons_arr.get(_label).lock();
				else this.buttons_arr.get(_label).unlock();
			}
			if(can_unselect) { var $it : * = this.buttons_arr.keys();
			while( $it.hasNext() ) { var key : String = $it.next();
			if(key != _label) if(this.buttons_arr.get(key).getToggable()) this.unselect(key);
			}}
		}
		
		public function unselect(_label : String) : void {
			this.buttons_arr.get(_label).unlock();
			this.buttons_arr.get(_label).untoggle();
		}
		
		public function toggled(_label : String) : Boolean {
			return this.buttons_arr.get(_label).getToggled();
		}
		
		public function get(_label : String) : RCControl {
			return this.buttons_arr.get(_label);
		}
		
		public function exists(key : String) : Boolean {
			return this.buttons_arr.exists(key);
		}
		
		public function enable(_label : String) : void {
			this.buttons_arr.get(_label).unlock();
			this.buttons_arr.get(_label).alpha = 1;
		}
		
		public function disable(_label : String) : void {
			this.buttons_arr.get(_label).lock();
			this.buttons_arr.get(_label).alpha = 0.6;
		}
		
		protected function clickHandler(_label : String) : void {
			this._label = _label;
			this.dispatchEvent(new GroupEvent("group_click",_label,this.getPositionForLabel(_label)));
			this.onClick();
		}
		
		public override function destroy() : void {
			{ var $it : * = this.buttons_arr.keys();
			while( $it.hasNext() ) { var key : String = $it.next();
			Fugu.safeDestroy(this.buttons_arr.get(key),null,{ fileName : "RCGroupButtons.hx", lineNumber : 198, className : "RCGroupButtons", methodName : "destroy"});
			}}
			this.buttons_arr = null;
		}
		
	}
}
