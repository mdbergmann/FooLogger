//
// Logger2.m
// ObjCLogger
//
// Logger implementation with appender support
//

#import "Logger.h"

@implementation Logger

- (instancetype)initWithName:(OFString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
        _logLevel = LEVEL_WARN;
        _appenders = [[OFMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_name release];
    [_appenders release];
    
    [super dealloc];
}

- (OFString *)name {
    return _name;
}

- (void)setLogLevel:(LoggingLevel)level {
    _logLevel = level;
}

- (LoggingLevel)logLevel {
    return _logLevel;
}

- (void)addAppender:(id<Appender>)appender {
    if (appender != nil && ![_appenders containsObject:appender]) {
        [_appenders addObject:appender];
    }
}

- (void)removeAppender:(id<Appender>)appender {
    [_appenders removeObject:appender];
}

- (void)removeAllAppenders {
    [_appenders removeAllObjects];
}

- (OFArray *)appenders {
    return [[_appenders copy] autorelease];
}

- (void)log:(OFString *)message level:(LoggingLevel)level function:(OFString *)function {
    // Check if we should log this level
    if (level > _logLevel) {
        return;
    }
    
    // Don't log if level is OFF
    if (level == LEVEL_OFF || _logLevel == LEVEL_OFF) {
        return;
    }
    
    // Send to all appenders
    for (id<Appender> appender in _appenders) {
        [appender append:message level:level loggerName:_name functionName:function];
    }
}

- (void)critical:(OFString *)message function:(OFString *)function {
    [self log:message level:LEVEL_CRIT function:function];
}

- (void)error:(OFString *)message function:(OFString *)function {
    [self log:message level:LEVEL_ERR function:function];
}

- (void)warn:(OFString *)message function:(OFString *)function {
    [self log:message level:LEVEL_WARN function:function];
}

- (void)info:(OFString *)message function:(OFString *)function {
    [self log:message level:LEVEL_INFO function:function];
}

- (void)debug:(OFString *)message function:(OFString *)function {
    [self log:message level:LEVEL_DEBUG function:function];
}

@end

// MARK: - LoggerManager

@implementation LoggerManager {
    OFMutableDictionary *_loggers;
    LoggingLevel _defaultLogLevel;
}

static LoggerManager *sharedInstance = nil;

+ (void)initialize {
    if (self == [LoggerManager class]) {
        sharedInstance = [[self alloc] init];
    }
}

+ (instancetype)sharedManager {
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _loggers = [[OFMutableDictionary alloc] init];
        _defaultLogLevel = LEVEL_WARN;
    }
    
    return self;
}

- (void)dealloc {
    [_loggers release];
    
    [super dealloc];
}

- (Logger *)loggerForName:(OFString *)name {
    if (name == nil) {
        name = @"<unnamed>";
    }
    
    Logger *logger = [_loggers objectForKey:name];
    if (logger == nil) {
        logger = [[Logger alloc] initWithName:name];
        [logger setLogLevel:_defaultLogLevel];
        [_loggers setObject:logger forKey:name];
        [logger release]; // Dictionary retains it
    }
    
    return logger;
}

- (Logger *)loggerForClass:(Class)cls {
    OFString *className = [OFString stringWithCString:class_getName(cls)
                                             encoding:OFStringEncodingUTF8];
    return [self loggerForName:className];
}

- (void)setDefaultLogLevel:(LoggingLevel)level {
    _defaultLogLevel = level;
}

- (LoggingLevel)defaultLogLevel {
    return _defaultLogLevel;
}

- (void)addAppenderToAll:(id<Appender>)appender {
    for (OFString *key in _loggers) {
        Logger *logger = [_loggers objectForKey:key];
        [logger addAppender:appender];
    }
}

- (void)removeAppenderFromAll:(id<Appender>)appender {
    for (OFString *key in _loggers) {
        Logger *logger = [_loggers objectForKey:key];
        [logger removeAppender:appender];
    }
}

@end
