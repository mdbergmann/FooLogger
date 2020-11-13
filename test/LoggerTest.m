//
//  LoggerTest.m
//  CocoLogger
//
//  Created by Manfred Bergmann on 05.07.10.
//  Copyright 2010 Software by MABE. All rights reserved.
//

#import "LoggerTest.h"


@implementation LoggerTest

- (void)setUp {
}

- (void)testLog {
    [CocoLogger initLogger:@"logfile.log" logPrefix:@"LoggerTest" logFilterLevel:LEVEL_WARN appendToFile:YES logToConsole:YES];
    [CocoLogger log:@"Hello World" level:LEVEL_WARN];
    [CocoLogger log:@"Hello World" level:LEVEL_INFO];
    CocoLog(LEVEL_WARN, @"Hello World");
    CocoLog(LEVEL_WARN, @"Hello World %@", @"good world");
}

@end
