//
//  iObserver
//
//  Created by Baluta Cristian on 2008-10-12.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
package core.observer;

interface IObserver {
	
	public function update (o:Observable, infoObj:Dynamic) :Void {}
}
