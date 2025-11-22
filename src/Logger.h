//
// Logger.h
// ObjCLogger
//
// Logger implementation with appender support
//

#import <ObjFW/ObjFW.h>
#import "LogLevel.h"
#import "Appender.h"

/**
 * Logger class with support for multiple appenders
 */
@interface Logger : OFObject {
@private
    OFString *_name;
    LoggingLevel _logLevel;
    OFMutableArray *_appenders;
}

/**
 * Initialize a new logger with the given name
 * @param name The logger name (typically the class or module name)
 */
- (instancetype)initWithName:(OFString *)name;

/**
 * Get the logger name
 */
- (OFString *)name;

/**
 * Set the log filter level
 * @param level The minimum level to log
 */
- (void)setLogLevel:(LoggingLevel)level;

/**
 * Get the current log filter level
 */
- (LoggingLevel)logLevel;

/**
 * Add an appender to this logger
 * @param appender The appender to add
 */
- (void)addAppender:(id<Appender>)appender;

/**
 * Remove an appender from this logger
 * @param appender The appender to remove
 */
- (void)removeAppender:(id<Appender>)appender;

/**
 * Remove all appenders
 */
- (void)removeAllAppenders;

/**
 * Get all appenders
 */
- (OFArray *)appenders;

/**
 * Log a message at the specified level
 * @param message The message to log
 * @param level The logging level
 * @param function The function name (use __PRETTY_FUNCTION__)
 */
- (void)log:(OFString *)message level:(LoggingLevel)level function:(OFString *)function;

// Convenience methods for different log levels

- (void)critical:(OFString *)message function:(OFString *)function;
- (void)error:(OFString *)message function:(OFString *)function;
- (void)warn:(OFString *)message function:(OFString *)function;
- (void)info:(OFString *)message function:(OFString *)function;
- (void)debug:(OFString *)message function:(OFString *)function;

@end

/**
 * Logger manager for getting and configuring loggers
 */
@interface LoggerManager : OFObject

/**
 * Get the shared logger manager instance
 */
+ (instancetype)sharedManager;

/**
 * Get a logger for the given name, creating it if necessary
 * @param name The logger name
 */
- (Logger *)loggerForName:(OFString *)name;

/**
 * Get a logger for the given class, creating it if necessary
 * @param cls The class
 */
- (Logger *)loggerForClass:(Class)cls;

/**
 * Set the default log level for all new loggers
 * @param level The default log level
 */
- (void)setDefaultLogLevel:(LoggingLevel)level;

/**
 * Get the default log level
 */
- (LoggingLevel)defaultLogLevel;

/**
 * Add an appender to all existing loggers
 * @param appender The appender to add
 */
- (void)addAppenderToAll:(id<Appender>)appender;

/**
 * Remove an appender from all loggers
 * @param appender The appender to remove
 */
- (void)removeAppenderFromAll:(id<Appender>)appender;

@end
