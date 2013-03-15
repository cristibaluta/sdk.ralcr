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

import android.net.http.AndroidHttpClient;
import android.os.AsyncTask;
import android.util.Log;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;
import org.apache.http.util.EntityUtils;
import org.haxe.nme.HaxeObject;
import org.haxe.nme.GameActivity;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Basic native Android extension for making HTTP GET and POST/PUT requests over http/https.
 * Currently only allows for responses and payloads of type String.
 *
 * A listener object passed from Haxe to get() or post() must implement the following callback methods.
 *
 * function httpStatus(statusCode:Int):Void;
 * function httpData(result:String):Void;
 * function httpError(error:String):Void;
 */
public class NMEHttps {
	
	public static final String DEFAULT_USER_AGENT = "Mozilla/5.0 (Linux; U; Android 2.2; en-us;)";

	static NMEHttps loader;
	public HttpsBackgroundTask activeTask;
	public Map<String, String> headers;
	public String userAgent;
	
	
	static public void ralcr_https_get (final String url, final String vars) {
		Log.d("ralcr_https_get", "get: "+url+"?"+vars);
		ralcr_https_cancel();
		loader = new NMEHttps();
		loader.get (url, vars);
	}
	static public void ralcr_https_post (final String url, final String payload) {
		ralcr_https_cancel();
		loader = new NMEHttps();
		loader.post (url, payload);
	}
	static public void ralcr_https_put (final String url, final String payload) {
		ralcr_https_cancel();
		loader = new NMEHttps();
		loader.put (url, payload);
	}
	
	static public void ralcr_https_cancel() {
    	Log.d("http", "cancel "+loader);
    	if (loader != null) {
    		loader.destroy();
    		loader = null;
		}
	}
	
	// UGLY HACK TO AVOID JNI CRASHES WHEN USING call1. Call this methods from time to time to see if the request is ready
	static public boolean ralcr_https_is_ready() {
		Log.d("nmehttps", "ask if ready");
		if (loader == null) return false;
		return loader.isReady();
	}
	static public boolean ralcr_https_is_successful() {
		Log.d("nmehttps", "ask if successful");
		if (loader == null) return false;
		return loader.isSuccessful();
	}
	static public String ralcr_https_get_result() {
		Log.d("nmehttps", "ralcr_https_get_result");
		if (loader == null) return "";
		return loader.getResult();
	}
	
	
	
	
	public NMEHttps () {
		headers = new HashMap<String,String>();
		userAgent = DEFAULT_USER_AGENT;
		userAgent = System.getProperty("http.agent");
	}
	public void get (final String url, final String vars) {
		// setHeader("Content-Type", "application/x-www-form-urlencoded");
		activeTask = new HttpsBackgroundTask (url+"?"+vars, HttpMethod.GET, null, headers, userAgent);
		activeTask.execute();
	}
	public void post (final String url, final String vars) {
		setHeader("Content-Type", "application/json");
		setHeader("Content-Length", Integer.toString(vars.length()));
		activeTask = new HttpsBackgroundTask (url, HttpMethod.POST, vars, headers, userAgent);
		activeTask.execute();
	}
	public void put (final String url, final String vars) {
		setHeader("Content-Type", "application/json");
		setHeader("Content-Length", Integer.toString(vars.length()));
		activeTask = new HttpsBackgroundTask (url, HttpMethod.PUT, vars, headers, userAgent);
		activeTask.execute();
	}
	
	public void setHeader(String name, String value){
		headers.put (name.toLowerCase(), value);
	}
	public void setUserAgent(String userAgent){
		this.userAgent = userAgent;
	}
	public void destroy() {
	    Log.d("http", "destroy "+activeTask);
	   	if (activeTask != null) {
	    	activeTask.cancel(true);
	    	activeTask = null;
		}
		Log.d("http", "destroy finished");
	}
	public boolean isReady() {
		return activeTask.isReady();
	}
	public boolean isSuccessful() {
		return activeTask.isSuccessful();
	}
	public String getResult() {
		return activeTask.getValue();
	}
	
	
	
	
	/**
	 * Background task to execute http request and then report its outcome back to Haxe listener.
	 */
	private class HttpsBackgroundTask extends AsyncTask<Void, Void, HttpResult> {
		
		//private final URL url;
		private final String url_str;
		private final HttpMethod method;
		private final String payload;
		private final Map<String, String> headers;
		private final String userAgent;
		public HttpResult httpresult;
		
		public HttpsBackgroundTask (String url, HttpMethod method, String payload, Map<String, String> headers, String userAgent) {
			//this.url = stringToURL(url);
			this.url_str = url;
			this.method = method;
			this.payload = payload;
			this.headers = headers;
			this.userAgent = userAgent;
			this.httpresult = null;
		}
		public boolean isReady() {
			Log.d("HttpsBackgroundTask", "isReady?");
			return httpresult != null;
		}
		public boolean isSuccessful() {
			Log.d("HttpsBackgroundTask", "isSuccessful?");
			return httpresult.isSuccessful();
		}
		public String getValue() {
			Log.d("HttpsBackgroundTask", "getValue?");
			return httpresult.getValue();
		}
		
		@Override
		protected HttpResult doInBackground(Void... unused) {
			Log.d("HttpsBackgroundTask", "doInBackground "+url_str);
			HttpResult result = null;
			String errorMessage = null;
			
			try {
				switch (method) {
					case GET: result = executeRequest ( new HttpGet ( url_str)); break;
					case POST: result = httpPost(); break;
					case PUT: result = httpPut(); break;
					default: throw new Exception("Unsupported http method: " + method);
				}
			}
			catch (UnsupportedEncodingException e) {
				errorMessage = e.toString();
			}
			catch (ClientProtocolException e) {
				errorMessage = e.toString();
			}
			catch (IOException e) {
				errorMessage = e.toString();
			}
			catch (Exception e) {
				errorMessage = e.toString();
			}
			
			if (errorMessage != null) {
				result = new HttpResult (false, errorMessage, -1);
			}
			
			return result;
		}
		
		// private HttpResult httpGet() throws IOException, URISyntaxException {
		// 	HttpGet request = new HttpGet(url);
		// 	return executeRequest(request);
		// }
		
		private HttpResult httpPost() throws IOException, URISyntaxException {
			HttpPost request = new HttpPost(url_str);
			request.setEntity(new StringEntity(payload));
			return executeRequest(request);
		}
		
		private HttpResult httpPut() throws IOException, URISyntaxException {
			HttpPut request = new HttpPut(url_str);
			request.setEntity ( new StringEntity(payload));
			return executeRequest(request);
		}
		
		private HttpResult executeRequest(HttpUriRequest request) throws IOException {
			
			AndroidHttpClient client = AndroidHttpClient.newInstance(userAgent);
			
			for (String header : headers.keySet()) {
				request.setHeader (header, headers.get(header));
			}
			
			try {
				HttpResponse httpResponse = client.execute(request);
				return createHttpResult(httpResponse);
			}
			finally {
				client.close();
			}
		}
		
		private HttpResult createHttpResult(HttpResponse response) {
			int statusCode = response.getStatusLine().getStatusCode();
			boolean isSuccessful = (statusCode < 400 || statusCode >= 600); // bit brittle?
			HttpEntity entity = response.getEntity();
			String result = "";
			
			if (entity != null) {
				try {
					result = EntityUtils.toString(entity);
				}
				catch (IOException e) {
					e.printStackTrace();
					isSuccessful = false;
					result = e.toString();
				}
			}
			else {
				result = "";
			}
			Log.d ("HttpResult create", result);
			return new HttpResult (isSuccessful, result, statusCode);
		}
		
		// This method runs in the UI thread
		@Override
		protected void onPostExecute(final HttpResult result) {
			httpresult = result;
		}
	}
	
	private class HttpResult {
		
		private boolean isSuccessful;
		private String value;
		private int statusCode;
		
		public HttpResult (boolean isSuccessful, String value, int statusCode) {
			this.isSuccessful = isSuccessful;
			this.value = value;
			this.statusCode = statusCode;
		}
		
		public boolean isSuccessful() {
		Log.d("HttpResult", "isSuccessful "+isSuccessful);
			return isSuccessful;
		}
		public String getValue() {
		Log.d("HttpResult", value);
			return value;
		}
		public int getStatusCode() {
		Log.d("HttpResult", ""+statusCode);
			return statusCode;
		}
	}
	
	private enum HttpMethod {
		GET,
		POST,
		PUT
	}
}
