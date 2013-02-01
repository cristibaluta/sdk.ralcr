#import <CFNetwork/CFNetwork.h>
#import <Foundation/Foundation.h>
#include <Https.h>
#include <hx/CFFI.h>

typedef void (*FunctionType)();


@interface HttpsRequest : NSObject {
	NSString *url;
	NSURLConnection *connection;
	NSMutableData *receivedData;
}
@property (nonatomic) FunctionType httpsLoadFinished;
@property (nonatomic) FunctionType httpsLoadError;
@property (nonatomic, readonly) NSString *result;
- (id)initWithURL:(NSString*)url;
- (void)get:(NSString*)variables;
- (void)post:(NSString*)variables;
- (void)download:(NSURLRequest *)request;
- (void)cancel;
@end

@implementation HttpsRequest
@synthesize httpsLoadFinished;
@synthesize httpsLoadError;
@synthesize result;

- (id) initWithURL:(NSString*)u {
	self = [super init];
	if (self) {
		url = u;
	}
	return self;
}

// Variables are a string of this form: var1=val1&var2=val2&
- (void) get:(NSString*)variables {
	NSString *geturl = [NSString stringWithFormat:@"%@%@?", url, variables];
	NSURLRequest *request = [[NSURLRequest alloc]
							 initWithURL: [NSURL URLWithString:geturl]
							 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
							 timeoutInterval: 10];
    [self download:request];
}

// Variables are a string of this form: var1=val1&var2=val2&
- (void) post:(NSString*)postStr {
	// POST variables are formated correctly from NMEHttps
	
    NSData *postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
	
	[self download:request];
}

- (void)download:(NSURLRequest *)request {
	NSLog(@"Https startDownload");
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSAssert (connection != nil, @"Failure to create URL connection.");
}

- (void)cancel {
	[connection cancel];
	[connection release];
	connection = nil;
	[receivedData release];
	receivedData = nil;
}



#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Https didReceiveResponse");
	receivedData = [[NSMutableData data] retain];
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    NSLog(@"Https didReceiveData");
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    
    result = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
	[receivedData release];
	receivedData = nil;
	NSLog(@"Https connectionDidFinishLoading %@", result);
	httpsLoadFinished();
}

// Forward errors
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    
	if ([error code] == kCFURLErrorNotConnectedToInternet) {
		result = @"Https connection didFail - not connected to the internet";
    }
	else {
		result = @"Https connection didFail - url not found";
    }
	NSLog(@"Https %@",result);
	httpsLoadError();
}

// Disable caching so that each time we run this app we are starting with a clean slate.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}
@end


namespace ralcr {
	
	HttpsRequest *request;
	AutoGCRoot *eventCompleteHandle = 0;
	AutoGCRoot *eventErrorHandle = 0;
	void httpsLoadFinishedHandler();
	void httpsLoadFinishedWithErrorsHandler();
	
	void https_get (const char *url, const char *variables) {
		
		request = [[HttpsRequest alloc] initWithURL:[[NSString alloc] initWithUTF8String:url]];
		request.httpsLoadFinished = &httpsLoadFinishedHandler;
		request.httpsLoadError = &httpsLoadFinishedWithErrorsHandler;
		[request get: [NSString stringWithUTF8String:variables]];
	}
	void https_post (const char *url, const char *variables) {
		
		request = [[HttpsRequest alloc] initWithURL:[[NSString alloc] initWithUTF8String:url]];
		request.httpsLoadFinished = &httpsLoadFinishedHandler;
		request.httpsLoadError = &httpsLoadFinishedWithErrorsHandler;
		[request post: [NSString stringWithUTF8String:variables]];
	}
	void https_cancel () {
		[request cancel];
		[request release];
		request = nil;
	}
	
	/** Notify Haxe of an Event */
	void httpsLoadFinishedHandler () {
		NSLog(@"loadFinishedHandler %@", request.result);
		val_call1 (eventCompleteHandle->get(), alloc_string([request.result cStringUsingEncoding:NSUTF8StringEncoding]));
	}
	void httpsLoadFinishedWithErrorsHandler () {
		NSLog(@"loadFinishedWithErrorsHandler %@", request.result);
		val_call1 (eventErrorHandle->get(), alloc_string([request.result cStringUsingEncoding:NSUTF8StringEncoding]));
	}
	
	
	void ralcr_https_set_did_finish_load_handle (value handler) {
		eventCompleteHandle = new AutoGCRoot(handler);
	}
	DEFINE_PRIM(ralcr_https_set_did_finish_load_handle, 1);
	void ralcr_https_set_did_finish_with_error_handle (value handler) {
		eventErrorHandle = new AutoGCRoot(handler);
	}
	DEFINE_PRIM(ralcr_https_set_did_finish_with_error_handle, 1);
}
