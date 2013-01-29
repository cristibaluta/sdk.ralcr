/**
 * Copyright (c) 2011 Milkman Games, LLC <http://www.milkmangames.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <GameKit/GameKit.h>
#include <ctype.h>
#include "Events.h"

/** ViewDelegate Objective-C Wrappers
 *
 * As far as I can tell it is not possible to let a vanilla c function
 * take a delegate callback, so we need to create these obj-c objects
 * to wrap the callbacks in.
 *
 */
typedef void (*FunctionType)();

@interface GKViewDelegate : NSObject <GKAchievementViewControllerDelegate,GKLeaderboardViewControllerDelegate>{
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@property (nonatomic) FunctionType onAchievementFinished;
@property (nonatomic) FunctionType onLeaderboardFinished;

@end
	
@implementation GKViewDelegate

@synthesize onAchievementFinished;
@synthesize onLeaderboardFinished;

- (id)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
    [viewController dismissModalViewControllerAnimated:YES];
	[viewController.view.superview removeFromSuperview];
	[viewController release];
	onAchievementFinished();
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [viewController dismissModalViewControllerAnimated:YES];
	[viewController.view.superview removeFromSuperview];
	[viewController release];
	onLeaderboardFinished();
}

@end

namespace ralcr{
	
	bool hxInitGameKit();
	bool hxIsGameCenterAvailable();
	bool hxIsUserAuthenticated();
	void hxAuthenticateLocalUser();
	void registerForAuthenticationNotification();
	void hxShowAchievements();
	void hxResetAchievements();
	void hxReportScoreForCategory(int score, const char *category);
	void hxReportAchievement(const char *achievementId, float percent);
	void hxShowLeaderBoardForCategory(const char *category);
	static void authenticationChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
	void achievementViewDismissed();
	void leaderboardViewDismissed();
	void dispatchHaxeEvent(EventType eventId);
	extern "C" void nme_extensions_send_event(Event &inEvent);
	
	//
	// Variables
	//
	
	/** Initialization State */
	static int isInitialized=0;
	
	/** View Delegate */
	GKViewDelegate *ViewDelegate;
	
	//
	// Public Methods
	//
	
	/** Initialize Haxe GK.  Return true if success, false otherwise. */
	bool hxInitGameKit(){
		// don't create twice.
		if(isInitialized==1){
			return false;
		}
		
		if (hxIsGameCenterAvailable()){
			// create the GameCenter object, and get user.
			ViewDelegate=[[GKViewDelegate alloc] init];
			ViewDelegate.onAchievementFinished=&achievementViewDismissed;
			ViewDelegate.onLeaderboardFinished=&leaderboardViewDismissed;
			isInitialized=1;
			return true;
		}
		
		return false;
	}
	
	/** Check if Game Center is available on this device. */
	bool hxIsGameCenterAvailable(){
		// Check for presence of GKLocalPlayer API.   
		Class gcClass = (NSClassFromString(@"GKLocalPlayer"));   
		
		// The device must be running running iOS 4.1 or later.   
		NSString *reqSysVer = @"4.1";   
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];   
		BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);   
		
		return (gcClass && osVersionSupported);
	}

	/** Attempt Authentication of the Player */
	void hxAuthenticateLocalUser() {
		printf("CPP HxgK: Auth user\n");
		if(!hxIsGameCenterAvailable()){
			return;
		}
		
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {      
			if (error == nil){
				registerForAuthenticationNotification();
				dispatchHaxeEvent(AUTH_SUCCEEDED);
			}else{
				NSLog(@"  %@", [error userInfo]);
				dispatchHaxeEvent(AUTH_FAILED);
			}
		}];
	}
	
	/** Return true if the local player is logged in */
	bool hxIsUserAuthenticated(){
		if ([GKLocalPlayer localPlayer].isAuthenticated){      
			return true;
		}
		return false;
	}
	
	/** Report a score to the server for a given category. */
	void hxReportScoreForCategory(int score, const char *category){
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSString *strCategory = [[NSString alloc] initWithUTF8String:category];
		
		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:strCategory] autorelease];
		if(scoreReporter){
			scoreReporter.value = score;
			
			[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {   
				if (error != nil){
					printf("CPP Hxgk: Error occurred reporting score-\n");
					NSLog(@"  %@", [error userInfo]);
					dispatchHaxeEvent(SCORE_REPORT_FAILED);
				}else{
					printf("CPP Hxgk: Score was successfully sent\n");
					dispatchHaxeEvent(SCORE_REPORT_SUCCEEDED);
				}
			}];   
		}
		[strCategory release];
		[pool drain];
	}
	
	/** Show the Default iOS UI Leaderboard for a given category. */
	void hxShowLeaderBoardForCategory(const char *category){
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSString *strCategory = [[NSString alloc] initWithUTF8String:category];
		
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];  
		if (leaderboardController != nil) {
			leaderboardController.category=strCategory;
			leaderboardController.leaderboardDelegate = ViewDelegate;
			
			UIViewController *glView2;
			if([[[UIDevice currentDevice] localizedModel] isEqualToString:@"iPad"]){
				glView2 = [[[UIApplication sharedApplication] keyWindow] rootViewController];
			}else{
				glView2 = [[UIViewController alloc] init];
				[window addSubview: glView2.view];
			}
			
			[glView2 presentModalViewController: leaderboardController animated: YES];
		}
		
		[strCategory release];
		[pool drain];
	}
	
	/** Report achievement progress to the server */
	void hxReportAchievement(const char *achievementId, float percent){
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSString *strAchievement = [[NSString alloc] initWithUTF8String:achievementId];
		
		GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: strAchievement] autorelease];   
		if (achievement){      
			achievement.percentComplete = percent;    
			[achievement reportAchievementWithCompletionHandler:^(NSError *error){
				if (error != nil){
					printf("CPP Hxgk: Error occurred reporting achievement-\n");
					NSLog(@"  %@", [error userInfo]);
					dispatchHaxeEvent(ACHIEVEMENT_REPORT_FAILED);
				}else{
					printf("CPP Hxgk: Achievement report successfully sent\n");
					dispatchHaxeEvent(ACHIEVEMENT_REPORT_SUCCEEDED);
				}

			}];
		}else {
			//TODO: making this callback before function end means it is possible to get in a bad state if you're doing nested calls
			dispatchHaxeEvent(ACHIEVEMENT_REPORT_FAILED);
		}

		
		[strAchievement release];
		[pool drain];
	}
	
	/** Get the available achievements */
	void hxGetAchievements(){
		// TODO: will need to alloc and populate a list in a haxe format and return via another callback
	}
	
	/** Show Achievements with Default UI */
	void hxShowAchievements(){
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];   
		if (achievements != nil){
			achievements.achievementDelegate = ViewDelegate;
			//UIViewController *glView2 = [[UIViewController alloc] init];
			//[window addSubview: glView2.view];
			UIViewController *glView2 = [[[UIApplication sharedApplication] keyWindow] rootViewController];
			[glView2 presentModalViewController: achievements animated: YES];
			// TODO: can we get the delegate to invoke a method properly timed for this event?
			dispatchHaxeEvent(ACHIEVEMENTS_VIEW_OPENED);
		}
	}
	
	/** Reset achievements */
	void hxResetAchievements(){
		[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error){
			 if (error != nil){
				 NSLog(@"  %@", [error userInfo]);
				 dispatchHaxeEvent(ACHIEVEMENT_RESET_FAILED);
			 }else{
				 dispatchHaxeEvent(ACHIEVEMENT_RESET_SUCCEEDED);
			 }
			 
		 }];
	}
	
	
	//
	// Implementation
	//
	
	/** Listen for Authentication Callback */
	void registerForAuthenticationNotification(){
		// TODO: need to REMOVE OBSERVER on dispose
		CFNotificationCenterAddObserver
		(
			CFNotificationCenterGetLocalCenter(),
			NULL,
			&authenticationChanged,
			(CFStringRef)GKPlayerAuthenticationDidChangeNotificationName,
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		 );
	}
	
	/** Notify haXe of an Event */
	void dispatchHaxeEvent(EventType eventId){
		Event evt(eventId);
		nme_extensions_send_event(evt);
	}
	
	//
	// Callbacks
	//
	
	/** Callback When Achievement View is Closed */
	void achievementViewDismissed(){
		dispatchHaxeEvent(ACHIEVEMENTS_VIEW_CLOSED);
	}
	
	/** Callback When Leaderboard View is Closed */
	void leaderboardViewDismissed(){
		dispatchHaxeEvent(LEADERBOARD_VIEW_CLOSED);
	}
	
	/** Callback When Authentication Status Has Changed */
	void authenticationChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
		if(!hxIsGameCenterAvailable()){
			return;
		}
		
		if ([GKLocalPlayer localPlayer].isAuthenticated){      
			printf("CPP Hxgk: You are logged in to game center:onAuthChanged \n");
		}else{
			printf("CPP Hxgk: You are NOT logged in to game center!:onAuthChanged \n");
		}
	}
	
}


