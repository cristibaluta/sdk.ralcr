//
//  RCScrollView
//
//  Created by Cristi Baluta on 2011-02-08.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//
import flash.display.DisplayObjectContainer;


class RCScrollView extends RCView {
	
	public var contentView :DisplayObjectContainer;// You can access directly the contentView, but be carefull
	public var contentRect :RCRect;// You can access directly the contentView, but be carefull
	var contentMask :RCRectangle;
	var verticalSliderIndicator :RCSlider;
	var horizontalSliderIndicator :RCSlider;
	var verticalSliderSync :RCSliderSync;
	var horizontalSliderSync :RCSliderSync;
	
	public var dragging :Bool;
	public var autohideSliders :Bool;
	public var enableMarginsFade (null, setMarginsFade) :Bool;
	public var bounces (null, setBounce) :Bool;
	public var decelerationRate :Float;
	public var pagingEnabled :Bool;
	public var scrollEnabled (null, setScrollEnabled) :Bool;
	public var scrollIndicatorInsets :RCPosition;
	
	dynamic public function scrollViewDidScroll():Void{}
	dynamic public function scrollViewWillBeginDragging():Void{}
	dynamic public function scrollViewDidEndDragging():Void{}
	dynamic public function scrollViewDidScrollToTop():Void{}
	dynamic public function scrollViewDidEndScrollingAnimation():Void{}
		
	
	public function new (x, y, w, h) {
		super(x, y);
		size = new RCSize (w, h);
		contentMask = new RCRectangle (0, 0, w, h);
		setContentView ( new RCView(0, 0) );
	}
	
	
	/**
	 *  Set a custom view as the contentView
	 */
	public function setContentView (content:DisplayObjectContainer) :Void {
		contentView = content;
		contentView.mask = contentMask;
		view.addChild ( contentView );
		view.addChild ( contentMask );
	}
	function setScrollEnabled (b:Bool) :Bool {
		//trace("setScrollEnabled "+b);
		var colors = [null, null, 0xDDDDDD, 0xFFFFFF];
		//trace("contentView.width "+contentView.width);
		
		// Add or remove the horizontal scrollbar
		if (contentView.width > size.width && horizontalSliderSync == null && b) {
			//trace("add horz");
			var scroller_w = Zeta.lineEquationInt (50, size.width-50, contentRect.size.width, size.width*10, size.width);
			var skinH = new SKSlider (scroller_w, 5, size.width, 5,  0, colors);
			horizontalSliderIndicator = new RCSlider (0, size.height + 2, Math.round(size.width), null, skinH);
			horizontalSliderSync = new RCSliderSync (RCStage.target, contentView, horizontalSliderIndicator, Math.round(size.width), "horizontal");
			horizontalSliderSync.onUpdate = scrollViewDidScrollHandler;
			view.addChild ( horizontalSliderIndicator );
		}
		else {
			Fugu.safeDestroy ([horizontalSliderIndicator, horizontalSliderSync]);
			horizontalSliderIndicator = null;
			horizontalSliderSync = null;
		}
		//trace("contentView.height "+contentView.height);
		
		// Add or remove the vertical scrollbar
		if (contentView.height > size.height && verticalSliderSync == null && b) {
			//trace("add vert");
			var scroller_h = Zeta.lineEquationInt (50, size.height-50, contentRect.size.height, size.height*10, size.height);
			var skinV = new SKSlider (5, scroller_h, 5, size.height,  0, colors);
			verticalSliderIndicator = new RCSlider (size.width + 2, 0, null, Math.round(size.height), skinV);
			verticalSliderSync = new RCSliderSync (RCStage.target, contentView, verticalSliderIndicator, Math.round(size.height), "vertical");
			verticalSliderSync.onUpdate = scrollViewDidScrollHandler;
			view.addChild ( verticalSliderIndicator );
		}
		else {
			Fugu.safeDestroy ([verticalSliderIndicator, verticalSliderSync]);
			verticalSliderIndicator = null;
			verticalSliderSync = null;
		}
		
		return b;
	}
	function scrollViewDidScrollHandler () :Void {
		scrollViewDidScroll();
	}
	
	/**
	 *  Take the rect from the contentView and fill the contentRect with it
	 */
	public function scrollRectToVisible (rect:RCRect, animated:Bool) :Void {
		
	}
	
	public function zoomToRect (rect:RCRect, animated:Bool) :Void {
		
	}
	
	public function setBounce (b:Bool) :Bool {
		bounces = b;
		return b;
	}
	public function setMarginsFade (b:Bool) :Bool {
		return b;
	}
	
	
	public function resume () :Void {
		if (verticalSliderSync != null)
			verticalSliderSync.resume();
		if (horizontalSliderSync != null)
			horizontalSliderSync.resume();
	}
	
	public function hold () :Void {
		if (verticalSliderSync != null)
			verticalSliderSync.hold();
		if (horizontalSliderSync != null)
			horizontalSliderSync.hold();
	}
	
	override public function destroy () :Void {
		Fugu.safeDestroy ([verticalSliderSync, horizontalSliderSync]);
		verticalSliderSync = null;
		horizontalSliderSync = null;
	}
}
