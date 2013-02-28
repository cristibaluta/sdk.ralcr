
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.View;
import android.view.KeyEvent;
import android.view.ViewGroup.MarginLayoutParams;
import android.content.Context;
import android.widget.RelativeLayout;
import org.haxe.nme.GameActivity;


class NMEWebView extends WebView {
	
	static View view = null;
	
	private class NMEWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.e("NMEWebView","shouldOverrideUrlLoading " + url);
			view.loadUrl ( url );
			return true;
		}
	}

	public NMEWebView (Context inContext,String inURL) {
		
		super(inContext);
	   
		WebSettings webSettings = getSettings();
		webSettings.setSavePassword(false);
		webSettings.setSaveFormData(false);
		webSettings.setJavaScriptEnabled(true);
		webSettings.setSupportZoom(false);

		setWebViewClient ( new NMEWebViewClient());

		loadUrl(inURL);
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
		
		view = new NMEWebView(GameActivity.getContext(), url);
		
		MarginLayoutParams marginsParams = new MarginLayoutParams (w, h);
		marginsParams.setMargins (x, y, 0, 0);
		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(marginsParams);
		view.setLayoutParams ( lp );
		
		GameActivity.addChild ( view );
		
		return view;
	}
	public static void ralcr_destroy_web_view () {
		Log.e("nmewebview", "ralcr_destroy_web_view");
		GameActivity.removeChild ( view );
		view = null;
		Log.e("nmewebview", "ralcr_destroy_web_view fin");
	}
}

