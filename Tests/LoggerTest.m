//
//  LoggerTest.m
//  ObjCLogger
//
//  Created by Manfred Bergmann on 05.07.10.
//  Copyright 2010 Software by MABE. All rights reserved.
//

#import "LoggerTest.h"


@implementation LoggerTest

- (void)setUp {
}

- (void)testLog {
    [ObjCLogger initLogger:@"logfile.log" logPrefix:@"LoggerTest" logFilterLevel:LEVEL_WARN appendToFile:YES logToConsole:YES];
    [ObjCLogger log:@"Hello World" level:LEVEL_WARN];
    [ObjCLogger log:@"Hello World" level:LEVEL_INFO];
    ObjCLog(LEVEL_WARN, @"Hello World");
    ObjCLog(LEVEL_WARN, @"Hello World %@", @"good world");
}

@end
