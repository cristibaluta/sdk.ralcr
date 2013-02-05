#import <UIKit/UIKit.h>
#include <ActivityIndicator.h>

namespace ralcr {

    UIActivityIndicatorView *activityIndicator;
    
    void new_activity_indicator (int x, int y, bool white, bool large) {	

		UIActivityIndicatorViewStyle style;
		if (white && large) {
			style = UIActivityIndicatorViewStyleWhiteLarge;
		}
		else if (white && !large) {
			style = UIActivityIndicatorViewStyleWhite;
		}
		else {
			style = UIActivityIndicatorViewStyleGray;
		}
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
		CGRect rect = activityIndicator.frame;
		rect.origin.x = x - rect.size.width/2;
		rect.origin.y = y - rect.size.height/2;
		activityIndicator.frame = rect;
		[activityIndicator startAnimating];
	
		[[[UIApplication sharedApplication] keyWindow] addSubview:activityIndicator];
    }
	
	void destroy_activity_indicator(){
	
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = nil;
	}
}


