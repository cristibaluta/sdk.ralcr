#import <UIKit/UIKit.h>
#include <AlertView.h>
#include <hx/CFFI.h>

namespace ralcr {
	
    void show_alert_view (const char *title, const char *message) {	
        
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithUTF8String:title] 
														message:[[NSString alloc] initWithUTF8String:message] 
                                                       delegate:NULL cancelButtonTitle:@"OK" 
											otherButtonTitles:NULL];
        [alert show];
        [alert release];
    }
	
	// void ralcr_show_alert_view (value title, value description){
	// 	show_alert_view (val_string(title), val_string(description));
	// }
	// DEFINE_PRIM (ralcr_show_alert_view, 2);
}
