
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
	static HaxeObject delegate;
	
	private class NMEWebViewClient extends WebViewClient {
		private HaxeObject delegate;
		public NMEWebViewClient (final HaxeObject listener) {
			super();
			delegate = listener;
		}
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.e("NMEWebView","shouldOverrideUrlLoading " + url);
			view.loadUrl ( url );
			return true;
		}
		@Override
		public void onPageFinished (WebView view, String url) {
			Log.e("NMEWebView","onPageFinished " + url);
			delegate.call1 ("didFinishLoadHandler", url);
			Log.e("NMEWebView","delegate.call1 ok. " + delegate);
		}
	}

	public NMEWebView (Context inContext, final String url, final HaxeObject listener) {
		
		super ( inContext );
		
		WebSettings webSettings = getSettings();
		webSettings.setSavePassword(false);
		webSettings.setSaveFormData(false);
		webSettings.setJavaScriptEnabled(true);
		webSettings.setSupportZoom(false);
		
		setWebViewClient ( new NMEWebViewClient ( listener));
		
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

   // @Override
   // public boolean onKeyDown(final int keyCode, KeyEvent event) {
   //  Log.e("NMEWebView","onKeyDown " + keyCode);
   //  if ((keyCode == KeyEvent.KEYCODE_BACK) && !canGoBack()) {
   //      GameActivity.popView();
   //  }
   //  return super.onKeyDown(keyCode, event);
   // }
	
	public static View ralcr_new_web_view (int x, int y, int w, int h, String url) {
		
		view = new NMEWebView (GameActivity.getContext(), url, delegate);
		
		MarginLayoutParams marginsParams = new MarginLayoutParams (w, h);
		marginsParams.setMargins (x, y, 0, 0);
		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(marginsParams);
		view.setLayoutParams ( lp );
		
		GameActivity.addChild ( view );
		
		return view;
	}
	public static void ralcr_set_did_finish_load_handle (final HaxeObject listener) {
		delegate = listener;
	}
	public static void ralcr_destroy_web_view () {
		GameActivity.removeChild ( view );
		view = null;
	}
}

