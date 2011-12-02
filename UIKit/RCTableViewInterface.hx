interface RCTableViewInterface {
	public function cellForRowAtIndexPath (indexPath:RCIndexPath) :RCTableViewCell;
	public function claimDataForCell (cell:RCTableViewCell) :Void;
	public function numberOfRowsInSection (section:Int) :Int;
	public function didSelectRowAtIndexPath (indexPath:RCIndexPath) :Void;
}
