/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/
package mloader;

import mloader.Loader;
import mloader.HttpLoader;
import msignal.Signal;

#if (openfl && android)
class NativeHttpLoader<T> extends HttpLoader<T>
{
	var handle:Dynamic;
	
	public function new(url:String)
	{
		super(url);
		
		// lazy init to avoid crash at startup
		if (native_new == null)
		{
			native_new = openfl.utils.JNI.createStaticMethod("mloader/nme/extension/android/HttpLoader", "<init>", "(Ljava/lang/String;)V");
			native_addHeader = openfl.utils.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "addHeader", "(Ljava/lang/String;Ljava/lang/String;)V");
			native_setUserAgent = openfl.utils.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "setUserAgent", "(Ljava/lang/String;)V");
			native_get = openfl.utils.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "get", "(Lorg/haxe/nme/HaxeObject;)V");
			native_post = openfl.utils.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "post", "(Ljava/lang/String;Lorg/haxe/nme/HaxeObject;)V");
			native_cancel = openfl.utils.JNI.createMemberMethod("mloader/nme/extension/android/HttpLoader", "cancel", "()V");
		}
        handle = native_new(haxe.Utf8.encode(url));
	}
	
	override public function send(data:Dynamic)
	{
		// if currently loading, cancel
		if (loading) cancel();

		// if no url, throw exception
		if (url == null) throw "No url defined for Loader";

		// update state
		loading = true;

		// dispatch started
		loaded.dispatchType(Start);

		// default content type
		var contentType = "application/octet-stream";

		if (Std.is(data, Xml))
		{
			// convert to string and send as application/xml
			data = Std.string(data);
			contentType = "application/xml";
		}
		else if (!Std.is(data, String))
		{
			// stringify and send as application/json
			data = haxe.Json.stringify(data);
			contentType = "application/json";
		}

		// only set content type if not already set
		if (!headers.exists("Content-Type"))
		{
			headers.set("Content-Type", contentType);
		}
		
		httpConfigure();
		addHeaders();

		var str = haxe.Utf8.encode(Std.string(data));
		native_post(handle, str, this);
	}
	
	override function loaderLoad()
	{
		if (url.indexOf("http") == 0)
		{
			httpConfigure();
			addHeaders();
			native_get(handle, this);
		}
		else
		{
			var result = nme.installer.Assets.getText(url);
			haxe.Timer.delay(callback(httpData, result), 10);
		}
	}

	override function addHeaders()
	{
		for (name in headers.keys())
			native_addHeader(handle, name, headers.get(name));
	}

	override function loaderCancel()
	{
		native_cancel(handle);
	}
	
	static var native_new:Dynamic;
	static var native_addHeader:Dynamic;
	static var native_setUserAgent:Dynamic;
	static var native_get:Dynamic;
	static var native_post:Dynamic;
	static var native_cancel:Dynamic;
}

#else
typedef NativeHttpLoader<T> = mloader.HttpLoader<T>;
#end