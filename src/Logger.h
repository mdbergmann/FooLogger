//
//  ObjCLogger.h
//  ObjCLogger
//
//  Created by Manfred Bergmann on 02.06.05.
//  Copyright 2005 mabe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// define for logging
#define ObjCLog(LEVEL,...) [ObjCLogger log:[NSString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__]] level:LEVEL]

@interface ObjCLogger : NSObject {
}

// init or close the logger
+ (int)initLogger:(NSString *)logPath
		logPrefix:(NSString *)aPrefix
   logFilterLevel:(int)aLevel
	 appendToFile:(BOOL)fileAppend
	 logToConsole:(BOOL)consoleLogging;

+ (int)closeLogger;

// set or get the logfilter level
+ (void)setLogFilterLevel:(int)aLevel;
+ (int)logFilterLevel;

// set or get logPrefix
+ (void)setLogPrefix:(NSString *)aPrefix;
+ (NSString *)logPrefix;

// make logoutput
+ (int)log:(NSString *)message level:(int)aLevel;

@end
