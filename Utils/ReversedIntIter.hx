class ReversedIntIter {
	
    var min : Int;
    var max : Int;

    public function new (max:Int, min:Int) {
        this.min = min;
        this.max = max;
    }

    public function hasNext() {
        return ( min < max );
    }

    public function next() {
        return max--;
    }
}
