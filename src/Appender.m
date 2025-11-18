//
// Created by Manfred Bergmann on 14.05.18.
//

#import "Appender.h"

@implementation BaseAppender

- (instancetype)init {
    self = [super init];
    if (self) {
        // Pattern: [d] = date, [l] = level, [c] = logger name, [M] = function, [m] = message
        _pattern = @"[d] [[l]] [c] [m] - [M]";
    }
    
    return self;
}

- (void)dealloc {
    [_pattern release];
    
    [super dealloc];
}

- (OFString *)dateFormat {
    return @"%Y-%m-%d %H:%M:%S";
}

- (OFString *)computePattern:(OFString *)message 
                       level:(LoggingLevel)level 
                  loggerName:(OFString *)logger 
                functionName:(OFString *)function {
    
    OFString *result = _pattern;
    
    // Replace date [d]
    OFDate *now = [OFDate date];
    OFString *dateStr = [now dateStringWithFormat:(OFConstantString *)[self dateFormat]];
    result = [result stringByReplacingOccurrencesOfString:@"[d]" withString:dateStr];
    
    // Replace level [l]
    OFString *levelStr = nil;
    switch(level) {
        case LEVEL_CRIT:
            levelStr = @"CRIT";
            break;
        case LEVEL_ERR:
            levelStr = @"ERR";
            break;
        case LEVEL_WARN:
            levelStr = @"WARN";
            break;
        case LEVEL_INFO:
            levelStr = @"INFO";
            break;
        case LEVEL_DEBUG:
            levelStr = @"DEBUG";
            break;
        case LEVEL_OFF:
            levelStr = @"OFF";
            break;
    }
    result = [result stringByReplacingOccurrencesOfString:@"[l]" withString:levelStr];
    
    // Replace logger name [c]
    result = [result stringByReplacingOccurrencesOfString:@"[c]" withString:logger ? logger : @""];
    
    // Replace message [m]
    result = [result stringByReplacingOccurrencesOfString:@"[m]" withString:message ? message : @""];
    
    // Replace function name [M]
    result = [result stringByReplacingOccurrencesOfString:@"[M]" withString:function ? function : @""];
    
    return result;
}

- (void)append:(OFString *)message 
         level:(LoggingLevel)level 
    loggerName:(OFString *)logger 
  functionName:(OFString *)function {
    // Base implementation does nothing
    // Subclasses must override
}

@end

@implementation ConsoleAppender

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)append:(OFString *)message 
         level:(LoggingLevel)level 
    loggerName:(OFString *)logger 
  functionName:(OFString *)function {
    
    OFString *formattedMessage = [self computePattern:message 
                                               level:level 
                                          loggerName:logger 
                                        functionName:function];
    
    // Write to stderr for errors and critical, stdout for others
    if (level <= LEVEL_ERR) {
        [OFStdErr writeString:formattedMessage];
        [OFStdErr writeString:@"\n"];
    } else {
        [OFStdOut writeString:formattedMessage];
        [OFStdOut writeString:@"\n"];
    }
}

@end
