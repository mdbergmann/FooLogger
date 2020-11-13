//
//  CocoLogger.m
//  CocoLogger
//
//  Created by Manfred Bergmann on 02.06.05.
//  Copyright 2005 mabe. All rights reserved.
//

#import "Logger.h"
#import "CoreLogger.h"

@implementation CocoLogger

/**
 \brief initialize the logger
 
 @param[in] logPath specify the path to where the outputgoes
 @param[in] aPrefix specify a log prefix e.g. the AppName
 @param[in] aLevel specify the log filter level to which the logger should be set to, can be changed with setLogFilterLevel:
 @param[in] fileAppend each time create a new file? YES or NO
 @param[in] consoleLogging specify if additionally the logging should go to the console
*/
+ (int)initLogger:(NSString *)logPath 
		logPrefix:(NSString *)aPrefix 
   logFilterLevel:(int)aLevel
	 appendToFile:(BOOL)fileAppend
	 logToConsole:(BOOL)consoleLogging {
	return initLogger([logPath UTF8String], [aPrefix UTF8String], aLevel, (char)fileAppend, (char)consoleLogging);
}

+ (int)closeLogger {
	return closeLogger();
}

/**
 \brief Set the logging filter level 
 @param aLevel
*/
+ (void)setLogFilterLevel:(int)aLevel {
	setLogFilterLevel(aLevel);
}

/**
\brief Get the current log filter level
 */
+ (int)logFilterLevel {
	return getLogFilterLevel();
}

/**
\brief Set the log prefix
 
 @param aPrefix
 */
+ (void)setLogPrefix:(NSString *)aPrefix {
	setLogPrefix([aPrefix UTF8String]);
}

/**
\brief Get the log prefix
 */
+ (NSString *)logPrefix {
	return [NSString stringWithUTF8String:getLogPrefix()];
}

/**
\brief Log a message to file and/or console
 
 @param message the logging message
 @param aLevel the level of this message
 @returns error status code != 0
 */
+ (int)log:(NSString *)message level:(int)aLevel {
	return corelog([message UTF8String], aLevel);
}

@end
