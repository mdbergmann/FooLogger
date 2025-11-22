//
// ObjCLoggerSwift.h
// ObjCLogger
//
// Central import header for the logger framework
// Import this file to use the logger API
//

#ifndef ObjCLogger_h
#define ObjCLogger_h

// Core logging framework
#import <ObjFW/ObjFW.h>

#import "LogLevel.h"

// Appenders
#import "Appender.h"
#import "FileAppender.h"

// Main logger
#import "Logger.h"

// Convenience: For quick setup
static inline Logger* CreateBasicLogger(OFString *name, LoggingLevel level, BOOL useConsole, OFString *filePath) {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:name];
    [logger setLogLevel:level];
    
    if (useConsole) {
        ConsoleAppender *console = [[ConsoleAppender alloc] init];
        [logger addAppender:console];
        [console release];
    }
    
    if (filePath != nil) {
        FileAppender *file = [[FileAppender alloc] initWithPath:filePath append:YES];
        [logger addAppender:file];
        [file release];
    }
    
    return logger;
}

// Convenience: Setup default logging for entire application
static inline void SetupDefaultLogging(LoggingLevel level, BOOL useConsole, OFString *filePath) {
    LoggerManager *manager = [LoggerManager sharedManager];
    [manager setDefaultLogLevel:level];
    
    if (useConsole) {
        ConsoleAppender *console = [[ConsoleAppender alloc] init];
        [manager addAppenderToAll:console];
        [console release];
    }
    
    if (filePath != nil) {
        FileAppender *file = [[FileAppender alloc] initWithPath:filePath append:YES];
        [manager addAppenderToAll:file];
        [file release];
    }
}

// Convenience macros for logging
#define LogCritical(logger, ...) [logger critical:[OFString stringWithFormat:__VA_ARGS__] function:[OFString stringWithUTF8String:__PRETTY_FUNCTION__]]
#define LogError(logger, ...) [logger error:[OFString stringWithFormat:__VA_ARGS__] function:[OFString stringWithUTF8String:__PRETTY_FUNCTION__]]
#define LogWarn(logger, ...) [logger warn:[OFString stringWithFormat:__VA_ARGS__] function:[OFString stringWithUTF8String:__PRETTY_FUNCTION__]]
#define LogInfo(logger, ...) [logger info:[OFString stringWithFormat:__VA_ARGS__] function:[OFString stringWithUTF8String:__PRETTY_FUNCTION__]]
#define LogDebug(logger, ...) [logger debug:[OFString stringWithFormat:__VA_ARGS__] function:[OFString stringWithUTF8String:__PRETTY_FUNCTION__]]


#endif /* ObjCLogger_h */
