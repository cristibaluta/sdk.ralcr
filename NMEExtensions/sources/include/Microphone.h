//
//  Created by Cristi Baluta on 6/29/11.
//  Copyright 2011 ralcr. All rights reserved.
//

#ifndef MICROPHONE
#define MICROPHONE

namespace ralcr {
	#ifdef IPHONE
	void startRecordingAtPath (const char *path);
	void stopRecording();
	#endif
}

#endif
