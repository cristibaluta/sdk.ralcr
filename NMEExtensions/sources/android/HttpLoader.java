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
//package nme.extension.android;

import android.net.http.AndroidHttpClient;
import android.os.AsyncTask;
import android.util.Log;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
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
 * Basic native Android extension for making HTTP GET and POST requests over http/https.
 *
 * Includes support for setting custom http headers and user agent. Also supports cancellation of active request.
 *
 * Currently only allows for responses and payloads of type String.
 *
 * A listener object passed from Haxe to get() or post() must implement the following callback methods.
 *
 * function httpStatus(statusCode:Int):Void;
 * function httpData(result:String):Void;
 * function httpError(error:String):Void;
 */
public class HttpLoader
{
	public static final String DEFAULT_USER_AGENT = "Mozilla/5.0 (Linux; U; Android 2.2; en-us;)";
	
	public static final String CALLBACK_ID_HTTP_STATUS = "httpStatus";
	public static final String CALLBACK_ID_HTTP_DATA = "httpData";
	public static final String CALLBACK_ID_HTTP_ERROR = "httpError";
	
	private final String url;
	private Map<String, String> headers;
	private String userAgent;
	public AsyncTask<Void, Void, HttpResult> activeTask;
	
	public HttpLoader(String url)
	{
		this.url = url;
		headers = new HashMap<String, String>();
		userAgent = DEFAULT_USER_AGENT;
		setDefaultHeaders();
	}
	
	protected void setDefaultHeaders()
	{
		setHeader("Content-Type", "application/x-www-form-urlencoded");
		setHeader("Content-Language", "en-US");
	}
	
	public void setHeader(String name, String value)
	{
		headers.put(name.toLowerCase(), value);
	}
	
	public void setUserAgent(String userAgent)
	{
		this.userAgent = userAgent;
	}
	
	public void get(final HaxeObject listener)
	{
		cancel();
		Log.d("http", "get: "+url);
		GameActivity.getInstance().runOnUiThread(new Runnable() {

            @Override
            public void run() {
            	activeTask = new HttpLoaderBackgroundTask(url, HttpMethod.GET, headers, userAgent, listener).execute();
            }
        });
	}
	
	public void post(final String payload, final HaxeObject listener)
	{
		cancel();
		
		GameActivity.getInstance().runOnUiThread(new Runnable() {

            @Override
            public void run() {
            	activeTask = new HttpLoaderBackgroundTask(url, HttpMethod.POST, payload, headers, userAgent, listener).execute();
            }
        });
	}
	
	public void cancel()
	{
		GameActivity.getInstance().runOnUiThread(new Runnable() {
			
            @Override
            public void run() {
            	Log.d("http", "cancel "+activeTask);
            	if (activeTask != null)
        		{
            		activeTask.cancel(true);
            		activeTask = null;
        		}
            	Log.d("http", "cancel finished");
            }
        });
	}
	
	/**
	 * Background task to execute http request and then report its outcome back to Haxe listener.
	 */
	private class HttpLoaderBackgroundTask extends AsyncTask<Void, Void, HttpResult>
	{
		private final URL url;
		private final HttpMethod method;
		private final Map<String, String> headers;
		private final String payload;
		private final HaxeObject listener;
		private final String userAgent;
		
		public HttpLoaderBackgroundTask(String url, HttpMethod method, Map<String, String> headers, String userAgent, HaxeObject listener)
		{
			this(url, method, null, headers, userAgent, listener);
		}
		
		public HttpLoaderBackgroundTask(String url, HttpMethod method, String payload, Map<String, String> headers, String userAgent, HaxeObject listener)
		{
			this.url = stringToURL(url);
			this.method = method;
			this.headers = headers;
			this.userAgent = userAgent;
			this.payload = payload;
			this.listener = listener;
		}
		
		/**
		 * Convert url string to URL instance so query parameters are encoded correctly when dispatching a request.
		 */
		private URL stringToURL(String url)
		{
			try {
				URL tempUrl = new URL(url);
				URI tempUri = new URI(tempUrl.getProtocol(), tempUrl.getUserInfo(), tempUrl.getHost(), tempUrl.getPort(), tempUrl.getPath(), tempUrl.getQuery(), tempUrl.getRef());
				return tempUri.toURL();
			}
			catch (MalformedURLException e) {
				e.printStackTrace();
			}
			catch (URISyntaxException e) {
				e.printStackTrace();
			}
			return null;
		}
		
		@Override
		protected HttpResult doInBackground(Void... unused)
		{
			Log.d("HttpLoaderBackgroundTask", "doInBackground "+url);
			HttpResult result = null;
			String errorMessage = null;
			
			try {
				switch (method) {
					case GET: result = httpGet();
						break;
					case POST: result = httpPost();
						break;
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
				result = new HttpResult(false, errorMessage, -1);
			}
			
			return result;
		}
		
		private HttpResult httpGet() throws IOException, URISyntaxException
		{
			HttpGet request = new HttpGet(url.toString());
			return executeRequest(request);
		}
		
		private HttpResult httpPost() throws IOException, URISyntaxException
		{
			HttpPost request = new HttpPost(url.toString());
			request.setEntity(new StringEntity(payload));
			return executeRequest(request);
		}
		
		private HttpResult executeRequest(HttpUriRequest request) throws IOException
		{
			AndroidHttpClient client = AndroidHttpClient.newInstance(userAgent);
			
			for (String header : headers.keySet()) {
				request.setHeader(header, headers.get(header));
			}
			
			try {
				HttpResponse httpResponse = client.execute(request);
				return createHttpResult(httpResponse);
			}
			finally {
				client.close();
			}
		}
		
		private HttpResult createHttpResult(HttpResponse response)
		{
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
			return new HttpResult(isSuccessful, result, statusCode);
		}
		
		@Override
		protected void onPostExecute(final HttpResult result)
		{
			GameActivity.getInstance().runOnUiThread
			(
			 new Runnable()
			 {
				public void run()
				{
					Log.d("onPostExecute", result.getValue());
					Log.d("onPostExecute", ""+listener);
//					if (result.getStatusCode() != -1) {
//						listener.callD1(HttpLoader.CALLBACK_ID_HTTP_STATUS, result.getStatusCode());
//					}
					
					if (result.isSuccessful()) {
						listener.call1(HttpLoader.CALLBACK_ID_HTTP_DATA, result.getValue());
					}
					else {
						listener.call1(HttpLoader.CALLBACK_ID_HTTP_ERROR, result.getValue());
					}
				}
			}
			);
		}
	}
	
	private class HttpResult
	{
		private boolean isSuccessful;
		private String value;
		private int statusCode;
		
		public HttpResult(boolean isSuccessful, String value, int statusCode)
		{

			Log.d("HttpResult", isSuccessful+" "+value+" "+statusCode);
			this.isSuccessful = isSuccessful;
			this.value = value;
			this.statusCode = statusCode;
		}
		
		public boolean isSuccessful()
		{
			return isSuccessful;
		}
		
		public String getValue()
		{
			return value;
		}
		
		public int getStatusCode()
		{
			return statusCode;
		}
	}
	
	private enum HttpMethod
	{
		GET,
		POST
	}
}
