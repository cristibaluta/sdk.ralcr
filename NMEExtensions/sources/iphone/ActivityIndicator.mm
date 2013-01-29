#include <AlertView.h>
#import <UIKit/UIKit.h>
#include <hx/CFFI.h>

namespace ralcr {

    //UIActivityIndicatorView *activityIndicator;
    //UIView *loadingView;
    
    void showAlertView(const char *title,const char *message){	
        
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithUTF8String:title] 
														message:[[NSString alloc] initWithUTF8String:message] 
                                                       delegate:NULL cancelButtonTitle:@"OK" 
											otherButtonTitles:NULL] ;//autorelease];
        [alert show];
        //[alert release];
    }
	//     void ShowSystemLoadingView(){
	// 
	// 	CGSize screen = [[UIScreen mainScreen] bounds].size;
	// 	NSString *name = [[UIDevice currentDevice] localizedModel];
	// 	
	// 	double w = screen.width;
	// 	double h = screen.height;
	// 
	//         activityIndicator= [[UIActivityIndicatorView alloc]  initWithFrame:CGRectMake(w/2-32, h/2-32, 64.0f,64.0f)];
	//         [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	// 
	// 	
	//         loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,w,h)];
	//         loadingView.backgroundColor = [UIColor blackColor];
	//         loadingView.alpha = 0.5;
	//         [loadingView addSubview:activityIndicator];
	//         [[[UIApplication sharedApplication] keyWindow] addSubview:loadingView];
	//         //[view release];
	//         //NSLog(@"ok");
	//         
	//         [activityIndicator startAnimating];
	//         //loading data
	//     }
	//     void HideSystemLoadingView(){
	//         if(activityIndicator!=NULL){
	//             [activityIndicator stopAnimating];
	//             [activityIndicator release];
	//             activityIndicator = NULL;
	//         
	//             [loadingView removeFromSuperview];
	//             [loadingView release];
	//             loadingView = NULL;
	//         }
	//     }
	// 
	// //rate
	// void rate(int appID){
	// 	[iRate sharedInstance].appStoreID = appID;
	// 	if ([[iRate sharedInstance] shouldPromptForRating]) {
	//         [[iRate sharedInstance] promptForRating];
	//     }
	// }
	
	
	// AlertView

	#ifdef IPHONE
	value show_alert_view (value title, value description){
		showAlertView (val_string(title), val_string(description));
		return alloc_null();
	}
	DEFINE_PRIM (show_alert_view, 2);
	#endif

}


