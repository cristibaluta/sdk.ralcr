//
//  Upload
//
//  Created by Baluta Cristian on 2008-07-04.
//  Copyright (c) 2008 www.lib.com. 
//	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
//
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
	
	inline public static var IMAGES :FileFilter = new FileFilter ("Images", "*.jpg;*.jpeg;*.png;*.gif");
	inline public static var MUSIC :FileFilter = new FileFilter ("Mp3 Files", "*.mp3");
	inline public static var FLASH :FileFilter = new FileFilter ("Flash Files", "*.swf");
	inline public static var VIDEOS :FileFilter = new FileFilter ("Flash Video", "*.flv;*.f4v;*.mp4");
	inline public static var TEXT :FileFilter = new FileFilter ("Text", "*.txt");
	inline public static var ALL :FileFilter = new FileFilter ("All", "*.*");
	
	var _file_reference :FileReference;
	var _scripts_path :String;
	
	public var name :String;
	public var size :Int;
	public var creationDate :Date;
	public var modificationDate :Date;
	
	public var percentLoaded :Int;
	public var errorMessage :String;
	
	/**
	 * Dispatch events
	 */
	dynamic public function onSelect () :Void {}
	dynamic public function onOpen () :Void {}
	dynamic public function onComplete () :Void {}
	dynamic public function onProgress () :Void {}
	dynamic public function onError () :Void {}
	
	
	public function new (scripts_path:String) {
		
		_scripts_path = scripts_path;
		
		_file_reference = new FileReference();
		_file_reference.addEventListener (Event.SELECT, selectHandler);
		_file_reference.addEventListener (Event.OPEN, openHandler);
		_file_reference.addEventListener (Event.COMPLETE, completeHandler);
		_file_reference.addEventListener (ProgressEvent.PROGRESS, progressHandler);
		_file_reference.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		_file_reference.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityHandler);
	}
	
	
	/**
	 * Select a file from the hard drive.
	 */
	public function browse (accepted_files:Array<FileFilter>) {
		_file_reference.browse ( accepted_files );
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
		
		
		var request = new URLRequest (_scripts_path + "filesystem/uploadFile.php");
		request.data = variables;
		request.method = URLRequestMethod.POST;
		
		_file_reference.upload ( request );
	}
	
	
	/**
	 * Download file.
	 */
	public function download (URL:String, ?new_name:String) {
		
		var request = new URLRequest ( URL );
		
		_file_reference.download (request, new_name);
	}
	
	
	/**
	 * Cancel the transfer.
	 */
	public function cancel () {
		_file_reference.cancel();
	}
	
	
	/**
	 * Handlers
	 */
	function selectHandler (e:Event) {
		trace("Selected File");
		try{
		trace("Name: " + _file_reference.name);
		trace("Type: " + _file_reference.type);
		trace("Size: " + _file_reference.size);
		trace("Created On: " + _file_reference.creationDate);
		trace("Modified On: " + _file_reference.modificationDate);
		}catch(e:Dynamic){trace(e);}
		
		name = _file_reference.name;
		size = Math.round ( _file_reference.size );
		creationDate = _file_reference.creationDate;
		modificationDate = _file_reference.modificationDate;
		
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
		_file_reference.removeEventListener (Event.SELECT, selectHandler);
		_file_reference.removeEventListener (Event.OPEN, openHandler);
		_file_reference.removeEventListener (Event.COMPLETE, completeHandler);
		_file_reference.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
		_file_reference.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		_file_reference.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityHandler);
	}
}
