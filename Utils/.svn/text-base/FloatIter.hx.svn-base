//
//  FloatIter
//
//  Created by Baluta Cristian on 2011-03-06.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
enum Direction {
	left;
	right;
}

class FloatIter {
	
	var direction :Direction;
	var v1 :Float;
	var v2 :Float;
	var step :Float;
	
	
	public function new (v1:Float, v2:Float, step:Float) {
		this.v1 = v1;
		this.v2 = v2;
		this.direction = (v1 < v2) ? right : left;
		this.step = step;
	}
	
	public function hasNext() {
		switch (direction) {
			case left: ( v1 < v2 );
			case right: ( v2 > v1 );
		}
		return ( v2 > v1 );
	}
	
	public function next() {
		switch (direction) {
			case left: v2-=step;
			case right: v1+=step;
		}
		return v1+=step;
	}
}
