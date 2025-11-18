//
// Created by Manfred Bergmann on 14.05.18.
//

#import <ObjFW/ObjFW.h>
#import "LogLevel.h"

@protocol Appender <OFObject>

/**
 * Append a log message
 * @param message The log message to append
 * @param level The logging level
 * @param logger The name of the logger
 * @param function The function name where the log occurred
 */
- (void)append:(OFString *)message level:(LoggingLevel)level loggerName:(OFString *)logger functionName:(OFString *)function;

/**
 * Get the date format supportted by ObjFW
 */
- (OFString *)dateFormat;

@end

/**
 * Base appender implementation providing common functionality
 */
@interface BaseAppender : OFObject <Appender> {
@protected
    OFString *_pattern;
}

/**
 * Initialize a new base appender
 */
- (instancetype)init;

/**
 * Compute the formatted log message based on the pattern
 * @param message The log message
 * @param level The logging level
 * @param logger The logger name
 * @param function The function name
 * @return The formatted log string
 */
- (OFString *)computePattern:(OFString *)message 
                       level:(LoggingLevel)level 
                  loggerName:(OFString *)logger 
                functionName:(OFString *)function;

@end

/**
 * Console appender that writes log messages to stdout/stderr
 */
@interface ConsoleAppender : BaseAppender

- (instancetype)init;

@end
