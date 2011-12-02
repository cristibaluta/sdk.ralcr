//
//  Main
//
//  Created by Baluta Cristian on 2011-08-18
//  Copyright (c) 2011 http://ralcr.com. All rights reserved.
//
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.geom.Point;


class Main {
	inline static var MC = flash.Lib.current.stage;
	
	static var indexes :Array<String>;
	static var hellos :Array<Array<String>>;
	static var tableView :RCTableView<RCTableViewCell>;
	
	
	static function main () {
		haxe.Firebug.redirectTraces();
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		init();
	}
	
	
	/**
	 * Init the application
	 */
	public static function init () {
		
		// register fonts, formats and stylesheets
		FontManager.init();
		//RegisterFonts.init();
		
		//MC.addChild ( new RCTextView (300, 50, 400, null, usage, FontManager.getRCFont("pixel")) );
		
		
		
		readFile();
	}
	
	// Read an external txt file and display its content
	static function readFile () :Void {
		var loader = new URLLoader();
		loader.addEventListener (Event.COMPLETE, completeHandler);
		
		var request = new URLRequest ( "hellos.plist?"+Math.random() );
		loader.load ( request );
	}
	// Add to stage the content from loaded txt file
	static function completeHandler (e:Event) :Void {
		
		var xml = Xml.parse ( e.target.data );
		var fast = new haxe.xml.Fast ( xml.firstElement() );
		
		
		indexes = new Array<String>();
		hellos = new Array<Array<String>>();
		
		for (p in fast.node.dict.nodes.key) {
			indexes.push ( p.innerData );
		}
		for (p in fast.node.dict.nodes.array) {
			var index = new Array<String>();
			for (pp in p.nodes.string) {
				index.push ( pp.innerData );
			}
			hellos.push ( index );
		}
		
		trace(indexes);
		MC.addChild ( new RCTextView (30, 6, null, null, "Hello in any language", FontManager.getRCFont("system", {color:0x000000})) );
		
		tableView = new RCTableView<RCTableViewCell> (20, 30, 300, 500);
		tableView.delegate = Main;
		tableView.init();
		MC.addChild ( tableView );
	}
	
	public static function cellForRowAtIndexPath (indexPath:RCIndexPath) :RCTableViewCell {
		var cell = new RCTableViewCell (300, 44);
			cell.indexPath = indexPath;
			cell.y = 44*indexPath.row;
		return cell;
	}
	public static function claimDataForCell (cell:RCTableViewCell) :Void {
		var arr = hellos[cell.indexPath.section][cell.indexPath.row].split("*");
		cell.titleView.text = arr[4]+arr[0] + " ("+arr[1]+") '"+arr[3]+"'";
	}
	public static function numberOfRowsInSection(section:Int) :Int {
		return hellos[section].length;
	}
	
}
