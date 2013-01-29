#include <AlertView.h>
#import <UIKit/UIKit.h>

namespace ralcr {
	
    void show_alert_view (const char *title,const char *message) {	
        
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithUTF8String:title] 
														message:[[NSString alloc] initWithUTF8String:message] 
                                                       delegate:NULL cancelButtonTitle:@"OK" 
											otherButtonTitles:NULL] ;//autorelease];
        [alert show];
        //[alert release];
    }
}
