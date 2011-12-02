//
//  Observable
//
//  Created by Baluta Cristian on 2008-10-12.
//  Copyright (c) 2008 ralcr.com. All rights reserved.
//
package core.observer;

class Observable {
	
	var changed :Bool;
	var observers :List<Dynamic>;
	
	public function new () {
		changed = false;
		observers = new List<Dynamic>();
	}
	
	
	/**
	 * Add an observer to the list of observers
	 */
	public function addObserver (o:Observer) :Bool {
		if (o == null) return false;
		
		// Don't add an observer more than once
		for (obs in observers)
			if (obs == o) return false;
		
		// Add the observer in the list
		observers.add ( o );
		
		return true;
	}
	
	
	/**
	 * Remove an observer from the list of observers
	 */
	public function removeObserver (o:Observer) :Bool {
		return observers.remove ( o );
	}
	
	
	/**
	 * Tell all observers that the subject has changed
	 */
	public function notifyObservers (?infoObj:Dynamic) :Void {
		if (!changed) return false;
		changed = false;
		
		for (obs in observers)
			obs.update (this, infoObj);
	}
	
}
