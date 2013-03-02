
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.View;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.ViewGroup.MarginLayoutParams;
import android.content.Context;
import android.widget.RelativeLayout;
import org.haxe.nme.GameActivity;
import org.haxe.nme.HaxeObject;


class NMEWebView extends WebView {
	
	static View view = null;
	public String url = null;
	
	private class NMEWebViewClient extends WebViewClient {
		
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.e("NMEWebView","shouldOverrideUrlLoading " + url);
			view.loadUrl ( url );
			return true;
		}
		@Override
		public void onPageFinished (WebView view, String url) {
			Log.e("NMEWebView","onPageFinished " + url);
			((NMEWebView)view).setUrl ( url );
		}
	}

	public NMEWebView (Context inContext, final String url) {
		
		super ( inContext );
		
		WebSettings webSettings = getSettings();
		webSettings.setSavePassword(false);
		webSettings.setSaveFormData(true);
		webSettings.setJavaScriptEnabled(true);
		webSettings.setSupportZoom(false);
		
		setWebViewClient ( new NMEWebViewClient());
		
		// Android Bug? It is required in order to show the keyboard when you touch an input field
		requestFocus ( View.FOCUS_DOWN );
		setOnTouchListener ( new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				switch (event.getAction()) {
					case MotionEvent.ACTION_DOWN:
					case MotionEvent.ACTION_UP:
						if (!v.hasFocus()) {
							v.requestFocus();
						}
						break;
				}
				return false;
			}
		});
		
		loadUrl ( url );
	}
	public String getUrl () {
		if (url == null) return null;
		String r_url = url;// After you get the url set it back to null because we want to listen for the next url
		url = null;
		return r_url;
	}
	public void setUrl (String url) {
		this.url = url;
	}
	
	
	public static View ralcr_new_web_view (int x, int y, int w, int h, String url) {
		
		view = new NMEWebView (GameActivity.getContext(), url);
		
		MarginLayoutParams marginsParams = new MarginLayoutParams (w, h);
		marginsParams.setMargins (x, y, 0, 0);
		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(marginsParams);
		view.setLayoutParams ( lp );
		
		GameActivity.addChild ( view );
		
		return view;
	}
	public static String ralcr_did_finish_load_with_url () {
		if (view == null) return null;
		return ((NMEWebView)view).getUrl();
	}
	public static void ralcr_destroy_web_view () {
		GameActivity.removeChild ( view );
		view = null;
	}
}

