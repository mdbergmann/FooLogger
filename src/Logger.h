//
//  ObjCLogger.h
//  ObjCLogger
//
//  Created by Manfred Bergmann on 02.06.05.
//  Copyright 2005 mabe. All rights reserved.
//

#import <ObjFW/ObjFW.h>

// define for logging
#define ObjCLog(LEVEL,...) [ObjCLogger log:[OFString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__, [OFString stringWithFormat:__VA_ARGS__]] level:LEVEL]

@interface ObjCLogger : OFObject {
}

// init or close the logger
+ (int)initLogger:(OFString *)logPath
		logPrefix:(OFString *)aPrefix
   logFilterLevel:(int)aLevel
	 appendToFile:(BOOL)fileAppend
	 logToConsole:(BOOL)consoleLogging;

+ (int)closeLogger;

// set or get the logfilter level
+ (void)setLogFilterLevel:(int)aLevel;
+ (int)logFilterLevel;

// set or get logPrefix
+ (void)setLogPrefix:(OFString *)aPrefix;
+ (OFString *)logPrefix;

// make logoutput
+ (int)log:(OFString *)message level:(int)aLevel;

@end
