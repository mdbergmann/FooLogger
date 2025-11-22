//
// LoggerTest.m
// ObjCLogger
//
// Test cases for Logger
//

#import "LoggerTest.h"

@implementation LoggerTest

- (void)setUp {
    // Clean up any existing test log file
    OFFileManager *fileManager = [OFFileManager defaultManager];
    @try {
        [fileManager removeItemAtPath:@"test_logger.log"];
    } @catch (id e) {
        // Ignore if file doesn't exist
    }
}

- (void)tearDown {
    // Clean up test file
    OFFileManager *fileManager = [OFFileManager defaultManager];
    @try {
        [fileManager removeItemAtPath:@"test_logger.log"];
    } @catch (id e) {
        // Ignore errors
    }
}

- (void)testBasicLogging {
    // Get a logger from the manager
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"TestLogger"];
    [logger setLogLevel:LEVEL_DEBUG];
    
    // Add a console appender
    ConsoleAppender *consoleAppender = [[ConsoleAppender alloc] init];
    [logger addAppender:consoleAppender];
    
    // Log at different levels
    LogCritical(logger, @"This is a critical message");
    LogError(logger, @"This is an error message");
    LogWarn(logger, @"This is a warning message");
    LogInfo(logger, @"This is an info message");
    LogDebug(logger, @"This is a debug message");
    
    [consoleAppender release];
}

- (void)testFileLogging {
    // Get a logger
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"FileLogger"];
    [logger setLogLevel:LEVEL_INFO];
    
    // Add a file appender
    FileAppender *fileAppender = [[FileAppender alloc] initWithPath:@"test_logger.log" 
                                                              append:NO];
    [logger addAppender:fileAppender];
    
    // Log some messages
    LogCritical(logger, @"This is a critical message");
    LogError(logger, @"This is an error message");
    LogWarn(logger, @"This is a warning message");
    LogInfo(logger, @"This is an info message");
    LogDebug(logger, @"This is a debug message");
    
    [fileAppender close];
    [fileAppender release];
    
    // Verify file exists
    OFFileManager *fileManager = [OFFileManager defaultManager];
    OFAssert([fileManager fileExistsAtPath:@"test_logger.log"]);
}

- (void)testMultipleAppenders {
    // Get a logger
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"MultiLogger"];
    [logger setLogLevel:LEVEL_DEBUG];
    
    // Add both console and file appenders
    ConsoleAppender *consoleAppender = [[ConsoleAppender alloc] init];
    FileAppender *fileAppender = [[FileAppender alloc] initWithPath:@"test_logger.log" 
                                                             append:NO];
    
    [logger addAppender:consoleAppender];
    [logger addAppender:fileAppender];
    
    // Log a message - should go to both appenders
    LogInfo(logger, @"This goes to both console and file");
    
    OFAssert([[logger appenders] count] == 2);
    
    // Remove console appender
    [logger removeAppender:consoleAppender];
    OFAssert([[logger appenders] count] == 1);
    
    [fileAppender close];
    [consoleAppender release];
    [fileAppender release];
}

- (void)testLogLevelFiltering {
    // Get a logger
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"FilterLogger"];
    [logger setLogLevel:LEVEL_WARN]; // Only WARN and above
    
    FileAppender *fileAppender = [[FileAppender alloc] initWithPath:@"test_logger.log" 
                                                             append:NO];
    [logger addAppender:fileAppender];
    
    // These should be logged
    LogCritical(logger, @"This is a critical message");
    LogError(logger, @"This is an error message");
    LogWarn(logger, @"This is a warning message");
    
    // These should NOT be logged
    LogInfo(logger, @"Should not appear");
    LogDebug(logger, @"Should not appear");
    
    [fileAppender close];
    [fileAppender release];
}

- (void)testConvenienceMacros {
    // Get a logger
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"MacroLogger"];
    [logger setLogLevel:LEVEL_DEBUG];
    
    ConsoleAppender *consoleAppender = [[ConsoleAppender alloc] init];
    [logger addAppender:consoleAppender];
    
    // Use convenience macros
    LogCritical(logger, @"Critical with value: %d", 42);
    LogError(logger, @"Error with string: %@", @"test");
    LogWarn(logger, @"Warning");
    LogInfo(logger, @"Info message");
    LogDebug(logger, @"Debug with multiple values: %d, %@", 100, @"hello");
    
    [consoleAppender release];
}

- (void)testLoggerManager {
    LoggerManager *manager = [LoggerManager sharedManager];
    
    // Set default log level
    [manager setDefaultLogLevel:LEVEL_INFO];
    OFAssert([manager defaultLogLevel] == LEVEL_INFO);
    
    // Get a new logger - should have the default level
    Logger *logger = [manager loggerForName:@"NewLogger"];
    OFAssert([logger logLevel] == LEVEL_INFO); //), @"New logger should have default level");
    
    // Get a logger for a class
    Logger *classLogger = [manager loggerForClass:[self class]];
    OFAssert(classLogger != nil);
    OFAssert([[classLogger name] containsString:@"LoggerTest"]);
}

- (void)testAddAppenderToAll {
    LoggerManager *manager = [LoggerManager sharedManager];
    
    // Create a few loggers
    Logger *logger1 = [manager loggerForName:@"Logger1"];
    Logger *logger2 = [manager loggerForName:@"Logger2"];
    Logger *logger3 = [manager loggerForName:@"Logger3"];
    
    // Create an appender and add it to all
    ConsoleAppender *appender = [[ConsoleAppender alloc] init];
    [manager addAppenderToAll:appender];
    
    // All loggers should have the appender
    OFAssert([[logger1 appenders] containsObject:appender]);
    OFAssert([[logger2 appenders] containsObject:appender]);
    OFAssert([[logger3 appenders] containsObject:appender]);
    
    // Remove from all
    [manager removeAppenderFromAll:appender];
    OFAssert([[logger1 appenders] count] == 0);
    
    [appender release];
}

@end
