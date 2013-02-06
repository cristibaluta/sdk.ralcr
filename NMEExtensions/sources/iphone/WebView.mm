#import <UIKit/UIKit.h>
#include <WebView.h>
#include <hx/CFFI.h>

typedef void (*FunctionType)();


@interface WebViewDelegate : NSObject <UIWebViewDelegate>
@property (nonatomic) FunctionType loadFinished;
@end
@implementation WebViewDelegate
@synthesize loadFinished;
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	loadFinished();
}
@end


namespace ralcr {
	
	UIWebView *webView;
	WebViewDelegate *webViewDelegate;
	AutoGCRoot *eventHandle = 0;
	void loadFinishedHandler();
	
	//extern "C" void nme_extensions_send_event(Event &inEvent);
	
	void new_web_view (int x, int y, int w, int h, const char *url) {
		
		webViewDelegate = [[WebViewDelegate alloc] init];
		webViewDelegate.loadFinished = &loadFinishedHandler;
		
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, w, h)];
		webView.delegate = webViewDelegate;
		NSURL *_url = [[NSURL alloc] initWithString: [[NSString alloc] initWithUTF8String:url]];
		NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
		[webView loadRequest:req];
		
		[[[UIApplication sharedApplication] keyWindow] addSubview:webView];
		
		//nme_app_set_active(FALSE);
	}
	void destroy_web_view () {
		[webView stopLoading];
		[webView removeFromSuperview];
		[webView release];
		webView = nil;
		[webViewDelegate release];
		webViewDelegate = nil;
		
		// http://www.nme.io/community/forums/bugs/ios-extensions-touch-release-issue/
		//call nme_app_set_active(TRUE);
		//[[UIApplication sharedApplication].delegate performSelectorOnMainThread:@selector(mainLoop) withObject:nil waitUntilDone:NO];
	}
	
	/** Notify Haxe of an Event */
	void loadFinishedHandler () {
		//NSLog(@"loadFinishedHandler %@", webView.request.URL.absoluteString);
		val_call1 (eventHandle->get(), alloc_string([webView.request.URL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding]));
	}
	
	void ralcr_set_did_finish_load_handle (value handler) {
		eventHandle = new AutoGCRoot(handler);
	}
	DEFINE_PRIM(ralcr_set_did_finish_load_handle, 1);
}
