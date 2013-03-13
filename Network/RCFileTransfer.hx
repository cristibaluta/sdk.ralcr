//
//  RCFileTransfer.hx
//
//  Created by Baluta Cristian on 2008-07-04.
//  Copyright (c) 2008 www.ralcr.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//

#if flash

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.FileFilter;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;


class RCFileTransfer {
	
	inline public static function IMAGES () :FileFilter { return new FileFilter ("Images", "*.jpg;*.jpeg;*.png;*.gif"); }
	inline public static function MUSIC () :FileFilter { return new FileFilter ("Mp3 Files", "*.mp3"); }
	inline public static function FLASH () :FileFilter { return new FileFilter ("Flash Files", "*.swf"); }
	inline public static function VIDEOS () :FileFilter { return new FileFilter ("Flash Video", "*.flv;*.f4v;*.mp4"); }
	inline public static function TEXT () :FileFilter { return new FileFilter ("Text", "*.txt"); }
	inline public static function ALL () :FileFilter { return new FileFilter ("All", "*.*"); }
	
	var fr :FileReference;
	var apiPath :String;
	
	public var name :String;
	public var size :Int;
	public var creationDate :Date;
	public var modificationDate :Date;
	
	public var percentLoaded :Int;
	public var errorMessage :String;
	
	dynamic public function onSelect () :Void {}
	dynamic public function onOpen () :Void {}
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	
	public function new (apiPath:String) {
		
		this.apiPath = apiPath;
		
		fr = new FileReference();
		fr.addEventListener (Event.SELECT, selectHandler);
		fr.addEventListener (Event.OPEN, openHandler);
		fr.addEventListener (Event.COMPLETE, completeHandler);
		fr.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		fr.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		fr.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityHandler);
	}
	
	
	/**
	 * Select a file from the hard drive.
	 */
	public function browse (accepted_files:Array<FileFilter>) {
		fr.browse ( accepted_files );
	}
	
	
	/**
	 * Begin the upload
	 */
	public function upload (path:String, new_name:String, ?variables_list:Dynamic) {
		
		var variables = new URLVariables();
		variables.path = path;
		variables.name = new_name;
		trace("upload: "+path+new_name);
		// Pass some more variables (ex: w, h, resize of the uploaded file)
		if (variables_list != null)
			for (f in Reflect.fields (variables_list))
				Reflect.setField (variables, f, Reflect.field (variables_list, f));
		
		
		var request = new URLRequest (apiPath + "filesystem/uploadFile.php");
		request.data = variables;
		request.method = URLRequestMethod.POST;
		
		fr.upload ( request );
	}
	
	
	/**
	 * Download file.
	 */
	public function download (URL:String, ?new_name:String) {
		
		var request = new URLRequest ( URL );
		
		fr.download (request, new_name);
	}
	
	
	/**
	 * Cancel the transfer.
	 */
	public function cancel () {
		fr.cancel();
	}
	
	
	/**
	 * Handlers
	 */
	function selectHandler (e:Event) {
		trace("Selected File");
		try{
		trace("Name: " + fr.name);
		trace("Type: " + fr.type);
		trace("Size: " + fr.size);
		trace("Created On: " + fr.creationDate);
		trace("Modified On: " + fr.modificationDate);
		}catch(e:Dynamic){trace(e);}
		
		name = fr.name;
		size = Math.round ( fr.size );
		creationDate = fr.creationDate;
		modificationDate = fr.modificationDate;
		
		onSelect ();
	}
	function openHandler (e:Event) {
 		trace("openHandler: " + e);
		onOpen();
	}
	function progressHandler (e:ProgressEvent) {
		percentLoaded = Math.round (e.bytesLoaded * 100 / e.bytesTotal);
		onProgress();
	}
	function ioErrorHandler (e:IOErrorEvent) {
		trace ("an IO error occurred: "+e.text);
		errorMessage = e.text;
		onError();
	}
	function securityHandler (e:SecurityErrorEvent) {
		trace("a security error occurred");
		errorMessage = e.text;
		onError();
	}
	function completeHandler (e:Event) {
		trace("the file has uploaded");
		percentLoaded = 100;
		onProgress();
		onComplete();
	}
	
	
	public function destroy () {
		fr.removeEventListener (Event.SELECT, selectHandler);
		fr.removeEventListener (Event.OPEN, openHandler);
		fr.removeEventListener (Event.COMPLETE, completeHandler);
		fr.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
		fr.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		fr.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityHandler);
	}
}
#end
