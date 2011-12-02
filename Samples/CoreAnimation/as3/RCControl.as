package  {
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.Boot;
	public class RCControl extends flash.display.Sprite {
		public function RCControl(x : Number = NaN,y : Number = NaN) : void { if( !flash.Boot.skip_constructor ) {
			super();
			this._toggled = false;
			this._toggable = false;
			this._clickable = true;
			this._lockable = true;
			this.x = x;
			this.y = y;
			this.useHandCursor = true;
			this.buttonMode = true;
			this.configureListeners(this);
		}}
		
		public function get locked() : Boolean { return getLocked(); }
		protected function set locked( __v : Boolean ) : void { $locked = __v; }
		protected var $locked : Boolean;
		public function get toggled() : Boolean { return getToggled(); }
		protected function set toggled( __v : Boolean ) : void { $toggled = __v; }
		protected var $toggled : Boolean;
		public function get toggable() : Boolean { return getToggable(); }
		public function set toggable( __v : Boolean ) : void { setToggable(__v); }
		protected var $toggable : Boolean;
		public function get clickable() : Boolean { return getClickable(); }
		public function set clickable( __v : Boolean ) : void { setClickable(__v); }
		protected var $clickable : Boolean;
		public function get lockable() : Boolean { return getLockable(); }
		public function set lockable( __v : Boolean ) : void { setLockable(__v); }
		protected var $lockable : Boolean;
		protected var _toggled : Boolean;
		protected var _toggable : Boolean;
		protected var _clickable : Boolean;
		protected var _lockable : Boolean;
		public var onClick : Function = function() : void {
			null;
		}
		public var onPress : Function = function() : void {
			null;
		}
		public var onRelease : Function = function() : void {
			null;
		}
		public var onOver : Function = function() : void {
			null;
		}
		public var onOut : Function = function() : void {
			null;
		}
		protected function configureListeners(dispatcher : flash.events.IEventDispatcher) : void {
			this.useHandCursor = true;
			this.buttonMode = true;
			dispatcher.addEventListener(flash.events.MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
			dispatcher.addEventListener(flash.events.MouseEvent.MOUSE_UP,this.mouseUpHandler);
			dispatcher.addEventListener(flash.events.MouseEvent.ROLL_OVER,this.rollOverHandler);
			dispatcher.addEventListener(flash.events.MouseEvent.ROLL_OUT,this.rollOutHandler);
			dispatcher.addEventListener(flash.events.MouseEvent.CLICK,this.clickHandler);
		}
		
		protected function removeListeners(dispatcher : flash.events.IEventDispatcher) : void {
			this.useHandCursor = false;
			this.buttonMode = false;
			dispatcher.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
			dispatcher.removeEventListener(flash.events.MouseEvent.MOUSE_UP,this.mouseUpHandler);
			dispatcher.removeEventListener(flash.events.MouseEvent.ROLL_OVER,this.rollOverHandler);
			dispatcher.removeEventListener(flash.events.MouseEvent.ROLL_OUT,this.rollOutHandler);
			dispatcher.removeEventListener(flash.events.MouseEvent.CLICK,this.clickHandler);
		}
		
		protected function mouseDownHandler(e : flash.events.MouseEvent) : void {
			this.onPress();
		}
		
		protected function mouseUpHandler(e : flash.events.MouseEvent) : void {
			this.onRelease();
		}
		
		protected function clickHandler(e : flash.events.MouseEvent) : void {
			this.onClick();
		}
		
		protected function rollOverHandler(e : flash.events.MouseEvent) : void {
			if(this._toggled) return;
			this.onOver();
		}
		
		protected function rollOutHandler(e : flash.events.MouseEvent) : void {
			if(this._toggled) return;
			this.onOut();
		}
		
		public function getToggled() : Boolean {
			return this._toggled;
		}
		
		public function getLocked() : Boolean {
			return !this._clickable;
		}
		
		public function getToggable() : Boolean {
			return this._toggable;
		}
		
		public function setToggable(t : Boolean) : Boolean {
			return this._toggable = t;
		}
		
		public function getClickable() : Boolean {
			return this._clickable;
		}
		
		public function setClickable(c : Boolean) : Boolean {
			if(!this._lockable) return c;
			if(c) this.configureListeners(this);
			else this.removeListeners(this);
			return this._clickable = c;
		}
		
		public function getLockable() : Boolean {
			return this._lockable;
		}
		
		public function setLockable(l : Boolean) : Boolean {
			return this._lockable = l;
		}
		
		public function lock() : void {
			this.setClickable(false);
		}
		
		public function unlock() : void {
			this.setClickable(true);
		}
		
		public function toggle() : void {
			if(this._toggable && this._lockable) {
				this.toggledState();
				this._toggled = true;
			}
		}
		
		public function untoggle() : void {
			if(this._toggable && this._lockable) {
				this._toggled = false;
				this.untoggledState();
			}
		}
		
		protected function toggledState() : void {
			null;
		}
		
		protected function untoggledState() : void {
			null;
		}
		
		public function destroy() : void {
			this.removeListeners(this);
		}
		
	}
}
