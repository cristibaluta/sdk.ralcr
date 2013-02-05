#include <Device.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <netinet/in.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SCNetworkReachability.h>

namespace ralcr {
	
	bool retina = false;
	bool retinaInit = false;
    
	const char *uniqueId(){
		NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
		return  [uid UTF8String];
	}
	
	const char *os(){
		return  [[[UIDevice currentDevice] systemName] UTF8String];
	}

	const char *vervion(){
		return  [[[UIDevice currentDevice] systemVersion] UTF8String];
	}

	const char *deviceName(){
		return  [[[UIDevice currentDevice] localizedModel] UTF8String];
	}

	const char *model(){
		return  [[[UIDevice currentDevice] model] UTF8String];
	}
	
	bool isRetina(){
		if(!retinaInit){
			
			CGSize iphoneRetina = CGSizeMake(640, 960);
			CGSize ipadRetina = CGSizeMake(2048, 1536);
			CGSize screen = [[UIScreen mainScreen] currentMode].size;
						
			if([UIScreen instancesRespondToSelector:@selector(currentMode)]){
				if(CGSizeEqualToSize(screen,ipadRetina) || CGSizeEqualToSize(screen,iphoneRetina)){
					retina = true;
				}
			}
			//retina = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
			retinaInit = true;
		}
		return retina;
	}
	
    bool networkAvailable(){
	
        // Create zero addy
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        // Recover reachability flags
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
        SCNetworkReachabilityFlags flags;
        
        BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
        CFRelease(defaultRouteReachability);
        
        if (!didRetrieveFlags){
            NSLog(@"Error. Could not recover network reachability flags");
            return false;
        }
        
        BOOL isReachable = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        return (isReachable && !needsConnection) ? true : false;
    }	

	void Vibrate(float milliseconds){
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
	
	const char *getDocPath(){
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectory = [paths objectAtIndex:0];

		const char * docPath = [[documentsDirectory stringByAppendingFormat:@"/"] UTF8String];

		return docPath;

	}
	
	const char *getRecPath(){
		return [[[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/"] UTF8String];
	}

}


