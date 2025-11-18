//
// FileAppender.m
// ObjCLogger
//
// Created by Manfred Bergmann
//

#import "FileAppender.h"

@implementation FileAppender

- (instancetype)initWithPath:(OFString *)logPath append:(BOOL)append {
    self = [super init];
    if (self) {
        _logPath = [logPath copy];
        _appendToFile = append;
        _fileHandle = nil;
        
        // If not appending and file exists, try to delete it
        if (!append) {
            OFFileManager *fileManager = [OFFileManager defaultManager];
            if ([fileManager fileExistsAtPath:_logPath]) {
                @try {
                    [fileManager removeItemAtPath:_logPath];
                } @catch (id e) {
                    [OFStdErr writeFormat:@"[FileAppender] Could not delete existing log file at %@: %@\n", 
                        _logPath, e];
                }
            }
        }
        
        // Open the file for writing
        @try {
            _fileHandle = [[OFFile alloc] initWithPath:_logPath mode:@"a"];
        } @catch (id e) {
            [OFStdErr writeFormat:@"[FileAppender] Could not open log file at %@: %@\n", 
                _logPath, e];
            _fileHandle = nil;
        }
    }
    
    return self;
}

- (void)dealloc {
    [self close];
    [_logPath release];
    
    [super dealloc];
}

- (OFString *)logPath {
    return _logPath;
}

- (void)close {
    if (_fileHandle != nil) {
        @try {
            [_fileHandle close];
        } @catch (id e) {
            [OFStdErr writeFormat:@"[FileAppender] Error closing file: %@\n", e];
        }
        [_fileHandle release];
        _fileHandle = nil;
    }
}

- (void)append:(OFString *)message 
         level:(LoggingLevel)level 
    loggerName:(OFString *)logger 
  functionName:(OFString *)function {
    
    if (_fileHandle == nil) {
        [OFStdErr writeString:@"[FileAppender] No open file handle!\n"];
        return;
    }
    
    OFString *formattedMessage = [self computePattern:message 
                                               level:level 
                                          loggerName:logger 
                                        functionName:function];
    
    @try {
        OFString *logLine = [formattedMessage stringByAppendingString:@"\n"];
        [_fileHandle writeString:logLine];
    } @catch (id e) {
        [OFStdErr writeFormat:@"[FileAppender] Error writing to file: %@\n", e];
    }
}

@end
