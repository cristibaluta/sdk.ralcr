//  InAppPurchase.m
//
//  Created by Yann on 11-2-23.
//  Copyright 2011 mybogame. All rights reserved.
 
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h> 
#include "InAppPurchase.h"
#include "Events.h"

extern "C" void nme_extensions_send_event(Event &inEvent);

@interface InAppPurchase: NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProduct *myProduct;
    SKProductsRequest *productsRequest;
	NSString *productID;
}

- (void)initInAppPurchase;
- (BOOL)canMakePurchases;
- (void)purchaseProduct:(NSString *) ProductIdentifiers;

@end

@implementation InAppPurchase

#pragma Public methods 

- (void)initInAppPurchase {
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (BOOL)canMakePurchases{
    return [SKPaymentQueue canMakePayments];
} 

- (void)purchaseProduct:(NSString *) ProductIdentifiers{
	productID = ProductIdentifiers;
	productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productID]];
	productsRequest.delegate = self;
	[productsRequest start];
} 

#pragma mark -
#pragma mark SKProductsRequestDelegate methods 

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
   	
	int count = [response.products count];
    
	NSLog(@"the count is %i",count);

	if (count > 0) {
		myProduct = [response.products objectAtIndex:0];
		//buy it
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	} else {
		Event evt(etIN_APP_PURCHASE_FAIL);
		evt.data = "IN_APP_PURCHASE_FAIL!";
		nme_extensions_send_event(evt);
	}
    
    [productsRequest release];
}
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    if (wasSuccessful){
		
		Event evt(etIN_APP_PURCHASE_SUCCESS);
		evt.data = "etIN_APP_PURCHASE_SUCCESS!";
		nme_extensions_send_event(evt);
		
        //finished the transaction
    }else{
        //failed transaction		
		Event evt(etIN_APP_PURCHASE_FAIL);
		evt.data = "IN_APP_PURCHASE_FAIL!";
		nme_extensions_send_event(evt);
    }

}
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [self finishTransaction:transaction wasSuccessful:YES];
} 
- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    [self finishTransaction:transaction wasSuccessful:YES];
} 
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self finishTransaction:transaction wasSuccessful:NO];
    }else{
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		
		Event evt(etIN_APP_PURCHASE_CANNEL);
		evt.data = "IN_APP_PURCHASE_CANNEL!";
		nme_extensions_send_event(evt);
        
    }
}

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
	for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)dealloc{
	if(myProduct) [myProduct release];
	if(productsRequest) [productsRequest release];
	if(productID) [productID release];
	[super dealloc];
}

@end

extern "C"{
	static InAppPurchase *inAppPurchase = nil;
	
	// static const char* jailbreak_apps[] = {
	// 	"/Applications/Cydia.app", 
	// 	"/Applications/limera1n.app", 
	// 	"/Applications/greenpois0n.app", 
	// 	"/Applications/blackra1n.app",
	// 	"/Applications/blacksn0w.app",
	// 	"/Applications/redsn0w.app",
	// 	NULL,
	// };

	// bool isJailBroken(){
	// 	// Now check for known jailbreak apps. If we encounter one, the device is jailbroken.
	// 	for (int i = 0; jailbreak_apps[i] != NULL; ++i){	
	// 		if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_apps[i]]]){
	// 			
	// 			Event evt(etIN_APP_PURCHASE_FAIL);
	// 			evt.data = "IN_APP_PURCHASE_FAIL!";
	// 			nme_extensions_send_event(evt);
	// 			
	// 			return YES;
	// 		}		
	// 	}
	// 	return NO;
	// }

	void initInAppPurchase(){
		inAppPurchase = [[InAppPurchase alloc] init];
		[inAppPurchase initInAppPurchase];
	}

	bool canPurchase(){
		return [inAppPurchase canMakePurchases];
	}

	void purchaseProduct(const char *inProductID){
		//if(isJailBroken())	return;
		NSString *productID = [[NSString alloc] initWithUTF8String:inProductID];
		[inAppPurchase purchaseProduct:productID];
	}

	void releaseInAppPurchase(){
		[inAppPurchase release];
	}
	

	
}



