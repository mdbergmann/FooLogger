//
// FileAppender.h
// ObjCLogger
//
// Created by Manfred Bergmann
//

#import <ObjFW/ObjFW.h>
#import "Appender.h"

/**
 * File appender that writes log messages to a file
 */
@interface FileAppender : BaseAppender {
@private
    OFString *_logPath;
    OFFile *_fileHandle;
    BOOL _appendToFile;
}

/**
 * Initialize a new file appender
 * @param logPath The path to the log file
 * @param append YES to append to existing file, NO to overwrite
 */
- (instancetype)initWithPath:(OFString *)logPath append:(BOOL)append;

/**
 * Get the log file path
 */
- (OFString *)logPath;

/**
 * Close the file handle
 */
- (void)close;

@end
