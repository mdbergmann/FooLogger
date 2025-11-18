//
// ExampleUsage.m
// ObjCLogger
//
// Examples of using the Logger API (ported from SwiftLog)
//

#import "ObjCLogger.h"

// MARK: - Example 1: Quick Start

void example1_QuickStart(void) {
    // Use convenience function for quick setup
    SetupDefaultLogging(LEVEL_INFO, YES, @"app.log");
    
    // Get a logger
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"Example1"];
    
    // Log away!
    LogInfo(logger, @"Application started");
    LogDebug(logger, @"This won't show (below threshold)");
    LogWarn(logger, @"Warning: Low memory");
    LogError(logger, @"Failed to connect");
}

// MARK: - Example 2: Per-Class Loggers

@interface NetworkManager : OFObject {
    Logger *_logger;
}
- (void)connect;
@end

@implementation NetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // Get logger for this class
        _logger = [[[LoggerManager sharedManager] loggerForClass:[self class]] retain];
        [_logger setLogLevel:LEVEL_DEBUG]; // Network module needs detailed logs
    }
    return self;
}

- (void)connect {
    LogInfo(_logger, @"Connecting to server...");
    
    // Simulate connection
    for (int i = 1; i <= 3; i++) {
        LogDebug(_logger, @"Attempt %d of 3", i);
        // ... connection logic ...
    }
    
    LogInfo(_logger, @"Connected successfully");
}

- (void)dealloc {
    [_logger release];
    [super dealloc];
}

@end

// MARK: - Example 3: Multiple Appenders

void example3_MultipleAppenders(void) {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"MultiApp"];
    [logger setLogLevel:LEVEL_DEBUG];
    
    // Add console for immediate feedback
    ConsoleAppender *console = [[ConsoleAppender alloc] init];
    [logger addAppender:console];
    
    // Add file for permanent record
    FileAppender *file = [[FileAppender alloc] initWithPath:@"debug.log" append:NO];
    [logger addAppender:file];
    
    // This goes to both console AND file
    LogInfo(logger, @"Message logged to both destinations");
    
    // Cleanup
    [file close];
    [console release];
    [file release];
}

// MARK: - Example 4: Custom Appender

@interface EmailAppender : BaseAppender {
    OFString *_emailAddress;
}
- (instancetype)initWithEmail:(OFString *)email;
@end

@implementation EmailAppender

- (instancetype)initWithEmail:(OFString *)email {
    self = [super init];
    if (self) {
        _emailAddress = [email copy];
    }
    return self;
}

- (void)dealloc {
    [_emailAddress release];
    [super dealloc];
}

- (void)append:(OFString *)message 
         level:(LoggingLevel)level 
    loggerName:(OFString *)logger 
  functionName:(OFString *)function {
    
    // Only send critical errors via email
    if (level == LEVEL_CRIT) {
        OFString *formatted = [self computePattern:message 
                                             level:level 
                                        loggerName:logger 
                                      functionName:function];
        
        [OFStdOut writeFormat:@"[EmailAppender] Would send email to %@: %@\n", 
            _emailAddress, formatted];
        // In real implementation: send actual email
    }
}

@end

void example4_CustomAppender(void) {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"CriticalAlerts"];
    [logger setLogLevel:LEVEL_DEBUG];
    
    // Add custom email appender
    EmailAppender *email = [[EmailAppender alloc] initWithEmail:@"admin@example.com"];
    [logger addAppender:email];
    
    // Also log to console
    ConsoleAppender *console = [[ConsoleAppender alloc] init];
    [logger addAppender:console];
    
    // Normal logs go to console only
    LogInfo(logger, @"Normal operation");
    
    // Critical logs go to BOTH console and email
    LogCritical(logger, @"System failure detected!");
    
    [email release];
    [console release];
}

// MARK: - Example 5: Module-Specific Configuration

void example5_ModuleConfiguration(void) {
    // Configure different modules differently
    
    // UI module - only warnings and above
    Logger *uiLogger = [[LoggerManager sharedManager] loggerForName:@"UI"];
    [uiLogger setLogLevel:LEVEL_WARN];
    
    // Network module - everything including debug
    Logger *netLogger = [[LoggerManager sharedManager] loggerForName:@"Network"];
    [netLogger setLogLevel:LEVEL_DEBUG];
    
    // Database module - info and above
    Logger *dbLogger = [[LoggerManager sharedManager] loggerForName:@"Database"];
    [dbLogger setLogLevel:LEVEL_INFO];
    
    // Add console to all
    ConsoleAppender *console = [[ConsoleAppender alloc] init];
    [[LoggerManager sharedManager] addAppenderToAll:console];
    [console release];
    
    // Test logging
    LogDebug(uiLogger, @"Button pressed");           // NOT logged (below threshold)
    LogDebug(netLogger, @"Sending HTTP request");    // Logged
    LogInfo(dbLogger, @"Query executed");            // Logged
}

// MARK: - Example 6: Dynamic Configuration

void example6_DynamicConfiguration(void) {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"Dynamic"];
    
    FileAppender *file = [[FileAppender alloc] initWithPath:@"dynamic.log" append:NO];
    [logger addAppender:file];
    
    // Start with minimal logging
    [logger setLogLevel:LEVEL_WARN];
    LogDebug(logger, @"Debug 1 - not logged");
    LogWarn(logger, @"Warning 1 - logged");
    
    // Increase verbosity for debugging
    [logger setLogLevel:LEVEL_DEBUG];
    LogDebug(logger, @"Debug 2 - now logged!");
    
    // Turn off logging temporarily
    [logger setLogLevel:LEVEL_OFF];
    LogError(logger, @"Error - not logged when OFF");
    
    // Re-enable
    [logger setLogLevel:LEVEL_INFO];
    LogInfo(logger, @"Info - logged again");
    
    [file close];
    [file release];
}

// MARK: - Example 7: Application Lifecycle

@interface MyApplication : OFObject
+ (void)setup;
+ (void)run;
+ (void)cleanup;
@end

@implementation MyApplication

+ (void)setup {
    // Configure logging at startup
    LoggerManager *manager = [LoggerManager sharedManager];
    
    // Set default level
    [manager setDefaultLogLevel:LEVEL_INFO];
    
    // Create appenders
    ConsoleAppender *console = [[ConsoleAppender alloc] init];
    FileAppender *file = [[FileAppender alloc] initWithPath:@"myapp.log" append:YES];
    
    // Add to all loggers
    [manager addAppenderToAll:console];
    [manager addAppenderToAll:file];
    
    [console release];
    [file release];
    
    // Log startup
    Logger *logger = [manager loggerForName:@"Application"];
    LogInfo(logger, @"MyApplication started");
}

+ (void)run {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"Application"];
    
    LogInfo(logger, @"Running main loop...");
    
    // Simulate work
    for (int i = 0; i < 5; i++) {
        LogDebug(logger, @"Processing iteration %d", i);
    }
    
    LogInfo(logger, @"Main loop completed");
}

+ (void)cleanup {
    Logger *logger = [[LoggerManager sharedManager] loggerForName:@"Application"];
    LogInfo(logger, @"Shutting down...");
    
    // Note: LoggerManager retains loggers, so explicit cleanup is optional
    // But you should close file appenders if you want to flush immediately
}

@end

void example7_ApplicationLifecycle(void) {
    [MyApplication setup];
    [MyApplication run];
    [MyApplication cleanup];
}

// MARK: - Main Example Runner

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [OFStdOut writeString:@"\n=== Example 1: Quick Start ===\n"];
        example1_QuickStart();
        
        [OFStdOut writeString:@"\n=== Example 2: Per-Class Loggers ===\n"];
        NetworkManager *nm = [[NetworkManager alloc] init];
        [nm connect];
        [nm release];
        
        [OFStdOut writeString:@"\n=== Example 3: Multiple Appenders ===\n"];
        example3_MultipleAppenders();
        
        [OFStdOut writeString:@"\n=== Example 4: Custom Appender ===\n"];
        example4_CustomAppender();
        
        [OFStdOut writeString:@"\n=== Example 5: Module-Specific Configuration ===\n"];
        example5_ModuleConfiguration();
        
        [OFStdOut writeString:@"\n=== Example 6: Dynamic Configuration ===\n"];
        example6_DynamicConfiguration();
        
        [OFStdOut writeString:@"\n=== Example 7: Application Lifecycle ===\n"];
        example7_ApplicationLifecycle();
    }
    
    return 0;
}
