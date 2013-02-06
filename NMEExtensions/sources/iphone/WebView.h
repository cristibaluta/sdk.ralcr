#ifndef WebView
#define WebView

namespace ralcr {

	void new_web_view (int x, int y, int w, int h, const char *url);
	void destroy_web_view();
	//void ralcr_set_did_finish_load_handle (value handler);// Will return back the url
}

#endif
