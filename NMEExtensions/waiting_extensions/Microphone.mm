//
//  Microphone
//
//  Created by Baluta Cristian on 2011-12-18.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Microphone : NSObject <AVAudioRecorderDelegate> {

	float time;
    NSTimer *levelTimer;
	NSURL *url;// url of the current file to record

    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum { ENC_AAC = 1, ENC_ALAC = 2, ENC_IMA4 = 3, ENC_ILBC = 4, ENC_ULAW = 5, ENC_PCM = 6, } encodingTypes;
}

- (void) startRecordingAtPath:(NSString*)path;
- (void) stopRecording;

@end



@implementation Microphone

- (void) startRecordingAtPath:(NSString*)path {

	int recordEncoding = [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0 ? ENC_AAC : ENC_IMA4;

    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];

    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if (recordEncoding == ENC_PCM) {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else {
        NSNumber *formatObject;

        switch (recordEncoding) {
            case (ENC_AAC):  formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC]; break;
            case (ENC_ALAC): formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless]; break;
            case (ENC_IMA4): formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4]; break;
            case (ENC_ILBC): formatObject = [NSNumber numberWithInt: kAudioFormatiLBC]; break;
            case (ENC_ULAW): formatObject = [NSNumber numberWithInt: kAudioFormatULaw]; break;
            default: formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
	// Create the url to Documents directory
    url = [[NSURL fileURLWithPath:path] retain];
    NSError *error = nil;
    
	audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
	[recordSettings release];
    
    if ([audioRecorder prepareToRecord] == YES){
		NSLog(@"Recording started");
        [audioRecorder record];
		//[audioRecorder recordForDuration:3];
		
		levelTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]
											  interval:0.03
												target:self
											  selector:@selector(levelTimerCallback:)
											  userInfo:nil
											   repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:levelTimer forMode:NSDefaultRunLoopMode];
    }
	else
	{
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
    }
}

- (void) stopRecording {
	[audioRecorder stop];
}


#pragma mark AVAudioRecording delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	NSLog(@"didFinishRecording");
}


- (void)levelTimerCallback:(NSTimer *)timer {
    //[audioRecorder updateMeters];
    //double avgPowerForChannel = pow(10, (0.05 * [audioRecorder averagePowerForChannel:0]));
    //[audioRecorder receiveInput:avgPowerForChannel];
    //NSLog(@"Avg. Power: %f", [audioRecorder averagePowerForChannel:0]);
}

- (void)dealloc {
    [audioRecorder release];
	[levelTimer release];
    [super dealloc];
}


@end
